//
//  ZHPayService.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/7/17.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHPayService.h"

//#define PAY_TYPE_DEFAULT_PAY_CODE @"1"
//#define PAY_TYPE_WX_PAY_CODE @"2"
//#define PAY_TYPE_ALI_PAY_CODE @"3"

NSString *const kZHAliPayTypeCode = @"3";
NSString *const kZHWXTypeCode = @"2";
NSString *const kZHDefaultPayTypeCode = @"1";

NSString *const kZHGiftPayTypeCode = @"20";


@implementation ZHPayService

+ (BOOL)checkRealNameAuthByResponseObject:(id)obj {

    if (![obj isKindOfClass:[NSDictionary class]]) {
        
        return NO;
    }

    NSString *errorBizCode =  obj[@"errorBizCode"];
    if ( errorBizCode && [errorBizCode isEqualToString:@"M000001"]) {
        
        return YES;
        
    }
    
    return NO;
    
}


@end
