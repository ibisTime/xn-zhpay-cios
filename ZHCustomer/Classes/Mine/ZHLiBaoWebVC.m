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
#import "AppConfig.h"

@interface ZHLiBaoWebVC ()<WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation ZHLiBaoWebVC

- (void)viewDidLayoutSubviews {
    
    self.webView.frame = self.view.bounds;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"礼包";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(refresh)];
    
    //
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    //
    
   UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)]];
    
    //
    UIBarButtonItem *closeButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(close)];

    self.navigationItem.leftBarButtonItems = @[backButtonItem,spaceItem,closeButtonItem];
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) configuration:config];
    [self.view addSubview:webView];
    webView.allowsBackForwardNavigationGestures = YES;
    self.webView = webView;
    webView.navigationDelegate = self;
    
//    self.urlStr = @"http://www.baidu.com";
    if ([AppConfig config].runEnv == RunEnvDev) {
        
        self.urlStr = @"http://lb.zhenghuijituan.com";
        
    }
    //
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.urlStr]];
    [webView loadRequest:req];
    
    //
}
- (void)back {
    
    if ([self.webView canGoBack]) {
        
        [self.webView goBack];
        
    } else {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

- (void)close {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

//
- (void)refresh {
    
    [self.webView reload];
    
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
