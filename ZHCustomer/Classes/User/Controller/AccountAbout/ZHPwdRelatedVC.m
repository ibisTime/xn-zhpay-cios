//
//  ZHPwdRelatedVC.m
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/12.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHPwdRelatedVC.h"

@interface ZHPwdRelatedVC ()

@property (nonatomic,assign) ZHPwdType type;
@property (nonatomic,strong) TLTextField *phoneTf;
@property (nonatomic,strong) TLCaptchaView *captchaView;
@property (nonatomic,strong) TLTextField *pwdTf;
@property (nonatomic,strong) TLTextField *rePwdTf;


@end

@implementation ZHPwdRelatedVC

- (instancetype)initWith:(ZHPwdType)type {

    if (self = [super init]) {
        
        self.type = type;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    self.view.backgroundColor = [UIColor grayColor];
    self.bgSV.backgroundColor = [UIColor groupTableViewBackgroundColor];

    
    [self setUpUI];
    [self .navigationController.navigationBar setBackgroundColor:[UIColor zh_themeColor]];
    
    
    if ([ZHUser user].mobile) {
        
        self.phoneTf.enabled = NO;
        self.phoneTf.text = [ZHUser user].mobile;
    }
    if(self.type == ZHPwdTypeForget) {
        
        self.title = @"忘记密码";
    
    } else if (self.type == ZHPwdTypeReset) {
        
          self.title = @"修改密码";
    
    } else if (self.type == ZHPwdTypeTradeReset) {
        
        self.title = @"支付密码";
        
    
    }
    
}

- (void)sendCaptcha {

    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = CAPTCHA_CODE;
    if (self.type == ZHPwdTypeTradeReset) { //交易密码
        
        http.parameters[@"bizType"] = USER_FIND_TRADE_PWD;
        
    } else { //找回密码
        
        http.parameters[@"bizType"] = USER_FIND_PWD_CODE;
        
    }
    http.parameters[@"mobile"] = self.phoneTf.text;
    [http postWithSuccess:^(id responseObject) {
        
        [self.captchaView.captchaBtn begin];
        
        if (self.type == ZHPwdTypeTradeReset) {
            [ZHUser user].tradepwdFlag = @"1";
            [[ZHUser user] updateUserInfo];
            
        }
        
    } failure:^(NSError *error) {
        
    }];

}


- (void)confirm {
    
    
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
    
    http.parameters[@"smsCaptcha"] = self.captchaView.captchaTf.text;
    if (self.type == ZHPwdTypeTradeReset) { //支付密码po
        
         http.code = USER_FIND_TRADE_PWD;
        
         http.parameters[@"tradePwdStrength"] = @"2";
         http.parameters[@"newTradePwd"] = self.pwdTf.text;
         http.parameters[@"userId"] = [ZHUser user].userId;
         http.parameters[@"token"] = [ZHUser user].token;

    } else {
    
        http.code = USER_FIND_PWD_CODE;
        http.parameters[@"mobile"] = self.phoneTf.text;
        http.parameters[@"smsCaptcha"] = self.captchaView.captchaTf.text;
        http.parameters[@"loginPwdStrength"] = @"2";
        http.parameters[@"newLoginPwd"] = self.pwdTf.text;
    
    }
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithHUDText:@"修改成功"];
        [self.navigationController popViewControllerAnimated:YES];
        if (self.success) {
            self.success();
        }
        
    } failure:^(NSError *error) {
        
        
    }];
 

    
    
}

- (void)setUpUI {

    CGFloat leftW = 90;
    
    //手机号
    TLTextField *phoneTf = [[TLTextField alloc] initWithframe:CGRectMake(0, 20, SCREEN_WIDTH, 45)
                                                    leftTitle:@"手机号"
                                                   titleWidth:leftW
                                                  placeholder:@"请输入手机号"];
    [self.bgSV addSubview:phoneTf];
    self.phoneTf = phoneTf;
    
    
    //验证码
    TLCaptchaView *captchaView = [[TLCaptchaView alloc] initWithFrame:CGRectMake(phoneTf.x, phoneTf.yy + 1, phoneTf.width, phoneTf.height)];
    [self.bgSV addSubview:captchaView];
    _captchaView = captchaView;
    [captchaView.captchaBtn addTarget:self action:@selector(sendCaptcha) forControlEvents:UIControlEventTouchUpInside];
    
    //新密码
    TLTextField *pwdTf = [[TLTextField alloc] initWithframe:CGRectMake(phoneTf.x, captchaView.yy + 15, phoneTf.width, phoneTf.height)
                                                  leftTitle:@"新密码"
                                                 titleWidth:leftW
                                                placeholder:@"请输入密码(不少于6位)"];
    [self.bgSV addSubview:pwdTf];
    pwdTf.secureTextEntry = YES;
    self.pwdTf = pwdTf;
    
    //重新输入
    TLTextField *rePwdTf = [[TLTextField alloc] initWithframe:CGRectMake(phoneTf.x, pwdTf.yy + 1, phoneTf.width, phoneTf.height)
                                                    leftTitle:@"确认密码"
                                                   titleWidth:leftW
                                                  placeholder:@"确认"];
    [self.bgSV addSubview:rePwdTf];
    rePwdTf.secureTextEntry = YES;
    self.rePwdTf = rePwdTf;
    
    //确认按钮
    UIButton *confirmBtn = [UIButton zhBtnWithFrame:CGRectMake(20, rePwdTf.yy + 30, SCREEN_WIDTH - 40, 44) title:@"确认"];
    [self.bgSV addSubview:confirmBtn];
    [confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];

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
