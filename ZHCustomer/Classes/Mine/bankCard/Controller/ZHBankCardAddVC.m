//
//  ZHBankCardAddVC.m
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/24.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHBankCardAddVC.h"
#import "TLPickerTextField.h"
#import "ZHBank.h"
#import "ZHRealNameAuthVC.h"

@interface ZHBankCardAddVC ()

@property (nonatomic,strong) TLTextField *realNameTf;

@property (nonatomic,strong) TLPickerTextField *bankNameTf; //开户行
@property (nonatomic,strong) TLTextField *subbranchTf; //支行

@property (nonatomic,strong) TLTextField *bankCardTf;
@property (nonatomic,strong) TLTextField *mobileTf;
@property (nonatomic,strong) UIScrollView *bgSV;

@property (nonatomic,strong) UIButton *operationBtn;

@property (nonatomic,strong) NSMutableArray <ZHBank *>*banks; //所有银行
@property (nonatomic,strong) NSMutableArray <NSString *>*bankNames; //所有银行


@end


@implementation ZHBankCardAddVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加银行卡";
    
    //只能添加本人银行卡
    if ([ZHUser user].realName && [ZHUser user].idNo) {
        
        [self realNameAuthAfterAction];
        
    } else {
    
        ZHRealNameAuthVC *authVC = [[ZHRealNameAuthVC alloc] init];
        [authVC setAuthSuccess:^{
            
            [self realNameAuthAfterAction];
            
        }];
        [self.navigationController pushViewController:authVC animated:YES];
        
    
    }
    
}



- (void)realNameAuthAfterAction {

    //检测是否进行实名认证
    
    UIScrollView *bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    [self.view addSubview:bgScrollView];
    self.bgSV = bgScrollView;
    
    
    [self setUpUI];
    
    
    //只能添加该用户，的银行卡
    self.realNameTf.text = [ZHUser user].realName;
    self.realNameTf.enabled = NO;
    
    if (self.bankCard) {
        
        self.realNameTf.text = self.bankCard.realName;
        self.bankNameTf.text = self.bankCard.bankName;
        self.subbranchTf.text = self.bankCard.subbranch;
        self.bankCardTf.text = self.bankCard.bankcardNumber;
        self.mobileTf.text = self.bankCard.bindMobile;
        [self.operationBtn setTitle:@"修改" forState:UIControlStateNormal];
    }
    
    //查询能绑定的银行卡
    //    TLNetworking *http = [TLNetworking new];
    //    http.showView = self.view;
    //    http.code = @"802116";
    //    http.parameters[@"token"] = [ZHUser user].token;
    //    //11 易宝 12 宝付 13 富友 01 线下
    //    http.parameters[@"channelType"] = @"11";
    //    [http postWithSuccess:^(id responseObject) {
    //
    //    } failure:^(NSError *error) {
    //
    //    }];
    
    //获取银行卡渠道
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"802116";
    http.parameters[@"channelType"] = @"40";
    http.parameters[@"status"] = @"1";
    [http postWithSuccess:^(id responseObject) {
        
        NSArray *arr = responseObject[@"data"];
        self.banks = [ZHBank tl_objectArrayWithDictionaryArray:arr];
        
        self.bankNames = [NSMutableArray arrayWithCapacity:self.banks.count];
        [self.banks enumerateObjectsUsingBlock:^(ZHBank * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [self.bankNames addObject:obj.bankName];
            
        }];
        
        self.bankNameTf.tagNames = self.bankNames;
        
    } failure:^(NSError *error) {
        
    }];


}

