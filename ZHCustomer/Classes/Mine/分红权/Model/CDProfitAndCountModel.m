//
//  CDProfitAndCountModel.m
//  ZHBusiness
//
//  Created by  tianlei on 2017/6/1.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CDProfitAndCountModel.h"

@implementation CDProfitAndCountModel

//- (NSNumber *)profitPoolMoney {
//
//    return @([self.totalStockCount longLongValue]*150);
//
//}

- (NSNumber *)mineProfitMoney {

    return @([self.mineProfitCount longLongValue]*150);

}

@end
