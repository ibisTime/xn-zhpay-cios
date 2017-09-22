//
//  ZHGoodsCategoryVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/10.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHGoodsCategoryVC.h"
#import "UIColor+theme.h"
#import "ZHDefaultGoodsVC.h"

@interface ZHGoodsCategoryVC ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *smallChooseScrollView;
@property (nonatomic,strong) UIButton *lasBtn;
@property (nonatomic,strong) NSMutableArray <UIButton *>*tagLbls;
@property (nonatomic,strong) UIScrollView  *switchScrollView;

@property (nonatomic,strong) NSMutableArray <NSNumber *>*isHaveChildVC;

@end

@implementation ZHGoodsCategoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //小类的数量
    NSInteger count = self.smallCategories.count;

    
    self.isHaveChildVC = [NSMutableArray array];
    for (NSInteger i = 0; i < count; i ++) {
        if (i == 0) {
            
            [self.isHaveChildVC addObject:@1];
            
        } else {
            
            [self.isHaveChildVC addObject:@0];
            
        }
        
    }
    
    //上部
    UIScrollView *smallChooseView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    smallChooseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:smallChooseView];
    smallChooseView.showsHorizontalScrollIndicator = NO;
    self.smallChooseScrollView = smallChooseView;
    self.smallChooseScrollView.delegate = self;
    
    //下部
    self.switchScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.smallChooseScrollView.yy, SCREEN_WIDTH, SCREEN_HEIGHT - [DeviceUtil top64] - [DeviceUtil bottom49] - smallChooseView.yy)];
    [self.view addSubview:self.switchScrollView];
    self.switchScrollView.showsHorizontalScrollIndicator = NO;
    self.switchScrollView.pagingEnabled = YES;
    self.switchScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * count, self.switchScrollView.height);
    self.switchScrollView.delegate = self;
    
    
    //
    //----//
    self.tagLbls = [NSMutableArray array];
    __block UIButton *lastMarkBtn = [UIButton new];
    [self.smallCategories enumerateObjectsUsingBlock:^(ZHCategoryModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSUInteger i = idx;
        //每个起点
        //计算宽度
        CGFloat w = [obj.name calculateStringSize:CGSizeMake(MAXFLOAT, MAXFLOAT) font:FONT(13)].width + 30;
        CGFloat x;
        if (i == 0) {
            
            x = 0;
            
        } else {
            
            x = lastMarkBtn.xx;
            
        }
        
        //---
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, w, 40) title:obj.name backgroundColor:[UIColor whiteColor]];
        [btn setTitleColor:[UIColor zh_textColor] forState:UIControlStateNormal];
        [smallChooseView addSubview:btn];
        btn.tag = 1000 + i;
        btn.titleLabel.font = FONT(13);
        [btn addTarget:self action:@selector(smallChoose:) forControlEvents:UIControlEventTouchUpInside];
        //--
        [self.tagLbls addObject:btn];
        //记录上一次的btn
        lastMarkBtn = btn;
        
        if (i == count - 1) {
            if (btn.xx > smallChooseView.width) {
                
                smallChooseView.contentSize = CGSizeMake(btn.xx, 40);
                
            } else {
                smallChooseView.contentSize = CGSizeMake(smallChooseView.width, 40);
            }
        }
        
        if (0 == i) {
            self.lasBtn = btn;
            [btn setTitleColor:[UIColor zh_themeColor] forState:UIControlStateNormal];
            
        }
        
    }];
    
    
    //先添加一个
    
   ZHDefaultGoodsVC *defaultVC = [[ZHDefaultGoodsVC alloc] init];
    if (self.smallCategories.count <= 0) {
        NSLog(@"又大类 没小类");
        return;
    }
   ZHCategoryModel *model = self.smallCategories[0];
    //先设置code  如果先设置frame,则viewDidLoad就会优先调用
   defaultVC.categoryCode = model.code;
   [self addChildViewController:defaultVC];
   defaultVC.view.frame = self.switchScrollView.bounds;
   [self.switchScrollView addSubview:defaultVC.view];

    
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    NSInteger index = scrollView.contentOffset.x/scrollView.width;
    
    //--//
    //取出
    if ([self.isHaveChildVC[index] isEqualToNumber:@1]) {
        
        
    } else {
        
        ZHDefaultGoodsVC *defaultVC2 = [[ZHDefaultGoodsVC alloc] init];
        [self addChildViewController:defaultVC2];
        
        ZHCategoryModel *model = self.smallCategories[index];
        //先设置code  如果先设置frame,则viewDidLoad就会优先调用
        defaultVC2.categoryCode = model.code;
        defaultVC2.view.frame = CGRectMake(SCREEN_WIDTH*index, 0, self.switchScrollView.width, self.switchScrollView.height);
        [self.switchScrollView addSubview:defaultVC2.view];
        self.isHaveChildVC[index] = @1;
        
    }
    
}


//#pragma mark- 操作上面
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    //    //拖动结束
    if ([scrollView isEqual:self.smallChooseScrollView]) {
        
        //取出离中点最近的一个按钮
        
    } else {
        
        NSInteger index = (targetContentOffset -> x)/SCREEN_WIDTH;
        UIButton *currentBtn = (UIButton *)[self.smallChooseScrollView viewWithTag:1000 + index];
        if ([self.lasBtn isEqual:currentBtn]) {
            return;
        }
        
        //     UIButton *currentBtn = self.tagLbls[index];
        [currentBtn setTitleColor:[UIColor zh_themeColor] forState:UIControlStateNormal];
        [self.lasBtn setTitleColor:[UIColor zh_textColor] forState:UIControlStateNormal];
        self.lasBtn = currentBtn;
        [self smallScroll:currentBtn];
        
    }
    
    
    
}


#pragma mark--上下联动相关,操作--上面--下面--动
- (void)smallChoose:(UIButton *)btn {
    
    if ([self.lasBtn isEqual:btn]) {
        return;
    }
    //下部改变
    [self.switchScrollView setContentOffset:CGPointMake(SCREEN_WIDTH * (btn.tag - 1000), 0) animated:NO];
    
    [self.lasBtn setTitleColor:[UIColor zh_textColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor zh_themeColor] forState:UIControlStateNormal];
    self.lasBtn = btn;
    [self smallScroll:btn];
    
}

- (void)smallScroll:(UIButton *)btn {
    
    //宽度 和 内容宽度
    CGFloat w = self.smallChooseScrollView.width;
//    CGFloat contentW = self.smallChooseScrollView.contentSize.width;
    //按钮中点 和 scrollview中点相比较
    
    //应当滚动的
    CGFloat  dValue =  btn.centerX - w/2.0;
    
    
    //分析什么时候不该移动
    //找出临界值
    
    //1.按钮中点小于 1/2
    
    //最大滚动之
    CGFloat maxScrollContent = self.smallChooseScrollView.contentSize.width - self.smallChooseScrollView.bounds.size.width;
    
    CGPoint movePoint = CGPointMake(dValue, 0);
    if (dValue < 0) {
        movePoint = CGPointMake(0, 0);
    }
    
    if (dValue > maxScrollContent) {
        movePoint = CGPointMake(maxScrollContent, 0);
    }
    
    [self.smallChooseScrollView setContentOffset:movePoint animated:YES];
    
    
}


@end
