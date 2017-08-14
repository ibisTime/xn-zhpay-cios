//
//  ZHPayVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/25.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHPayVC.h"
#import "ZHPayInfoCell.h"
#import "ZHPayFuncModel.h"
#import "ZHPayFuncCell.h"
#import "ZHCurrencyHelper.h"
#import "CDShopPaySuccessVC.h"
#import "WXApi.h"
#import "ZHPaySceneManager.h"
#import "TLWXManager.h"
#import "ZHCurrencyModel.h"
#import "TLAlipayManager.h"
#import "ZHPwdRelatedVC.h"
#import "ZHShop.h"
#import "ZHPayService.h"
#import "ZHRealNameAuthVC.h"
#import "TLHeader.h"
#import "ZHUser.h"
#import "UIColor+theme.h"

//
@interface ZHPayVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong) NSMutableArray <ZHPayFuncModel *>*pays;

//消费金额输入
@property (nonatomic,strong) TLTextField *amountTf;

@property (nonatomic, strong) UIView *payView;
//底部总价
@property (nonatomic,strong) UILabel *priceLbl;

@property (nonatomic,strong) ZHPaySceneManager *paySceneManager;

@property (nonatomic,strong) UITableView *payTableView;

@property (nonatomic, strong) NSNumber *changeRate;
@end


@implementation ZHPayVC

- (void)canclePay {

    [self.navigationController dismissViewControllerAnimated:YES completion:nil];

}

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    [self.amountTf becomeFirstResponder];
    
}


- (void)inputChange:(UITextField *)textField {

    if (!textField.text && textField.text.length <= 0) {
        
        self.priceLbl.text = @"0";
        return ;
    }
    
    
    if (self.shopPayType == ZHShopPayTypeBuyGiftB) {
        
        if (! self.changeRate) {
            
            return;
      
        }
        
       long long value = [textField.text floatValue]*1000/[self.changeRate floatValue];
       self.priceLbl.text = [@(value) convertToRealMoney];
       return;
    }
    
    
    self.priceLbl.text = [NSString stringWithFormat:@"%.2f", [textField.text floatValue]];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.amountTf.delegate = self;
    
    
    //
    if (self.navigationController) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(canclePay)];
    }
    
    
#pragma mark- 检测是否设置了交易密码
    if (![[ZHUser user].tradepwdFlag isEqualToString:@"1"]) {
        
        [self setPlaceholderViewTitle:@"您还未设置支付密码" operationTitle:@"前往设置"];
        [self addPlaceholderView];
        
    } else {//
        
        [self beginLoad];
    
    }
    
    //addNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    
    if (self.shopPayType == ZHShopPayTypeBuyGiftB) {
        
        TLNetworking *convertHttp = [TLNetworking new];
        convertHttp.code = @"002051";
        convertHttp.parameters[@"fromCurrency"] = kFRB;
        convertHttp.parameters[@"toCurrency"] = kGiftB;
//      convertHttp.parameters[@"fromCurrency"] =  kGiftB;
//      convertHttp.parameters[@"toCurrency"] = kFRB;
        [convertHttp postWithSuccess:^(id responseObject) {
            
            self.changeRate =  responseObject[@"data"][@"rate"];
            
        } failure:^(NSError *error) {
            
            
        }];

    } else if (self.shopPayType == ZHShopPayTypeBuyLMB) {
    
        TLNetworking *convertHttp = [TLNetworking new];
        convertHttp.code = @"002051";
        convertHttp.parameters[@"fromCurrency"] = kFRB;
        convertHttp.parameters[@"toCurrency"] = kLMB;
        [convertHttp postWithSuccess:^(id responseObject) {
            
            self.changeRate =  responseObject[@"data"][@"rate"];
            
        } failure:^(NSError *error) {
            
            
        }];
    
    }
    
}

