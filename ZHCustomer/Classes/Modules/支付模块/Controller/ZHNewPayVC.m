//
//  ZHNewPayVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/23.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHNewPayVC.h"
#import "ZHPayInfoView.h"
#import "ZHPayFuncModel.h"
#import "ZHPayFuncCell.h"
#import "ZHCurrencyHelper.h"
#import "WXApi.h"
#import "ZHPaySceneManager.h"
#import "TLWXManager.h"
#import "ZHCurrencyModel.h"
#import "TLGroupModel.h"
#import "TLAlipayManager.h"
#import "ZHGoSetTradePwdView.h"
#import "ZHPwdRelatedVC.h"
#import "ZHPayService.h"
#import "ZHRealNameAuthVC.h"

@interface ZHNewPayVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong) NSMutableArray <ZHPayFuncModel *>*pays;
@property (nonatomic,strong) ZHPaySceneManager *paySceneManager;

@property (nonatomic,strong) UITableView *payTableView;
@property (nonatomic, strong) ZHPayInfoView *priceInfoView;

//底部价格
@property (nonatomic, strong) UIView *payView;
@property (nonatomic,strong) UILabel *priceLbl;

@end

@implementation ZHNewPayVC

- (void)canclePay {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"支付";
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //----//----//
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
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    
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
    [pwdAboutVC setSuccess:^{
        
        [self removePlaceholderView];
        [self beginLoad];
        
    }];
    
    [self.navigationController pushViewController:pwdAboutVC animated:YES];
    
}


- (void)beginLoad {

    //--//
    NSArray *imgs ;
    NSArray *payNames;
    NSArray *payType = @[@(ZHPayTypeOther),@(ZHPayTypeWeChat),@(ZHPayTypeAlipay)];
    NSArray <NSNumber *>*status = @[@(YES),@(NO),@(NO)];
    
//    if (self.type == ZHPayViewCtrlTypeHZB) {
//        
//        payNames  = @[@"余额",@"微信支付",@"支付宝"]; //余额(可用100)
//        imgs = @[@"zh_pay",@"we_chat",@"alipay"];
//        
//    } else
    
        
      if(self.type == ZHPayViewCtrlTypeNewYYDB) {
        
        //
        if ([self.rmbAmount isEqual:@0]) { //不是人民币价格
            
            payNames  = @[@"余额"]; //余额(可用100)
            imgs = @[@"zh_pay"];
            
        } else {//人民币价格
            
            payNames  = @[@"余额",@"微信支付",@"支付宝"]; //余额(可用100)
            imgs = @[@"zh_pay",@"we_chat",@"alipay"];
            payType = @[@(ZHPayTypeOther),@(ZHPayTypeWeChat),@(ZHPayTypeAlipay)];
            status = @[@(YES),@(NO),@(NO)];
            
        }
        
        
    } else if(self.type == ZHPayViewCtrlTypeNewGoods) {
        
        if (self.isFRBAndGXZ) {
            
            payNames  = @[@"余额",@"微信支付",@"支付宝"]; //余额(可用100)

        } else {
            
            payNames  = @[@"分润",@"微信支付",@"支付宝"]; //余额(可用100)

        }
        imgs = @[@"zh_pay",@"we_chat",@"alipay"];
        
    }
    
    
    self.pays = [NSMutableArray array];
    
    //隐藏掉支付宝
    NSInteger count = payNames.count;
    
    
    //只创建可以支付的支付方式，， 一元夺宝只有 余额支付 就显示余额
    for (NSInteger i = 0; i < count; i ++) {
        
        ZHPayFuncModel *zhPay = [[ZHPayFuncModel alloc] init];
        zhPay.payImgName = imgs[i];
        zhPay.payName = payNames[i];
        zhPay.isSelected = [status[i] boolValue];
        zhPay.payType = [payType[i] integerValue];
        [self.pays addObject:zhPay];
        
    }
    
    
    //
    self.paySceneManager = [[ZHPaySceneManager alloc] init];
    switch (self.type) {
            
//        case ZHPayViewCtrlTypeHZB: { //购买汇赚宝
//            
//            self.paySceneManager.isInitiative = NO;
//            self.paySceneManager.amount = [self.HZBModel.price convertToSimpleRealMoney];
//
//            //2.支付
//            ZHPaySceneUIItem *payFuncItem = [[ZHPaySceneUIItem alloc] init];
//            payFuncItem.headerHeight = 30.0;
//            payFuncItem.footerHeight = 0.1;
//            payFuncItem.rowNum = self.pays.count;
//            self.paySceneManager.groupItems = @[payFuncItem];
//            
//            //
//            if (!self.HZBModel) {
//                [TLAlert alertWithHUDText:@"汇赚宝信息呢？"];
//                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//                return;
//            }
//            //
//            [self setUpUI];
//            
//            self.priceLbl.text = self.paySceneManager.amount;
//            self.priceInfoView.contentLbl.attributedText = self.amoutAttr;
//
//        } break;
            
        case ZHPayViewCtrlTypeNewYYDB: { //2.0版本的一元夺宝
            
            self.paySceneManager.isInitiative = NO;
            self.paySceneManager.amount = [self.rmbAmount convertToSimpleRealMoney];
     
            
            //2.支付
            ZHPaySceneUIItem *payFuncItem = [[ZHPaySceneUIItem alloc] init];
            payFuncItem.headerHeight = 30.0;
            payFuncItem.footerHeight = 0.1;
            payFuncItem.rowNum = self.pays.count;
            self.paySceneManager.groupItems = @[payFuncItem];
            
            [self setUpUI];
            
            if (self.amoutAttr) {
                
                self.priceLbl.attributedText = self.amoutAttr;
                
            } else {
                
                self.priceLbl.text = self.paySceneManager.amount;
                
            }
            
            self.priceInfoView.contentLbl.attributedText = self.amoutAttr;

            
            
        } break;
            
        case ZHPayViewCtrlTypeNewGoods: { //普通商品支付
            
            self.paySceneManager.isInitiative = NO;

            //2.支付
            ZHPaySceneUIItem *payFuncItem = [[ZHPaySceneUIItem alloc] init];
            payFuncItem.headerHeight = 30.0;
            payFuncItem.footerHeight = 0.1;
            payFuncItem.rowNum = self.pays.count;
            self.paySceneManager.groupItems = @[payFuncItem];
            [self setUpUI];
            
            self.priceLbl.attributedText = self.amoutAttr;
            self.priceInfoView.contentLbl.attributedText = self.amoutAttr;

 
        } break;
            
        default: [TLAlert alertWithHUDText:@"您还没有选择支付场景"];
            
    }

    

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
    }
    
    
    //判断余额还是其它
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
                
                NSString *pwd = alertCtrl.textFields[0].text;
                
