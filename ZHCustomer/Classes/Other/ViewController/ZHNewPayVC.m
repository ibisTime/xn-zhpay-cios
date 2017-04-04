//
//  ZHNewPayVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/23.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHNewPayVC.h"
#import "ZHPayInfoCell.h"
#import "ZHPayFuncModel.h"
#import "ZHPayFuncCell.h"
#import "ZHCurrencyHelper.h"
#import "WXApi.h"
#import "ZHPaySceneManager.h"
#import "TLWXManager.h"
#import "ZHCurrencyModel.h"
#import "TLGroupModel.h"
#import "TLAlipayManager.h"


#define PAY_TYPE_DEFAULT_PAY_CODE @"1"
#define PAY_TYPE_WX_PAY_CODE @"2"
#define PAY_TYPE_ALI_PAY_CODE @"3"

@interface ZHNewPayVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong) NSMutableArray <ZHPayFuncModel *>*pays;

@property (nonatomic,strong) UILabel* tempAttrLbl;

@property (nonatomic,strong) TLTextField *amountTf;

@property (nonatomic,strong) UILabel *priceLbl;
@property (nonatomic,strong) ZHPaySceneManager *paySceneManager;

@property (nonatomic,strong) UITableView *payTableView;

@end

@implementation ZHNewPayVC

