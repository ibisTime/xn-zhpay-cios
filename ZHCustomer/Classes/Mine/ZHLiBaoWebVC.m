//
//  ZHLiBaoWebVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/10/10.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHLiBaoWebVC.h"
#import <WebKit/WebKit.h>
#import "TLProgressHUD.h"

@interface ZHLiBaoWebVC ()<WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation ZHLiBaoWebVC

- (void)viewDidLayoutSubviews {
    
    self.webView.frame = self.view.bounds;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) configuration:config];
    [self.view addSubview:webView];
    self.webView = webView;
    webView.navigationDelegate = self;
    
//    self.urlStr = @"http://www.baidu.com";
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.urlStr]];
    [webView loadRequest:req];
    
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    [TLProgressHUD showWithStatus:nil];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    [TLProgressHUD dismiss];

}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
    [TLProgressHUD dismiss];

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
