//
//  TLUpdateAppService.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/7/25.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLUpdateAppService.h"
#import "ZHCMacro.h"
#import "TLHeader.h"

@implementation TLUpdateAppService


+ (void)updateAppWithVC:(UIViewController *)currentVC {
    
    if (!currentVC) {
        NSLog(@"updateAppWithVC 需要传入VC");
        return;
    }
    
    TLNetworking *http = [TLNetworking new];
    http.code = @"807718";
    http.parameters[@"type"] = @"ios_c";

    [http postWithSuccess:^(id responseObject) {
        
     
        NSString *version = responseObject[@"data"][@"version"];
        NSString *downloadUrl = responseObject[@"data"][@"downloadUrl"];
        NSString *note = responseObject[@"data"][@"note"];
        NSString *forceUpdate = responseObject[@"data"][@"forceUpdate"];
        NSString *checked = responseObject[@"data"][@"checked"]; // 在审核
        
        if ([checked isEqualToString:@"0"]) {
            
            return ;
        }
        
        NSString *currentBundleVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        if ([version isEqualToString:currentBundleVersion]) {
            return;
        }

        //1.在审核,忽略更新
        //2.不是审核阶段，比较本地版本号 是否 与服务器版本号相同，不同进行更新。相同跳过
        NSString *title = @"应用更新";
        NSString *msg = [NSString stringWithFormat:@"最新版本为：%@\n%@",version,note];

        UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:title
                                                                           message:msg
                                                                    preferredStyle:UIAlertControllerStyleAlert];
        
        //
        UIAlertAction *updateAction = [UIAlertAction actionWithTitle:@"前往更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSString *urlStr = downloadUrl;
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
            
        }];
        
        //
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"稍后更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];

        //
        if ([forceUpdate isEqual:@"1"]) {
            
            [alertCtrl addAction:updateAction];
            
        } else {
            
            [alertCtrl addAction:cancleAction];
            [alertCtrl addAction:updateAction];
            
        }
        [currentVC presentViewController:alertCtrl animated:YES completion:nil];
        
//        data =  {
//            downloadUrl = 1;
//            forceUpdate = 1;
//            note = "\U672c\U6b21\U4fee\U6539\U5185\U5bb9";
//            version = "1.0.0";
//            };
        
    } failure:^(NSError *error) {
        
    }];

    
 

    
    
    return;
    
    
    //
    [TLNetworking GET:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",APP_ID] parameters:nil success:^(NSString *msg, id data) {
        
        //线上版本
        NSString *versionStr = data[@"results"][0][@"version"];
        //审核中的判断条件
        //1.-- olde_version 和线上相等 一定是在审核
        
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
