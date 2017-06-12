 //
//  TLWithdrawalVC.m
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/24.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHWithdrawalVC.h"
#import "TLPickerTextField.h"
#import "ZHBankCardAddVC.h"
#import "ZHPwdRelatedVC.h"


@interface ZHWithdrawalVC ()

@property (nonatomic,strong) TLPickerTextField *bankPickTf;
@property (nonatomic,strong) UILabel *balanceLbl;
@property (nonatomic,strong) UILabel *hinLbl;
@property (nonatomic,strong) UITextField *moneyTf;
@property (nonatomic,strong) NSMutableArray <ZHBankCard *>*banks;
@property (nonatomic,strong) TLTextField *tradePwdTf;

@end

@implementation ZHWithdrawalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提现";
    
    [self beginLoad];
    
}

- (void)beginLoad {

    //
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"802016";
    http.parameters[@"userId"] = [ZHUser user].userId;
    http.parameters[@"token"] = [ZHUser user].token;
    
    [http postWithSuccess:^(id responseObject) {
        
        
        
        NSArray *banks = responseObject[@"data"];
        if (banks.count >0 ) {
            
            [self removePlaceholderView];
            self.banks = [ZHBankCard tl_objectArrayWithDictionaryArray:banks];
            [self setUpUI];
            
            //获取取现次数
            TLNetworking *http = [TLNetworking new];
            http.code = @"802027";
            http.parameters[@"key"] = @"CUSERMONTIMES";
            [http postWithSuccess:^(id responseObject) {
                
                self.hinLbl.text = [NSString stringWithFormat:@"*每月最大取现次数: %@ 次", responseObject[@"data"][@"cvalue"]];
               
            } failure:^(NSError *error) {
                
            }];

            
            
        } else { //无卡
            
            [self setPlaceholderViewTitle:@"您还未添加银行卡" operationTitle:@"前往添加"];
            [self addPlaceholderView];
        
            
        }
        
    } failure:^(NSError *error) {
        
        
    }];

}

#pragma mark- 站位图行为
- (void)tl_placeholderOperation {


    ZHBankCardAddVC *addVC = [[ZHBankCardAddVC alloc] init];
    addVC.addSuccess = ^(ZHBankCard *card){
        
        [self beginLoad];
        
    };
    
    [self.navigationController pushViewController:addVC animated:YES];
    
}

#pragma mark- 设置交易密码
- (void)setTrade:(UIButton *)btn {

    ZHPwdRelatedVC *tradeVC = [[ZHPwdRelatedVC alloc] initWith:ZHPwdTypeTradeReset];
    tradeVC.success = ^() {
    
        btn.hidden = YES;
    
    };
    [self.navigationController pushViewController:tradeVC animated:YES];

}

- (void)setUpUI {

    self.bankPickTf = [[TLPickerTextField alloc] initWithframe:CGRectMake(0, 10, SCREEN_WIDTH, 50)
                                                     leftTitle:@"银行卡"
                                                    titleWidth:90
                                                   placeholder:@"请选择银行卡"];
    [self.view addSubview:self.bankPickTf];
    self.bankPickTf.isSecurity = YES;
    
    //
    UIView *mv = [self withdrawalView];
    [self.view addSubview:mv];
    
    //支付密码按钮
    TLTextField *tradePwdTf = [[TLTextField alloc] initWithframe:CGRectMake(0, mv.yy  + 10, SCREEN_WIDTH, 50) leftTitle:@"支付密码" titleWidth:90 placeholder:@"请输入支付密码"];
    tradePwdTf.secureTextEntry = YES;
    tradePwdTf.isSecurity = YES;
    [self.view addSubview:tradePwdTf];
    self.tradePwdTf = tradePwdTf;
    
    //
    UIButton *withdrawalBtn = [UIButton zhBtnWithFrame:CGRectMake(15, tradePwdTf.yy + 30, SCREEN_WIDTH - 30, 45) title:@"提现"];
    [self.view addSubview:withdrawalBtn];
    [withdrawalBtn addTarget:self action:@selector(withdrawal) forControlEvents:UIControlEventTouchUpInside];
    
    //
    UIButton *setPwdBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, withdrawalBtn.yy + 10, SCREEN_WIDTH - 30, 30) title:@"您还未设置支付密码,前往设置->" backgroundColor:[UIColor clearColor]];
    [self.view addSubview:setPwdBtn];
    [setPwdBtn setTitleColor:[UIColor zh_textColor] forState:UIControlStateNormal];
    setPwdBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [setPwdBtn addTarget:self action:@selector(setTrade:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //给初始化数据
    self.balanceLbl.text = [@"可用余额：" add:[self.balance convertToRealMoney]];
    
    
    //取出银行卡
    NSMutableArray *bankCards = [NSMutableArray arrayWithCapacity:self.banks.count];
    
    [self.banks enumerateObjectsUsingBlock:^(ZHBankCard * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [bankCards addObject:obj.bankcardNumber];
    }];
    
    self.bankPickTf.tagNames = bankCards;
    self.bankPickTf.text = bankCards[0];
    
    if ([[ZHUser user].tradepwdFlag isEqualToString:@"1"]) {
        setPwdBtn.hidden = YES;
    }

}

- (void)withdrawal {
    
    if ([self.balance isEqual:@0]) {
       
        [TLAlert alertWithHUDText:@"余额不足"];
        return;
    }

    if(![self.moneyTf.text valid]) {
        
        [TLAlert alertWithHUDText:@"请输入提现金额"];
        return;
        
    }
    
    //
    if ([self.moneyTf.text greaterThan:self.balance]) {
       
        [TLAlert alertWithHUDText:@"余额不足"];
        return;
    }
    
    if (![self.bankPickTf.text valid]) {
        
        [TLAlert alertWithHUDText:@"请选择银行卡"];
        return;
    }
    
    if (![self.tradePwdTf.text valid]) {
        
        [TLAlert alertWithHUDText:@"请输入支付密码"];
        return;
    }
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"802750";
    http.parameters[@"token"] = [ZHUser user].token;
 
    
    http.parameters[@"accountNumber"] = self.accountNum;
    //
    http.parameters[@"amount"] = [self.moneyTf.text convertToSysMoney];   //@"-100";
    //银行卡号
    http.parameters[@"payCardNo"] = self.bankPickTf.text; //开户行信息

    
    http.parameters[@"applyUser"] = [ZHUser user].userId;
    http.parameters[@"applyNote"] = @"用户端取现";
    http.parameters[@"tradePwd"] = self.tradePwdTf.text;

    [self.banks enumerateObjectsUsingBlock:^(ZHBankCard * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.bankcardNumber isEqualToString:self.bankPickTf.text ]) {
            
            http.parameters[@"payCardInfo"] = obj.subbranch; //实体账户编号,

        }
    }];


    