- (void)bindCard {

    if (![self.realNameTf.text valid]) {
        [TLAlert alertWithMsg:@"请输入姓名"];
        return;
    }
    
    
    if (![self.bankNameTf.text valid]) {
        [TLAlert alertWithMsg:@"请选择银行卡"];
        return;
    }
    
    if (![self.subbranchTf.text valid]) {
        [TLAlert alertWithMsg:@"请填写开户支行"];
        return;
    }
    
    if (![self.bankCardTf.text valid]) {
        [TLAlert alertWithMsg:@"请填写银行卡号"];
        return;
    }
    
    if (![self.mobileTf.text valid]) {
        [TLAlert alertWithMsg:@"请填写与银行卡绑定的手机号"];
        return;
    }
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    
    if (self.bankCard) {//修改
        
        http.code = @"802012";
        http.parameters[@"code"] = self.bankCard.code;
        http.parameters[@"status"] = @"1";
        
    } else {//绑定
    
       http.code = @"802010";
    
    }

    http.parameters[@"token"] = [ZHUser user].token;
    http.parameters[@"userId"] = [ZHUser user].userId;
    http.parameters[@"realName"] = self.realNameTf.text;
    
    NSString *bankName = self.bankNameTf.text;
  __block  ZHBank *bank = nil;
    [self.banks enumerateObjectsUsingBlock:^(ZHBank * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj.bankName isEqualToString:bankName]) {
            bank = obj;
            *stop = YES;
        }
    }];
    
    __block  NSString *bankCode = nil;
    [self.banks enumerateObjectsUsingBlock:^(ZHBank * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.bankName isEqualToString: self.bankNameTf.text ]) {
            bankCode = obj.bankCode;
        }
    }];
   
    
    if (!bankCode) {
        [TLAlert alertWithHUDText:@"暂时无法添加"];
        return;
    }
    
    
    http.parameters[@"bankName"] = self.bankNameTf.text;
    http.parameters[@"bankCode"] = bankCode;

    http.parameters[@"subbranch"] = self.subbranchTf.text;//支行
    http.parameters[@"bankcardNumber"] = self.bankCardTf.text; //卡号
    http.parameters[@"bindMobile"] = self.mobileTf.text; //绑定的手机号
    http.parameters[@"currency"] = @"CNY"; //币种
    http.parameters[@"type"] = @"B"; //b端用户


//  C=C端用户 B=B端用户 1=保证金账户；2=进钱账户；3=出钱账户；4=走账户
    [http postWithSuccess:^(id responseObject) {
        
        if (self.bankCard) {
            
            [TLAlert alertWithHUDText:@"修改成功"];

        } else {
            [TLAlert alertWithHUDText:@"绑定成功"];

        }
        
        [self.navigationController popViewControllerAnimated:YES];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            ZHBankCard *card = [[ZHBankCard alloc] init];
            card.bankName = self.bankNameTf.text;
//            card.bankCode = responseObject[@"data"];
            card.bankcardNumber = self.bankCardTf.text;
            if (self.addSuccess) {
                self.addSuccess(card);
            }
        });
        
    } failure:^(NSError *error) {
        
        
    }];


}

- (void)setUpUI {

    CGFloat leftW = 90;
    CGFloat margin = 0.5;
    
    //户名
    TLTextField *nameTf = [[TLTextField alloc] initWithframe:CGRectMake(0, 10, SCREEN_WIDTH, 45) leftTitle:@"户名" titleWidth:leftW placeholder:@"请输入银行卡所属人姓名"];
    [self.bgSV addSubview:nameTf];
    self.realNameTf = nameTf;
    
    //开户行
    TLPickerTextField *bankPick = [[TLPickerTextField alloc] initWithframe:CGRectMake(0, nameTf.yy + margin, SCREEN_WIDTH, nameTf.height) leftTitle:@"开户行" titleWidth:leftW placeholder:@"请选择开户行"];
//    bankPick.tagNames = @[@"农业",@"深证",@"哪里"];
    [self.bgSV addSubview:bankPick];
    self.bankNameTf = bankPick;
    
    //开户支行
    TLTextField *subbranchTf = [[TLTextField alloc] initWithframe:CGRectMake(0, bankPick.yy + margin, SCREEN_WIDTH, 45) leftTitle:@"开户支行" titleWidth:leftW placeholder:@"请输入开户支行"];
    [self.bgSV addSubview:subbranchTf];
    self.subbranchTf = subbranchTf;
    
    //卡号
    TLTextField *bankCardTf = [[TLTextField alloc] initWithframe:CGRectMake(0, subbranchTf.yy + margin, SCREEN_WIDTH, 45) leftTitle:@"银行卡号  " titleWidth:leftW placeholder:@"请输入银行卡号"];
    [self.bgSV addSubview:bankCardTf];
    bankCardTf.keyboardType = UIKeyboardTypeNumberPad;
    self.bankCardTf = bankCardTf;
    
    //手机号
    TLTextField *mobileTf = [[TLTextField alloc] initWithframe:CGRectMake(0, bankCardTf.yy + margin, SCREEN_WIDTH, 45) leftTitle:@"手机号" titleWidth:leftW placeholder:@"请输入银行卡预留手机号"];
    [self.bgSV addSubview:mobileTf];
    mobileTf.keyboardType = UIKeyboardTypeNumberPad;
    self.mobileTf = mobileTf;
    
    //
    UIButton *addBtn = [UIButton zhBtnWithFrame:CGRectMake(15, mobileTf.yy + 30, SCREEN_WIDTH - 30, 45) title:@"添加"];
    [self.bgSV addSubview:addBtn];
    [addBtn addTarget:self action:@selector(bindCard) forControlEvents:UIControlEventTouchUpInside];
    self.operationBtn = addBtn;

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
