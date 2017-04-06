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

- (NSString *)nickname {

    return self.user[@"nickname"];
}

- (NSString *)mobile {

    return self.user[@"mobile"];

}

//我的汇赚宝状态：TO_PAY("0", "待支付"),
//ACTIVATED("1", "激活"),
//OFFLINE("91", "人为下架"),
//DIED("92","正常耗尽");
- (NSString *)getStatusName {

    NSDictionary *dict = @{
                           @"0" : @"待支付",
                           @"1" : @"已激活",
                           @"91" : @"认为下架",
                           @"92" : @"已摇满"
                           };
    
    return dict[self.status];
    
}

- (BOOL)isAbandon {

    if ([self.status isEqualToString:@"92"]) {
        
        return YES;
        
    } else {
        
        return NO;
    
    }
}


@end
