//
//  ZHGoodsDetailVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/26.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHGoodsDetailVC.h"
#import "TLBannerView.h"
#import "ZHStepView.h"
#import "ZHBuyToolView.h"
#import "ZHTreasureInfoView.h"
#import "ZHImmediateBuyVC.h"

#import "ZHTreasureProgressVC.h"//夺宝进度
#import "ZHEvaluateListVC.h" //评价列表
#import "ZHSingleDetailVC.h" //详情列表

#import "ZHShoppingCartVC.h"
#import "ZHUserLoginVC.h"
#import "ChatViewController.h"

#import "ZHCartManager.h"
#import "MJRefresh.h"
#import "ChatManager.h"

@interface ZHGoodsDetailVC ()<ZHBuyToolViewDelegate>

@property (nonatomic,strong) UIScrollView *bgScrollView;
@property (nonatomic,strong) ZHBuyToolView *buyView;
@property (nonatomic,weak) TLBannerView *bannerView;

@property (nonatomic,strong) UILabel *nameLbl;
@property (nonatomic,strong) UILabel *advLbl;
@property (nonatomic,strong) UILabel *priceLbl;

@property (nonatomic,strong) UIView *line1;
@property (nonatomic,strong) UIView *line2;

@property (nonatomic, weak) ZHStepView *stepView;
@property (nonatomic, strong) ZHTreasureInfoView *infoView;

@property (nonatomic,strong) UIView *switchView;

//顶部切换相关
@property (nonatomic,strong) UIView *switchLine;
@property (nonatomic,strong) UIButton *lastBtn;

@property (nonatomic,strong) UIView *detailView;
@property (nonatomic,strong) UIView *evaluateViwe;


@end

@implementation ZHGoodsDetailVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.bannerView.timer invalidate];
    self.bannerView.timer = nil;
}

#pragma mark- 顶部切换事件
- (void)switchConten:(UIButton *)btn {

    if ([_lastBtn isEqual:btn]) {
        return;
    }
    NSInteger tag = btn.tag;
    
    switch (tag) {
         //商品
        case 0: [self.view bringSubviewToFront:self.bgScrollView];

            break;
        //详情
        case 1:  [self.view bringSubviewToFront:self.detailView];
        
            break;
            
        case 2: //评价
        
            [self.view bringSubviewToFront:self.evaluateViwe];
            break;
            
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.switchLine.centerX = btn.centerX;
        btn.titleLabel.font = FONT(18);
        [btn setTitleColor:[UIColor zh_themeColor] forState:UIControlStateNormal];
        [self.lastBtn  setTitleColor:[UIColor zh_textColor] forState:UIControlStateNormal];
        
        self.lastBtn.titleLabel.font = FONT(17);
    }];
    
    self.lastBtn = btn;

  

}

#pragma mark - 客服消息变更
- (void)kefuUnreadMsgChange:(NSNotification *)notification {
    
    if (self.buyView.kefuMsgHintView) {
        
       self.buyView.kefuMsgHintView.hidden = ![notification.userInfo[kKefuUnreadMsgKey] boolValue];
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];    
    self.navigationItem.titleView = self.switchView;
    
    //客服消息变更
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kefuUnreadMsgChange:) name:kKefuUnreadMsgChangeNotification object:nil];
    
    //购物车变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cartCountChange) name:kShoopingCartCountChangeNotification object:nil];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49)];
    self.bgScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bgScrollView];
    
    //底部工具条
    self.buyView = [[ZHBuyToolView alloc] initWithFrame:CGRectMake(0, self.bgScrollView.yy, SCREEN_WIDTH, 49)];
    self.buyView.delegate = self;
    [self.view addSubview:self.buyView];
    
    //根据为夺宝或者为 普通商品加载不同的商品
    [self setUpUI];
    
    //
    self.bgScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    
    
    //包尾按钮事件
    __weak  ZHStepView *weakStep = self.stepView;
    __weak typeof(self) weakSelf = self;
    self.stepView.buyAllAction = ^(){
#pragma mark- 夺宝价格展示
        weakStep.count = [weakSelf.treasure.totalNum integerValue] - [weakSelf.treasure.investNum integerValue];
        
        weakSelf.buyView.priceLbl.attributedText = [ZHCurrencyHelper
                                                    stepPriceWithQBB:weakSelf.treasure.price3
                                           GWB:weakSelf.treasure.price2
                                                                                       RMB:weakSelf.treasure.price1
                                                      bounds:CGRectMake(0, -1, 10, 10)
                                                                                count: weakStep.count];
    };
    
    
    //
