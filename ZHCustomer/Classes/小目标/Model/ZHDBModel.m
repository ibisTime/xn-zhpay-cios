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

- (NSString *)getPriceCurrencyName {

    NSDictionary *dict = @{
                           kFRB : @"分润",
                           kGXB : @"贡献值",
                           kQBB : @"钱包币",
                           kGWB : @"购物币",
                           kHBYJ : @"红包业绩",
                           kHBB : @"红包币",
                           kCNY : @"分润"
                           };
    
    
    return dict[self.fromCurrency] ? : @"???";

}


- (NSString *)getPriceDetail {

    NSDictionary *dict = @{
                           kFRB : @"分润",
                           kGXB : @"贡献值",
                           kQBB : @"钱包币",
                           kGWB : @"购物币",
                           kHBYJ : @"红包业绩",
                           kHBB : @"红包币"
                           };
    
   
    return  [NSString stringWithFormat:@"%@ %@",[self.toAmount convertToSimpleRealMoney],dict[self.toCurrency]];

}

- (NSString *)winUserNickName {

    return self.user[@"nickname"];
}

- (NSNumber *)price {

    return self.fromAmount;
    
}

- (float)getProgress {

    return [self.investNum floatValue]/[self.totalNum floatValue];

}

- (NSInteger)getSurplusPeople {

    return   [self.totalNum integerValue] - [self.investNum integerValue];
}


@end
