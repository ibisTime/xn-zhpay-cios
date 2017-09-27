//
//  ZHFRBToOtherPeopleVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/6/5.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHCurrencyToOtherPeopleVC.h"
#import "ZHPwdRelatedVC.h"
#import "TLHeader.h"
#import "ZHUser.h"
#import "ZHCurrencyHelper.h"
#import "UIColor+theme.h"
#import "ZHCurrencyModel.h"
#import "AppConfig.h"


@interface ZHCurrencyToOtherPeopleVC()

@property (nonatomic, strong) UIScrollView *bgSV;

@property (nonatomic, strong) UITextField *phoneTf;

//
@property (nonatomic, strong) UITextField *tradePwdTf;

//
@property (nonatomic, strong) UITextField *moneyTf;

//
@property (nonatomic, strong) ZHCurrencyModel *currentCurrencyModel;

@end

@implementation ZHCurrencyToOtherPeopleVC

- (void)viewDidLoad {

    [super viewDidLoad];
    
    self.title = @"转账";
    
    if (!self.accountNumber) {
        [TLAlert alertWithError:@"传入 账户编号"];
        return;
    }
    
    
    [self tl_placeholderOperation];
    
    
}

- (void)getBeiShu {
    
    //
    TLNetworking *http = [TLNetworking new];
    http.code = @"802027";
    http.parameters[@"companyCode"] = [AppConfig config].companyCode;
    http.parameters[@"systemCode"] = [AppConfig config].systemCode;
    http.parameters[@"key"] = @"TRANSAMOUNTBS";
    http.parameters[@"type"] = @"TR";
    [http postWithSuccess:^(id responseObject) {
        
        self.moneyTf.placeholder = [NSString stringWithFormat:@"转账金额必须为 %@ 的整倍数",responseObject[@"data"][@"cvalue"]];
        
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)tl_placeholderOperation {
    
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"802502";
    http.parameters[@"accountNumber"] = self.accountNumber;
    http.parameters[@"token"] = [ZHUser user].token;
    [http postWithSuccess:^(id responseObject) {
        
        //获取币种
        self.currentCurrencyModel = [ZHCurrencyModel tl_objectWithDictionary:responseObject[@"data"]];
        
#pragma mark- 检测是否设置了交易密码
        if (![[ZHUser user].tradepwdFlag isEqualToString:@"1"]) {
            
            
            [self setPlaceholderViewTitle:@"您还未设置支付密码" operationTitle:@"前往设置"];
            [self addPlaceholderView];
            //
                    ZHPwdRelatedVC *pwdAboutVC = [[ZHPwdRelatedVC alloc] initWith:ZHPwdTypeTradeReset];
                    [pwdAboutVC setSuccess:^{
            
                        [self removePlaceholderView];
                        [self setUpUI];
                        [self getBeiShu];
                        
                    }];
            
                    [self.navigationController pushViewController:pwdAboutVC animated:YES];
        } else {//
            
            [self setUpUI];
            [self getBeiShu];

        }
     


        
    } failure:^(NSError *error) {
        
        
    }];
  
    
    
    
}

- (void)setUpUI {

    UIScrollView *bgSV  = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    [self.view addSubview:bgSV];
    self.bgSV = bgSV;
    
    CGFloat leftW = 120;
    
    //手机号
    TLTextField *phoneTf = [[TLTextField alloc] initWithframe:CGRectMake(0, 20, SCREEN_WIDTH, 45)
                                                    leftTitle:@"收款人账号"
                                                   titleWidth:leftW
                                                  placeholder:@"输入完整手机号"];
    [self.bgSV addSubview:phoneTf];
    self.phoneTf = phoneTf;
    self.phoneTf.keyboardType = UIKeyboardTypeNumberPad;

    

    
    //
    self.moneyTf = [[TLTextField alloc] initWithframe:CGRectMake(0, phoneTf.yy + 1, SCREEN_WIDTH, 45)
                                                    leftTitle:@"转账金额"
                                                   titleWidth:leftW
                                                  placeholder:@"转账金额必须为 -- 的整倍数"];
    [self.bgSV addSubview:self.moneyTf];
    self.moneyTf.keyboardType = UIKeyboardTypeNumberPad;
    //
    //
    UILabel *hintLbl = [UILabel labelWithFrame:CGRectMake(15, self.moneyTf.yy, SCREEN_WIDTH - 30, 30) textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor clearColor]
                                          font:FONT(13)
                                     textColor:[UIColor themeColor]];
    [self.bgSV addSubview:hintLbl];
    hintLbl.numberOfLines = 0;
    //    => 100*n
    
    hintLbl.text = [NSString stringWithFormat:@"可转账余额：%@",[self.currentCurrencyModel.amount convertToRealMoney]];
    
    //
    self.tradePwdTf = [[TLTextField alloc] initWithframe:CGRectMake(0, hintLbl.yy + 1, SCREEN_WIDTH, 45)
                                            leftTitle:@"支付密码"
                                           titleWidth:leftW
                                          placeholder:@"请输入支付密码"];
    [self.bgSV addSubview:self.tradePwdTf];
    self.tradePwdTf.secureTextEntry = YES;
    
    //
    UIButton *firstConfirmBtn = [UIButton zhBtnWithFrame:CGRectMake(20, self.tradePwdTf.yy + 20, SCREEN_WIDTH - 40, 45) title:@"确认"];
    [self.bgSV addSubview:firstConfirmBtn];
    
    [firstConfirmBtn addTarget:self action:@selector(firstStepAction) forControlEvents:UIControlEventTouchUpInside];
    
    
}

#pragma mark- 转账第一步
- (void)firstStepAction {
    
    
    //
    if (![self.phoneTf.text valid]) {
        [TLAlert alertWithInfo:@"请输入对方账号"];
        return;
    }
    
    //
    if (![self.moneyTf.text valid] || [self.moneyTf.text floatValue] <= 0) {
        [TLAlert alertWithInfo:@"转账金额需大于0"];
        return;
    }
    
    //
    if (![self.tradePwdTf.text valid]) {
        [TLAlert alertWithInfo:@"请输入支付密码"];
        return;
    }

    UIControl *maskCtrl = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [[UIApplication sharedApplication].keyWindow addSubview:maskCtrl];
    maskCtrl.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    [maskCtrl addTarget:self action:@selector(remove:) forControlEvents:UIControlEventTouchUpInside];
    
    //
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectZero];
    bgView.backgroundColor = [UIColor whiteColor];
    [maskCtrl addSubview:bgView];
    bgView.layer.cornerRadius = 10;
    bgView.layer.masksToBounds = YES;
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(maskCtrl.mas_centerX);
        make.centerY.equalTo(maskCtrl.mas_centerY).offset(-70);
        make.width.equalTo(@280);
        make.height.equalTo(@200);
    }];
    //
    UILabel *reHintLbl = [UILabel labelWithFrame:CGRectZero
                                    textAligment:NSTextAlignmentLeft
                                 backgroundColor:[UIColor whiteColor]
                                            font:FONT(17)
                                       textColor:[UIColor textColor]];
    [bgView addSubview:reHintLbl];
    [reHintLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset(10);
        make.right.equalTo(bgView.mas_right).offset(-10);
        make.top.equalTo(bgView.mas_top).offset(15);
    }];
    
    UILabel *reHintLbl1 = [UILabel labelWithFrame:CGRectZero
                                    textAligment:NSTextAlignmentLeft
                                 backgroundColor:[UIColor whiteColor]
                                            font:FONT(17)
                                       textColor:[UIColor textColor]];
    [bgView addSubview:reHintLbl1];
    [reHintLbl1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset(10);
        make.right.equalTo(bgView.mas_right).offset(-10);
        make.top.equalTo(reHintLbl.mas_bottom).offset(5);
    }];
    
    reHintLbl.text = [NSString stringWithFormat:@"收款人账号：%@",self.phoneTf.text];
    reHintLbl1.text = [NSString stringWithFormat:@"转账金额：%@",self.moneyTf.text];

    
    //
    UILabel *warnLbl = [UILabel labelWithFrame:CGRectZero
                                    textAligment:NSTextAlignmentLeft
                                 backgroundColor:[UIColor whiteColor]
                                            font:FONT(12)
                                       textColor:[UIColor themeColor]];
    [bgView addSubview:warnLbl];
    warnLbl.numberOfLines = 0;
    [warnLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset(10);
        make.right.equalTo(bgView.mas_right).offset(-10);
        make.top.equalTo(reHintLbl1.mas_bottom).offset(15);
    }];
    
    warnLbl.text = @"您正在进行转账操作，请仔细核对对方账号和转账金额！\n转账成功后平台概不负责追回款项，请小心操作";
    
    UIButton *cancleBtn = [UIButton zhBtnWithFrame:CGRectZero title:@"取消"];
    [bgView addSubview:cancleBtn];
    [cancleBtn addTarget:self action:@selector(cancle:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *confirmBtn = [UIButton zhBtnWithFrame:CGRectZero title:@"确认"];
    [bgView addSubview:confirmBtn];
    [confirmBtn addTarget:self action:@selector(confirmBtn:) forControlEvents:UIControlEventTouchUpInside];

    
    [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(35);
        make.bottom.equalTo(bgView.mas_bottom).offset(-20);
        
        //
        make.left.equalTo(bgView.mas_left).offset(30);
        
    }];
    
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(cancleBtn.mas_width);
        make.height.equalTo(cancleBtn.mas_height);
        make.bottom.equalTo(cancleBtn.mas_bottom);
        
        //
        make.right.equalTo(bgView.mas_right).offset(-30);
        
    }];
