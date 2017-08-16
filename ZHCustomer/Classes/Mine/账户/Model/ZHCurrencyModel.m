//
//  ZHCurrencyModel.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/5.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHCurrencyModel.h"

 NSString *const kFRB = @"FRB";
 NSString *const kGXB = @"GXJL";
 NSString *const kQBB = @"QBB";
 NSString *const kGWB = @"GWB";
 NSString *const kDigitalJF = @"SZJF";
 NSString *const kGiftB = @"LPQ";
 NSString *const kLMB = @"LMQ";


 NSString *const kHBYJ  = @"HBYJ";
 NSString *const kHBB  = @"HBB";

 NSString *const kCNY = @"CNY";

@implementation ZHCurrencyModel

- (NSString *)getTypeName {

    NSDictionary *dict = @{
                           kFRB : @"分润",
                           kGXB : @"贡献值",
                           kQBB : @"钱包币",
                           kGWB : @"购物币",
                           kHBYJ : @"红包业绩",
                           kHBB : @"红包币",
                           kGiftB : @"礼品券",
                           kDigitalJF : @"数字积分",
                           kLMB : @"联盟券"
                           };
    
    return dict[self.currency];

}
@end
