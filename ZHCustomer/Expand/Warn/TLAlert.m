//
//  TLAlert.m
//  WeRide
//
//  Created by  tianlei on 2016/11/25.
//  Copyright © 2016年 trek. All rights reserved.
//

#import "TLAlert.h"
#import "MBProgressHUD.h"

@implementation TLAlert

+ (MBProgressHUD *)alertWithHUDText:(NSString *)text {

   return [self alertWithHUDText:text duration:2.0 complection:nil];

}

+ (MBProgressHUD *)alertWithHUDText:(NSString *)text duration:(NSTimeInterval)sec complection:(void(^)())complection {

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    //    hud.bezelView.backgroundColor = [UIColor blackColor];
    //    hud.bezelView.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    hud.animationType = MBProgressHUDAnimationZoomOut;
    //    hud.bezelView.style =  MBProgressHUDBackgroundStyleSolidColor;
    hud.mode = MBProgressHUDModeText;
    hud.label.text = text;
    //    hud.label.textColor = [UIColor whiteColor];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(sec * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hud hideAnimated:YES];
        if (complection) {
            complection();
        }
    });
    
    return hud;


}

+ (void)alertWithMsg:(NSString * )message viewCtrl:(UIViewController *)vc {

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    //取消行为
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertController addAction:action2];
    [vc presentViewController:alertController animated:YES completion:nil];


}

+ (void)alertWithMsg:(NSString * )message
{
    [self alertWithTitile:nil message:message confirmAction:nil];
}

+ (void)alertWithTitile:(NSString *)title message:(NSString *)message
{
    [self alertWithTitile:title message:message confirmAction:nil];
}

+ (void)alertWithTitile:(NSString *)title message:(NSString *)message confirmAction:(void(^)())confirmAction;
{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    //取消行为
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        if (confirmAction) {
            confirmAction();
        }
    }];
    
    
    [alertController addAction:action2];
    //rootViewController 展示
    
    
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController ;
    
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        
        UITabBarController *tbc = (UITabBarController *)rootViewController;
        [tbc.selectedViewController  presentViewController:alertController animated:YES completion:nil];
        
    } else {
        
        [rootViewController presentViewController:alertController animated:YES completion:nil];
        
    }
  
    
}



//带有 删除 和 确认的提示
+ (UIAlertController *)alertWithTitle:(NSString *)title
                              Message:(NSString *)message
                           confirmMsg:(NSString *)confirmMsg
                            CancleMsg:(NSString *)msg
                               cancle:(void(^)(UIAlertAction *action))cancle
                              confirm:(void(^)(UIAlertAction *action))confirm
{
    //
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    //取消行为
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:msg style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if(cancle){
            cancle(action);
        }
        
    }];
    
    
    //确认行为
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:confirmMsg style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (confirm) {
            confirm(action);
        }
    }];
    
    
    [alertController addAction:action2];
    [alertController addAction:action1];
    
    //rootViewController 展示
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController ;
    
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        
        UITabBarController *tbc = (UITabBarController *)rootViewController;
        [tbc.selectedViewController presentViewController:alertController animated:YES completion:nil];
        
    } else {
        
        [rootViewController presentViewController:alertController animated:YES completion:nil];
        
    }
    return alertController;
    
}

@end
