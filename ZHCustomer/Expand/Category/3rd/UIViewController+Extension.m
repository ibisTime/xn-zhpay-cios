//
//  UIViewController+Extension.m
//  OMMO
//
//  Created by 田磊 on 16/4/3.
//  Copyright © 2016年 OMMO. All rights reserved.
//

#import "UIViewController+Extension.h"

@implementation UIViewController (Extension)


@end

@implementation UINavigationController (Extension)

+ (UINavigationController *)currentNavigationController
{
    UIViewController *rootController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    if([rootController isKindOfClass:[UITabBarController class]]){
    
        UITabBarController *tbc = (UITabBarController *)rootController;
        return tbc.selectedViewController;
        
    } else if([rootController isKindOfClass:[UINavigationController class]]){
    
        return (UINavigationController *)rootController;
        
    } else {
    
        return nil;
    }
    
}

+ (void)pushViewControllerHiddenBottomBar:(UIViewController *)controller
{
    controller.hidesBottomBarWhenPushed = YES;
    [[UINavigationController currentNavigationController] pushViewController:controller animated:YES];
}

@end