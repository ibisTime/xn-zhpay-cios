//
//  AppConfig.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/12.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, RunEnv) {
    RunEnvRelease = 0,
    RunEnvDev,
    RunEnvTest
};

FOUNDATION_EXPORT void TLLog(NSString *format, ...);

@interface AppConfig : NSObject


+ (instancetype)config;

@property (nonatomic,assign) RunEnv runEnv;

//url请求地址
@property (nonatomic,strong ,readonly) NSString *addr;
@property (nonatomic,strong ,readonly) NSString *shareBaseUrl;

@property (nonatomic,copy, readonly) NSString *pushKey;

@property (nonatomic, copy, readonly) NSString *wxKey;
@property (nonatomic,copy) NSString *aliPayKey;
@property (nonatomic, copy, readonly) NSString *aliMapKey;



@end
