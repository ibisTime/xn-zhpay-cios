//
//  ZHGoodsVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/23.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHGoodsVC.h"
#import "ZHLookForTreasureVC.h"
#import "ZHGoodsCell.h"
#import "ZHDefaultGoodsVC.h"
#import "TLMsgBadgeView.h"
#import "ZHShoppingCartVC.h"
#import "ZHUserLoginVC.h"
#import "ZHNavigationController.h"
#import "ZHSegmentView.h"
#import "ZHGoodsCategoryManager.h"
#import "ZHGoodsCategoryVC.h"
#import "ZHCartManager.h"
#import "ZHSearchVC.h"
#import "ZHDuoBaoVC.h"

@interface ZHGoodsVC ()<ZHSegmentViewDelegate>

@property (nonatomic,strong) UIScrollView *switchScrollView;
@property (nonatomic,strong) UIView *typeChangeView;
@property (nonatomic,strong) UIButton *goShoppingCartBtn;
@property (nonatomic,strong) UIView *reloaView;
@property (nonatomic,strong) TLMsgBadgeView *msgBadgeView;
@property (nonatomic,strong) ZHGoodsCategoryVC *zeroBuyVC;

@end

@implementation ZHGoodsVC
{

    dispatch_group_t _getCategoryGroup;
    
}

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"尖货";
    _getCategoryGroup = dispatch_group_create();
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search"] style:UIBarButtonItemStylePlain target:self action:@selector(search)];
    
    
    [self setUpUI];

    return;
#warning -- 上面部分，调整界面用 ；要去调
    
    // 判断底部滑动的时候，是否已经加载过控制器

    //1.判断小类是否已经加载完成
    ZHGoodsCategoryManager *manager = [ZHGoodsCategoryManager manager];
    
    if (manager.lysgCategories && manager.dshjCategories) {
        
        //2.顶部的大类和小类切换
        [self setUpUI];
        
    } else {
        
        //去请求
        [self reload];
    
    }
    
//    UIButton *btn = self.goShoppingCartBtn;
    if (self.msgBadgeView) {
        
        self.msgBadgeView.msgCount = [ZHCartManager manager].count;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cartCountChange) name:kShoopingCartCountChangeNotification object:nil];
    
    

    
}

#pragma mark- 数量改变通知
- (void)cartCountChange {

    if (self.msgBadgeView) {
        
        self.msgBadgeView.msgCount = [ZHCartManager manager].count;

    }

}


//获取失败,重新获取
- (void)reload {

    __block  NSInteger count = 0;
       dispatch_group_enter(_getCategoryGroup);
        //获取分类接口
        TLNetworking *http = [TLNetworking new];
        http.code = @"808006";
        http.showView = self.view;
        http.parameters[@"parentCode"] = @"FL201600000000000001";
        [http postWithSuccess:^(id responseObject) {
            count ++;
            dispatch_group_leave(_getCategoryGroup);
            
            [ZHGoodsCategoryManager manager].dshjCategories = [ZHCategoryModel tl_objectArrayWithDictionaryArray:responseObject[@"data"]];
            
        } failure:^(NSError *error) {
            
            dispatch_group_leave(_getCategoryGroup);
            [self.view addSubview:self.reloaView];
            
        }];
    
    dispatch_group_enter(_getCategoryGroup);
    //获取分类接口
    TLNetworking *http1 = [TLNetworking new];
    http1.code = @"808006";
    http1.showView = self.view;
    http1.parameters[@"parentCode"] = @"FL201600000000000003";
    [http1 postWithSuccess:^(id responseObject) {
        
        count ++;
        dispatch_group_leave(_getCategoryGroup);
        [ZHGoodsCategoryManager manager].lysgCategories = [ZHCategoryModel tl_objectArrayWithDictionaryArray:responseObject[@"data"]];
        
    } failure:^(NSError *error) {
        
        dispatch_group_leave(_getCategoryGroup);
        [self.view addSubview:self.reloaView];
        
    }];
    
    dispatch_group_notify(_getCategoryGroup, dispatch_get_main_queue(), ^{
        
        if (count == 2) {
            [self setUpUI];
        }
        
    });

}


- (UIView *)reloaView {

    if (!_reloaView) {
        
      _reloaView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 100)];
        _reloaView.centerY = (SCREEN_WIDTH - 64 - 49) / 2.0;
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        lbl.text = @"亲，加载失败了";
        lbl.font = [UIFont systemFontOfSize:20];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.textColor = [UIColor zh_textColor];
        [_reloaView addSubview:lbl];
        
        UIButton *reLoadBtn = [[UIButton alloc] initWithFrame:CGRectMake(30,lbl.yy, 150, 40) title:@"重新加载" backgroundColor:[UIColor clearColor]];
        reLoadBtn.centerX = _reloaView.width/2.0;
        reLoadBtn.layer.borderColor = [UIColor zh_textColor2].CGColor;
        reLoadBtn.layer.borderWidth = 1;
        [reLoadBtn setTitleColor:[UIColor zh_textColor] forState:UIControlStateNormal];
        [reLoadBtn addTarget:self action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
        [_reloaView addSubview:reLoadBtn];
        
    }
    
    return _reloaView;

}



