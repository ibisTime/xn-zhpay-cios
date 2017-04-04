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
#import "ZHCoupon.h"
#import "ZHCouponSelectedVC.h"
#import "WXApi.h"
#import "ZHPaySceneManager.h"
#import "TLWXManager.h"
#import "ZHCurrencyModel.h"
#import "TLAlipayManager.h"

@interface ZHPayVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong) NSMutableArray <ZHPayFuncModel *>*pays;

@property (nonatomic,strong) UILabel* tempAttrLbl;

@property (nonatomic,strong) TLTextField *amountTf;

@property (nonatomic,strong) ZHPayInfoCell *couponsCell;

//底部总价
@property (nonatomic,strong) UILabel *priceLbl;

@property (nonatomic,strong) ZHPaySceneManager *paySceneManager;

@property (nonatomic,strong) UITableView *payTableView;


@end

@implementation ZHPayVC



#pragma mark- textField--代理

- (void)textFieldDidEndEditing:(UITextField *)textField {

    if (!textField.text && textField.text.length <= 0) {
        
        self.priceLbl.text = @"0";
        return ;
    }
    
    if (self.selectedCoupon) {
        
        if ([textField.text greaterThanOrEqual:self.selectedCoupon.storeTicket.key1]) {
            
            CGFloat value1 = [textField.text floatValue];
            CGFloat value2 = [[self.selectedCoupon.storeTicket.key2 convertToRealMoney] floatValue];
            
            CGFloat num = value1 - value2;
            
            self.priceLbl.text = [NSString stringWithFormat:@"%.2f",num];
            
        } else {
            
            self.priceLbl.text = [NSString stringWithFormat:@"%.2f", [textField.text floatValue]];
            
        }
        
    } else {
        
        self.priceLbl.text = [NSString stringWithFormat:@"%.2f", [textField.text floatValue]];
        
    }
    

}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//
//}


- (void)canclePay {

    [self.navigationController dismissViewControllerAnimated:YES completion:nil];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //--//
    NSArray *imgs = @[@"zh_pay",@"we_chat",@"alipay"];
    NSArray *payNames;
    payNames  = @[@"余额",@"微信支付",@"支付宝"]; //余额(可用100)

    NSArray *payType = @[@(ZHPayTypeOther),@(ZHPayTypeWeChat),@(ZHPayTypeAlipay)];
    NSArray <NSNumber *>*status = @[@(YES),@(NO),@(NO)];
    self.pays = [NSMutableArray array];
    
    NSInteger count = imgs.count;
    
 
    
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
    
    self.paySceneManager.isInitiative = YES;
    
    //1.第一组
    ZHPaySceneUIItem *priceItem = [[ZHPaySceneUIItem alloc] init];
    priceItem.headerHeight = 10.0;
    priceItem.footerHeight = 0.1;
    priceItem.rowNum = 1;
    
    //2.优惠券
    ZHPaySceneUIItem *couponItem = [[ZHPaySceneUIItem alloc] init];
    couponItem.headerHeight = 10.0;
    couponItem.footerHeight = 10.0;
    couponItem.rowNum = 1;
    
    //3.支付
    ZHPaySceneUIItem *payFuncItem = [[ZHPaySceneUIItem alloc] init];
    payFuncItem.headerHeight = 30.0;
    payFuncItem.footerHeight = 0.1;
    payFuncItem.rowNum = self.pays.count;
    
    self.paySceneManager.groupItems = @[priceItem,couponItem,payFuncItem];
    

    
    //界面
    [self setUpUI];

    
    //----//----//
    if (self.navigationController) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(canclePay)];
    }
    
//    self.priceLbl.attributedText = [ZHCurrencyHelper totalPriceAttrWithQBB:@"100" GWB:@"200" RMB:@"300" ];
    
    
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


    
#pragma mark- 除汇赚宝外  获得余额
    //首先获得总额