#pragma mark- 夺宝价格展示
    self.stepView.countChange = ^(NSUInteger count){
    
        if (weakSelf.priceLbl && weakSelf.treasure) {
            weakSelf.buyView.priceLbl.attributedText = [ZHCurrencyHelper stepPriceWithQBB:weakSelf.treasure.price3
                                                                                      GWB:weakSelf.treasure.price2
                                                                                      RMB:weakSelf.treasure.price1
                                                                                   bounds:CGRectMake(0, -1, 10, 10) count:count];
            
//            [ZHCurrencyHelper calculatePriceWithQBB:weakSelf.treasure.price3
//                                                                                   GWB:weakSelf.treasure.price2
//                                                                                   RMB:weakSelf.treasure.price1 count:count];
            
        }
    
    };
    
    //---//夺宝
    if (self.detailType == 1) { //夺宝
        
        [self setUPDBData];
        
        
        self.buyView.priceLbl.attributedText = [ZHCurrencyHelper
                                                    stepPriceWithQBB:weakSelf.treasure.price3
                                                    GWB:weakSelf.treasure.price2
                                                    RMB:weakSelf.treasure.price1
                                                    bounds:CGRectMake(0, -1, 10, 10)
                                                count: 1];

    } else {
    
        //拍普通商品，价格在上面
        self.bannerView.imgUrls = self.goods.pics;
        self.nameLbl.text = self.goods.name;
        self.advLbl.text = self.goods.advTitle;
        self.priceLbl.text = self.goods.totalPrice;
        self.buyView.countView.msgCount = [ZHCartManager manager].count;
        
    }
    
    //扩大
    self.bgScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.stepView.yy + 10);

    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(treasureSuccess) name:@"dbBuySuccess" object:nil];
    
    self.buyView.kefuMsgHintView.hidden = ![ChatManager defaultManager].isHaveKefuUnredMsg;
    
}

- (void)treasureSuccess{

    [self.bgScrollView.mj_header beginRefreshing];
}

- (void)cartCountChange {

    if (self.detailType == ZHGoodsDetailTypeDefault && self.buyView) {
        
        self.buyView.countView.msgCount = [ZHCartManager manager].count;
        
    }
    //----//
}


- (void)setUPDBData {

    self.bannerView.imgUrls = self.treasure.pics;
    
    self.nameLbl.text = self.treasure.name;
    self.advLbl.text = self.treasure.slogan;
    self.priceLbl.attributedText = [ZHCurrencyHelper totalPriceAttr2WithQBB:self.treasure.price3 GWB:self.treasure.price2 RMB:self.treasure.price1];
    
    self.infoView.progress.progress = [self.treasure getProgress];
    self.infoView.peopleView.bootomLbl.text = [NSString stringWithFormat:@"%@",self.treasure.investNum];
    //        self.infoView.priceView.bootomLbl.text = [self.goods.price1 stringValue];
    self.infoView.dayView.bootomLbl.text = [self.treasure getSurplusTime];
    
    //底部购买工具条
    self.buyView.type = ZHBuyTypeLookForTreasure;
    self.stepView.isDefault = NO;

}

#pragma mark- 一元夺宝刷新
- (void)refresh {

    if (self.treasure) {
        
        TLNetworking *http = [TLNetworking new];
        http.code = @"808312";
        http.parameters[@"code"] = self.treasure.code;

        [http postWithSuccess:^(id responseObject) {
            self.treasure = [ZHTreasureModel tl_objectWithDictionary: responseObject[@"data"]];
            
            [self setUPDBData];
            
            [self.bgScrollView.mj_header endRefreshing];
        } failure:^(NSError *error) {
            
            [self.bgScrollView.mj_header endRefreshing];

        }];
        
    } else {
        
        [self.bgScrollView.mj_header endRefreshing];
    }

}

