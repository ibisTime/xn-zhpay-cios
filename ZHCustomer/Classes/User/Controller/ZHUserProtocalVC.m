//
//  ZHUserProtocalVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/27.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHUserProtocalVC.h"
#import <WebKit/WebKit.h>

@interface ZHUserProtocalVC ()<WKNavigationDelegate>

@end

@implementation ZHUserProtocalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"正汇钱包用户协议";
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"807717";
    http.parameters[@"ckey"] = @"reg_protocol";


    [http postWithSuccess:^(id responseObject) {
        
        WKWebViewConfiguration *webConfig = [[WKWebViewConfiguration alloc] init];
        
        WKWebView *webV = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) configuration:webConfig];
        [self.view addSubview:webV];
        webV.navigationDelegate = self;
        [webV loadHTMLString:responseObject[@"data"][@"note"] baseURL:nil];
        
    } failure:^(NSError *error) {
        
    }];
    
    
    
    
}


- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [TLProgressHUD dismiss];
    [TLAlert alertWithHUDText:@"加载失败"];
    
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    [TLProgressHUD showWithStatus:nil];

//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
//    [MBProgressHUD hideHUDForView:self.view animated:YES]
    [TLProgressHUD dismiss];
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
