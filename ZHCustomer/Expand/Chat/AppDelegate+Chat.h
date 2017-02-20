//
//  AppDelegate+Chat.h
//  IMChat
//
//  Created by  tianlei on 2016/11/29.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "AppDelegate.h"

#import <HyphenateLite/HyphenateLite.h>

@interface AppDelegate (Chat)<EMClientDelegate>

- (void)chatInit;

// APP进入后台
- (void)chatApplicationDidEnterBackground:(UIApplication *)application;

// APP将要从后台返回
- (void)chatApplicationWillEnterForeground:(UIApplication *)application;

//已经收到 远程通知
- (void)chatDidReceiveRemoteApplication:(UIApplication *)application notification:(NSDictionary *)userInfo;

@end
