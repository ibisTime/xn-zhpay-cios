//
//  ZHUserForgetPwdVC.m
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/12.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHUserForgetPwdVC.h"
#import "ZHCaptchaView.h"

@interface ZHUserForgetPwdVC ()

@property (nonatomic,strong) ZHAccountTf *phoneTf;
@property (nonatomic,strong) ZHCaptchaView *captchaView;
@property (nonatomic,strong) ZHAccountTf *pwdTf;
@property (nonatomic,strong) ZHAccountTf *rePwdTf;


@end

@implementation ZHUserForgetPwdVC



- (void)sendCaptcha {
    
    if (![self.phoneTf.text isPhoneNum]) {
        
        [TLAlert alertWithHUDText:@"请输入正确的手机号"];
        
        return;
    }
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = CAPTCHA_CODE;
    http.parameters[@"bizType"] = USER_FIND_PWD_CODE;
    http.parameters[@"mobile"] = self.phoneTf.text;
    
    [http postWithSuccess:^(id responseObject) {
        
        [self.captchaView.captchaBtn begin];
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

- (void)changePwd {
    
    if (![self.phoneTf.text isPhoneNum]) {
        
        [TLAlert alertWithHUDText:@"请输入正确的手机号"];
        
        return;
    }
    
    if (!(self.captchaView.captchaTf.text && self.captchaView.captchaTf.text.length > 3)) {
        [TLAlert alertWithHUDText:@"请输入正确的验证码"];
        
        return;
    }
    
    if (!(self.pwdTf.text &&self.pwdTf.text.length > 5)) {
        
        [TLAlert alertWithHUDText:@"请输入6位以上密码"];
        return;
    }
    
    if (![self.pwdTf.text isEqualToString:self.rePwdTf.text]) {
        
        [TLAlert alertWithHUDText:@"输入的密码不一致"];
        return;
        
    }
    
    
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = USER_FIND_PWD_CODE;
    http.parameters[@"mobile"] = self.phoneTf.text;
    http.parameters[@"smsCaptcha"] = self.captchaView.captchaTf.text;
    http.parameters[@"loginPwdStrength"] = @"2";
    http.parameters[@"newLoginPwd"] = self.pwdTf.text;
    
    [http postWithSuccess:^(id responseObject) {
        
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        
        
    }];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"找回密码";
    CGFloat margin = ACCOUNT_MARGIN;
    CGFloat w = SCREEN_WIDTH - 2*margin;
    CGFloat h = ACCOUNT_HEIGHT;
    CGFloat middleMargin = ACCOUNT_MIDDLE_MARGIN;
    
    //账号
    ZHAccountTf *phoneTf = [[ZHAccountTf alloc] initWithFrame:CGRectMake(margin, 50, w, h)];
    phoneTf.zh_placeholder = @"请输入手机号";
    phoneTf.keyboardType = UIKeyboardTypeNumberPad;
    phoneTf.leftIconView.image = [UIImage imageNamed:@"手机号"];
    [self.bgSV addSubview:phoneTf];
    self.phoneTf = phoneTf;
    
    //验证码
    ZHCaptchaView *captchaView = [[ZHCaptchaView alloc] initWithFrame:CGRectMake(margin, phoneTf.yy + middleMargin, w, h)];
    [self.bgSV addSubview:captchaView];
    captchaView.captchaTf.zh_placeholder = @"请输入验证码";
   captchaView.captchaTf.leftIconView.image = [UIImage imageNamed:@"验证码"];
    [captchaView.captchaBtn addTarget:self action:@selector(sendCaptcha) forControlEvents:UIControlEventTouchUpInside];
    self.captchaView = captchaView;
    
    //密码
    ZHAccountTf *pwdTf = [[ZHAccountTf alloc] initWithFrame:CGRectMake(margin, captchaView.yy + middleMargin, w, h)];
    pwdTf.secureTextEntry = YES;
    pwdTf.zh_placeholder = @"请输入密码";
    pwdTf.leftIconView.image = [UIImage imageNamed:@"密码"];
    [self.bgSV addSubview:pwdTf];
    self.pwdTf = pwdTf;
    
    //re密码
    ZHAccountTf *rePwdTf = [[ZHAccountTf alloc] initWithFrame:CGRectMake(margin, pwdTf.yy + middleMargin, w, h)];
    rePwdTf.secureTextEntry = YES;
    rePwdTf.zh_placeholder = @"重新输入";
    [self.bgSV addSubview:rePwdTf];
    rePwdTf.leftIconView.image = [UIImage imageNamed:@"密码"];
    self.rePwdTf = rePwdTf;
    
    //xiu gai
    UIButton *confirmBtn = [UIButton zhBtnWithFrame:CGRectMake(margin,rePwdTf.yy + 50, w, h) title:@"确认"];
    [self.bgSV addSubview:confirmBtn];
    [confirmBtn addTarget:self action:@selector(changePwd) forControlEvents:UIControlEventTouchUpInside];
    
    
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