- (void)keyboardWillAppear:(NSNotification *)notification {
    
    //获取键盘高度
    CGFloat duration =  [notification.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    CGRect keyBoardFrame = [notification.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    
    [UIView animateWithDuration:duration delay:0 options: 458752 | UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        self.payView.y = CGRectGetMinY(keyBoardFrame) - 64 - self.payView.height;
        
        
    } completion:NULL];
    
}


- (void)tl_placeholderOperation {

    ZHPwdRelatedVC *pwdAboutVC = [[ZHPwdRelatedVC alloc] initWith:ZHPwdTypeTradeReset];
    [self.navigationController pushViewController:pwdAboutVC animated:YES];
    
   [pwdAboutVC setSuccess:^{
    
       [self removePlaceholderView];
       [self beginLoad];
    
   }];

}

- (void)beginLoad {

    self.pays = [NSMutableArray array];
    self.paySceneManager = [[ZHPaySceneManager alloc] init];

    //--//
    NSArray *imgs;
    NSArray *payNames;
    NSArray *payType;
    NSArray <NSNumber *>*status;
    
    switch (self.shopPayType) {
        case ZHShopPayTypeDefaultO2O: {
        
            if ([self.shop.payCurrency isEqualToString:@"1"]) {
                
                payNames  = @[@"分润",@"联盟券",@"微信支付",@"支付宝"]; //余额(可用100)
                
            } else {
                
                payNames  = @[@"余额",@"联盟券",@"微信支付",@"支付宝"]; //余额(可用100)
                
            }
            imgs = @[@"zh_pay",@"zh_pay",@"we_chat",@"alipay"];
            payType = @[@(ZHPayTypeOther),@(ZHPayTypeLMB),@(ZHPayTypeWeChat),@(ZHPayTypeAlipay)];
            status = @[@(YES),@(NO),@(NO),@(NO)];
            
            self.paySceneManager.leftTitleStr = @"消费金额";
            self.paySceneManager.placeholderStr = @"请输入消费金额";

            //    isGift ? @"请输入礼品券数量" : @"请输入消费金额"
            //    isGift ? @"购买数量" : @"消费金额"
        } break;
            
        case ZHShopPayTypeGiftO2O: {
            
            payNames = @[@"礼品券余额"];
            imgs = @[@"zh_pay"];
            payType = @[@(ZHPayTypeGiftB)];
            status = @[@(YES)];
            self.paySceneManager.leftTitleStr = @"消费金额";
            self.paySceneManager.placeholderStr = @"请输入礼品券数量";
            
            //    isGift ? @"请输入礼品券数量" : @"请输入消费金额"
            //    isGift ? @"购买数量" : @"消费金额"
            
        } break;
            
        case ZHShopPayTypeBuyGiftB: {
            
            payNames  = @[@"分润",@"微信支付",@"支付宝"]; //余额(可用100)
            imgs = @[@"zh_pay",@"we_chat",@"alipay"];
            payType = @[@(ZHPayTypeOther),@(ZHPayTypeWeChat),@(ZHPayTypeAlipay)];
            status = @[@(YES),@(NO),@(NO)];
            self.paySceneManager.leftTitleStr = @"购买数量";
            self.paySceneManager.placeholderStr = @"请输入礼品券数量";
            
            //    isGift ? @"请输入礼品券数量" : @"请输入消费金额"
            //    isGift ? @"购买数量" : @"消费金额"
            
        } break;
            
        case ZHShopPayTypeBuyLMB: {
            
            payNames  = @[@"分润",@"微信支付",@"支付宝"]; //余额(可用100)
            imgs = @[@"zh_pay",@"we_chat",@"alipay"];
            payType = @[@(ZHPayTypeOther),@(ZHPayTypeWeChat),@(ZHPayTypeAlipay)];
            status = @[@(YES),@(NO),@(NO)];
            self.paySceneManager.leftTitleStr = @"购买数量";
            self.paySceneManager.placeholderStr = @"请输入联盟券数量";
            
        } break;
            
            
    }

    
    //全部转换为支付模型
    for (NSInteger i = 0; i < imgs.count; i ++) {
        
        ZHPayFuncModel *zhPay = [[ZHPayFuncModel alloc] init];
        zhPay.payImgName = imgs[i];
        zhPay.payName = payNames[i];
        zhPay.isSelected = [status[i] boolValue];
        zhPay.payType = [payType[i] integerValue];
        [self.pays addObject:zhPay];
        
    }
    
    //--//
    self.paySceneManager.isInitiative = YES;
    
    //1.第一组
    ZHPaySceneUIItem *priceItem = [[ZHPaySceneUIItem alloc] init];
    priceItem.headerHeight = 10.0;
    priceItem.footerHeight = 10.0;
    priceItem.rowNum = 1;
    
    //3.支付
    ZHPaySceneUIItem *payFuncItem = [[ZHPaySceneUIItem alloc] init];
    payFuncItem.headerHeight = 30.0;
    payFuncItem.footerHeight = 0.1;
    payFuncItem.rowNum = self.pays.count;
    
    self.paySceneManager.groupItems = @[payFuncItem];
    
    //界面
    [self setUpUI];
    
#pragma mark- 微信支付回调
    [TLWXManager manager].wxPay = ^(BOOL isSuccess,int errorCode){
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (isSuccess) {
                [TLAlert alertWithHUDText:@"支付成功"];
                
                if (self.paySucces) {
                    self.paySucces();
                }
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                
            } else {
                
                [TLAlert alertWithHUDText:@"支付失败"];
                
                
            }
            
        });
        
    };
    
