//
//  TLHTMLStrVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/27.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLHTMLStrVC.h"
#import <WebKit/WebKit.h>

@interface TLHTMLStrVC ()<WKNavigationDelegate>

@end

@implementation TLHTMLStrVC

//    ('aboutus','关于我们');
//    ('reg_protocol','注册协议');

//    ('treasure_rule','夺宝玩法介绍');
//    ('treasure_statement','夺宝免责申明');

//    ('fyf_rule','发一发玩法介绍');

//    ('fyf_statement','发一发免责申明');
//    ('yyy_statement','摇一摇免责申明');

//    ('yyy_rule','摇一摇玩法介绍');

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"807717";
    
    switch (self.type) {
            
        case ZHHTMLTypeAboutUs: {
            
            http.parameters[@"ckey"] = @"aboutus";

        } break;
            
        case ZHHTMLTypeRegProtocol: {
            
            http.parameters[@"ckey"] = @"reg_protocol";

        } break;
            
        case ZHHTMLTypeDBIntroduce: {
            http.parameters[@"ckey"] = @"treasure_rule";

        } break;
            
        case ZHHTMLTypeSendBrebireMoneyIntroduce: {
            http.parameters[@"ckey"] = @"fyf_rule";

        } break;
            
        case ZHHTMLTypeShakeItOfIntroduce: {
            http.parameters[@"ckey"] = @"yyy_rule";

        } break;
            
    }


    [http postWithSuccess:^(id responseObject) {
        
        WKWebViewConfiguration *webConfig = [[WKWebViewConfiguration alloc] init];
        
        WKWebView *webV = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) configuration:webConfig];
        [self.view addSubview:webV];
        webV.navigationDelegate = self;
        
        NSString *styleStr = @"<style type=\"text/css\"> *{ font-size:30px;}</style>";
        NSString *htmlStr = responseObject[@"data"][@"note"];
        [webV loadHTMLString:[NSString stringWithFormat:@"%@%@",htmlStr,styleStr] baseURL:nil];
        
    } failure:^(NSError *error) {
        
    }];
    


    
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