#pragma mark- 购买
- (void)buy {
    
    
    if (![ZHUser user].isLogin) {
       
        ZHUserLoginVC *loginVC = [[ZHUserLoginVC alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:nil];
        loginVC.loginSuccess = ^(){
            [self buy];
        };
        return;
    }

    if (self.detailType == ZHGoodsDetailTypeDefault) { 
        //查看数量
        
        ZHImmediateBuyVC *buyVC = [[ZHImmediateBuyVC alloc] init];
        buyVC.type = ZHIMBuyTypeSingle;
        self.goods.count = self.stepView.count;
        buyVC.goodsRoom = @[self.goods];
        [self.navigationController pushViewController:buyVC animated:YES];
        
    } else { //夺宝
        
        ZHImmediateBuyVC *buyVC = [[ZHImmediateBuyVC alloc] init];
        buyVC.type = ZHIMBuyTypeYYDB;
        self.treasure.count = self.stepView.count;
        buyVC.treasureRoom = @[self.treasure];
        [self.navigationController pushViewController:buyVC animated:YES];
        
    }
    
}

#pragma mark- 前往客服
//客服
- (void)chat {

    if (![ZHUser user].isLogin) {
        
        ZHUserLoginVC *loginVC = [[ZHUserLoginVC alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:nil];
//        loginVC.loginSuccess = ^(){
//            [self buy];
//        };
        
    } else {
    
        ChatViewController *vc = [[ChatViewController alloc] initWithConversationChatter:@"ioskefu" conversationType:EMConversationTypeChat];
        vc.title = @"客服";
        vc.defaultUserAvatarName = @"user.png";
        [self.navigationController pushViewController:vc animated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:kUnreadMsgChangeNotification object:nil];

    }

    //夺宝成功之后刷新该页面
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(<#selector#>) name:<#(nullable NSNotificationName)#> object:<#(nullable id)#>];
    
}

#pragma mark- 夺宝后刷新
- (void)treasureRefresh {


}

#pragma mark- 加入购物车
- (void)addToShopCar {

    if (![ZHUser user].isLogin) {
        
        ZHUserLoginVC *loginVC = [[ZHUserLoginVC alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:nil];
        loginVC.loginSuccess = ^(){
            [self buy];
        };
        return;
    }
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"808030";
    http.parameters[@"userId"] = [ZHUser user].userId;
    http.parameters[@"token"] = [ZHUser user].token;

    http.parameters[@"productCode"] = self.goods.code;
    http.parameters[@"quantity"] = [NSString stringWithFormat:@"%ld",self.stepView.count];
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithHUDText:@"添加到购物车成功"];
        
        [ZHCartManager manager].count = [ZHCartManager manager].count + self.stepView.count;
        
    } failure:^(NSError *error) {
        
        
    }];
    

}

#pragma mark- 购物车
- (void)openShopCar {

    if (![ZHUser user].isLogin) {
        
        ZHUserLoginVC *loginVC = [[ZHUserLoginVC alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:nil];
        loginVC.loginSuccess = ^(){
            [self buy];
        };
        return;
    }
    
    ZHShoppingCartVC *vc = [[ZHShoppingCartVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark- 查看一元夺宝购买详情
- (void)lookBuyDetail {
    
    ZHTreasureProgressVC *vc = [[ZHTreasureProgressVC alloc] init];
    vc.treasureModel = self.treasure;
    [self.navigationController pushViewController:vc animated:YES];
    
}



- (UIView *)detailView {
    
    if (!_detailView ) {
        
        ZHSingleDetailVC *detailVC = [[ZHSingleDetailVC alloc] init];
        detailVC.view.frame = self.bgScrollView.frame;
        [self addChildViewController:detailVC];
        if (self.goods) {
            
            detailVC.goods = self.goods;
            
        } else {
            
            detailVC.treasure = self.treasure;
        }
        
        [self.view addSubview:detailVC.view];
        _detailView = detailVC.view;
        
    }
    return _detailView;
    
}


-(UIView *)evaluateViwe {
    
    if (!_evaluateViwe ) {
        
        ZHEvaluateListVC *evaluateListVC = [[ZHEvaluateListVC alloc] init];

        
        if (self.detailType == ZHGoodsDetailTypeLookForTreasure) {
            
            evaluateListVC.goodsCode = self.treasure.code;

        } else {
        
            evaluateListVC.goodsCode = self.goods.code;
            
        }
        
        evaluateListVC.view.frame = self.bgScrollView.frame;
        [self addChildViewController:evaluateListVC];
        [self.view addSubview:evaluateListVC.view];

        _evaluateViwe = evaluateListVC.view;
        
    }
    
    return _evaluateViwe;
    
}

- (void)setUpUI {

    //轮播图
    TLBannerView *bannerView = [[TLBannerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*0.6)];
    [self.bgScrollView addSubview:bannerView];
    self.bannerView = bannerView;
    
    
    //
    UIView *line0 = [[UIView alloc] init];
    line0.backgroundColor = [UIColor zh_lineColor];
    [self.bgScrollView addSubview:line0];
    [line0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bannerView.mas_bottom);
        make.left.equalTo(self.bgScrollView.mas_left);
        make.width.mas_equalTo(@(SCREEN_WIDTH));
        make.height.mas_equalTo(@(1));
    }];
    
    //名字
    self.nameLbl = [UILabel labelWithFrame:CGRectZero
                              textAligment:NSTextAlignmentLeft
                           backgroundColor:[UIColor whiteColor]
                                      font:FONT(16)
                                 textColor:[UIColor zh_textColor]];
    self.nameLbl.numberOfLines = 0;
    [self.bgScrollView addSubview:self.nameLbl];
    
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.bgScrollView.mas_left).offset(15);
        make.top.equalTo(self.bannerView.mas_bottom).offset(15);
        make.width.mas_equalTo(@(SCREEN_WIDTH - 30));

    }];
    

    //广告语
//    CGRectMake(self.nameLbl.x, self.nameLbl.yy + 10, self.nameLbl.width, 10)
    self.advLbl = [[UILabel alloc] initWithFrame:CGRectZero
                                    textAligment:NSTextAlignmentLeft
                                 backgroundColor:[UIColor whiteColor]
                                            font:FONT(14)
                                       textColor:[UIColor zh_textColor2]];
    [self.bgScrollView addSubview:self.advLbl];
    self.advLbl.numberOfLines = 0;
    [self.advLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.nameLbl.mas_bottom).offset(10);
        make.left.equalTo(self.bgScrollView.mas_left).offset(15);
        make.width.mas_equalTo(@(SCREEN_WIDTH - 30));
    }];
    
    //数量选择
    

    //价格
