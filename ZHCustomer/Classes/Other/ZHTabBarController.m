//
//  ZHTabBarController.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/23.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHTabBarController.h"
#import "ZHNavigationController.h"
//#import "ZHMineVC.h"
#import "ZHUserLoginVC.h"
//#import "ChatManager.h"

@interface ZHTabBarController ()<UITabBarControllerDelegate>

@end

@implementation ZHTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    NSArray *titles = @[@"优店",@"尖货",@"摇一摇",@"小目标",@"我的"];
    //, BPProjectCategoryVC  BPSubscriptionVC
    
    
//    @"ZHMineVC"  ZHMineViewCtrl   ZHChatVC
    NSArray *VCNames = @[@"ZHShopVC",@"ZHGoodsVC",@"ZHShakeItOffVC",@"ZHDuoBaoVC",@"ZHMineViewCtrl"];
    NSArray *imageNames = @[@"优店00",@"尖货00",@"摇一摇00",@"小目标00",@"我的00"];
    NSArray *selectedImageNames = @[@"优店01",@"尖货01",@"摇一摇01",@"小目标01",@"我的01"];
    
//    NSArray *titles = @[@"优店",@"尖货",@"小目标",@"发一发",@"我的"];
//    NSArray *VCNames = @[@"ZHShopVC",@"ZHGoodsVC",@"ZHDuoBaoVC", @"ZHBriberyMoneyVC",@"ZHMineViewCtrl"];
//    NSArray *imageNames = @[@"优店00",@"尖货00",@"小目标00",@"发一发00",@"我的00"];
//    NSArray *selectedImageNames = @[@"优店01",@"尖货01",@"发一发01",@"摇一摇01",@"我的01"];
    
    for (int i = 0; i < imageNames.count; i++) {
        
        [self addChildVCWithTitle:titles[i]
                       controller:VCNames[i]
                      normalImage:imageNames[i]
                    selectedImage:selectedImageNames[i]];
    }
    

            self.selectedIndex = 2;

//    //消息变更
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unreadMsgChange) name:kUnreadMsgChangeNotification object:nil];
    
    //退出通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(usrLoginOut) name:kUserLoginOutNotification object:nil];
    
    //退出通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogin) name:kUserLoginNotification object:nil];

}

- (void)usrLoginOut {

    self.tabBar.items[3].badgeValue =  nil;
   [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

}


//- (void)userLogin {
//
//    [self unreadMsgChange];
//    
//}

//- (void)unreadMsgChange {
//
//    NSInteger count = [[ChatManager defaultManager] unreadMsgCount];
//    if (count <= 0) {
//       
//        self.tabBar.items[3].badgeValue = nil;
//        
//    } else {
//        
//      self.tabBar.items[3].badgeValue =  [NSString stringWithFormat:@"%ld",count];
//
//    }
//    
//   [UIApplication sharedApplication].applicationIconBadgeNumber = [ChatManager defaultManager].unreadMsgCount;
//    
//}


- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {

    //登录
    if ([[ZHUser user] isLogin]) {
        
        return YES;
    }
    
    //未登录
    UINavigationController *mineNav = tabBarController.viewControllers[4];
    
//    UINavigationController *chatNav = tabBarController.viewControllers[3];
//    UINavigationController *sendToSendNav = tabBarController.viewControllers[1];


    if ([mineNav isEqual:viewController]) {
        
            
            ZHUserLoginVC *loginVC = [[ZHUserLoginVC alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
            loginVC.loginSuccess = ^(){
            
                self.selectedIndex = 4;
            };
            [self presentViewController:nav animated:YES completion:nil];
            return NO;
            
        
    }
    
//    else if([chatNav isEqual:viewController]) {
//    
//        ZHUserLoginVC *loginVC = [[ZHUserLoginVC alloc] init];
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
//        loginVC.loginSuccess = ^(){
//            
//            self.selectedIndex = 3;
//            
//        };
//        [self presentViewController:nav animated:YES completion:nil];
//        return NO;
//        
//    }
    
//    else if([sendToSendNav isEqual:viewController]) {
//        
//        ZHUserLoginVC *loginVC = [[ZHUserLoginVC alloc] init];
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
//        loginVC.loginSuccess = ^(){
//            
//            self.selectedIndex = 1;
//            
//        };
//        [self presentViewController:nav animated:YES completion:nil];
//        
//    
//        return NO;
//    }
    
    else {
    
        return YES;
    }


}

- (void)addChildVCWithTitle:(NSString *)title
                 controller:(NSString *)controllerName
                normalImage:(NSString *)normalImageName
              selectedImage:(NSString *)selectedImageName
{
    Class vcClass = NSClassFromString(controllerName);
    UIViewController *vc = [[vcClass alloc] init];
    
    //获得原始图片
    UIImage *normalImage = [self getOrgImage:[UIImage imageNamed:normalImageName]];
    UIImage *selectedImage = [self getOrgImage:[UIImage imageNamed:selectedImageName]];
    
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:normalImage selectedImage:selectedImage];
    
    //title颜色
    [tabBarItem setTitleTextAttributes:@{
                                         NSForegroundColorAttributeName : [UIColor zh_themeColor]
                                         } forState:UIControlStateSelected];
    [tabBarItem setTitleTextAttributes:@{
                                         NSForegroundColorAttributeName : [UIColor zh_textColor]
                                         } forState:UIControlStateNormal];
    vc.tabBarItem =tabBarItem;
    ZHNavigationController *navigationController = [[ZHNavigationController alloc] initWithRootViewController:vc];
    
    [self addChildViewController:navigationController];
    
}

- (UIImage *)getOrgImage:(UIImage *)image
{
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

@end