#pragma mark- 支付宝支付回调
    [[TLAlipayManager manager] setPayCallBack:^(BOOL isSuccess, NSDictionary *resultDict){
        
        if (isSuccess) {
            
            [TLAlert alertWithHUDText:@"支付成功"];
            
            if (self.paySucces) {
                self.paySucces();
            }
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            
        } else {
            
            [TLAlert alertWithHUDText:@"支付失败"];
            
        }
        
    }];

}


#pragma mark- 支付
- (void)pay {
    
     __block ZHPayType type;
    [self.pays enumerateObjectsUsingBlock:^(ZHPayFuncModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isSelected) {
            
            type = obj.payType;
            *stop = YES;
        }
        
    }];
    
    
    if (![self.amountTf.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入消费金额"];
        return;
        
    }
    
    NSString *payType;
    switch (type) {
        case ZHPayTypeAlipay: {
            
            payType = kZHAliPayTypeCode;
            
        }
            break;
        case ZHPayTypeWeChat: {
            
            payType = kZHWXTypeCode;
        }
            break;
            
        case ZHPayTypeOther: {
            
            payType = kZHDefaultPayTypeCode;
        }
        break;
            
            
        case ZHPayTypeGiftB: {
            
            payType = kZHGiftPayTypeCode;
            
        }
        break;
            
        case ZHPayTypeLMB : {
        
            payType = kZHLMBPayTypeCode;

        }
            break;

            
    }
    
    //买B
    if(self.shopPayType == ZHShopPayTypeBuyGiftB) {
    
        if (type == ZHPayTypeOther) {
        
            UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:nil message:@"请输入支付密码" preferredStyle:UIAlertControllerStyleAlert];
            [alertCtrl addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                
                textField.secureTextEntry = YES;
                
            }];
            
            [alertCtrl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            
            [alertCtrl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                if (![alertCtrl.textFields[0].text valid]) {
                    
                    [TLAlert alertWithInfo:@"请输入支付密码"];
                    
                } else {
                    
                    [self buyGiftBPayPwd:alertCtrl.textFields[0].text payType:payType];
                    
                }
                
                
            }]];
            
            
            [self presentViewController:alertCtrl animated:YES completion:nil];
        
        } else {
        
            [self buyGiftBPayPwd:nil payType:payType];

        
        }
       
        
        return;
    }
    
    
    if(self.shopPayType == ZHShopPayTypeBuyLMB) {
        
        if (type == ZHPayTypeOther) {
            
            UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:nil message:@"请输入支付密码" preferredStyle:UIAlertControllerStyleAlert];
            [alertCtrl addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                
                textField.secureTextEntry = YES;
                
            }];
            
            [alertCtrl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            
            [alertCtrl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                if (![alertCtrl.textFields[0].text valid]) {
                    
                    [TLAlert alertWithInfo:@"请输入支付密码"];
                    
                } else {
                    
                    [self buyLMBPayPwd:alertCtrl.textFields[0].text payType:payType];
                    
                }
                
                
            }]];
            
            
            [self presentViewController:alertCtrl animated:YES completion:nil];
            
        } else {
            
            [self buyGiftBPayPwd:nil payType:payType];
            
            
        }
        
        
        return;
    }


    //消费
    if (type == ZHPayTypeAlipay || type == ZHPayTypeWeChat ) {
        
        [self shopPay:payType payPwd:nil];
        
        
    } else  {
    
        UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:nil message:@"请输入支付密码" preferredStyle:UIAlertControllerStyleAlert];
        [alertCtrl addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            
            textField.secureTextEntry = YES;
            
        }];
        
        [alertCtrl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [alertCtrl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if (![alertCtrl.textFields[0].text valid]) {
                
                [TLAlert alertWithInfo:@"请输入支付密码"];
                
            } else {
                
                [self shopPay:payType payPwd:alertCtrl.textFields[0].text];
                
            }
            
            
        }]];
        
        
        [self presentViewController:alertCtrl animated:YES completion:nil];

        
        
    }

    
}


