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
#import "ZHShopDetailVC.h"
#import "TLHeader.h"
#import "ZHBuyToolView.h"
#import "ZHTreasureInfoView.h"
#import "ZHImmediateBuyVC.h"
#import "ZHEvaluateListVC.h" //评价列表
#import "ZHSingleDetailVC.h" //详情列表
#import "ZHUserLoginVC.h"
#import "MJRefresh.h"
#import "ZHShareView.h"
#import "AppConfig.h"
#import "CDGoodsParameterChooseView.h"
#import "CDGoodsParameterModel.h"
#import "ZHUser.h"
#import "UIColor+theme.h"

@interface ZHGoodsDetailVC ()<GoodsParameterChooseDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *bgScrollView;


@property (nonatomic,weak) TLBannerView *bannerView;
@property (nonatomic, strong) UIScrollView *goodsDetailTypeScrollView;

@property (nonatomic,strong) UILabel *nameLbl;
@property (nonatomic,strong) UILabel *advLbl;
@property (nonatomic,strong) UILabel *priceLbl;


@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *shopNameLbl;
@property (nonatomic, strong) UILabel *shopPhoneLbl;
@property (nonatomic, strong) UILabel *shopAdvLbl;

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
        [self.parameterModelArr enumerateObjectsUsingBlock:^(CDGoodsParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            //
            obj.masterGoodsModel = self.goods;
            
        }];
        
        [self setUpUI];
        [self addEvent];
        [self initData];
        
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

- (void)initData {

    //拍普通商品，价格在上面
    self.bannerView.imgUrls = @[[self.goods.advPic convertImageUrl]];
    
    
    //---//
    self.nameLbl.text = self.goods.name;
    self.advLbl.text = self.goods.slogan;
    self.priceLbl.text = [self.goods displayPriceStr];
    
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:[self.goods.store.advPic convertThumbnailImageUrl]]];
    self.shopPhoneLbl.text = [self.goods.store getShopTypeName];
    
    self.shopAdvLbl.text = self.goods.store.slogan;
    self.shopNameLbl.text = self.goods.store.name;
    
}

