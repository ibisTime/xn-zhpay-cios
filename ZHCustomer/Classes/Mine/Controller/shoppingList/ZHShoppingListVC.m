//
//  ZHShoppingListVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/30.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHShoppingListVC.h"
#import "ZHSegmentView.h"
#import "ZHShop.h"
#import "ZHShoppingListCategoryVC.h"
#import "ZHPayService.h"
#import "TLHeader.h"


@interface ZHShoppingListVC ()<ZHSegmentViewDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *switchScrollV;

@property (nonatomic,strong) ZHShoppingListCategoryVC *allVC;
@property (nonatomic,strong) ZHShoppingListCategoryVC *willPayVC;
@property (nonatomic,strong) ZHShoppingListCategoryVC *didPayVC;
@property (nonatomic,strong) ZHShoppingListCategoryVC *willSendVC;

@property (nonatomic,strong) ZHShoppingListCategoryVC *didFinishVC;


@property (nonatomic,strong) NSMutableArray *isAdd;

@end


@implementation ZHShoppingListVC

- (void)tl_placeholderOperation {

    [TLProgressHUD showWithStatus:nil];
    [ZHPayService getFRBToGiftB:^(NSNumber *rate) {
        
        [self removePlaceholderView];
      
        
        [TLProgressHUD dismiss];

    } failure:^{
        
        [self addPlaceholderView];
        [TLProgressHUD dismiss];
        
    }];
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购物清单";
    
    [self setPlaceholderViewTitle:@"加载失败" operationTitle:@"重新加载"];
    
//    [self tl_placeholderOperation];
    //
    ZHSegmentView *segmentView =  [[ZHSegmentView alloc] initWithFrame:CGRectMake(0, 0.5, SCREEN_WIDTH, 45)];
    [self.view addSubview:segmentView];
    segmentView.delegate = self;
    segmentView.tagNames = @[@"全部",@"待支付",@"待发货",@"待收货",@"已收货"];
    self.isAdd = [@[@1, @0, @0, @0,@0] mutableCopy];
    
    //
    UIScrollView *switchScrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, segmentView.yy + 0.5, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - segmentView.yy)];
    switchScrollV.pagingEnabled = YES;
    switchScrollV.contentSize = CGSizeMake(SCREEN_WIDTH * 3, switchScrollV.height);
    [self.view addSubview:switchScrollV];
    self.switchScrollV = switchScrollV;
    switchScrollV.scrollEnabled = NO;
    
    //
    [self addChildViewController:self.allVC];
    
 
}

- (ZHShoppingListCategoryVC *)willSendVC {

    if (!_willSendVC) {
        
        _willSendVC = [[ZHShoppingListCategoryVC alloc] init];
        _willSendVC.status = ZHOrderStatusWillSend;
        _willSendVC.view.frame = CGRectMake(2*SCREEN_WIDTH, 0, SCREEN_WIDTH, self.switchScrollV.height);
        
        [self.switchScrollV addSubview:_willSendVC.view];
    }
    return _willSendVC;

}
- (ZHShoppingListCategoryVC *)allVC {

    if (!_allVC) {
        _allVC = [[ZHShoppingListCategoryVC alloc] init];
        
        _allVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.switchScrollV.height);
//        _allVC.status = ZHOrderStatusAll;
        [self.switchScrollV addSubview:_allVC.view];

    }
    return _allVC;
}

- (ZHShoppingListCategoryVC *)willPayVC {
    
    if (!_willPayVC) {
        _willPayVC = [[ZHShoppingListCategoryVC alloc] init];
        

        _willPayVC.status = ZHOrderStatusWillPay;
//        _willPayVC.statusCode = @"1";
        _willPayVC.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, self.switchScrollV.height);

    }
    return _willPayVC;
}

- (ZHShoppingListCategoryVC *)didPayVC {

    if (!_didPayVC) {
        _didPayVC = [[ZHShoppingListCategoryVC alloc] init];
        
        _didPayVC.status = ZHOrderStatusDidPay;
        _didPayVC.view.frame = CGRectMake(SCREEN_WIDTH*3, 0, SCREEN_WIDTH, self.switchScrollV.height);
    }
    return _didPayVC;


}

- (ZHShoppingListCategoryVC *)didFinishVC {

    if(!_didFinishVC) {
    
        _didFinishVC = [[ZHShoppingListCategoryVC alloc] init];
        
        _didFinishVC.status = ZHOrderStatusDidFinish;
        _didFinishVC.view.frame = CGRectMake(SCREEN_WIDTH*4, 0, SCREEN_WIDTH, self.switchScrollV.height);
    
    }
    
    return _didFinishVC;

}



- (BOOL)segmentSwitch:(NSInteger)idx {

    [self.switchScrollV setContentOffset:CGPointMake(idx*SCREEN_WIDTH, 0) animated:NO];
    if (idx == 0) {
        
        
    } else if( idx == 1 ) {
        
        if ([self.isAdd[1] isEqual:@0]) {
            
            [self addChildViewController:self.willPayVC];
            [self.switchScrollV addSubview:_willPayVC.view];

        } else {
        
            self.isAdd[1] = @1;
        }
        
    } else if(idx == 2) {
    
        if ([self.isAdd[idx] isEqual:@0]) {
            
            [self addChildViewController:self.willSendVC];
            [self.switchScrollV addSubview:_willSendVC.view];
            
        } else {
            
            self.isAdd[idx] = @1;
        }
    
    } else if(idx == 3) {
        
        if ([self.isAdd[idx] isEqual:@0]) {
            
            [self addChildViewController:self.didPayVC];
            [self.switchScrollV addSubview:_didPayVC.view];

            
        } else {
            
            self.isAdd[idx] = @1;
        }
        
        
    } else if (idx == 4) {
    
        if ([self.isAdd[idx] isEqual:@0]) {
            
            [self addChildViewController:self.didFinishVC];
            [self.switchScrollV addSubview:_didFinishVC.view];
            
            
        } else {
            
            self.isAdd[idx] = @1;
        }
    
    }
    
    return YES;
}
@end