#pragma mark- 优店支付, 余额支付需要支付密码
- (void)shopPay:(NSString *)payType payPwd:(nullable NSString *)pwd {
    
        TLNetworking *http = [TLNetworking new];
        http.showView = self.view;
        http.code = @"808241";
        http.parameters[@"userId"] = [ZHUser user].userId;
        http.parameters[@"storeCode"] = self.shop.code;
        http.parameters[@"tradePwd"] = pwd;
        http.parameters[@"amount"] = [self.amountTf.text convertToSysMoney];
        http.parameters[@"token"] = [ZHUser user].token;
        http.parameters[@"payType"] = payType;
    
        [http postWithSuccess:^(id responseObject) {
            
            if ([ZHPayService checkRealNameAuthByResponseObject:responseObject]) {
                
                //需要实名
                [TLAlert alertWithInfo: responseObject[@"errorInfo"] ? : nil];
                ZHRealNameAuthVC *vc = [[ZHRealNameAuthVC alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                
                return;
                
            }
        
            
            if ([payType isEqualToString: kZHWXTypeCode]) {
                
                [self wxPayWithInfo:responseObject[@"data"]];
                
            } else if([payType isEqualToString: kZHAliPayTypeCode]) {
            
                [self aliPayWithInfo:responseObject[@"data"]];
                
            
            } else {
                
                [TLAlert alertWithHUDText:@"支付成功"];
                
                if (self.paySucces) {
                    self.paySucces();
                }
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                
                
                
            }
            
        } failure:^(NSError *error) {
            
            
        }];

}


- (void)aliPayWithInfo:(NSDictionary *)info {

    //支付宝回调
    [TLAlipayManager payWithOrderStr:info[@"signOrder"]];
    
}


- (void)wxPayWithInfo:(NSDictionary *)info {


    NSDictionary *dict = info;
    //调起微信支付
    PayReq* req             = [[PayReq alloc] init];
    req.partnerId           = [dict objectForKey:@"partnerid"];
    req.prepayId            = [dict objectForKey:@"prepayId"];
    req.nonceStr            = [dict objectForKey:@"nonceStr"];
    req.timeStamp           = [[dict objectForKey:@"timeStamp"] intValue];
    req.package             = [dict objectForKey:@"wechatPackage"];
    req.sign                = [dict objectForKey:@"sign"];
    
    if([WXApi sendReq:req]){
    
    } else {
        
        [TLAlert alertWithHUDText:@"支付失败"];
        
    }

}


#pragma mark - tableView代理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    //支持点击整个cell,选择支付方式
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[ZHPayFuncCell class]]) {
       
        //----不是余额把 支付密码隐藏掉----//
        if (self.pays[indexPath.row].isSelected) {
            return;
        }
        
       [[NSNotificationCenter defaultCenter] postNotificationName:@"PAY_TYPE_CHANGE_NOTIFICATION" object:nil userInfo:@{@"sender" : cell}];
   
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}