- (void)canclePay {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    {
        TLGroupModel *group0 = [[TLGroupModel alloc] init];
        group0.headerHeight = 10.0;
        group0.footerHeight = 10.0;
        
        TLGroupModel *group1 = [[TLGroupModel alloc] init];
        group1.headerHeight = 30.0;
        group1.footerHeight = 0.1;
        group1.headerView = [self payFuncHeaderView];

        
    }
    
//    if (!self.balanceString) {
//        
//        NSLog(@"请传入余额字符串");
//    }
    
    //--//
    NSArray *imgs ;
    NSArray *payNames;
    if (self.type == ZHPayViewCtrlTypeHZB) {
        
        payNames  = @[self.balanceString,@"微信支付",@"支付宝"]; //余额(可用100)
        imgs = @[@"zh_pay",@"we_chat",@"alipay"];
        
    } else if(self.type == ZHPayViewCtrlTypeNewYYDB) {
    
        payNames  = @[@"余额"]; //余额(可用100)
        imgs = @[@"zh_pay"];
        
    } else {
        
        payNames  = @[@"余额",@"微信支付",@"支付宝"]; //余额(可用100)
        imgs = @[@"zh_pay",@"we_chat",@"alipay"];

        
    }
    
    NSArray *payType = @[@(ZHPayTypeOther),@(ZHPayTypeWeChat),@(ZHPayTypeAlipay)];
    NSArray <NSNumber *>*status = @[@(YES),@(NO),@(NO)];
    self.pays = [NSMutableArray array];
    
    //隐藏掉支付宝
    NSInteger count = payNames.count;
    
    //只有一种支付，
//    if ([self.rmbAmount isEqual:@0]) {
//        
//        count = 1;
//        
//    }
    
    //只创建可以支付的支付方式，， 一元夺宝只有 余额支付 就显示余额
    for (NSInteger i = 0; i < count; i ++) {
        
        ZHPayFuncModel *zhPay = [[ZHPayFuncModel alloc] init];
        zhPay.payImgName = imgs[i];
        zhPay.payName = payNames[i];
        zhPay.isSelected = [status[i] boolValue];
        zhPay.payType = [payType[i] integerValue];
        [self.pays addObject:zhPay];
    }
    
    //--//
    self.paySceneManager = [[ZHPaySceneManager alloc] init];
    switch (self.type) {
            
        case ZHPayViewCtrlTypeHZB: { //购买汇赚宝
            
            self.paySceneManager.isInitiative = NO;
            self.paySceneManager.amount = [self.HZBModel.price convertToSimpleRealMoney];
            //1.第一组
            ZHPaySceneUIItem *priceItem = [[ZHPaySceneUIItem alloc] init];
            priceItem.headerHeight = 10.0;
            priceItem.footerHeight = 10.0;
            priceItem.rowNum = 1;
            
            //2.支付
            ZHPaySceneUIItem *payFuncItem = [[ZHPaySceneUIItem alloc] init];
            payFuncItem.headerHeight = 30.0;
            payFuncItem.footerHeight = 0.1;
            payFuncItem.rowNum = self.pays.count;
            self.paySceneManager.groupItems = @[priceItem,payFuncItem];
            
            //
            if (!self.HZBModel) {
                [TLAlert alertWithHUDText:@"汇赚宝信息呢？"];
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                return;
            }
            [self setUpUI];
            
            self.amountTf.enabled = self.paySceneManager.isInitiative;
            
            if (self.amoutAttr) {
                
                [self.amountTf addSubview:self.tempAttrLbl];
                self.amountTf.placeholder = nil;
                self.tempAttrLbl.attributedText = self.amoutAttr;
                self.priceLbl.attributedText = self.amoutAttr;
                self.amountTf.text = self.paySceneManager.amount;
                self.amountTf.textColor = [UIColor clearColor];
                
            } else {
                
                self.amountTf.text = self.paySceneManager.amount;
                self.priceLbl.text = self.paySceneManager.amount;
                
            }
            
//            self.amountTf.text = self.paySceneManager.amount;
//            self.priceLbl.text = self.paySceneManager.amount;
            
        } break;
            
          case ZHPayViewCtrlTypeNewYYDB: { //2.0版本的一元夺宝
            
            self.paySceneManager.isInitiative = NO;
            self.paySceneManager.amount = [self.rmbAmount convertToSimpleRealMoney];
            
            //1.第一组
            ZHPaySceneUIItem *priceItem = [[ZHPaySceneUIItem alloc] init];
            priceItem.headerHeight = 10.0;
            priceItem.footerHeight = 10.0;
            priceItem.rowNum = 1;
            
            //2.支付
            ZHPaySceneUIItem *payFuncItem = [[ZHPaySceneUIItem alloc] init];
            payFuncItem.headerHeight = 30.0;
            payFuncItem.footerHeight = 0.1;
            payFuncItem.rowNum = self.pays.count;
            self.paySceneManager.groupItems = @[priceItem,payFuncItem];
            [self setUpUI];
            self.amountTf.enabled = self.paySceneManager.isInitiative;
            
            if (self.amoutAttr) {
                
                [self.amountTf addSubview:self.tempAttrLbl];
                self.amountTf.placeholder = nil;
                self.tempAttrLbl.attributedText = self.amoutAttr;
                self.priceLbl.attributedText = self.amoutAttr;
                self.amountTf.text = self.paySceneManager.amount;
                self.amountTf.textColor = [UIColor clearColor];
                
            } else {
                
                self.amountTf.text = self.paySceneManager.amount;
                self.priceLbl.text = self.paySceneManager.amount;
                
            }
            
            
        } break;
            
        case ZHPayViewCtrlTypeNewGoods: { //普通商品支付
            
            self.paySceneManager.isInitiative = NO;
            self.paySceneManager.amount = [self.rmbAmount convertToSimpleRealMoney];
            
            //1.第一组
            ZHPaySceneUIItem *priceItem = [[ZHPaySceneUIItem alloc] init];
            priceItem.headerHeight = 10.0;
            priceItem.footerHeight = 10.0;
            priceItem.rowNum = 1;
            
            //2.支付
            ZHPaySceneUIItem *payFuncItem = [[ZHPaySceneUIItem alloc] init];
            payFuncItem.headerHeight = 30.0;
            payFuncItem.footerHeight = 0.1;
            payFuncItem.rowNum = self.pays.count;
            self.paySceneManager.groupItems = @[priceItem,payFuncItem];
            [self setUpUI];
            self.amountTf.enabled = self.paySceneManager.isInitiative;
            
            if (self.amoutAttr) {
                
                [self.amountTf addSubview:self.tempAttrLbl];
                self.amountTf.placeholder = nil;
                self.tempAttrLbl.attributedText = self.amoutAttr;
                self.priceLbl.attributedText = self.amoutAttr;
                self.amountTf.text = self.paySceneManager.amount;
                self.amountTf.textColor = [UIColor clearColor];
                
            } else {
                
                self.amountTf.text = self.paySceneManager.amount;
                self.priceLbl.text = self.paySceneManager.amount;
                
            }
            
            
        } break;
            
            
        default: [TLAlert alertWithHUDText:@"您还没有选择支付场景"];
            
    }
    
    //----//----//
    if (self.navigationController) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(canclePay)];
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
    
    
#pragma mark- 购买汇赚宝获取分润
//    if (self.type == ZHPayViewCtrlTypeHZB) {
//        TLNetworking *http = [TLNetworking new];
////        http.showView = self.view;
//        http.code = @"802503";
//        http.parameters[@"userId"] = [ZHUser user].userId;
//        http.parameters[@"token"] = [ZHUser user].token;
//        http.parameters[@"currency"] = kFRB;
//        [http postWithSuccess:^(id responseObject) {
//            
//            NSNumber *surplusMoney =  responseObject[@"data"][0][@"amount"];
//            
////            CGFloat rate =  1.0/[responseObject[@"data"][@"rate"] floatValue];
////        
////            
////             self.pays[0].payName = [NSString stringWithFormat:@"分润(%@) (1分润=%@人民币)",[surplusMoney convertToRealMoney],responseObject[@"data"][@"rate"]];
//            
//            self.pays[0].payName = [NSString stringWithFormat:@"分润(%@)",[surplusMoney convertToRealMoney]];
//            [self.payTableView reloadData];
//            
//        } failure:^(NSError *error) {
//            
//        }];
//
//        return;
//    }
    
    
#pragma mark- 获得余额
    //首先获得总额
