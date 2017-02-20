//
//  MBProgressHUD+add.m
//  WeRide
//
//  Created by  tianlei on 2016/12/9.
//  Copyright © 2016年 trek. All rights reserved.
//

#import "MBProgressHUD+add.h"
#import "MBProgressHUD.h"
@implementation MBProgressHUD (add)

+ (MBProgressHUD *)tl_showText:(NSString *)text {

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.bezelView.backgroundColor = [UIColor whiteColor];
    hud.animationType = MBProgressHUDAnimationZoomOut;
    hud.mode = MBProgressHUDModeText;
    hud.label.text = text;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hud hideAnimated:YES];
    });
    
    return hud;
    
}

@end