- (void)addEvent {

    //
    self.bgScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    
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


#pragma mark- 一元夺宝刷新
- (void)refresh {

   [self.bgScrollView.mj_header endRefreshing];

}

#pragma mark- 规格选择的代理
- (void)finishChooseWithType:(GoodsParameterChooseType)type chooseView:(CDGoodsParameterChooseView *)chooseView parameter:(CDGoodsParameterModel *)parameterModel count:(NSInteger)count {

    [chooseView dismiss];
    
    //
    ZHImmediateBuyVC *buyVC = [[ZHImmediateBuyVC alloc] init];
    
    self.goods.currentCount = count;
    self.goods.currentParameterPriceRMB = parameterModel.price1;
    
//    self.goods.currentParameterPriceGWB = parameterModel.price2;
//    self.goods.currentParameterPriceQBB = parameterModel.price3;
    
    self.goods.currentParameterModel = parameterModel;

    
    buyVC.goodsRoom = @[self.goods];
    [self.navigationController pushViewController:buyVC animated:YES];
    
}

#pragma mark- 购买
- (void)buy {
    
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
    
    CDGoodsParameterChooseView *chooseView = [CDGoodsParameterChooseView chooseView];
    chooseView.coverImageUrl = [self.goods.advPic convertImageUrl];
    
    [self.parameterModelArr enumerateObjectsUsingBlock:^(CDGoodsParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        obj.isGift = [self.goods isGift];
        
    }];
    [chooseView loadArr:self.parameterModelArr];
    chooseView.delegate = self;
    [chooseView show];
    
}


- (void)goShop {

    ZHShopDetailVC *shopDetailVC = [[ZHShopDetailVC alloc] init];
    shopDetailVC.shopCode = self.goods.store.code;
    [self.navigationController pushViewController:shopDetailVC animated:YES];

}

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


- (void)setUpUI {

    self.navigationItem.titleView = self.switchView;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"分享"] style:UIBarButtonItemStylePlain target:self action:@selector(share)];
    
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //底部负责左右切换的背景
    self.goodsDetailTypeScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - [DeviceUtil top64] - 49)];
    [self.view addSubview:self.goodsDetailTypeScrollView];
    self.goodsDetailTypeScrollView.pagingEnabled = YES;
    self.goodsDetailTypeScrollView.showsHorizontalScrollIndicator = NO;
    self.goodsDetailTypeScrollView.backgroundColor = [UIColor zh_backgroundColor];
    self.goodsDetailTypeScrollView.delegate = self;
    self.goodsDetailTypeScrollView.contentSize = CGSizeMake(self.goodsDetailTypeScrollView.width*3, self.goodsDetailTypeScrollView.height);
    adjustsContentInsets(self.goodsDetailTypeScrollView);
    
    //商品信息背景 ，加在左右切换的背景上
    self.bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.goodsDetailTypeScrollView.height)];
    self.bgScrollView.backgroundColor = [UIColor whiteColor];
    [self.goodsDetailTypeScrollView addSubview: self.bgScrollView];
    
    //
    UIView *contentView = [[UIView alloc] init];
    [self.bgScrollView addSubview:contentView];
    
    //
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.bgScrollView);
        make.width.equalTo(self.bgScrollView.mas_width);
    }];
    
    
    UIButton *buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.bgScrollView.yy, SCREEN_WIDTH, 49) title:@"立即购买" backgroundColor:[UIColor zh_themeColor]];
    [buyBtn addTarget:self action:@selector(buy) forControlEvents:UIControlEventTouchUpInside];
    buyBtn.titleLabel.font = FONT(18);
    [self.view addSubview:buyBtn];
    
    
    //轮播图
    TLBannerView *bannerView = [[TLBannerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*0.8)];
    [contentView addSubview:bannerView];
    self.bannerView = bannerView;
    
    //
    UIView *line0 = [[UIView alloc] init];
    line0.backgroundColor = [UIColor zh_lineColor];
    [contentView addSubview:line0];
    [line0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bannerView.mas_bottom);
        make.left.equalTo(contentView.mas_left);
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
    [contentView addSubview:self.nameLbl];
    
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(contentView.mas_left).offset(15);
        make.top.equalTo(self.bannerView.mas_bottom).offset(15);
        make.width.mas_equalTo(@(SCREEN_WIDTH - 30));

    }];
    

    //广告语
    self.advLbl = [[UILabel alloc] initWithFrame:CGRectZero
                                    textAligment:NSTextAlignmentLeft
                                 backgroundColor:[UIColor whiteColor]
                                            font:FONT(14)
                                       textColor:[UIColor zh_textColor2]];
    [contentView addSubview:self.advLbl];
    self.advLbl.numberOfLines = 0;
    [self.advLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.nameLbl.mas_bottom).offset(10);
        make.left.equalTo(contentView.mas_left).offset(15);
        make.width.mas_equalTo(@(SCREEN_WIDTH - 30));
    }];
    
    //价格
    self.priceLbl = [UILabel labelWithFrame:CGRectZero
                               textAligment:NSTextAlignmentLeft
                            backgroundColor:[UIColor whiteColor]
                                       font:FONT(16)
                                  textColor:[UIColor zh_themeColor]];
    [contentView addSubview:self.priceLbl];
    [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.advLbl.mas_bottom).offset(11);
        make.left.equalTo(contentView.mas_left).offset(15);
        make.width.mas_equalTo(@(SCREEN_WIDTH - 30));
    }];
    
    
    
    //
    UIView *priceBottomLine = [[UIView alloc] init];
    priceBottomLine.backgroundColor = [UIColor zh_lineColor];
    [contentView addSubview:priceBottomLine];
    [priceBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.priceLbl.mas_bottom).offset(11);
        make.left.equalTo(contentView.mas_left);
        make.width.mas_equalTo(@(SCREEN_WIDTH));
        make.height.mas_equalTo(@(1));
        
    }];
   
    //底部店铺背景
    UIButton *goShopDetailBtn = [[UIButton alloc] init];
    [contentView addSubview:goShopDetailBtn];
    [goShopDetailBtn addTarget:self action:@selector(goShop) forControlEvents:UIControlEventTouchUpInside];
    
    //店铺封面
    self.coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 80, 65)];
    self.coverImageView.layer.borderWidth = 0.5;
    self.coverImageView.layer.borderColor = [UIColor colorWithHexString:@"#dedede"].CGColor;
    self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.coverImageView.layer.cornerRadius = 2;
    self.coverImageView.layer.masksToBounds = YES;
    self.coverImageView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:self.coverImageView];
    

    //
    self.shopNameLbl = [UILabel labelWithFrame:CGRectZero
                              textAligment:NSTextAlignmentLeft
                           backgroundColor:[UIColor clearColor]
                                      font:[UIFont secondFont]
                                 textColor:[UIColor zh_textColor]];
    self.nameLbl.height = [[UIFont secondFont] lineHeight];
    [contentView addSubview:self.shopNameLbl];
 
    
    //
    self.shopPhoneLbl = [UILabel labelWithFrame:CGRectZero
                                   textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor whiteColor]
                                           font:FONT(13)
                                      textColor:[UIColor zh_textColor2]];
    [contentView addSubview:self.shopPhoneLbl];

    
    //
    self.shopAdvLbl = [UILabel labelWithFrame:CGRectMake(self.nameLbl.x, self.nameLbl.yy + 3, self.nameLbl.width, ceilf([FONT(11) lineHeight]*2))
                             textAligment:NSTextAlignmentLeft
                          backgroundColor:[UIColor whiteColor]
                                     font:FONT(13)
                                textColor:[UIColor zh_textColor2]];
    [contentView addSubview:self.shopAdvLbl];
    
    [goShopDetailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.equalTo(self.coverImageView);
        make.left.right.equalTo(contentView);
        
    }];
    
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).offset(15);
        make.top.equalTo(priceBottomLine.mas_top).offset(15);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(65);
        make.bottom.equalTo(contentView.mas_bottom);
        
    }];
    
    [self.shopNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coverImageView.mas_right).offset(10);
        make.right.equalTo(contentView.mas_right).offset(-15);
        make.top.equalTo(self.coverImageView.mas_top);
    }];
    
    
    [self.shopAdvLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.shopNameLbl.mas_bottom).offset(7);
        make.left.equalTo(self.shopNameLbl.mas_left);
        make.right.equalTo(contentView.mas_right).offset(-15);
    }];
    
    [self.shopPhoneLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.shopAdvLbl.mas_bottom).offset(7);
        make.left.equalTo(self.shopNameLbl.mas_left);
        make.right.equalTo(contentView.mas_right).offset(-15);
        
    }];
    
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