//    TLNetworking *http2 = [TLNetworking new];
//    http2.code = @"808801";
//    http2.parameters[@"userId"] = [ZHUser user].userId;
//    http2.parameters[@"token"] = [ZHUser user].token;
//    [http2 postWithSuccess:^(id responseObject) {
//        
//        NSNumber *surplusMoney =  responseObject[@"data"];
//        self.pays[0].payName = [NSString stringWithFormat:@"余额(%@)",[surplusMoney convertToRealMoney]];
//        [self.payTableView reloadData];
//        
//        
//    } failure:^(NSError *error) {
//        
//        
//    }];
    
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
        
        [TLAlert alertWithHUDText:@"请输入消费金额"];
        return;
        
    }
    
    NSString *payType;
    switch (type) {
        case ZHPayTypeAlipay: {
            
            payType = PAY_TYPE_ALI_PAY_CODE;
            
        }
            break;
        case ZHPayTypeWeChat: {
            
            payType = PAY_TYPE_WX_PAY_CODE;
        }
            break;
            
        case ZHPayTypeOther: {
            
            payType = PAY_TYPE_DEFAULT_PAY_CODE;
        }
            break;
    }
    
    if(self.type == ZHPayViewCtrlTypeHZB) {
        
        [self hzbPay:payType];
        
    } if (self.type == ZHPayViewCtrlTypeNewYYDB) {
        
        //特殊
        [self newYydbPay:@"9"];
        
    } else if (self.type == ZHPayViewCtrlTypeNewGoods) {
    
        [self goodsPay:payType];
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
        
        [TLAlert alertWithHUDText:@"支付失败"];
        
    }
    
}

- (void)aliPayWithInfo:(NSDictionary *)info {
    
    
    //支付宝回调
    [TLAlipayManager payWithOrderStr:info[@"signOrder"]];
    
    
}

#pragma mark- 2.0新一元夺宝支付
- (void)newYydbPay:(NSString *)payType {
    
//    [TLNetworking GET:[TLNetworking ipUrl] parameters:nil success:^(NSString *msg, id data) {
    
        TLNetworking *http = [TLNetworking new];
        http.showView = self.view;
        http.code = @"615020";
        http.parameters[@"userId"] = [ZHUser user].userId;
        http.parameters[@"jewelCode"] = self.dbModel.code;
        http.parameters[@"times"] = [NSString stringWithFormat:@"%ld",self.dbModel.count];
        http.parameters[@"payType"] = payType;
        //---//
        [http postWithSuccess:^(id responseObject) {
            
//            if ([payType isEqualToString: @"2"]) {
//                
//                [self wxPayWithInfo:responseObject[@"data"]];
//                
//            } else {
//                
//                [TLAlert alertWithHUDText:@"支付成功"];
//                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//                if (self.paySucces) {
//                    self.paySucces();
//                }
//            }
            
            [TLAlert alertWithHUDText:@"支付成功"];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            if (self.paySucces) {
                self.paySucces();
            }
            
            
        } failure:^(NSError *error) {
            
        }];
        
//    } abnormality:nil failure:^(NSError *error) {
//        
//        
//    }];
    
}

- (void)goodsPay:(NSString *)payType {

    if (!self.goodsCodeList) {
        
        NSLog(@"请填写订单信息");
        return;
    }
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"808052";
    http.parameters[@"codeList"] = self.goodsCodeList;
    http.parameters[@"payType"] = payType;
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithHUDText:@"购买成功"];
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
            if (self.paySucces) {
                self.paySucces();
            }
            
        }];
        
    } failure:^(NSError *error) {
        
        
    }];
    

}


