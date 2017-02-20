//
//  ZHDBLastStepVC.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/14.
//  Copyright © 2017年  tianlei. All rights reserved.
//  等待宝贝收货 和 签收

#import "TLBaseVC.h"
#import "ZHMineTreasureModel.h"
@interface ZHDBLastStepVC : TLBaseVC

@property (nonatomic,strong) ZHMineTreasureModel *mineTreasure;

@property (nonatomic,copy) void(^success)();

@end