#pragma mark- 买联盟券最后流程
- (void)buyLMBPayPwd:(NSString *)payPwd payType:(NSString *)payType {


    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"808251";
    http.parameters[@"storeCode"] = self.shop.code;
    http.parameters[@"quantity"] = [self.amountTf.text convertToSysMoney];
    http.parameters[@"payType"] = payType;
    http.parameters[@"tradePwd"] = payPwd;
    http.parameters[@"userId"] = [ZHUser user].userId;
    http.parameters[@"token"] = [ZHUser user].token;
    
    [http postWithSuccess:^(id responseObject) {
        
        
        if ([ZHPayService checkRealNameAuthByResponseObject:responseObject]) {
            
            //需要实名
            [TLAlert alertWithInfo: responseObject[@"errorInfo"] ? : nil];
            ZHRealNameAuthVC *vc = [[ZHRealNameAuthVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            
            return;
            
        }
        
        //
        if ([payType isEqualToString: kZHWXTypeCode]) {
            
            [self wxPayWithInfo:responseObject[@"data"]];
            
        } else if([payType isEqualToString: kZHAliPayTypeCode]) {
            
            [self aliPayWithInfo:responseObject[@"data"]];
            
            
        } else {
            
            [TLAlert alertWithHUDText:@"支付成功"];
            
            if (self.paySucces) {
                self.paySucces();
            }
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            
            
            
        }
        
        
    } failure:^(NSError *error) {
        
        
        
    }];

}


#pragma mark- 买礼品券最后流程
- (void)buyGiftBPayPwd:(NSString *)payPwd payType:(NSString *)payType {


    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"808250";
    http.parameters[@"storeCode"] = self.shop.code;
    http.parameters[@"quantity"] = [self.amountTf.text convertToSysMoney];
    http.parameters[@"payType"] = payType;
    http.parameters[@"tradePwd"] = payPwd;
    http.parameters[@"userId"] = [ZHUser user].userId;
    http.parameters[@"token"] = [ZHUser user].token;

    [http postWithSuccess:^(id responseObject) {
        
        
        if ([ZHPayService checkRealNameAuthByResponseObject:responseObject]) {
            
            //需要实名
            [TLAlert alertWithInfo: responseObject[@"errorInfo"] ? : nil];
            ZHRealNameAuthVC *vc = [[ZHRealNameAuthVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            
            return;
            
        }
        
        //
        if ([payType isEqualToString: kZHWXTypeCode]) {
            
            [self wxPayWithInfo:responseObject[@"data"]];
            
        } else if([payType isEqualToString: kZHAliPayTypeCode]) {
            
            [self aliPayWithInfo:responseObject[@"data"]];
            
            
        } else {
            
            [TLAlert alertWithHUDText:@"支付成功"];
            
            if (self.paySucces) {
                self.paySucces();
            }
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            
            
            
        }

        
    } failure:^(NSError *error) {
        
        
        
    }];



}

//
- (void)setUpUI {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 65)];
    
    BOOL isGift = self.shopPayType == ZHShopPayTypeBuyGiftB;
    
    self.amountTf = [[TLTextField alloc] initWithframe:CGRectMake(0, 10, SCREEN_WIDTH, 45) leftTitle:self.paySceneManager.leftTitleStr   titleWidth:90 placeholder:self.paySceneManager.placeholderStr ];
    

    
    [headerView addSubview:self.amountTf];
    self.amountTf.backgroundColor = [UIColor whiteColor];
    self.amountTf.keyboardType = UIKeyboardTypeDecimalPad;
    [self.amountTf addTarget:self action:@selector(inputChange:) forControlEvents:UIControlEventEditingChanged];

    
    //
    UITableView *payTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49) style:UITableViewStyleGrouped];
    [self.view addSubview:payTableView];
    self.payTableView = payTableView;
    payTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 1)];
    payTableView.rowHeight = 50;
    payTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    payTableView.dataSource = self;
    payTableView.delegate = self;
    
    payTableView.tableHeaderView = headerView;
    
    //底部支付相关
    UIView *payView = [[UIView alloc] initWithFrame:CGRectMake(0, payTableView.yy, SCREEN_WIDTH, 49)];
    payView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:payView];
    self.payView = payView;
    
    //按钮
    UIButton *payBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 0, 100, payView.height) title:@"确认支付" backgroundColor:[UIColor zh_themeColor]];
    [payView addSubview:payBtn];
    payBtn.titleLabel.font = [UIFont secondFont];
    [payBtn addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchUpInside];
    
    //
    UILabel *titleLbl = [UILabel labelWithFrame:CGRectMake(15, 0, 70, payView.height)
                                   textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor whiteColor]
                                           font:[UIFont secondFont]
                                      textColor:[UIColor zh_textColor]];
    [payView addSubview:titleLbl];
    titleLbl.text = @"实际支付:";
    //
    UILabel *payAmountLbl = [UILabel labelWithFrame:CGRectMake(titleLbl.xx + 10, 0, SCREEN_WIDTH - titleLbl.xx - 10 - payBtn.width, payBtn.height)
                                       textAligment:NSTextAlignmentLeft
                                    backgroundColor:[UIColor whiteColor]
                                               font:[UIFont secondFont]
                                          textColor:[UIColor zh_themeColor]];
    [payView addSubview:payAmountLbl];
    payAmountLbl.text = @"";
    payAmountLbl.numberOfLines = 0;
    self.priceLbl = payAmountLbl;

}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    
    return self.paySceneManager.groupItems.count;

}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    ZHPaySceneUIItem *item = self.paySceneManager.groupItems[section];
    return item.footerHeight;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    ZHPaySceneUIItem *item = self.paySceneManager.groupItems[section];
    return item.headerHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    ZHPaySceneUIItem *item = self.paySceneManager.groupItems[section];
    return item.rowNum;
    

}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

        
   return [self payFuncHeaderView];
    
 
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
       static NSString * payFuncCellId = @"ZHPayFuncCell";
       ZHPayFuncCell  *cell = [tableView dequeueReusableCellWithIdentifier:payFuncCellId];
        if (!cell) {
            cell = [[ZHPayFuncCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:payFuncCellId];
        }
        cell.pay = self.pays[indexPath.row];
        
        return cell;
    
}


- (UIView *)payFuncHeaderView {
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    headView.backgroundColor = [UIColor whiteColor];
    
    UILabel *lbl = [UILabel labelWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 35, headView.height)
                              textAligment:NSTextAlignmentLeft
                           backgroundColor:[UIColor clearColor]
                                      font:FONT(12)
                                 textColor:[UIColor zh_textColor]];
    lbl.text = @"支付方式";
    [headView addSubview:lbl];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, headView.height - 0.5, SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = [UIColor zh_lineColor];
    [headView addSubview:lineView];
    
    return headView;
}







@end
