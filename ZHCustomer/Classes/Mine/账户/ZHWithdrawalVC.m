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
#import "TLHeader.h"
#import "UIColor+theme.h"
#import "ZHUser.h"

#define WITHDRAW_RULE_MAX_KEY @"QXDBZDJE"
#define WITHDRAW_RULE_MAX_COUNT_KEY @"CUSERMONTIMES"
#define WITHDRAW_RULE_BEI_SHU_KEY @"CUSERQXBS"
#define WITHDRAW_RULE_PROCEDURE_FEE_KEY @"CUSERQXFL"


@interface ZHWithdrawalVC ()

@property (nonatomic,strong) TLPickerTextField *bankPickTf;
@property (nonatomic,strong) UILabel *balanceLbl;
@property (nonatomic,strong) UILabel *procedureFeeLbl;


//--//
//@property (nonatomic,strong) UILabel *hinLbl;
@property (nonatomic, strong) UILabel *withdrawRuleLbl;
@property (nonatomic, strong) UIButton *setPwdBtn;

@property (nonatomic,strong) UITextField *moneyTf;
@property (nonatomic,strong) NSMutableArray <ZHBankCard *>*banks;
@property (nonatomic,strong) TLTextField *tradePwdTf;

@property (nonatomic, strong) NSNumber *maxMoney;
@property (nonatomic, strong) NSNumber *beiShu;
@property (nonatomic, strong) NSNumber *maxCount;
@property (nonatomic, strong) NSNumber *produceFee;

@property (nonatomic, assign) BOOL getBankCardSuccess;



@end

@implementation ZHWithdrawalVC {

    dispatch_group_t _group;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提现";

    _group = dispatch_group_create();
    
    [self setPlaceholderViewTitle:@"加载失败" operationTitle:@"重新加载"];
    //
    [self beginLoad];
    
}





- (void)hiddenSetPwdbtn {

    
    self.setPwdBtn.hidden = YES;
    self.setPwdBtn.height = 0.1;

}

- (void)beginLoad {
    
    [TLProgressHUD showWithStatus:nil];
    __block NSInteger successCount = 0;
    
    dispatch_group_enter(_group);
    TLNetworking *ruleHttp = [TLNetworking new];
    ruleHttp.code = @"802028";
    ruleHttp.parameters[@"keyList"] = @[WITHDRAW_RULE_MAX_KEY,
                                        WITHDRAW_RULE_MAX_COUNT_KEY,
                                        WITHDRAW_RULE_BEI_SHU_KEY,
                                        WITHDRAW_RULE_PROCEDURE_FEE_KEY];
    
    [ruleHttp postWithSuccess:^(id responseObject) {
        
        dispatch_group_leave(_group);
        successCount ++;
        
        self.beiShu = responseObject[@"data"][WITHDRAW_RULE_BEI_SHU_KEY];
        self.maxCount = responseObject[@"data"][WITHDRAW_RULE_MAX_COUNT_KEY];
        
        self.maxMoney = responseObject[@"data"][WITHDRAW_RULE_MAX_KEY];
        self.produceFee = responseObject[@"data"][WITHDRAW_RULE_PROCEDURE_FEE_KEY];
        
    } failure:^(NSError *error) {
        
        dispatch_group_leave(_group);

    }];

    //
    dispatch_group_enter(_group);
    TLNetworking *http = [TLNetworking new];
    http.code = @"802016";
    http.parameters[@"userId"] = [ZHUser user].userId;
    http.parameters[@"token"] = [ZHUser user].token;
    [http postWithSuccess:^(id responseObject) {
     
        dispatch_group_leave(_group);
        successCount ++;
        
        NSArray *banks = responseObject[@"data"];
        self.banks = [ZHBankCard tl_objectArrayWithDictionaryArray:banks];

        
    } failure:^(NSError *error) {
        dispatch_group_leave(_group);

        
    }];
    
    
    //
    dispatch_group_notify(_group, dispatch_get_main_queue(), ^{
        
        [TLProgressHUD dismiss];
        if (successCount == 2) {
            self.getBankCardSuccess = YES;

            [self addPlaceholderView];
            
            if (self.banks.count > 0 ) {
                

                //
                [self setUpUI];
                
                //
                if ([[ZHUser user].tradepwdFlag isEqualToString:@"1"]) {
                    
                    [self hiddenSetPwdbtn];
                }
                
                self.procedureFeeLbl.text = @"本次提现手续费：0.00";
                
                //时间
                [self.moneyTf addTarget:self action:@selector(moneyChange:) forControlEvents:UIControlEventEditingChanged];
                
                
                //余额进行初始化
                self.balanceLbl.text = [@"可用余额：" add:[self.balance convertToRealMoney]];
                
                NSMutableParagraphStyle *paragraphyStyle = [[NSMutableParagraphStyle alloc] init];
                paragraphyStyle.lineSpacing = 5;
                
               NSString *flStr = [NSString stringWithFormat:@"%.f",[self.produceFee floatValue]*100];
                
                NSAttributedString *attr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"取现规则：\n1.每月最大取现次数：%@\n2.提现金额必须是%@的倍数，单笔最高%@\n3.取现手续费率 %@%%",self.maxCount,self.beiShu,self.maxMoney,flStr ]attributes:@{NSParagraphStyleAttributeName : paragraphyStyle}];
                
                
                
                //
                self.withdrawRuleLbl.attributedText = attr;
                
            } else { //无卡
                
                [self setPlaceholderViewTitle:@"您还未添加银行卡" operationTitle:@"前往添加"];
                [self addPlaceholderView];
                
            }
        
        } else{
            
            [self removePlaceholderView];

        }
        
    });;

    
}

