//
//  TLWXManager.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/9.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "WXApiObject.h"

@interface TLWXManager : NSObject<WXApiDelegate>

+ (instancetype)manager;
+ (BOOL)judgeAndHintInstalllWX;

- (void)registerApp;

+ (void)wxShareWebPageWithScene:(int)scene title:(NSString *)title desc:(NSString *)desc url:(NSString *)url;

+ (void)wxShareWebPageWith:(NSString *)title desc:(NSString *)desc url:(NSString *)url;
@property (nonatomic, copy) void(^wxPay)(BOOL isSuccess,int errorCode);
@property (nonatomic, copy) void(^wxShare)(BOOL isSuccess,int errorCode);

@end