//                if(self.type == ZHPayViewCtrlTypeHZB) {
//                    
//                    [self hzbPay:payType payPwd:pwd];
//                    
//                }
                
                if (self.type == ZHPayViewCtrlTypeNewYYDB) {
                    
                    //特殊
                    if (type == ZHPayTypeOther) {
                        [self newYydbPay:payType payPwd:pwd];
                        
                    } else {
                        
                        [self newYydbPay:payType payPwd:pwd];
                        
                    }
                    
                } else if (self.type == ZHPayViewCtrlTypeNewGoods) {
                    
                    [self goodsPay:payType payPwd:pwd];
                }
                

            }
            
            
        }]];
        
        
        [self presentViewController:alertCtrl animated:YES completion:nil];
        
    } else {
    
//        if(self.type == ZHPayViewCtrlTypeHZB) {
//            
//            [self hzbPay:payType payPwd:nil];
//            
//        }
        
        
        if(self.type == ZHPayViewCtrlTypeNewYYDB) {
            
            //特殊
            if (type == ZHPayTypeOther) {
                [self newYydbPay:payType payPwd:nil];
                
            } else {
                
                [self newYydbPay:payType payPwd:nil];
                
            }
            
        } else if (self.type == ZHPayViewCtrlTypeNewGoods) {
            
            [self goodsPay:payType payPwd:nil];
        }


    }

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
        
        [TLAlert alertWithError:@"支付失败"];
        
    }
    
}

- (void)aliPayWithInfo:(NSDictionary *)info {
    
    //支付宝回调
    [TLAlipayManager payWithOrderStr:info[@"signOrder"]];
    
    
}


#pragma mark- 2.0新一元夺宝支付
- (void)newYydbPay:(NSString *)payType  payPwd:(NSString *)pwd{
    
    [TLNetworking GET:[TLNetworking ipUrl] parameters:nil success:^(NSString *msg, id data) {
    
        TLNetworking *http = [TLNetworking new];
        http.showView = self.view;
        //615020
        http.code = @"615021";
        http.parameters[@"userId"] = [ZHUser user].userId;
        http.parameters[@"jewelCode"] = self.dbModel.code;
        http.parameters[@"times"] = [NSString stringWithFormat:@"%ld",self.dbModel.count];
        http.parameters[@"payType"] = payType;
        http.parameters[@"tradePwd"] = pwd;
        http.parameters[@"ip"] = data[@"ip"];
        //---//
        [http postWithSuccess:^(id responseObject) {
            
            if ([payType isEqualToString: kZHWXTypeCode]) {
                
                [self wxPayWithInfo:responseObject[@"data"]];
                
            } else if([payType isEqualToString:kZHAliPayTypeCode]){
            
                [self aliPayWithInfo:responseObject[@"data"]];
                
            } else {
                
                [TLAlert alertWithHUDText:@"支付成功"];
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                if (self.paySucces) {
                    self.paySucces();
                }
            }
            
        } failure:^(NSError *error) {
            
        }];
        
    } abnormality:nil failure:^(NSError *error) {
        
        
    }];
    
}