#pragma mark- 输入金额改变
- (void)moneyChange:(UITextField *)moneyTf {

    if (moneyTf.text.length) {
        
//        self.procedureFeeLbl.text = @"本次提现手续费：100";

        CGFloat num = [self.produceFee floatValue];
        
        self.procedureFeeLbl.text = [NSString stringWithFormat:@"本次提现手续费：%.2f",[moneyTf.text floatValue]*num];


    } else {
    
        self.procedureFeeLbl.text = @"本次提现手续费：0.00";

    }
    
 

}


#pragma mark- 站位图行为
- (void)tl_placeholderOperation {

    if (!self.getBankCardSuccess) {
        
        [self beginLoad];
        return;
    }

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
    
        [self hiddenSetPwdbtn];    
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
    self.setPwdBtn = setPwdBtn;
    
    //
    //
//    self.hinLbl = [UILabel labelWithFrame:CGRectMake(15, setPwdBtn.yy, SCREEN_WIDTH - 30, 20)
//                             textAligment:NSTextAlignmentLeft
//                          backgroundColor:[UIColor whiteColor]
//                                     font:FONT(12)
//                                textColor:[UIColor themeColor]];
//    [self.view addSubview:self.hinLbl];
//    self.hinLbl.text = @"每月最大取现次数:--";
    
    
    //
    UILabel *hinLbl2 = [UILabel labelWithFrame:CGRectMake(15, setPwdBtn.yy + 3, SCREEN_WIDTH - 30, 20)
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor clearColor]
                                          font:FONT(12)
                                     textColor:[UIColor themeColor]];
    [self.view addSubview:hinLbl2];
    self.withdrawRuleLbl = hinLbl2;
    self.withdrawRuleLbl.numberOfLines = 0;
    [hinLbl2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(setPwdBtn.mas_bottom).offset(3);
        make.right.equalTo(self.view.mas_right).offset(-15);
    }];
    
    
    //取出银行卡
    NSMutableArray *bankCards = [NSMutableArray arrayWithCapacity:self.banks.count];
    
    [self.banks enumerateObjectsUsingBlock:^(ZHBankCard * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [bankCards addObject:obj.bankcardNumber];
    }];
    
    self.bankPickTf.tagNames = bankCards;
    self.bankPickTf.text = bankCards[0];
    
  

}

- (void)withdrawal {
    

    
    //
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
    http.parameters[@"applyNote"] = @"iOS用户端取现";
    http.parameters[@"tradePwd"] = self.tradePwdTf.text;

    [self.banks enumerateObjectsUsingBlock:^(ZHBankCard * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.bankcardNumber isEqualToString:self.bankPickTf.text ]) {
            
            http.parameters[@"payCardInfo"] = obj.bankName; //实体账户编号,

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
    self.procedureFeeLbl = [UILabel labelWithFrame:CGRectMake(15, line.yy + 3, SCREEN_WIDTH - 15, 25)
                                      textAligment:NSTextAlignmentLeft
                                   backgroundColor:[UIColor clearColor]
                                              font:FONT(14)
                                         textColor:[UIColor themeColor]];
    [bgV addSubview:self.procedureFeeLbl];
    
    
    //
    UILabel *balanceLbl = [UILabel labelWithFrame:CGRectMake(15, self.procedureFeeLbl.yy, SCREEN_WIDTH - 15, 25)
                                     textAligment:NSTextAlignmentLeft
                                  backgroundColor:[UIColor whiteColor]
                                             font:FONT(14)
                                        textColor:[UIColor zh_textColor2]];
    [bgV addSubview:balanceLbl];
    balanceLbl.text = @"可取现余额";
    self.balanceLbl = balanceLbl;
    
   
    //
    bgV.height = balanceLbl.yy + 3;

 
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
