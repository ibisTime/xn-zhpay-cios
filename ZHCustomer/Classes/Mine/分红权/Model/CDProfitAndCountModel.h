//
//  CDProfitAndCountModel.h
//  ZHBusiness
//
//  Created by  tianlei on 2017/6/1.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@interface CDProfitAndCountModel : TLBaseModel


/**
 今日分红权收益
 */
@property (nonatomic, strong) NSNumber *todayProfitAmount;

/**
 池中总个数
 */
@property (nonatomic, strong) NSNumber *totalStockCount;

/**
 我的分红权个数
 */
@property (nonatomic, strong) NSNumber *mineProfitCount;

/**
 收益池金额
 */
@property (nonatomic, strong) NSNumber *profitPoolMoney;

/**
 我的分红权金额
 */
@property (nonatomic, strong, readonly) NSNumber *mineProfitMoney;


@end
