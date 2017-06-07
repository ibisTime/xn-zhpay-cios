//
//  ZHUserLoginVC.m
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/12.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHUserLoginVC.h"
#import "ZHUserRegistVC.h"
#import "ZHUserForgetPwdVC.h"
#import "ZHNavigationController.h"
//#import "ZHHomeVC.h"
//#import "ChatManager.h"

#import "UICKeyChainStore.h"


@interface ZHUserLoginVC ()

@property (nonatomic,strong) ZHAccountTf *phoneTf;
@property (nonatomic,strong) ZHAccountTf *pwdTf;

@end

@implementation ZHUserLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";

    [self setUpUI];
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    //登录成功之后，给予回调
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login) name:kUserLoginNotification object:nil];
    
    //是否有存储的账号密码
    UICKeyChainStore *keyChainStore = [UICKeyChainStore keyChainStoreWithService:[UICKeyChainStore defaultService]];
    NSString *userName =  [keyChainStore stringForKey:KEY_CHAIN_USER_NAME_KEY];
    NSString *passWord =  [keyChainStore stringForKey:KEY_CHAIN_USER_PASS_WORD_KEY];


    if (userName) {
        self.phoneTf.text = userName;
        
        if (passWord) {
            
            self.pwdTf.text = passWord;
            
        }
        
    }
    
 
    
    [self.pwdTf addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventEditingChanged];
    //
//    [self.pwdTf addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:NULL];

}

- (void)valueChange:(UITextField *)tf {

    if (!tf.text || tf.text.length == 0) {
        
        UICKeyChainStore *keyChainStore = [UICKeyChainStore keyChainStoreWithService:[UICKeyChainStore defaultService]];
        [keyChainStore removeItemForKey:KEY_CHAIN_USER_PASS_WORD_KEY];
        
    }

}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSString*, id> *)change context:(nullable void *)context {

    NSLog(@"909090909");
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {


    return YES;
    
}

- (void)back {

    [self.navigationController dismissViewControllerAnimated:YES completion:nil];

}

//登录成功
- (void)login {

    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    if (self.loginSuccess) {
        self.loginSuccess();
    }

}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    
}


- (void)findPwd {

    ZHUserForgetPwdVC *vc = [[ZHUserForgetPwdVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];

}


- (void)goReg {

    [self.navigationController pushViewController:[[ZHUserRegistVC alloc] init] animated:YES];

}

- (void)goLogin {
    
    
    if (![self.phoneTf.text isPhoneNum]) {
        
        [TLAlert alertWithHUDText:@"请输入正确的手机号"];
        
        return;
    }

    if (!(self.pwdTf.text &&self.pwdTf.text.length > 5)) {
        
        [TLAlert alertWithHUDText:@"请输入6位以上密码"];
        return;
    }

    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = USER_LOGIN_CODE;

    http.parameters[@"loginName"] = self.phoneTf.text;
    http.parameters[@"loginPwd"] = self.pwdTf.text;
    [http postWithSuccess:^(id responseObject) {
        
       NSString *token = responseObject[@"data"][@"token"];
       NSString *userId = responseObject[@"data"][@"userId"];

       //1.获取用户信息
        TLNetworking *http = [TLNetworking new];
        http.showView = self.view;
        http.code = USER_INFO;
        http.parameters[@"userId"] = userId;
        http.parameters[@"token"] = token;
        [http postWithSuccess:^(id responseObject) {
          
         NSDictionary *userInfo = responseObject[@"data"];
         [ZHUser user].userId = userId;
         [ZHUser user].token = token;
         [[ZHUser user] saveUserInfo:userInfo];
         [[ZHUser user] setUserInfoWithDict:userInfo];
            
         [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginNotification object:nil];
        
         //记住密码，保存在较为安全的钥匙串中
          UICKeyChainStore *keyChainStore = [UICKeyChainStore keyChainStoreWithService:[UICKeyChainStore defaultService]];
          [keyChainStore setString:self.phoneTf.text forKey:KEY_CHAIN_USER_NAME_KEY error:nil];
          [keyChainStore setString:self.pwdTf.text forKey:KEY_CHAIN_USER_PASS_WORD_KEY error:nil];
        
         
            
//         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//             
//             [[ChatManager defaultManager] loginWithUserName:userId];
//
//         });
            
                //登录环信
//                if ([[ChatManager defaultManager] loginWithUserName:userId]) {
//                    
//                    [ZHUser user].userId = userId;
//                    [ZHUser user].token = token;
//                    [[ZHUser user] saveUserInfo:userInfo];
//                    [[ZHUser user] setUserInfoWithDict:userInfo];
//                    
//                    [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginNotification object:nil];
//                    
//                } else {
//                    
//                    [TLAlert alertWithHUDText:@"登录失败"];
//                    
//                }
            

            } failure:^(NSError *error) {
                
                
            }];
            
        } failure:^(NSError *error) {
            
            
        }];

 
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    
    [self.view endEditing:YES];
    
}


- (void)setUpUI {
    
    
    UIScrollView *bgSV = self.bgSV;
    
    CGFloat margin = ACCOUNT_MARGIN;
    CGFloat w = SCREEN_WIDTH - 2*margin;
    CGFloat h = ACCOUNT_HEIGHT;
    CGFloat middleMargin = ACCOUNT_MIDDLE_MARGIN;
    
    //账号
    ZHAccountTf *phoneTf = [[ZHAccountTf alloc] initWithFrame:CGRectMake(margin, 50, w, h)];
    phoneTf.leftIconView.image = [UIImage imageNamed:@"手机号"];
    phoneTf.zh_placeholder = @"请输入手机号";
    [bgSV addSubview:phoneTf];
    self.phoneTf = phoneTf;
    phoneTf.keyboardType = UIKeyboardTypeNumberPad;

    
    //密码
    ZHAccountTf *pwdTf = [[ZHAccountTf alloc] initWithFrame:CGRectMake(margin, phoneTf.yy + middleMargin, w, h)];
    pwdTf.secureTextEntry = YES;
    pwdTf.leftIconView.image = [UIImage imageNamed:@"密码"];
    pwdTf.zh_placeholder = @"请输入密码";
    [bgSV addSubview:pwdTf];
    self.pwdTf = pwdTf;
    
    //找回密码
    UIButton *forgetPwdBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,pwdTf.yy + 10 , 100, 25) title:@"找回密码" backgroundColor:[UIColor clearColor]];
    [forgetPwdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bgSV addSubview:forgetPwdBtn];
    forgetPwdBtn.titleLabel.font = [UIFont thirdFont];
    forgetPwdBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    forgetPwdBtn.xx = SCREEN_WIDTH - margin;
    [forgetPwdBtn addTarget:self action:@selector(findPwd) forControlEvents:UIControlEventTouchUpInside];
    
    //登陆
    UIButton *loginBtn = [UIButton zhBtnWithFrame:CGRectMake(margin,pwdTf.yy + 55, w, h) title:@"登录"];
    [bgSV addSubview:loginBtn];
    [loginBtn addTarget:self action:@selector(goLogin) forControlEvents:UIControlEventTouchUpInside];

    
    //注册
    UIButton *regBtn = [UIButton borderBtnWithFrame:CGRectMake(margin,loginBtn.yy + 30, w, h) title:@"注册" borderColor:[UIColor whiteColor]];
    [regBtn addTarget:self action:@selector(goReg) forControlEvents:UIControlEventTouchUpInside];
    [bgSV addSubview:regBtn];



}
@end
