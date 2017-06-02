//
//  ZHDBRecodBrowserView.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/28.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHDBRecodBrowserView.h"
#import "ZHAwardAnnounceView.h"

#import "ZHDBBrowserCoreView.h"

@interface ZHDBRecodBrowserView()

//@property (nonatomic, strong) NSMutableArray <ZHAwardAnnounceView *>*awardViewRooms;
@property (nonatomic, strong) ZHDBBrowserCoreView *coreView1;
@property (nonatomic, strong) ZHDBBrowserCoreView *coreView2;


@end


@implementation ZHDBRecodBrowserView

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        UIView *headerBgView = self;
        headerBgView.backgroundColor = [UIColor whiteColor];
        
        //左边图片
        UIImageView *hintImageView = [[UIImageView alloc] initWithFrame:CGRectMake(17, 17, 46, 50)];
        hintImageView.image = [UIImage imageNamed:@"分秒实况"];
        [headerBgView addSubview:hintImageView];
        
        //线
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor zh_lineColor];
        [headerBgView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(hintImageView.mas_right).offset(17);
            make.width.mas_equalTo(@1);
            make.height.mas_equalTo(@(50));
            make.centerY.equalTo(headerBgView.mas_centerY);
        }];
        
        //右边实况背景
        UIView *rightBgView = [[UIView alloc] initWithFrame:CGRectMake(hintImageView.xx + 18 + 10, 13.5, SCREEN_WIDTH - line.xx, 57)];
        rightBgView.clipsToBounds = YES;
        [self addSubview:rightBgView];
        
        
        //
        ZHDBBrowserCoreView *core1View = [[ZHDBBrowserCoreView alloc] initWithFrame:rightBgView.bounds];
        [rightBgView addSubview:core1View];
//        core1View.backgroundColor = [UIColor orangeColor];
        self.coreView1 = core1View;
        core1View.displayTag = 0;
        
        //
        ZHDBBrowserCoreView *core2View = [[ZHDBBrowserCoreView alloc] initWithFrame:CGRectMake(0, rightBgView.height, rightBgView.width, rightBgView.height)];
        [rightBgView addSubview:core2View];
//        core2View.backgroundColor = [UIColor blueColor];
        self.coreView2 = core2View;
        core2View.displayTag = 1;

        
        
        
//        //右边实况
//        self.awardViewRooms = [[NSMutableArray alloc] initWithCapacity:3];
//        for (NSInteger i = 0; i < 6 ; i++) {
//            
//            CGFloat x = hintImageView.xx + 18 + 10;
//            CGFloat y = 13.5 + i*(15 + 6);
//            
//            ZHAwardAnnounceView *awardV = [[ZHAwardAnnounceView alloc] initWithFrame:CGRectMake(x, y, SCREEN_WIDTH - line.xx, 15)];
//            //        [headerBgView addSubview:awardV];
//            [self.awardViewRooms addObject:awardV];
//            
//        }
        
//        [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(begin) userInfo:nil repeats:NO];
        
    }
    
    return self;

}

- (void)setHistoryModels:(NSMutableArray<ZHDBHistoryModel *> *)historyModels {

    if (_historyModels.count > 0) {//以后轮播
        
        _historyModels = historyModels;
        
        if (self.coreView1.displayTag == 0) {
            
            self.coreView2.historyModels = _historyModels;
            
        } else {
        
            self.coreView1.historyModels = _historyModels;

        }
        
            [UIView animateWithDuration:1 animations:^{
                
                if (self.coreView1.displayTag == 0) {
                    
                    self.coreView1.y = -57;
                    self.coreView2.y = 0;

                    
                } else {
                    
                    self.coreView1.y = 0;
                    self.coreView2.y = -57;

                    
                }
                
//                //---///
//                if (self.coreView2.y == 0) {
//                    
//                    self.coreView2.y = -57;
//                    
//                } else {
//                    
//                    self.coreView2.y = 0;
//                    
//                }
                
            } completion:^(BOOL finished) {
                
                if (self.coreView1.displayTag == 0) {
                    
                    self.coreView1.displayTag = 1;
                    self.coreView2.displayTag = 0;
                    
                    self.coreView1.y = 57;
                    
                } else {
                    
                    self.coreView1.displayTag = 0;
                    self.coreView2.displayTag = 1;
                    self.coreView2.y = self.coreView2.height;
                
                }
//                NSLog(@"%@--%@",NSStringFromCGRect(self.coreView1.frame),NSStringFromCGRect(self.coreView2.frame));
            }];
        
        
    } else { //第一次只显示就行
    
        _historyModels = historyModels;
        self.coreView1.historyModels = _historyModels;
        
    }
    

}



@end