//    //银行卡号
//    http.parameters[@"bankcardCode"] = self.bankPickTf.text; //实体账户编号,
//    //    正数表示实体转虚拟；负数表示虚拟转实体
//
//    //批量虚拟账户
//    http.parameters[@"accountNumberList"] = @[self.accountNum];
////    11 充值 -11取现；19 红冲 -19 蓝补；
//    http.parameters[@"bizType"] = @"-11"; //虚拟账户
//    http.parameters[@"bizNote"] = @"1"; //虚拟账户

    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithHUDText:@"提现成功,我们将会对该交易进行审核"];
        [self.navigationController popViewControllerAnimated:YES];
        if (self.success) {
            self.success();
        }
        
    } failure:^(NSError *error) {
        
    }];
    
//    "bankcardCode": "1",
//    "transAmount": "1",
//    "accountNumber": "1",
//    "bizType": "1",
//    "bizNote": "1",
//    "channelTypeList": [
//                        "1",
//                        "2"
//                        ]



}

- (UIView *)withdrawalView {

    UIView *bgV = [[UIView alloc] initWithFrame:CGRectMake(0, self.bankPickTf.yy + 10, SCREEN_WIDTH, 147)];
    bgV.backgroundColor = [UIColor whiteColor];
    UILabel *hintLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 18, 300, 30) textAligment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor] font:[UIFont secondFont] textColor:[UIColor zh_textColor]];
    hintLbl.text = @"提现金额";
    hintLbl.height = [[UIFont secondFont] lineHeight];
    [bgV addSubview:hintLbl];
    
    //
    UILabel *markLbl = [UILabel labelWithFrame:CGRectMake(15, hintLbl.yy + 20, 23, 40) textAligment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor] font:FONT(30) textColor:[UIColor colorWithHexString:@"#333333"]];
    [bgV addSubview:markLbl];
    markLbl.text = @"￥";
    markLbl.height = [FONT(25) lineHeight];
    
    //输入
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(markLbl.xx + 15, markLbl.y - 7, SCREEN_WIDTH - markLbl.xx - 5, markLbl.height)];
    [bgV addSubview:tf];
    tf.font = FONT(30);
    tf.centerY = markLbl.centerY;
    tf.placeholder = @"请输入取现金额";
    tf.keyboardType = UIKeyboardTypeDecimalPad;
    self.moneyTf = tf;
    
    //
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, tf.yy + 15, SCREEN_WIDTH - 15, 0.5)];
    [bgV addSubview:line];
    line.backgroundColor = [UIColor zh_lineColor];
    
    //
    UILabel *balanceLbl = [UILabel labelWithFrame:CGRectMake(15, line.yy, SCREEN_WIDTH - 15, 38) textAligment:NSTextAlignmentLeft backgroundColor:[UIColor whiteColor] font:FONT(14) textColor:[UIColor zh_textColor2]];
    [bgV addSubview:balanceLbl];
    balanceLbl.text = @"可取现余额";
    self.balanceLbl = balanceLbl;

    //
    self.hinLbl = [UILabel labelWithFrame:CGRectMake(0, self.balanceLbl.yy, SCREEN_WIDTH - 15, 20) textAligment:NSTextAlignmentRight
                          backgroundColor:[UIColor whiteColor]
                                     font:FONT(12)
                                textColor:[UIColor themeColor]];
    [bgV addSubview:self.hinLbl];
    self.hinLbl.text = @"*每月最大取现次数:--";
    
    //
    UILabel *hinLbl2 = [UILabel labelWithFrame:CGRectMake(0, self.hinLbl.yy + 3, SCREEN_WIDTH - 15, 20) textAligment:NSTextAlignmentRight
                          backgroundColor:[UIColor whiteColor]
                                     font:FONT(12)
                                textColor:[UIColor themeColor]];
    [bgV addSubview:hinLbl2];
    hinLbl2.text = @"提现金额必须是5的倍数，单笔最高5万";
    bgV.height = hinLbl2.yy + 10;
    
    return bgV;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
