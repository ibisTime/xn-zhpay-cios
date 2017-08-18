//
//  TLUpdateVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/8/17.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLUpdateVC.h"
#import "TLUpdateAppService.h"
#import "TLNetworking.h"
#import "ZHTabBarController.h"

@interface TLUpdateVC ()

@end

@implementation TLUpdateVC


- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [self updateApp];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *bgIV = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:bgIV];
    bgIV.contentMode = UIViewContentModeScaleAspectFill;
    
    bgIV.image = [UIImage imageNamed:@"lanch"];
    
    [self setPlaceholderViewTitle:@"加载失败" operationTitle:@"重新加载"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)applicationWillEnterForeground {

    [self updateApp];

}

- (void)updateApp {
    
    TLNetworking *http = [TLNetworking new];
    http.code = @"807718";
    http.showView = self.view;
    http.parameters[@"type"] = @"ios_c";
    
    [http postWithSuccess:^(id responseObject) {
        
        [self removePlaceholderView];
        NSString *version = responseObject[@"data"][@"version"];
        NSString *downloadUrl = responseObject[@"data"][@"downloadUrl"];
        NSString *note = responseObject[@"data"][@"note"];
        NSString *forceUpdate = responseObject[@"data"][@"forceUpdate"];
        NSString *checking = responseObject[@"data"][@"checked"]; // 是否在审核 1.是 0否

        if ([checking isEqualToString:@"1"]) {
            //审核中
            [self setRootVC];
            return ;
        }
        
        NSString *currentBundleVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        if ([version isEqualToString:currentBundleVersion]) {
            [self setRootVC];
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
        if ([forceUpdate isEqual:@"1"]) {
            
            //强制更新
            UIAlertAction *updateAction = [UIAlertAction actionWithTitle:@"前往更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                NSString *urlStr = downloadUrl;
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
                
            }];
            [alertCtrl addAction:updateAction];
            
            
        } else {
            
            //
            UIAlertAction *updateAction = [UIAlertAction actionWithTitle:@"前往更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                NSString *urlStr = downloadUrl;
                NSLog(@"%@",downloadUrl);
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
                [self setRootVC];
                
            }];
            
            //
            UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"稍后更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self setRootVC];
            }];
            
            [alertCtrl addAction:cancleAction];
            [alertCtrl addAction:updateAction];
            
        }
        
        UIView *subView1 = alertCtrl.view.subviews[0];
        UIView *subView2 = subView1.subviews[0];
        UIView *subView3 = subView2.subviews[0];
        UIView *subView4 = subView3.subviews[0];
        UIView *subView5 = subView4.subviews[0];
        //取title和message：
        //        UILabel *title = subView5.subviews[0];
        id message = subView5.subviews[1];
        if (message && [message isKindOfClass:[UILabel class]]) {
            UILabel *lbl = message;
            lbl.textAlignment = NSTextAlignmentLeft;
            
        }
        //
        [self presentViewController:alertCtrl animated:YES completion:nil];

    } failure:^(NSError *error) {
        
        [self addPlaceholderView];

    }];


}



- (void)tl_placeholderOperation {

    [self updateApp];

}


- (void)setRootVC {
    
    
    [UIApplication sharedApplication].keyWindow.rootViewController = [[ZHTabBarController alloc] init];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
