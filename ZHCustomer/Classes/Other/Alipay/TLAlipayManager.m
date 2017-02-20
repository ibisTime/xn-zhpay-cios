//
//  TLAlipayManager.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/12.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLAlipayManager.h"
#import <AlipaySDK/AlipaySDK.h>
@implementation TLAlipayManager

- (void)pay {
    
//  服务端把  orderString传给客户端

    [[AlipaySDK defaultService] payOrder:@"orderString" fromScheme:@"" callback:^(NSDictionary *resultDic) {
        
//        NSLog(@"reslut = %@",resultDic);
        
    }];

}

@end
