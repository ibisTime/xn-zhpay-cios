//
//  ZHHZBModel.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/8.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHHZBModel.h"

@implementation ZHHZBModel

+ (NSDictionary *)tl_replacedKeyFromPropertyName {
    
    return @{
             
             @"description" :  @"desc",
             @"ID" :  @"id"

             };
    
}

- (void)setID:(NSString *)ID {

    _ID = [ID copy];

}


- (NSString *)getStatusName {

    NSDictionary *dict = @{
                           @"0" : @"待支付",
                           @"1" : @"未激活",
                           @"2" : @"已激活",
                           @"3" : @"已冻结"
                           };
    
    return dict[self.status];
    
}

@end
