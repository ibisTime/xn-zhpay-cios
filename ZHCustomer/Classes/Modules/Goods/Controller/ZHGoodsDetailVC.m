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
#import "ZHEvaluateListVC.h" //评价列表
#import "ZHSingleDetailVC.h" //详情列表
#import "ZHShoppingCartVC.h"
#import "ZHUserLoginVC.h"
#import "MJRefresh.h"
#import "ZHShareView.h"
#import "AppConfig.h"
#import "CDGoodsParameterChooseView.h"
#import "CDGoodsParameterModel.h"

@interface ZHGoodsDetailVC ()<GoodsParameterChooseDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *bgScrollView;

//@property (nonatomic,strong) ZHBuyToolView *buyView;

@property (nonatomic,weak) TLBannerView *bannerView;
@property (nonatomic, strong) UIScrollView *goodsDetailTypeScrollView;

@property (nonatomic,strong) UILabel *nameLbl;
@property (nonatomic,strong) UILabel *advLbl;
@property (nonatomic,strong) UILabel *priceLbl;
@property (nonatomic,strong) UILabel *postageLbl;



@property (nonatomic,strong) UIView *line1;
@property (nonatomic,strong) UIView *line2;

//@property (nonatomic, weak) ZHStepView *stepView;
//@property (nonatomic, strong) ZHTreasureInfoView *infoView;

//
@property (nonatomic,strong) UIView *switchView;
@property (nonatomic, strong) UIView *switchSubView;
@property (nonatomic, assign) BOOL switchByTap;


//顶部切换相关
@property (nonatomic, strong) UIView *switchLine;
@property (nonatomic, strong) UIButton *lastBtn;
@property (nonatomic, strong) UIView *detailView;
@property (nonatomic, strong) UIView *evaluateViwe;
//@property (nonatomic, strong) UIView *goodsArgsView;
@property (nonatomic, copy) NSArray <CDGoodsParameterModel *> *parameterModelArr;

@end


@implementation ZHGoodsDetailVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.bannerView.timer invalidate];
    self.bannerView.timer = nil;
}

- (void)tl_placeholderOperation {
    
    //先查询规格
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"808037";
    http.parameters[@"productCode"] = self.goods.code;
    [http postWithSuccess:^(id responseObject) {
        
        [self removePlaceholderView];
        
        self.parameterModelArr = [CDGoodsParameterModel tl_objectArrayWithDictionaryArray:responseObject[@"data"]];
        
        [self setUpUI];
        [self addEvent];
        
    } failure:^(NSError *error) {
        
        [self addPlaceholderView];

    }];
    //
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setPlaceholderViewTitle:@"加载失败" operationTitle:@"重新加载"];
    [self tl_placeholderOperation];
  
}

- (void)addEvent {


    //
    self.bgScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    
    //拍普通商品，价格在上面
    self.bannerView.imgUrls = @[[self.goods.advPic convertImageUrl]];
    
    
    //---//
    self.nameLbl.text = self.goods.name;
    self.advLbl.text = self.goods.slogan;
    self.priceLbl.text = [ZHCurrencyHelper totalPriceWithQBB:self.goods.QBB GWB:self.goods.GWB  RMB:self.goods.RMB];
    
    self.postageLbl.text = @"邮费:10元";
    
    //扩大
//    self.bgScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.stepView.yy + 10);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(treasureSuccess) name:@"dbBuySuccess" object:nil];
    
}

