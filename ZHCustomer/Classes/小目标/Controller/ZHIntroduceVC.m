//
//  ZHIntroduceVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHIntroduceVC.h"

@interface ZHIntroduceVC ()

@end

@implementation ZHIntroduceVC

 - (void)viewDidLoad {
     
        [super viewDidLoad];
        
        self.title = @"玩法介绍";
        
        UIWebView *webV = [[UIWebView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:webV];
        
        TLNetworking *http = [TLNetworking new];
        http.showView = self.view;
        http.code = @"807717";
        http.parameters[@"ckey"] = @"aboutus";
        http.parameters[@"token"] = [ZHUser user].token;
        [http postWithSuccess:^(id responseObject) {
            
            [webV loadHTMLString:responseObject[@"data"][@"note"] baseURL:nil];
            
        } failure:^(NSError *error) {
            
        }];
     
}
@end