//    TLNetworking *http2 = [TLNetworking new];
//    http2.code = @"808801";
//    http2.parameters[@"userId"] = [ZHUser user].userId;
//    http2.parameters[@"token"] = [ZHUser user].token;
//    [http2 postWithSuccess:^(id responseObject) {
//        
//      NSNumber *surplusMoney =  responseObject[@"data"];
//      self.pays[0].payName = [NSString stringWithFormat:@"余额(%@)",[surplusMoney convertToRealMoney]];
//      [self.payTableView reloadData];
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
            
            payType = @"3";
            
        }
            break;
        case ZHPayTypeWeChat: {
            
            payType = @"2";
        }
            break;
            
        case ZHPayTypeOther: {
            
            payType = @"1";
        }
            break;
    }

        [self shopPay:payType];

    
}

#pragma mark- 优店支付
- (void)shopPay:(NSString *)payType {

//    if (payType) {
//        <#statements#>
//    }
//    
//    [TLNetworking GET:[TLNetworking ipUrl] parameters:nil success:^(NSString *msg, id data) {
    
        TLNetworking *http = [TLNetworking new];
        http.showView = self.view;
        http.code = @"808241";
        http.parameters[@"userId"] = [ZHUser user].userId;
        http.parameters[@"storeCode"] = self.shop.code;
    
        if (self.selectedCoupon && [self.amountTf.text greaterThanOrEqual:self.selectedCoupon.storeTicket.key1]) {
            
            http.parameters[@"ticketCode"] = self.selectedCoupon.code; //优惠券编号
        }
    
        http.parameters[@"amount"] = [self.amountTf.text convertToSysMoney];
        http.parameters[@"token"] = [ZHUser user].token;
        http.parameters[@"payType"] = payType;
    
        [http postWithSuccess:^(id responseObject) {
            
            
            if ([payType isEqualToString: @"2"]) {
                
                [self wxPayWithInfo:responseObject[@"data"]];
                
            } else if([payType isEqualToString: @"3"]) {
            
                [self aliPayWithInfo:responseObject[@"data"]];
                
            
            } else {
                
                [TLAlert alertWithHUDText:@"支付成功"];
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

    if ( indexPath.section == 1 && self.coupons.count > 0) { //选择折扣券
        
        ZHCouponSelectedVC *selectedVC = [[ZHCouponSelectedVC alloc] init];
        selectedVC.coupons = self.coupons;
        selectedVC.selected = ^(ZHMineCouponModel *coupon) {
        
            self.couponsCell.infoLbl.text = [NSString stringWithFormat:@"满 %@减 %@",[coupon.storeTicket.key1 convertToSimpleRealMoney],[coupon.storeTicket.key2 convertToSimpleRealMoney]];
            self.selectedCoupon = coupon;
            
            //重新计算金额
            if (self.amountTf.text && [self.amountTf.text greaterThanOrEqual:self.selectedCoupon.storeTicket.key1]) {
                
                CGFloat num = [self.amountTf.text floatValue] - [[self.selectedCoupon.storeTicket.key2 convertToRealMoney] floatValue];
                
                self.priceLbl.text = [NSString stringWithFormat:@"%.2f",num];
                
            } else {
            
                self.priceLbl.text = self.amountTf.text;
            }
            
        };
        
        [self.navigationController pushViewController:selectedVC animated:YES];
        
    }
    
    
    //支持点击整个cell,选择支付方式
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[ZHPayFuncCell class]]) {
       
       [[NSNotificationCenter defaultCenter] postNotificationName:@"PAY_TYPE_CHANGE_NOTIFICATION" object:nil userInfo:@{@"sender" : cell}];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

   
}

- (NSMutableArray<ZHMineCouponModel *> *)coupons {

    if (!_coupons) {
        
        _coupons = [[NSMutableArray alloc] init];
    }
    
    return _coupons;
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

        
        if (section == 2) {
            return [self payFuncHeaderView];
        }
        
 
    return nil;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 2) {
        
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

    } else if (indexPath.section == 1 ) {
        
        //
        infoCell.titleLbl.text = @"使用抵扣券";
        if (self.coupons.count > 0) {
        
            infoCell.infoLbl.text = @"请选择折扣券";
            
        } else {
        
            infoCell.infoLbl.text = @"还没有折扣券";

        }
        self.couponsCell = infoCell;
        infoCell.hidenArrow = NO;
    
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



@end
