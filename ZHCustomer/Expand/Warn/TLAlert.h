//
//  TLAlert.h
//  WeRide
//
//  Created by  tianlei on 2016/11/25.
//  Copyright © 2016年 trek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class MBProgressHUD;

@interface TLAlert : NSObject

//设置延迟时间
+ (MBProgressHUD *)alertWithHUDText:(NSString *)text duration:(NSTimeInterval)sec complection:(void(^)())complection;
+ (MBProgressHUD *)alertWithHUDText:(NSString *)text;

+ (void)alertWithMsg:(NSString * )message;
+ (void)alertWithMsg:(NSString * )message viewCtrl:(UIViewController *)vc;


+ (void)alertWithTitile:(NSString *)title
                message:(NSString *)message;


+ (void)alertWithTitile:(NSString *)title
                message:(NSString *)message
          confirmAction:(void(^)())confirmAction;


//+ (void)alertWithTitile:(NSString *)title
//                message:(NSString *)message
//             controller:(UIViewController *)controller
//             completion:(void (^)(void))completion;

//带有 删除 和 确认 的提示
+ (UIAlertController *)alertWithTitle:(NSString *)title
                              Message:(NSString *)message
                           confirmMsg:(NSString *)confirmMsg
                            CancleMsg:(NSString *)msg
                               cancle:(void(^)(UIAlertAction *action))cancle
                              confirm:(void(^)(UIAlertAction *action))confirm;

@end