#pragma mark- 顶部切换事件
- (void)switchConten:(UIButton *)btn {
    
    
    if ([_lastBtn isEqual:btn]) {
        return;
    }
    
    self.switchByTap = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.switchByTap = NO;
        
    });
    
    NSInteger tag = btn.tag - 100;
    
    switch (tag) {
            //商品
        case 0: [self.goodsDetailTypeScrollView addSubview:self.bgScrollView];
            
            break;
            //详情
        case 1:  [self.goodsDetailTypeScrollView addSubview:self.detailView];
            
            break;
            
            //参数
//        case 2:
//            
//            [self.goodsDetailTypeScrollView addSubview:self.goodsArgsView];
//            
//            break;
//            
//            //评价
        case 2 :
            [self.goodsDetailTypeScrollView addSubview:self.evaluateViwe];
            
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
    
    
    //
    [self.goodsDetailTypeScrollView setContentOffset:CGPointMake(self.goodsDetailTypeScrollView.width*tag, 0) animated:YES];
    
}

#pragma mark- 商品详情切换的scrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

//    return;
  
    if (self.switchByTap) {
      
        return;
    }
    
    NSInteger tag =  scrollView.contentOffset.x/SCREEN_WIDTH + 100;
    
    if (tag < 0) {
        return;
    }
    
    
    UIButton *btn = (UIButton *)[self.switchSubView viewWithTag:tag];
    if (!btn) {
        return;
    }
    
    switch (tag - 100) {
            //商品
        case 0: [self.goodsDetailTypeScrollView addSubview:self.bgScrollView];
            
            break;
            //详情
        case 1:  [self.goodsDetailTypeScrollView addSubview:self.detailView];
            
            break;
            
            //参数
//        case 2:
//            
//            [self.goodsDetailTypeScrollView addSubview:self.goodsArgsView];
//            
//            break;
            
            //评价
        case 2 :
            [self.goodsDetailTypeScrollView addSubview:self.evaluateViwe];
            
            break;
            
    }
    
    if (!btn || [self.lastBtn isEqual:btn]) {
        return;
    }
    
    //
    [UIView animateWithDuration:0.25 animations:^{
        
        self.switchLine.centerX = btn.centerX;
        btn.titleLabel.font = FONT(18);
        [btn setTitleColor:[UIColor zh_themeColor] forState:UIControlStateNormal];
        [self.lastBtn  setTitleColor:[UIColor zh_textColor] forState:UIControlStateNormal];
        
        self.lastBtn.titleLabel.font = FONT(17);
    }];
    
    self.lastBtn = btn;
    

}


-(void)share {
    
    ZHShareView *shareView = [[ZHShareView alloc] init];
    shareView.wxShare = ^(BOOL isSuccess, int code){
        
        if (isSuccess) {
            
            [TLAlert alertWithHUDText:@"分享成功"];
            
        }
        
    };
    
//     http://121.43.101.148:5603/share/share-product.html?code=CP201704071617018969
    shareView.title = @"正汇钱包";
    shareView.content = self.goods.name;
    shareView.shareUrl = [NSString stringWithFormat:@"%@/share/share-product.html?code=%@",[AppConfig config].shareBaseUrl,self.goods.code];
    
    [shareView show];
    
    
    
}


- (void)treasureSuccess{

    [self.bgScrollView.mj_header beginRefreshing];
}

//- (void)cartCountChange {
//
//    if (self.detailType == ZHGoodsDetailTypeDefault && self.buyView) {
//        
//        self.buyView.countView.msgCount = [ZHCartManager manager].count;
//        
//    }
//    //----//
//}


#pragma mark- 一元夺宝刷新
- (void)refresh {


      [self.bgScrollView.mj_header endRefreshing];


}

