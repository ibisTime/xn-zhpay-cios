//
//  AppDelegate.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/23.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "AppDelegate.h"
#import "ZHTabBarController.h"
#import "ChatManager.h"
#import "AppDelegate+Chat.h"
#import "AppDelegate+JPush.h"

#import "ZHGoodsCategoryManager.h"
#import "UMMobClick/MobClick.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "IQKeyboardManager.h"
#import "ChatViewController.h"
#import "TLWXManager.h"
#import "ZHUserRegistVC.h"
#import "ZHUserLoginVC.h"
#import "ZHLocationManager.h"
#import "SVProgressHUD.h"
#import "ZHPayVC.h"
#import "ZHCartManager.h"
#import "AppConfig.h"
#import "TLRealmPlayground.h"

//#ifdef NSFoundationVersionNumber_iOS_9_x_Max
//#import <UserNotifications/UserNotifications.h>
//#endif
//#import "JPUSHService.h"


@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    NSLog(@"%s %s",__typeof__(CGPointMake(0, 1)),@encode(CGPoint));
    
    //设置应用环境
    [AppConfig config].runEnv = RunEnvDev;
    
    if ([AppConfig config].runEnv == RunEnvDev) {
        
        [TLRealmPlayground play];
        
    }
    
    //高德地图
    [AMapServices sharedServices].apiKey = [AppConfig config].aliMapKey;
    
    //初始化环信
    [self chatInit];
    
    //微信
    TLWXManager *wxManager = [TLWXManager manager];
    [wxManager registerApp];
    
    //HUD
    [SVProgressHUD setMinimumDismissTimeInterval:2];
    [SVProgressHUD setMaximumDismissTimeInterval:10];
    
    //推送注册
    [self jpushInitWithLaunchOption:launchOptions];

    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginOut) name:kUserLoginOutNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogin) name:kUserLoginNotification object:nil];
    
//    //开始监听位置
//    ZHLocationManager *locationManager = [ZHLocationManager manager];
//    [locationManager.mapLocationManager startUpdatingLocation];
    
    UINavigationBar *navBar = [UINavigationBar appearance];
    navBar.barTintColor = [UIColor whiteColor];
    navBar.translucent = NO;
    navBar.tintColor = [UIColor zh_textColor];
    [navBar setTitleTextAttributes:@{
                                     NSForegroundColorAttributeName : [UIColor zh_textColor]
                                     }];
    [navBar setBackgroundImage:[[UIColor whiteColor] convertToImage ] forBarMetrics:UIBarMetricsDefault];
    navBar.shadowImage = [[UIColor colorWithHexString:@"#dedede"] convertToImage];
    
    //键盘忽略控制器
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = YES;
    [manager.disabledToolbarClasses addObject:[ChatViewController class]];
    [manager.disabledToolbarClasses addObject:[ZHUserLoginVC class]];
    [manager.disabledToolbarClasses addObject:[ZHUserRegistVC class]];

    //
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = [[ZHTabBarController alloc] init];
    
    //获取商品的分类，
    ZHGoodsCategoryManager *categoryManager = [ZHGoodsCategoryManager manager];
    [categoryManager getAllCategory];
    
    NSSetUncaughtExceptionHandler(*UncaughtExceptionHandler);
    
    //友盟异常捕获
    UMConfigInstance.appKey = @"586b96bf82b6352a6b00044b";
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    
    //
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginOutNotification object:nil];
//    });
    
    //判断的同时进行赋值
    if ([ZHUser user].isLogin) {
        //已经由用户信息
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginNotification object:nil];
    }
    
    return YES;
    
}

#pragma mark- 用户登录操作
- (void)userLogin {

    [JPUSHService setAlias:[ZHUser user].userId callbackSelector:nil object:nil];
    
    TLLog(@"%@",[ZHUser user].userId);
    [[ZHCartManager manager] getCount];
}

#pragma mark- 退出登录
- (void)userLoginOut {

    [JPUSHService setAlias:@"" callbackSelector:nil object:nil];
    
    [[ZHUser user] loginOut];
    [[ChatManager defaultManager] chatLoginOut];
    //重置购物车
    [[ZHCartManager manager] reset];
    
    UITabBarController *tbc = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    tbc.selectedIndex = 2;
    
}


void UncaughtExceptionHandler(NSException *exception){

    NSArray *arr= [exception callStackSymbols];//得到当前调用栈信息
    NSString*reason = [exception reason];//非常重要，就是崩溃的原因
    NSString*name = [exception name];//异常类型
    
    NSLog(@"exception type : %@ \n crash reason : %@ \n call stack info: %@--崩溃了", name, reason, arr);
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    return  [WXApi handleOpenURL:url delegate:[TLWXManager manager]];
    
}

//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
//    
//    return [WXApi handleOpenURL:url delegate:[TLWXManager manager]];
//    
//}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            
            NSLog(@"result = %@",resultDic);
            
        }];
        
        return YES;

    } else {
    
        return [WXApi handleOpenURL:url delegate:[TLWXManager manager]];

    }
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    [self chatApplicationDidEnterBackground:application];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    //环信
    [self chatApplicationWillEnterForeground:application];

    [application cancelAllLocalNotifications];
}

#pragma mark- 推送相关
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [self jpushRegisterDeviceToken:deviceToken];
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    [self jpushDidReceiveRemoteNotification:userInfo];
    
    completionHandler(UIBackgroundFetchResultNewData);
}


- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    
    [self jpushDidReceiveLocalNotification:notification];
    
}


//用户点击 本地通知 吊起App ios10 以下
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
    
    
}


//用户点击 远程通知 吊起App ios10 以下
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
    
    
    
}

- (void)applicationWillTerminate:(UIApplication *)application {

    TLLog(@"应用退出");

}


@end