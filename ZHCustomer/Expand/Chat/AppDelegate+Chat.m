//
//  AppDelegate+Chat.m
//  IMChat
//
//  Created by  tianlei on 2016/11/29.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "AppDelegate+Chat.h"

#import "ChatViewController.h"
#import "EaseSDKHelper.h"
#import "ChatManager.h"
#import "EaseSDKHelper.h"
#import "AppConfig.h"

//#define EaseMobAppKey @"easemob-demo#chatdemoui"
//#define EaseMobAppKey @"tianleios#zh-dev"


@implementation AppDelegate (Chat)
- (void)chatInit{
    
//    [[EaseSDKHelper  shareHelper] _registerRemoteNotification];

    EMOptions *options = [EMOptions optionsWithAppkey:[AppConfig config].chatKey];
    options.isAutoAcceptGroupInvitation = NO;
    options.enableConsoleLog = NO;
    options.enableDeliveryAck = NO;
    
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    
    //进行数据库迁移
//  [[EMClient sharedClient] migrateDatabaseToLatestSDK];
    
    //管理者
    [ChatManager defaultManager];
    [[EMClient sharedClient] addDelegate:self];

    //肯定有账号登录，从DB获取数据
    if ([EMClient sharedClient].isAutoLogin) {
        
        ///--- 解决查询不到会话列表的bug
        

       [[ChatManager defaultManager] getAllConversionFromDB];
        
        //刚进入--设置未读消息
        [UIApplication sharedApplication].applicationIconBadgeNumber = [ChatManager defaultManager].unreadMsgCount;
        
    }
//        [[ChatManager defaultManager] getAllConversionFromDB];
////        //解决进入应用 bandagAccount 不会改变的问题
////       [[NSNotificationCenter defaultCenter] postNotificationName:UNREAD_MSG_COUNT_CHANGE_NOTIFICATION object:nil];

}

#pragma mark- 自动登录时的回调
- (void)autoLoginDidCompleteWithError:(EMError *)aError {

    if([[EMClient sharedClient] isConnected] && !aError){
        
        
       NSArray *arr = [[EMClient sharedClient].chatManager getAllConversations];
//        [[NSNotificationCenter defaultCenter] postNotificationName:<#(nonnull NSNotificationName)#> object:<#(nullable id)#>];
    }


}


- (void)userAccountDidLoginFromOtherDevice {
    
    [TLAlert alertWithTitile:@"提示" message:@"当前账号已从其它设备登录,请重新登录" confirmAction:^{
        
           [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginOutNotification object:nil];
        
    }];
}

- (void)connectionStateDidChange:(EMConnectionState)aConnectionState {
    
    if (aConnectionState == EMConnectionDisconnected) {
        
        //        [TLAlert alertWithHUDText:@"环信断开连接"];
        
    }
}



- (void)chatDidReceiveRemoteApplication:(UIApplication *)application notification:(NSDictionary *)userInfo {

    [[EMClient sharedClient] application:application didReceiveRemoteNotification:userInfo];

}

// APP进入后台
- (void)chatApplicationDidEnterBackground:(UIApplication *)application
{
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}
  
// APP将要从后台返回
- (void)chatApplicationWillEnterForeground:(UIApplication *)application
{
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}

@end