#pragma mark- 规格选择的代理
- (void)finishChooseWithType:(GoodsParameterChooseType)type chooseView:(CDGoodsParameterChooseView *)chooseView parameter:(CDGoodsParameterModel *)parameterModel count:(NSInteger)count {

    [chooseView dismiss];
    
    //
    ZHImmediateBuyVC *buyVC = [[ZHImmediateBuyVC alloc] init];
    buyVC.type = ZHIMBuyTypeSingle;
    buyVC.postage = @10000;
    self.goods.count = count;
    
    self.goods.currentParameterPriceRMB = parameterModel.price1;
    self.goods.currentParameterPriceGWB = parameterModel.price2;
    self.goods.currentParameterPriceQBB = parameterModel.price3;
    self.goods.selectedParameter = parameterModel;
    
    buyVC.goodsRoom = @[self.goods];
    [self.navigationController pushViewController:buyVC animated:YES];
    
}
#pragma mark- 购买
- (void)buy {
    
    CDGoodsParameterChooseView *chooseView = [CDGoodsParameterChooseView chooseView];
    chooseView.coverImageUrl = [self.goods.advPic convertImageUrl];
    [chooseView loadArr:self.parameterModelArr];
    chooseView.delegate = self;
    [chooseView show];
    
    //
    if (![ZHUser user].isLogin) {
       
        ZHUserLoginVC *loginVC = [[ZHUserLoginVC alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:nil];
        loginVC.loginSuccess = ^(){
            [self buy];
        };
        return;
    }

    
}


//#pragma mark- 加入购物车
//- (void)addToShopCar {
//
//    if (![ZHUser user].isLogin) {
//        
//        ZHUserLoginVC *loginVC = [[ZHUserLoginVC alloc] init];
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
//        [self presentViewController:nav animated:YES completion:nil];
//        loginVC.loginSuccess = ^(){
//            [self buy];
//        };
//        return;
//    }
//    
//    TLNetworking *http = [TLNetworking new];
//    http.showView = self.view;
//    http.code = @"808040";
//    http.parameters[@"userId"] = [ZHUser user].userId;
//    http.parameters[@"token"] = [ZHUser user].token;
//
//    http.parameters[@"productCode"] = self.goods.code;
//    http.parameters[@"quantity"] = [NSString stringWithFormat:@"%ld",self.stepView.count];
//    [http postWithSuccess:^(id responseObject) {
//        
//        [TLAlert alertWithHUDText:@"添加到购物车成功"];
//        
////        [ZHCartManager manager].count = [ZHCartManager manager].count + self.stepView.count;
//        
//    } failure:^(NSError *error) {
//        
//        
//    }];
//    
//
//}

//#pragma mark- 购物车
//- (void)openShopCar {
//
//    if (![ZHUser user].isLogin) {
//        
//        ZHUserLoginVC *loginVC = [[ZHUserLoginVC alloc] init];
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
//        [self presentViewController:nav animated:YES completion:nil];
//        loginVC.loginSuccess = ^(){
//            [self buy];
//        };
//        return;
//    }
//    
//    ZHShoppingCartVC *vc = [[ZHShoppingCartVC alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
//
//}



- (UIView *)detailView {
    
    if (!_detailView ) {
        
        ZHSingleDetailVC *detailVC = [[ZHSingleDetailVC alloc] init];
        detailVC.view.frame = CGRectOffset(self.bgScrollView.frame, SCREEN_WIDTH, 0);
        [self addChildViewController:detailVC];
        detailVC.goods = self.goods;

        
        [self.view addSubview:detailVC.view];
        _detailView = detailVC.view;
        
    }
    return _detailView;
    
}


-(UIView *)evaluateViwe {
    
    if (!_evaluateViwe ) {
        
        ZHEvaluateListVC *evaluateListVC = [[ZHEvaluateListVC alloc] init];

    
        
        evaluateListVC.goodsCode = self.goods.code;
        evaluateListVC.peopleNum = self.goods.boughtCount;
        evaluateListVC.view.frame = CGRectOffset(self.bgScrollView.frame, SCREEN_WIDTH*2, 0);
        [self addChildViewController:evaluateListVC];
        [self.view addSubview:evaluateListVC.view];

        _evaluateViwe = evaluateListVC.view;
        
    }
    
    return _evaluateViwe;
    
}

//- (UIView *)goodsArgsView {
//
//    if (!_goodsArgsView) {
//        
//        ZHGoodsParameterVC *vc = [ZHGoodsParameterVC new];
//        vc.view.frame = CGRectOffset(self.bgScrollView.frame, SCREEN_WIDTH*2, 0);;
//        vc.productCode = self.goods.code;
//        [self addChildViewController:vc];
//        [self.view addSubview:vc.view];
//        
//        _goodsArgsView = vc.view;
//        
//    }
//    
//    return _goodsArgsView;
//
//}

- (void)setUpUI {

    self.navigationItem.titleView = self.switchView;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"分享"] style:UIBarButtonItemStylePlain target:self action:@selector(share)];
    
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //底部负责左右切换的背景
    self.goodsDetailTypeScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49)];
    [self.view addSubview:self.goodsDetailTypeScrollView];
    self.goodsDetailTypeScrollView.pagingEnabled = YES;
    self.goodsDetailTypeScrollView.showsHorizontalScrollIndicator = NO;
    self.goodsDetailTypeScrollView.backgroundColor = [UIColor zh_backgroundColor];
    self.goodsDetailTypeScrollView.delegate = self;
    self.goodsDetailTypeScrollView.contentSize = CGSizeMake(self.goodsDetailTypeScrollView.width*3, self.goodsDetailTypeScrollView.height);
    
    //商品信息背景
    self.bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49)];
    self.bgScrollView.backgroundColor = [UIColor whiteColor];
    
    [self.goodsDetailTypeScrollView addSubview: self.bgScrollView];
    
    
    UIButton *buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.bgScrollView.yy, SCREEN_WIDTH, 49) title:@"立即购买" backgroundColor:[UIColor zh_themeColor]];
    [buyBtn addTarget:self action:@selector(buy) forControlEvents:UIControlEventTouchUpInside];
    buyBtn.titleLabel.font = FONT(18);
    [self.view addSubview:buyBtn];
    
    
    
    //轮播图
    TLBannerView *bannerView = [[TLBannerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*0.8)];
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
    self.postageLbl = [UILabel labelWithFrame:CGRectZero
                               textAligment:NSTextAlignmentLeft
                            backgroundColor:[UIColor whiteColor]
                                       font:FONT(14)
                                  textColor:[UIColor zh_textColor]];
    [self.bgScrollView addSubview:self.postageLbl];
    [self.postageLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceLbl.mas_bottom).offset(11);
        make.left.equalTo(self.bgScrollView.mas_left).offset(15);
    }];
    
    //
    UIView *priceBottomLine = [[UIView alloc] init];
    priceBottomLine.backgroundColor = [UIColor zh_lineColor];
    [self.bgScrollView addSubview:priceBottomLine];
    [priceBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.postageLbl.mas_bottom).offset(11);
        make.left.equalTo(self.bgScrollView.mas_left);
        make.width.mas_equalTo(@(SCREEN_WIDTH));
        make.height.mas_equalTo(@(1));
        
    }];
   
   //
 
}

#pragma mark- 顶部切换UI
- (UIView *)switchView {
    
    if (!_switchView) {
        
        _switchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 160, 34)];
        _switchView.backgroundColor = [UIColor whiteColor];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _switchView.width, 40)];
        self.switchLine = [[UIView alloc] initWithFrame:CGRectMake(0, 40 - 2, 40, 2)];
        self.switchLine.backgroundColor = [UIColor zh_themeColor];
        [bgView addSubview:self.switchLine];
        self.switchSubView = bgView;
        
        NSArray *types = @[@"商品",@"详情",@"评价"];
        for (NSInteger i = 0; i < types.count; i ++) {
            
            CGFloat x = _switchView.width/types.count;
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i*x, 2, x, 28) title:types[i] backgroundColor:[UIColor whiteColor]];
            btn.titleLabel.font = FONT(17);
            [bgView addSubview:btn];
            
            [btn addTarget:self action:@selector(switchConten:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitleColor:[UIColor zh_textColor] forState:UIControlStateNormal];
            btn.tag = i + 100;
            
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
