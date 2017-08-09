//
//  ZHChangeNickNameVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/3.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHChangeNickNameVC.h"
#import "TLHeader.h"
#import "ZHUser.h"

@interface ZHChangeNickNameVC ()

@property (nonatomic,strong) TLTextField *nickNameTf;

@end

@implementation ZHChangeNickNameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"修改昵称";
    
    self.nickNameTf = [[TLTextField alloc] initWithframe:CGRectMake(0, 10, SCREEN_WIDTH, 45) leftTitle:@"昵称" titleWidth:70 placeholder:@"请输入昵称"];
    [self.view addSubview:self.nickNameTf];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    
    if ([ZHUser user].nickname) {
        
        self.nickNameTf.text = [ZHUser user].nickname;
        
    }
    
}

- (void)save {
    
    if (![self.nickNameTf.text valid]) {
        [TLAlert alertWithHUDText:@"请输入昵称"];
        return;
    }

    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"805075";
    http.parameters[@"userId"] = [ZHUser user].userId;
    http.parameters[@"token"] = [ZHUser user].token;
    http.parameters[@"nickname"] = self.nickNameTf.text;
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithHUDText:@"修改成功"];
        [self.navigationController popViewControllerAnimated:YES];
        [ZHUser user].nickname = self.nickNameTf.text;
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoChange object:nil];
        
        [[ZHUser user] updateUserInfo];
        
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
