//
//  ZHMonthCardModel.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/7.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHMonthCardModel.h"

@implementation ZHMonthCardModel

+ (NSDictionary *)tl_replacedKeyFromPropertyName {

    return @{
             
             @"description" :  @"desc"
             
             };

}

- (NSString *)getStatusName {

    NSDictionary *dict = @{
                           @"0" : @"待支付",
                           @"1" : @"未清算",
                           @"2" : @"已清算"
                           };
    
    return dict[self.status];

}
@end
