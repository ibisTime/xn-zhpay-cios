//
//  UIViewController+Extension.h
//  OMMO
//
//  Created by 田磊 on 16/4/3.
//  Copyright © 2016年 OMMO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Extension)

@end


@interface UINavigationController (Extension)

+ (UINavigationController *)currentNavigationController;
+ (void)pushViewControllerHiddenBottomBar:(UIViewController *)controller;

@end