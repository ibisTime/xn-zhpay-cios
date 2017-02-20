//
//  ZHDBRecordVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/3.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHDBRecordVC.h"
#import "ZHSegmentView.h"
#import "ZHDBRecordListVC.h"


@interface ZHDBRecordVC ()<ZHSegmentViewDelegate>

@property (nonatomic,strong) UIScrollView *switchScrollV;

@property (nonatomic,strong) ZHDBRecordListVC *ingVC;
@property (nonatomic,strong) ZHDBRecordListVC *edVC;
@property (nonatomic,strong) ZHDBRecordListVC *mineVC;
@property (nonatomic,strong) NSMutableArray *addRecords;


@end

@implementation ZHDBRecordVC



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"夺宝记录";
    ZHSegmentView *segmentView =  [[ZHSegmentView alloc] initWithFrame:CGRectMake(0, 0.5, SCREEN_WIDTH, 45)];
    [self.view addSubview:segmentView];
    segmentView.delegate = self;
    segmentView.tagNames = @[@"全部",@"进行中",@"已揭晓",@"已中奖"];
    
    self.addRecords = [NSMutableArray arrayWithArray:@[@1,@0,@0,@0]];
    
    //
    UIScrollView *switchScrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, segmentView.yy + 0.5, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - segmentView.yy)];
    switchScrollV.pagingEnabled = YES;
    switchScrollV.contentSize = CGSizeMake(SCREEN_WIDTH * 4, switchScrollV.height);
    [self.view addSubview:switchScrollV];
    self.switchScrollV = switchScrollV;
    switchScrollV.scrollEnabled = NO;
    
    //全部
    ZHDBRecordListVC *allVC = [[ZHDBRecordListVC alloc] init];
    allVC.status = @"all";
    allVC.view.frame =  CGRectMake(0, 0, SCREEN_WIDTH, switchScrollV.height);
    [self addChildViewController:allVC];
    [switchScrollV addSubview:allVC.view];
    
    //进行中


}

- (BOOL)segmentSwitch:(NSInteger)idx {
    
    [self.switchScrollV setContentOffset:CGPointMake(SCREEN_WIDTH*idx, 0)];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       
        switch (idx) {
            case 0:
                
                break;
            case 1:{
                if ([self.addRecords[idx] isEqual:@0]) {
                    
                    ZHDBRecordListVC *ingVC = [[ZHDBRecordListVC alloc] init];
                    [self addChildViewController:ingVC];
                    ingVC.status = @"3";
                    ingVC.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, self.switchScrollV.height);
                    [self.switchScrollV addSubview:ingVC.view];
                    
                    self.addRecords[idx] = @1;
                }
                
            }
                
                break;
            case 2:
                if ([self.addRecords[idx] isEqual:@0]) {
                    
                    //已揭晓
                    ZHDBRecordListVC *edVC = [[ZHDBRecordListVC alloc] init];
                    [self addChildViewController:edVC];
                    edVC.status = @"7";
                    edVC.view.frame = CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, self.switchScrollV.height);
                    [self.switchScrollV addSubview:edVC.view];
                    
                    self.addRecords[idx] = @1;
                }
                
                break;
            case 3:
                if ([self.addRecords[idx] isEqual:@0]) { //我的中奖记录
                    
                    ZHDBRecordListVC *mineVC = [[ZHDBRecordListVC alloc] init];
                    [self addChildViewController:mineVC];
                    mineVC.isMineGetRecord = YES;
                    mineVC.view.frame = CGRectMake(SCREEN_WIDTH*3, 0, SCREEN_WIDTH, self.switchScrollV.height);
                    [self.switchScrollV addSubview:mineVC.view];
                    
                    self.addRecords[idx] = @1;
                }
                
                break;
                
        }
        
    });

    return YES;
}



@end
