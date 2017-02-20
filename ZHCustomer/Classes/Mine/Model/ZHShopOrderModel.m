//
//  ZHShopOrderModel.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/4.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHShopOrderModel.h"

@implementation ZHShopOrderModel

- (NSString *)getStatusName {
    
    NSDictionary *dict = @{
                           
                           @"0" : @"待支付",
                           @"1" : @"已支付",
                           @"2" : @"已取消"
                           };
    
    return dict[self.status];
    
}

@end