//尖货支付
- (void)goodsPay:(NSString *)payType payPwd:(NSString *)pwd {

    if (!self.goodsCodeList) {
        
        NSLog(@"请填写订单信息");
        return;
    }
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"808052";
    http.parameters[@"codeList"] = self.goodsCodeList;
    http.parameters[@"payType"] = payType;
    http.parameters[@"tradePwd"] = pwd;
    
    [http postWithSuccess:^(id responseObject) {
        
        if ([ZHPayService checkRealNameAuthByResponseObject:responseObject]) {
            
            //需要实名
            [TLAlert alertWithInfo: responseObject[@"errorInfo"] ? : nil];
            ZHRealNameAuthVC *vc = [[ZHRealNameAuthVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            
            return ;
            
        }
        
        if ([payType isEqualToString:kZHAliPayTypeCode]) {
            
            [self aliPayWithInfo:responseObject[@"data"]];

        } else if([payType isEqualToString:kZHWXTypeCode]) {
        
            [self wxPayWithInfo:responseObject[@"data"]];
            
        } else {
        
            [TLAlert alertWithHUDText:@"购买成功"];
            //
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                
                if (self.paySucces) {
                    self.paySucces();
                }
                
            }];
            
        }
     
        
    } failure:^(NSError *error) {
        
        
    }];
    
}


#pragma mark- 汇赚宝支付
- (void)hzbPay:(NSString *)payType payPwd:(NSString *)pwd {
    
//
//        TLNetworking *http = [TLNetworking new];
//        http.showView = self.view;
//        http.code = @"615110";
//        http.parameters[@"hzbTemplateCode"] = self.HZBModel.code;
//        http.parameters[@"payType"] = payType;
//        http.parameters[@"token"] = [ZHUser user].token;
//        http.parameters[@"userId"] = [ZHUser user].userId;
//        http.parameters[@"tradePwd"] = pwd;
//    
//        [http postWithSuccess:^(id responseObject) {
//            
//            if ([payType isEqualToString:kZHWXTypeCode]) {
//                
//                [self wxPayWithInfo:responseObject[@"data"]];
//                
//            } else if([payType isEqualToString:kZHAliPayTypeCode]){
//            
//                [self aliPayWithInfo:responseObject[@"data"]];
//            } else {
//                
//                [TLAlert alertWithHUDText:@"购买成功"];
//                [self.navigationController dismissViewControllerAnimated:YES completion:^{
//                    
//                    if (self.paySucces) {
//                        self.paySucces();
//                    }
//                    
//                }];
//                
//            }
//            
//        } failure:^(NSError *error) {
//            
//        }];
    
}


#pragma mark - tableView代理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BOOL con1 = self.pays[indexPath.row].payType == ZHPayTypeWeChat;
    BOOL con2 = [WXApi isWXAppInstalled];
    if (con1 && !con2) {
        [TLAlert alertWithHUDText:@"您还未安装微信,不能进行微信支付"];
        return;
    }
    
    //支持点击整个cell,选择支付方式
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[ZHPayFuncCell class]]) {
        
        
        //解决重复点击
        if (self.pays[indexPath.row].isSelected) {
            return;
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PAY_TYPE_CHANGE_NOTIFICATION" object:nil userInfo:@{@"sender" : cell}];
        

    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}


//
- (void)setUpUI {
    
    //
    UITableView *payTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49) style:UITableViewStyleGrouped];
    [self.view addSubview:payTableView];
    self.payTableView = payTableView;
    payTableView.showsVerticalScrollIndicator = NO;
    payTableView.showsHorizontalScrollIndicator = NO;
    payTableView.rowHeight = 50;
    payTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    payTableView.dataSource = self;
    payTableView.delegate = self;
    
    
    //headerView
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    payTableView.tableHeaderView = headerView;
//    headerView.backgroundColor = [UIColor orangeColor];
    
    self.priceInfoView = [[ZHPayInfoView alloc] initWithFrame:CGRectMake(0, -25, SCREEN_WIDTH, 50)];
    [headerView addSubview:self.priceInfoView];
    self.priceInfoView.titleLbl.text = @"消费金额";
    headerView.height = self.priceInfoView.yy + 10;
    
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

#pragma mark- dataSource
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
