//
//  AppDelegate.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/23.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "AppDelegate.h"
#import "ZHTabBarController.h"
#import "AppDelegate+JPush.h"

#import "UMMobClick/MobClick.h"
#import "WXApi.h"
#import "IQKeyboardManager.h"

#import "TLWXManager.h"
#import "ZHUserRegistVC.h"
#import "ZHUserLoginVC.h"
#import "SVProgressHUD.h"
#import "AppConfig.h"
#import <CoreLocation/CoreLocation.h>
#import "TLAlipayManager.h"
#import "TLLocationService.h"


@interface AppDelegate ()<WXApiDelegate>


@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //设置应用环境
    [AppConfig config].runEnv = RunEnvDev;
    
    //请求定位权限
    [[TLLocationService service].locationManager requestWhenInUseAuthorization];
    
    //微信
    TLWXManager *wxManager = [TLWXManager manager];
    [wxManager registerApp];
    
    //HUD
    [SVProgressHUD setMinimumDismissTimeInterval:3];
    [SVProgressHUD setMaximumDismissTimeInterval:8];
    
    //推送注册
    [self jpushInitWithLaunchOption:launchOptions];

    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginOut) name:kUserLoginOutNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogin) name:kUserLoginNotification object:nil];
    
//  //开始监听位置
//  ZHLocationManager *locationManager = [ZHLocationManager manager];
//  [locationManager.mapLocationManager startUpdatingLocation];
    
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
    [manager.disabledToolbarClasses addObject:[ZHUserLoginVC class]];
    [manager.disabledToolbarClasses addObject:[ZHUserRegistVC class]];

    //
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = [[ZHTabBarController alloc] init];
    //获取商品的分类，
        
    //友盟异常捕获
    UMConfigInstance.appKey = @"586b96bf82b6352a6b00044b";
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    
    //判断的同时进行赋值
    if ([ZHUser user].isLogin) {
        
        //已经由用户信息
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginNotification object:nil];
        
    }
    
    return YES;
    
}


#pragma mark- 用户登录操作
- (void)userLogin {

//    [JPUSHService setAlias:[ZHUser user].userId callbackSelector:nil object:nil];
     TLLog(@"%@",[ZHUser user].userId);
    
}

#pragma mark- 退出登录
- (void)userLoginOut {
    

//    [self userLoginOutCancleLocation];

    //用户 数据清除放在最后
    [[ZHUser user] loginOut];

    //重置位置信息
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UITabBarController *tbc = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        tbc.selectedIndex = 2;
        
    });

    
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


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    
    if ([url.host isEqualToString:@"certi.back"]) {
        
        NSString *str =  [url query];
        NSArray <NSString *>*arr =  [str componentsSeparatedByString:@"&"];
        
       __block NSString *bizNoStr;
       __block NSDictionary *dict;
        [arr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj hasPrefix:@"biz_content="]) {
                
                bizNoStr = [obj substringWithRange:NSMakeRange(12, obj.length - 12)];
        
                dict = [NSJSONSerialization JSONObjectWithData:[bizNoStr.stringByRemovingPercentEncoding dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
               
             }
            
        }];
        
        
        //--//
        if (!dict[@"failed_reason"]) {
            
            //通知我们的服务器认证成功
            TLNetworking *http = [TLNetworking new];
            http.showView = [UIApplication sharedApplication].keyWindow;
            http.code = @"805192";
            http.parameters[@"userId"] = [ZHUser user].userId;
            http.parameters[@"bizNo"] = [ZHUser user].tempBizNo;
            [http postWithSuccess:^(id responseObject) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"realNameSuccess" object:nil];
                
            } failure:^(NSError *error) {
                
                
            }];
            
        }

        return YES;
        
    }
    
    if ([url.host isEqualToString:@"safepay"]) {
        
        [TLAlipayManager hadleCallBackWithUrl:url];
        return YES;

    } else {
    
        return [WXApi handleOpenURL:url delegate:[TLWXManager manager]];

    }
    //
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
//    [self chatApplicationDidEnterBackground:application];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    //环信
//    [self chatApplicationWillEnterForeground:application];

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



//- (void)userLoginOutCancleLocation {
//
//    
//    if (![ZHUser user].userId) {
//        return;
//    }
//    
//    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
//    dict[@"placholder"] = @"placeholder";
//    dict[@"userId"] = [ZHUser user].userId;
//    dict[@"token"] = [ZHUser user].token;
//    
//    [TLNetworking POST:[NSString stringWithFormat:@"%@/forward-service%@",[[AppConfig config] addr],@"/user/logOut"] parameters:dict success:^(id responseObject) {
//        
//    }  failure:^(NSError *error) {
//        
//    }];
//
//}


@end