#pragma mark- 汇赚宝支付
- (void)hzbPay:(NSString *)payType {
    
//    [TLNetworking GET:[TLNetworking ipUrl] parameters:nil success:^(NSString *msg, id data) {
    
        TLNetworking *http = [TLNetworking new];
        http.showView = self.view;
        http.code = @"615110";
        http.parameters[@"hzbTemplateCode"] = self.HZBModel.code;
        http.parameters[@"payType"] = payType;
        http.parameters[@"token"] = [ZHUser user].token;
        http.parameters[@"userId"] = [ZHUser user].userId;
//        http.parameters[@"ip"] = data[@"ip"];
    
        [http postWithSuccess:^(id responseObject) {
            
            if ([payType isEqualToString:PAY_TYPE_WX_PAY_CODE]) {
                
                [self wxPayWithInfo:responseObject[@"data"]];
                
            } else if([payType isEqualToString:PAY_TYPE_ALI_PAY_CODE]){
            
                [self aliPayWithInfo:responseObject[@"data"]];
            } else {
                
                [TLAlert alertWithHUDText:@"购买成功"];
                [self.navigationController dismissViewControllerAnimated:YES completion:^{
                    
                    if (self.paySucces) {
                        self.paySucces();
                    }
                    
                }];
                
            }
            
        } failure:^(NSError *error) {
            
        }];
        
//    } abnormality:nil failure:^(NSError *error) {
//        
//        
//    }];
    
    
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
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PAY_TYPE_CHANGE_NOTIFICATION" object:nil userInfo:@{@"sender" : cell}];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}


//
- (void)setUpUI {
    
    UITableView *payTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49) style:UITableViewStyleGrouped];
    [self.view addSubview:payTableView];
    self.payTableView = payTableView;
    payTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 1)];
    payTableView.rowHeight = 50;
    payTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    payTableView.dataSource = self;
    payTableView.delegate = self;
    
    //底部支付相关
    UIView *payView = [[UIView alloc] initWithFrame:CGRectMake(0, payTableView.yy, SCREEN_WIDTH, 49)];
    payView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:payView];
    
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
    
    if (section == 1) {
        
       return [self payFuncHeaderView];
        
    }
    
    return nil;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ( indexPath.section == 1) { //支付方式的组
        
        static NSString * payFuncCellId = @"ZHPayFuncCell";
        ZHPayFuncCell  *cell = [tableView dequeueReusableCellWithIdentifier:payFuncCellId];
        if (!cell) {
            cell = [[ZHPayFuncCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:payFuncCellId];
        }
        cell.pay = self.pays[indexPath.row];
        
        return cell;
        
    }
    
    //支付金额-- 和优惠券
    ZHPayInfoCell *infoCell = [tableView dequeueReusableCellWithIdentifier:@"id2"];
    
    if (!infoCell) {
        
        infoCell = [[ZHPayInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id2"];
    }
    if (indexPath.section == 0) {
        
        infoCell.titleLbl.text = @"消费金额";
        infoCell.hidenArrow = YES;
        
        [infoCell addSubview:self.amountTf];
        
    }
    
    return infoCell;
    
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

- (TLTextField *)amountTf {
    
    if (!_amountTf) {
        
        _amountTf = [[TLTextField alloc] initWithFrame:CGRectMake(100, 0, SCREEN_WIDTH - 100, 50)];
        _amountTf.backgroundColor = [UIColor whiteColor];
        _amountTf.placeholder = @"请输入消费金额";
        _amountTf.delegate = self;
        _amountTf.keyboardType = UIKeyboardTypeDecimalPad;
    }
    return _amountTf;
    
}

- (UILabel *)tempAttrLbl {
    
    if (!_tempAttrLbl) {
        
        _tempAttrLbl  = [UILabel  labelWithFrame:CGRectMake(0, 0, self.amountTf.width, self.amountTf.height)
                                    textAligment:NSTextAlignmentLeft
                                 backgroundColor:[UIColor whiteColor]
                                            font:[UIFont secondFont]
                                       textColor:[UIColor zh_themeColor]];
        _tempAttrLbl.backgroundColor = [UIColor whiteColor];
        _tempAttrLbl.numberOfLines = 0;
        
    }
    return _tempAttrLbl;
    
}

@end
