//
//  TLLocationService.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/7/25.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLLocationManager;

@interface TLLocationService : NSObject

+ (instancetype)service;

- (void)startService;


/**
 如果处于定位成功的状态，会立即发送通知
 */
- (void)checkLocation;


/**
 记录最近一次，定位情况
 */
@property (nonatomic, assign) BOOL isSuccess;

@property (nonatomic, strong, readonly) CLLocationManager *locationManager;


FOUNDATION_EXTERN NSString * const kLocationServiceFailureNotification;
FOUNDATION_EXTERN NSString * const kLocationServiceSuccessNotification;

@end
