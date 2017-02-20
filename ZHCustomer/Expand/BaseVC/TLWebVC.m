//
//  TLWebVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/10.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLWebVC.h"
#import <WebKit/WebKit.h>

@interface TLWebVC ()<WKNavigationDelegate>

@end

@implementation TLWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    WKWebViewConfiguration *webConfig = [[WKWebViewConfiguration alloc] init];
    
    WKWebView *webV = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) configuration:webConfig];
    [self.view addSubview:webV];
    webV.navigationDelegate = self;
    
    NSURL *url = [[NSURL alloc] initWithString:self.url];
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url];
    
    [webV loadRequest:req];
    
}


- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [TLAlert alertWithHUDText:@"加载失败"];
    
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

@end
