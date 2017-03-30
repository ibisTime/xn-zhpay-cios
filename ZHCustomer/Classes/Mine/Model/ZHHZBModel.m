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

//- (void)setID:(NSString *)ID {
//
//    _ID = [ID copy];
//
//}

- (NSString *)mobile {

    return self.user[@"mobile"];

}

- (NSString *)getStatusName {

    NSDictionary *dict = @{
                           @"0" : @"待支付",
                           @"1" : @"已激活",
                           @"2" : @"已冻结",
                           };
    
    return dict[self.status];
    
}

@end