//    CGRectMake(self.nameLbl.x, self.advLbl.yy + 11, self.nameLbl.width, 10)
    self.priceLbl = [UILabel labelWithFrame:CGRectZero
                               textAligment:NSTextAlignmentLeft
                            backgroundColor:[UIColor whiteColor]
                                       font:FONT(16)
                                  textColor:[UIColor zh_themeColor]];
    [self.bgScrollView addSubview:self.priceLbl];
    [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.advLbl.mas_bottom).offset(11);
        make.left.equalTo(self.bgScrollView.mas_left).offset(15);
        make.width.mas_equalTo(@(SCREEN_WIDTH - 30));
    }];
    
    

    //
    UIView *priceBottomLine = [[UIView alloc] init];
    priceBottomLine.backgroundColor = [UIColor zh_lineColor];
    [self.bgScrollView addSubview:priceBottomLine];
    [priceBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceLbl.mas_bottom).offset(11);
        make.left.equalTo(self.bgScrollView.mas_left);
        make.width.mas_equalTo(@(SCREEN_WIDTH));
        make.height.mas_equalTo(@(1));
    }];
    
    

    //以上为公共部分
    if (self.detailType == 1) { //夺宝---autoLayout
    
        //夺宝信息
        ZHTreasureInfoView *infoView = [[ZHTreasureInfoView alloc] initWithFrame:CGRectZero];
        [self.bgScrollView addSubview:infoView];
        self.infoView = infoView;
        [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.bgScrollView.mas_left);
            make.top.equalTo(priceBottomLine.mas_bottom).offset(20);
            make.height.mas_equalTo(@60);
            make.width.mas_equalTo(@(260));
            
        }];
        
        //
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero];
        [self.bgScrollView addSubview:btn];
        [btn addTarget:self action:@selector(lookBuyDetail) forControlEvents:UIControlEventTouchUpInside];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(infoView.mas_right);
            make.left.equalTo(self.bgScrollView.mas_left);
            make.top.equalTo(infoView.mas_top);
            make.bottom.equalTo(infoView.mas_bottom);
            make.width.mas_equalTo(@(SCREEN_WIDTH));

        }];
        
        //向右箭头
        UIImageView *arrowImageV = [[UIImageView alloc] initWithFrame:CGRectZero];
        arrowImageV.image = [UIImage imageNamed:@"更多"];
        [self.bgScrollView addSubview:arrowImageV];
        [arrowImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.mas_equalTo(@10);
            make.height.mas_equalTo(@17);
            make.top.equalTo(self.infoView.mas_top).offset(15);
            make.right.mas_equalTo(@(SCREEN_WIDTH - 15));
            
        }];
        
        //
        UIView *infoViewBottomLine = [[UIView alloc] init];
        infoViewBottomLine.backgroundColor = [UIColor zh_lineColor];
        [self.bgScrollView addSubview:infoViewBottomLine];
        [infoViewBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(infoView.mas_bottom).offset(20);
            make.left.equalTo(self.bgScrollView.mas_left);
            make.width.mas_equalTo(@(SCREEN_WIDTH));
            make.height.mas_equalTo(@(1));
        }];
        ////
        
       ZHStepView *stepV = [[ZHStepView alloc] initWithFrame:CGRectZero type:ZHStepViewTypeDefault];
       self.stepView = stepV;
       [self.bgScrollView addSubview:self.stepView];
       [stepV mas_makeConstraints:^(MASConstraintMaker *make) {
           
             make.left.equalTo(self.bgScrollView.mas_left).offset(LEFT_MARGIN);
             make.top.equalTo(infoViewBottomLine.mas_bottom).offset(30);
             make.width.mas_equalTo(@280);
             make.height.mas_equalTo(@25);
        }];
    
    } else { //普通---frame

        ZHStepView *stepV = [[ZHStepView alloc] initWithFrame:CGRectZero type:ZHStepViewTypeDefault];
        self.stepView = stepV;
        self.stepView.isDefault = YES;

        [self.bgScrollView addSubview:self.stepView];
        [stepV mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.bgScrollView.mas_left).offset(LEFT_MARGIN);
            make.top.equalTo(priceBottomLine.mas_bottom).offset(20);
            make.width.mas_equalTo(@250);
            make.height.mas_equalTo(@25);
        }];
        
    }



}



