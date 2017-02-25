//
//  ZHRealNameAuthVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/29.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHRealNameAuthVC.h"

@interface ZHRealNameAuthVC ()

@property (nonatomic,strong) TLTextField *realNameTf;
@property (nonatomic,strong) TLTextField *idNoTf;
@property (nonatomic,strong) TLTextField *bankCardNoTf;
@property (nonatomic,strong) TLTextField *mobileTf;

//@property (nonatomic,strong) TLCaptchaView *captchaView;

@end

@implementation ZHRealNameAuthVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"实名认证";
    [self setUpUI];
    

 
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

- (void)confirm {
    
    
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
        [ZHUser user].tempRealName = self.realNameTf.text;
        [ZHUser user].tempIdNo = self.idNoTf.text;
        
        //:8903/std-certi/zhima?bizNo=ZM42342545
        NSString *urlStr = [NSString stringWithFormat:@"http://121.40.165.180:8903/std-certi/zhima?bizNo=%@",responseObject[@"data"][@"bizNo"]];
        
        NSString *alipayUrl = [NSString stringWithFormat:@"alipayqr://platformapi/startapp?saId=10000007&qrcode=%@",urlStr];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:alipayUrl] options:@{} completionHandler:nil];
        
    } failure:^(NSError *error) {
        
        
    }];
    
    
//        TLNetworking *http = [TLNetworking new];
//        http.showView = self.view;
//        http.code = @"805190";
//        http.parameters[@"userId"] = [ZHUser user].userId;
//        http.parameters[@"realName"] = self.realNameTf.text;
//        http.parameters[@"idKind"] = @"1";
//        http.parameters[@"token"] = [ZHUser user].token;
//        http.parameters[@"idNo"] = self.idNoTf.text;
//        http.parameters[@"cardNo"] = self.bankCardNoTf.text;
//        http.parameters[@"bindMobile"] = self.mobileTf.text; //绑定的手机号码
//
//        [http postWithSuccess:^(id responseObject) {
//    
//            [TLAlert alertWithHUDText:@"实名认证成功"];
//            [self.navigationController popViewControllerAnimated:YES];
//            
//            [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoChange object:nil];
//            
//            [[ZHUser user] updateUserInfo];
//            [ZHUser user].realName = self.realNameTf.text;
//            [ZHUser user].idNo = self.idNoTf.text;
//            if (self.authSuccess) {
//                self.authSuccess();
//            }
//            
//        } failure:^(NSError *error) {
//         
//            
//        }];

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
    
//    //银行卡号
//    TLTextField *bankCardNoTf = [[TLTextField alloc] initWithframe:CGRectMake(0, idNoTf.yy + 1, SCREEN_WIDTH, 45)
//                                                   leftTitle:@"银行卡号"
//                                                  titleWidth:leftW
//                                                 placeholder:@"请输入您本人的银行卡号"];
//    [self.view addSubview:bankCardNoTf];
//    bankCardNoTf.isSecurity = YES;
//    bankCardNoTf.keyboardType = UIKeyboardTypeNumberPad;
//    self.bankCardNoTf = bankCardNoTf;
//    
//    //银行卡号
//    TLTextField *mobileTf = [[TLTextField alloc] initWithframe:CGRectMake(0, bankCardNoTf.yy + 1, SCREEN_WIDTH, 45)
//                                                         leftTitle:@"手机号码"
//                                                        titleWidth:leftW
//                                                       placeholder:@"请输您的银行卡预留手机号"];
//    [self.view addSubview:mobileTf];
//    mobileTf.isSecurity = YES;
//    mobileTf.keyboardType = UIKeyboardTypeNumberPad;
//    self.mobileTf = mobileTf;
//    
    
    //确认按钮
    UIButton *confirmBtn = [UIButton zhBtnWithFrame:CGRectMake(20, idNoTf.yy + 30, SCREEN_WIDTH - 40, 44) title:@"确认"];
    [self.view addSubview:confirmBtn];
    [confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    
//    //验证码
//    TLCaptchaView *captchaView = [[TLCaptchaView alloc] initWithFrame:CGRectMake(realNameTf.x, realNameTf.yy + 1, realNameTf.width, realNameTf.height)];
//    [self.bgSV addSubview:captchaView];
//    _captchaView = captchaView;
//    [captchaView.captchaBtn addTarget:self action:@selector(sendCaptcha) forControlEvents:UIControlEventTouchUpInside];
    
    //新密码
    
    
    if ([ZHUser user].realName && [ZHUser user].realName.length > 0) {
        self.realNameTf.text = [ZHUser user].realName;
        self.idNoTf.text = [ZHUser user].idNo;
        
        confirmBtn.hidden = YES;
        self.realNameTf.enabled = NO;
        self.idNoTf.enabled = NO;
        self.bankCardNoTf.hidden = YES;
        self.mobileTf.hidden = YES;
    }
    


}

@end
