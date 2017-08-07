//
//  TLUpdateAppService.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/7/25.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLUpdateAppService.h"
#import "ZHCMacro.h"

@implementation TLUpdateAppService


+ (void)updateAppWithVC:(UIViewController *)currentVC {
    
    if (!currentVC) {
        NSLog(@"updateAppWithVC 需要传入VC");
        return;
    }
    
    //
    [TLNetworking GET:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",APP_ID] parameters:nil success:^(NSString *msg, id data) {
        
        //线上版本
        NSString *versionStr = data[@"results"][0][@"version"];
        //版本号不同就要更新
        if (![versionStr isEqualToString:OLD_VERSION] && ![versionStr isEqualToString:[NSString appCurrentBundleVersion]]) {
            
            //此版本是否用户拒绝跟新
            NSString *updateValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"update_app_key"];
            if(updateValue && [updateValue isEqualToString:versionStr]) {
                
                return ;
            }
            
            UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"应用更新"
                                                                               message:[NSString stringWithFormat:@"最新版本为：%@",versionStr]
                                                                        preferredStyle:UIAlertControllerStyleAlert];
            
            //
            UIAlertAction *updateAction = [UIAlertAction actionWithTitle:@"前往更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                NSString *appName = APP_NAME;
                NSString *urlStr = [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/%@/id%@?mt=8",appName,APP_ID];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
                
            }];
            
            //
            UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"稍后更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            //
            UIAlertAction *noHintUpdateAction = [UIAlertAction actionWithTitle:@"不在提示" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [[NSUserDefaults standardUserDefaults] setObject:versionStr forKey:@"update_app_key"];
                
            }];
            
            //
            [alertCtrl addAction:updateAction];
            [alertCtrl addAction:cancleAction];
            [alertCtrl addAction:noHintUpdateAction];
            
            //
            [currentVC presentViewController:alertCtrl animated:YES completion:nil];
            
        }
        
    } abnormality:nil failure:nil];
    
    
    
}

@end
