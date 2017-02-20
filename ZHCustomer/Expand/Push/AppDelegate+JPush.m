//
//  AppDelegate+JPush.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/6.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "AppDelegate+JPush.h"

#import <UserNotifications/UserNotifications.h>
#import "AppConfig.h"

@implementation AppDelegate (JPush)

- (void)jpushRegisterDeviceToken:(NSData *)deviceToken {

    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)jpushDidReceiveRemoteNotification:(NSDictionary *)userInfo {

    [JPUSHService handleRemoteNotification:userInfo];

}


- (void)jpushDidReceiveLocalNotification:(UILocalNotification *)notification {

    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];

}


- (void)jpushInitWithLaunchOption:(NSDictionary *)launchOptions {

    JPUSHRegisterEntity * joushEntity = [[JPUSHRegisterEntity alloc] init];
    joushEntity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    [JPUSHService registerForRemoteNotificationConfig:joushEntity delegate:self];
    
    BOOL isProducation = [AppConfig config].runEnv == RunEnvRelease;
    [JPUSHService setupWithOption:launchOptions
                           appKey:[AppConfig config].pushKey
                          channel:@"iOS"
                 apsForProduction:isProducation
            advertisingIdentifier:nil];
    
    if (isProducation) {
        [JPUSHService setLogOFF];
    }

}


#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        [JPUSHService handleRemoteNotification:userInfo];
        TLLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
        
    } else {
        
        // 判断为本地通知
        TLLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

//点击消息会触发该方法
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        [JPUSHService handleRemoteNotification:userInfo];
        TLLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
        
    } else {
        // 判断为本地通知
        TLLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();  // 系统要求执行这个方法
}
#endif


- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}


//{
//    "_j_msgid" = 2371100428;
//    aps =     {
//        alert =         {
//            body = "这是内容";
//            subtitle = "副标题";
//            title = "标题";
//        };
//        badge = 1;
//        "content-available" = 1;
//        sound = default;
//    };
//    name = tianlei; //附加字段
//    url = "https://www.jiguang.cn/push/app/7cd9f997dcedd781b3409c52/push/notification";
//}

@end