#pragma mark- 顶部切换UI
- (UIView *)switchView {
    
    if (!_switchView) {
        
        _switchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 190, 34)];
        _switchView.backgroundColor = [UIColor whiteColor];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _switchView.width, 40)];
        self.switchLine = [[UIView alloc] initWithFrame:CGRectMake(0, 40 - 2, 40, 2)];
        self.switchLine.backgroundColor = [UIColor zh_themeColor];
        [bgView addSubview:self.switchLine];
        
        NSArray *types = @[@"商品",@"详情",@"评价"];
        for (NSInteger i = 0; i < types.count; i ++) {
            
            CGFloat x = _switchView.width/3.0;
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i*x, 2, x, 28) title:types[i] backgroundColor:[UIColor whiteColor]];
            btn.titleLabel.font = FONT(17);
            [bgView addSubview:btn];
            [btn addTarget:self action:@selector(switchConten:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitleColor:[UIColor zh_textColor] forState:UIControlStateNormal];
            btn.tag = i;
            if (i == 0) {
                btn.titleLabel.font = FONT(18);
                self.switchLine.centerX = btn.centerX;
                [btn setTitleColor:[UIColor zh_themeColor] forState:UIControlStateNormal];
                self.lastBtn = btn;
            }
            
        }
        
        
        
        [_switchView addSubview:bgView];
    }
    return _switchView;
    
}




@end
