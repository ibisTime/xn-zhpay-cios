//
//  ZHPayService.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/7/17.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHPayService : NSObject


/**
 @param obj
 @return yes 需要去实名认证 ； NO不需要进行实名认证 1.可能用户已经实名 2.业务不需要实名
 */
+ (BOOL)checkRealNameAuthByResponseObject:(id)obj;

@end


FOUNDATION_EXTERN NSString *const kZHAliPayTypeCode;
FOUNDATION_EXTERN NSString *const kZHWXTypeCode;
FOUNDATION_EXTERN NSString *const kZHDefaultPayTypeCode;
FOUNDATION_EXTERN NSString *const kZHGiftPayTypeCode;



