//
//  ZHEarningModel.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/4/3.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHEarningModel.h"

@implementation ZHEarningModel

- (NSString *)getStatusName {

//    2 未返利 3.返利中 4.已返利
    NSDictionary *dict = @{
                           @"2" : @"待收益",
                           @"3" : @"收益中",
                           @"4" : @"已收益"
                           };
    
    return dict[self.status];

}

@end
