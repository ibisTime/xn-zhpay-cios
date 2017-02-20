//
//  ZHAboutUsVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/13.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHAboutUsVC.h"

@interface ZHAboutUsVC ()

@end

@implementation ZHAboutUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"关于我们";
    
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
