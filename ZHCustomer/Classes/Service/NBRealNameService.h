//
//  NBRealNameService.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/7/17.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, NBRealNameAuthenticationType) {
    NBRealNameAuthenticationTypeZMXY = 0, //芝麻信用
   
};
@interface NBRealNameService : NSObject

+ (instancetype)service;

/**
 实名认证方式
 */
@property (nonatomic, assign) NBRealNameAuthenticationType type;


@end
