//
//  ZHHBConvertFRVC.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/3.
//  Copyright © 2017年  tianlei. All rights reserved.
// 红包 转分润的VC 或者   红包业绩 转换为--贡献奖励 或者分润

#import "TLBaseVC.h"
#import "ZHCurrencyModel.h"
//
//      50=红包兑分润 52=红包业绩兑分润 54=红包业绩兑贡献奖励

typedef NS_ENUM(NSInteger,ZHCurrencyConvertType) {

    ZHCurrencyConvertHBToFR = 0,
    
    ZHCurrencyConvertHBYJToFR,
    ZHCurrencyConvertHBYJToGXJL
    
};

@interface ZHHBConvertFRVC : TLBaseVC

@property (nonatomic,assign) ZHCurrencyConvertType type;
@property (nonatomic,strong) NSNumber *amount;
@property (nonatomic,copy) void (^success)();

@end