//    [firstConfirmBtn addTarget:self action:@selector(firstStepAction) forControlEvents:UIControlEventTouchUpInside];


}

- (void)confirmBtn:(UIButton *)btn {
    
    [(UIView *)[[btn nextResponder] nextResponder] removeFromSuperview];
    
    //
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"802418";
    http.parameters[@"fromUserId"] = [ZHUser user].userId;
    http.parameters[@"toMobile"] = self.phoneTf.text;
    http.parameters[@"amount"] = [self.moneyTf.text convertToSysMoney];
    http.parameters[@"tradePwd"] = self.tradePwdTf.text;
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"转账成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"zh_acount_change" object:nil];

      [self.navigationController popViewControllerAnimated:YES];
        if (self.success) {
            
            NSNumber *currentNum = @([self.currentCurrencyModel.amount longLongValue] - [self.moneyTf.text longLongValue]*1000);
            self.success(currentNum);
            
        }
        
        
    } failure:^(NSError *error) {
        
        
    }];


}

- (void)cancle:(UIButton *)btn {

    [(UIControl *)[[btn nextResponder] nextResponder] removeFromSuperview];
}

- (void)remove:(UIControl *)ctrl {

    [ctrl removeFromSuperview];

}

//- (void)lastStepAction {
//    
//    
//}
@end
