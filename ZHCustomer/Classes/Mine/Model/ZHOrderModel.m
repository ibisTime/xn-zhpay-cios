//
//  ZHOrderModel.m
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/17.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHOrderModel.h"
#import "ZHOrderDetailModel.h"

@implementation ZHOrderModel


+ (NSDictionary *)mj_objectClassInArray {

    return @{ @"productOrderList" : [ZHOrderDetailModel class]};

}


- (NSString *)getStatusName {

    
    //1待支付 2 已支付待发货 3 已发货待收货 4 已收货 91用户取消 92 商户取消 93 快递异常

    NSDictionary *dict = @{
                           @"1" : @"待支付",
                           @"2" : @"待发货",
                           @"3" : @"待收货",
                           @"4" : @"已收货",
                           @"91" : @"已取消",
                           @"92" : @"商户取消",
                           @"93" : @"快递异常"
                                                      };
    
    return dict[self.status];

}


@end


