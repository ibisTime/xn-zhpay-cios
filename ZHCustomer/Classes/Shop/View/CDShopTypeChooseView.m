//
//  CDShopTypeChooseView.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/6/14.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CDShopTypeChooseView.h"
#import "ZHShopTypeView.h"
#import "ZHShopTypeModel.h"
#import "UIButton+WebCache.h"



@interface CDShopTypeChooseView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic,strong) NSMutableArray <ZHShopTypeView *>*shopTypeViewRooms;
@property (nonatomic, strong) UIPageControl *shopTypePageCtrl;

@end

@implementation CDShopTypeChooseView

+ (instancetype)chooseView {

    CDShopTypeChooseView *view = [[CDShopTypeChooseView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 215)];
    view.backgroundColor = [UIColor backgroundColor];
    
    return view;
    

}

- (UIScrollView *)contentScrollView {

    if (!_contentScrollView) {
        
        _contentScrollView = [[UIScrollView alloc] init];
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        
    }
    
    return _contentScrollView;

}



- (NSMutableArray<ZHShopTypeView *> *)shopTypeViewRooms {
    
    if (!_shopTypeViewRooms) {
        
        _shopTypeViewRooms = [[NSMutableArray alloc] init];
    }
    
    return _shopTypeViewRooms;
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.contentScrollView];
        
        CGFloat pageCtrlH = 20;
        
        self.contentScrollView.delegate = self;
        self.contentScrollView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height - pageCtrlH);

        
        //可能出现pageControll
        UIPageControl *pageCtrl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.contentScrollView.yy + 0.5, self.width, pageCtrlH)];
        pageCtrl.backgroundColor = [UIColor whiteColor];
        pageCtrl.pageIndicatorTintColor = [UIColor colorWithHexString:@"#cccccc"];
        pageCtrl.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"#fe4332"];
        self.shopTypePageCtrl = pageCtrl;
        [self addSubview:self.shopTypePageCtrl];
        
    }
    
    return self;
    
}


#pragma mark- scrollViewDidscroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    self.shopTypePageCtrl.currentPage = scrollView.contentOffset.x/self.contentScrollView.width;
        
}


- (void)setTypeModels:(NSArray<ZHShopTypeModel *> *)typeModels {

    _typeModels = typeModels;
   
    //1.获取数据
    NSArray <ZHShopTypeModel *>* models = _typeModels;
    
    
    //2.先移除原来的
    if (self.shopTypeViewRooms.count > 0) {
        
        [self.shopTypeViewRooms makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.shopTypeViewRooms removeAllObjects];
    }
    
    //计算几页
    NSInteger pageCount = models.count/8;
    if (models.count%8 != 0) {
        pageCount += 1;
    }
    
    //
    self.shopTypePageCtrl.numberOfPages = pageCount;
    //        [self.shopTypePageCtrl updateCurrentPageDisplay];
    self.shopTypePageCtrl.defersCurrentPageDisplay = YES;
    
    //计算contentSize
    self.contentScrollView.contentSize = CGSizeMake(pageCount*SCREEN_WIDTH, self.contentScrollView.height);
    
    //3.然后添加新的
    CGFloat margin = 0.5;
    
    //
    CGFloat w = (SCREEN_WIDTH - 3*margin)/4.0;
    CGFloat h = 97;
    
    __weak typeof(self) weakSelf = self;
    for (NSInteger i = 0; i < models.count; i ++) {
        
        //i 无要求
        CGFloat x = (w + margin)*(i%4) + SCREEN_WIDTH *(i/8);
        
        CGFloat y = (97 + margin)*((i - 8*(i/8))/4) + 0.5;
        
        ZHShopTypeView *shopTypeView = [[ZHShopTypeView alloc] initWithFrame:CGRectMake(x, y, w, h)
                                        
                                                                   funcImage:nil
                                                                    funcName:models[i].name];
        [self.contentScrollView  addSubview:shopTypeView];
        
        [self.shopTypeViewRooms addObject:shopTypeView];
        [shopTypeView.funcBtn sd_setImageWithURL:[NSURL URLWithString:[models[i].pic convertImageUrl]] forState:UIControlStateNormal];
        shopTypeView.index = i;
        
        shopTypeView.selected = ^(NSInteger idx) {
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(didChoose:typeModel:)]) {
                
                [self.delegate didChoose:idx typeModel:self.typeModels[idx]];
                
            }
            
        };
    }
    

}
//


@end
