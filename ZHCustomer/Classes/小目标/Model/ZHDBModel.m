//
//  ZHDBModel.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/22.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHDBModel.h"
#import "ZHCurrencyModel.h"

@implementation ZHDBModel

- (NSString *)getPriceDetail {

    NSDictionary *dict = @{
                           kFRB : @"分润",
                           kGXB : @"贡献奖励",
                           kQBB : @"钱包币",
                           kGWB : @"购物币",
                           kHBYJ : @"红包业绩",
                           kHBB : @"红包币"
                           };
    
   
    return  [NSString stringWithFormat:@"%@ %@",[self.amount convertToSimpleRealMoney],dict[self.currency]];

}

- (float)getProgress {

    return [self.investNum floatValue]/[self.totalNum floatValue];

}

- (NSInteger)getSurplusPeople {

    return   [self.totalNum integerValue] - [self.investNum integerValue];
}


@end
