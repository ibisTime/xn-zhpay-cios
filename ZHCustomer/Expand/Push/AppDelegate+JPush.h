//
//  AppDelegate+JPush.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/6.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "AppDelegate.h"
#import "JPUSHService.h"


@interface AppDelegate (JPush)<JPUSHRegisterDelegate>

//初始化
- (void)jpushInitWithLaunchOption:(NSDictionary *)launchOptions;

//注册上传token
- (void)jpushRegisterDeviceToken:(NSData *)deviceToken;

//ios10 -> ios7 收到远程推送
- (void)jpushDidReceiveRemoteNotification:(NSDictionary *)userInfo;

//ios10 -> ios7 收到本地推送
- (void)jpushDidReceiveLocalNotification:(UILocalNotification *)notification;

@end
