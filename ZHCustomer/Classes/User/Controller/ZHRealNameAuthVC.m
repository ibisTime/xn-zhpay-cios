//
//  ZHRealNameAuthVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/29.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHRealNameAuthVC.h"
#import "TLHeader.h"
#import "UIColor+theme.h"
#import "ZHUser.h"

#define IOS_VERSION_10 (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_9_x_Max)?(YES):(NO)  

@interface ZHRealNameAuthVC ()<UIAlertViewDelegate>

@property (nonatomic,strong) TLTextField *realNameTf;
@property (nonatomic,strong) TLTextField *idNoTf;
@property (nonatomic,strong) TLTextField *bankCardNoTf;
@property (nonatomic,strong) TLTextField *mobileTf;
@property (nonatomic, strong) UIButton *confirmBtn;
//@property (nonatomic,strong) TLCaptchaView *captchaView;

@end

@implementation ZHRealNameAuthVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"实名认证";
    [self setUpUI];
    
    //已经实名认证过的用户
    if ([ZHUser user].realName && [ZHUser user].realName.length > 0) {
        
            self.realNameTf.text = [ZHUser user].realName;
            self.idNoTf.text = [ZHUser user].idNo;
    
            self.confirmBtn.hidden = YES;
            self.realNameTf.enabled = NO;
            self.idNoTf.enabled = NO;
            self.bankCardNoTf.hidden = YES;
            self.mobileTf.hidden = YES;
    }

 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(realName) name:@"realNameSuccess" object:nil];
    
}


- (void)realName {

    [TLAlert alertWithHUDText:@"实名认证成功"];
    [self.navigationController popViewControllerAnimated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoChange object:nil];
    
    [[ZHUser user] updateUserInfo];
    [ZHUser user].realName = self.realNameTf.text;
    [ZHUser user].idNo = self.idNoTf.text;
    if (self.authSuccess) {
        self.authSuccess();
    }


}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSString *appstoreUrl = @"itms-apps://itunes.apple.com/app/id333206289";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appstoreUrl]];
    }
}

- (BOOL)canOpenAlipay {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipays://"]];
}


- (void)confirm {
    
    if (![self canOpenAlipay]) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"实名认证需要安装支付宝,是否下载并安装支付宝完成认证?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好的", nil];
        [alertView show];
        
        return;
        
    }
    
    
    if (![self.realNameTf.text isChinese]) {
        [TLAlert alertWithHUDText:@"请输入正确的中文名称"];
        return;
    }
    
    if (![self.idNoTf.text valid] || self.idNoTf.text.length != 18) {
        
        [TLAlert alertWithHUDText:@"请输入身份证号码"];
        return;
        
    }
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"805191";
    //    http.url = @"http://121.40.165.180:8903/std-certi/api";
    http.parameters[@"userId"] = [ZHUser user].userId;
    http.parameters[@"idKind"] = @"1";
    http.parameters[@"idNo"] = self.idNoTf.text;
    http.parameters[@"realName"] = self.realNameTf.text;
    http.parameters[@"returnUrl"] = @"zhqb://certi.back";

    
    [http postWithSuccess:^(id responseObject) {
        
        if ([responseObject[@"data"][@"isSuccess"] isEqual:@1]) {
            
            [TLAlert alertWithHUDText:@"实名认证成功"];
            [self.navigationController popViewControllerAnimated:YES];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoChange object:nil];
            
            [[ZHUser user] updateUserInfo];
            [ZHUser user].realName = self.realNameTf.text;
            [ZHUser user].idNo = self.idNoTf.text;
            if (self.authSuccess) {
                self.authSuccess();
            }
            
            return ;
        }
        
        
        [ZHUser user].tempBizNo = responseObject[@"data"][@"bizNo"];
        NSString *urlStr = [NSString stringWithFormat:@"http://121.40.165.180:8903/std-certi/zhima?bizNo=%@",responseObject[@"data"][@"bizNo"]];
        
        NSString *alipayUrl = [NSString stringWithFormat:@"alipayqr://platformapi/startapp?saId=10000007&qrcode=%@",urlStr];
        
        //打开进行
        //此方法到  -- ios10 -- 但是ios10还可以使用
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:alipayUrl]];

       
        
    } failure:^(NSError *error) {
        
        
    }];
    
    


}
- (void)setUpUI {

    CGFloat leftW = 90;
    
    //姓名
    TLTextField *realNameTf = [[TLTextField alloc] initWithframe:CGRectMake(0, 20, SCREEN_WIDTH, 45)
                                                    leftTitle:@"姓名"
                                                   titleWidth:leftW
                                                  placeholder:@"请输入真实姓名"];
    realNameTf.isSecurity = YES;
    [self.view addSubview:realNameTf];
    self.realNameTf = realNameTf;
    
    //身份证号
    TLTextField *idNoTf = [[TLTextField alloc] initWithframe:CGRectMake(0, realNameTf.yy + 1, SCREEN_WIDTH, 45)
                                                       leftTitle:@"身份证号"
                                                      titleWidth:leftW
                                                     placeholder:@"请输入您的身份证号码"];
    [self.view addSubview:idNoTf];
    idNoTf.isSecurity = YES;
    self.idNoTf = idNoTf;
    
    //确认按钮
    UIButton *confirmBtn = [UIButton zhBtnWithFrame:CGRectMake(20, idNoTf.yy + 30, SCREEN_WIDTH - 40, 44) title:@"确认"];
    [self.view addSubview:confirmBtn];
    [confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    self.confirmBtn = confirmBtn;
    
    
}

@end