#pragma mark- 点击购物车选项
- (void)goShoppingCart {
    
    if (![ZHUser user].isLogin) {
        
        ZHUserLoginVC *loginVC = [[ZHUserLoginVC alloc] init];
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:nil];
        
        
        return;
    }
    ZHShoppingCartVC *vc = [[ZHShoppingCartVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)search {
    
    ZHSearchVC *searchVC = [[ZHSearchVC alloc] init];
    searchVC.type = ZHSearchVCTypeDefaultGoods;
    [self.navigationController pushViewController:searchVC animated:YES];
    
}

//}


- (BOOL)segmentSwitch:(NSInteger)idx {

    if (idx == 1) {
        
        ZHDuoBaoVC *小目标VC = [[ZHDuoBaoVC alloc] init];
        [self.navigationController pushViewController:小目标VC animated:YES];
        return NO;
        
//        ZHLookForTreasureVC *treasureVC = [[ZHLookForTreasureVC alloc] init];
//        [self.navigationController pushViewController:treasureVC animated:YES];
//        return NO;
        
    }
    
    
    if (idx == 2) {
        
        [self addChildViewController:self.zeroBuyVC];
        self.zeroBuyVC.smallCategories = [ZHGoodsCategoryManager manager].lysgCategories;
        self.zeroBuyVC.view.frame = self.switchScrollView.bounds;
        self.zeroBuyVC.view.x =SCREEN_WIDTH * 2;
        [self.switchScrollView addSubview:self.zeroBuyVC.view];
        
    }
    
    [self.switchScrollView setContentOffset:CGPointMake(idx*SCREEN_WIDTH, 0) animated:NO];
    
    return YES;

}

- (ZHGoodsCategoryVC *)zeroBuyVC {

    if (!_zeroBuyVC) {
        _zeroBuyVC = [[ZHGoodsCategoryVC alloc] init];
    }
    
    return _zeroBuyVC;
    
}


- (UIButton *)goShoppingCartBtn {
    
    if (!_goShoppingCartBtn) {
        
        _goShoppingCartBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 57,SCREEN_HEIGHT -  110 - 10 - 64, 37, 37)];
        [_goShoppingCartBtn setImage:[UIImage imageNamed:@"购物车"] forState:UIControlStateNormal];
        [_goShoppingCartBtn addTarget:self action:@selector(goShoppingCart) forControlEvents:UIControlEventTouchUpInside];
        
        if (!self.msgBadgeView) {
            
            TLMsgBadgeView *badgeView = [[TLMsgBadgeView alloc] initWithFrame:CGRectMake( 22, -3, 18, 18)];
            badgeView.padding = 13;
            [_goShoppingCartBtn addSubview:badgeView];
            badgeView.font = FONT(13);
            self.msgBadgeView = badgeView;
        }
   
//        badgeView.msgCount = 30;
        
    }
    return _goShoppingCartBtn;
    
}


- (void)setUpUI {

    [self.reloaView removeFromSuperview];

//    //顶部切换按钮
    CGFloat h = 45;
    CGFloat margin = 0.5;
    
    //切换按钮
    ZHSegmentView *segmentView = [[ZHSegmentView alloc] initWithFrame:CGRectMake(0, margin, SCREEN_WIDTH, h)];
    segmentView.delegate = self;
    segmentView.tagNames = @[@"剁手合集",@"一元夺宝",@"0元试购"];
    [self.view addSubview:segmentView];
    self.typeChangeView = segmentView;
    
    
    self.switchScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.typeChangeView.yy, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49 - self.typeChangeView.yy)];
    [self.view addSubview:self.switchScrollView];
    self.switchScrollView.pagingEnabled = YES;
    self.switchScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, self.switchScrollView.height);
    self.switchScrollView.scrollEnabled = NO;
    
    //添加剁手合集分类
    ZHGoodsCategoryVC *dshjVC = [[ZHGoodsCategoryVC alloc] init];
    [self addChildViewController:dshjVC];
    //小类赋值
    dshjVC.smallCategories = [ZHGoodsCategoryManager manager].dshjCategories;
    [self.switchScrollView addSubview:dshjVC.view];
    
    //添加购物车--按钮
    [self.view addSubview:self.goShoppingCartBtn];
    
}


@end
