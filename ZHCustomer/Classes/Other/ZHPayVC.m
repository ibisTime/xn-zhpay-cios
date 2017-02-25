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

@interface ZHPayVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong) NSMutableArray <ZHPayFuncModel *>*pays;

@property (nonatomic,strong) UILabel* tempAttrLbl;

@property (nonatomic,strong) TLTextField *amountTf;
@property (nonatomic,strong) NSMutableArray <ZHCoupon *>*coupons;
@property (nonatomic,strong) ZHPayInfoCell *couponsCell;
@property (nonatomic,strong) ZHCoupon *selectedCoupon;
@property (nonatomic,strong) UILabel *priceLbl;
@property (nonatomic,strong) ZHPaySceneManager *paySceneManager;

@property (nonatomic,strong) UITableView *payTableView;


@end

@implementation ZHPayVC



#pragma mark- textField--代理
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (!textField.text && textField.text.length <= 0) {
        
          self.priceLbl.text = @"0";
        return;
    }
    
    if (self.selectedCoupon) {
        
        if ([textField.text greaterThanOrEqual:self.selectedCoupon.ticketKey1]) {
            
            CGFloat num = [textField.text floatValue] - [[self.selectedCoupon.ticketKey2 convertToRealMoney] floatValue];
            self.priceLbl.text = [NSString stringWithFormat:@"%.2f",num];
            
        } else {
        
           self.priceLbl.text = [NSString stringWithFormat:@"%.2f", [textField.text floatValue]];
        
        }
        
    } else {
    
        self.priceLbl.text = [NSString stringWithFormat:@"%.2f", [textField.text floatValue]];
        
    }
  
}

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
    if (self.type == ZHPayVCTypeHZB) {
        
        payNames  = @[@"分润",@"微信支付",@"支付宝"]; //余额(可用100)

    } else {
    
        payNames  = @[@"余额",@"微信支付",@"支付宝"]; //余额(可用100)

    }
    NSArray *payType = @[@(ZHPayTypeOther),@(ZHPayTypeWeChat),@(ZHPayTypeAlipay)];
    NSArray <NSNumber *>*status = @[@(YES),@(NO),@(NO)];
    self.pays = [NSMutableArray array];
    
    NSInteger count = imgs.count;
    

    
//    if (!self.orderAmount || [self.orderAmount isEqual:@0]) {
//        count = 1;
//    }
    
    if (self.type == ZHPayVCTypeShop || self.type == ZHPayVCTypeHZB || self.type == ZHPayVCTypeMonthCard) {
        //三种支付都有
        
        
    } else {
        
        if ([self.orderAmount isEqual:@0]) {
            
            count = 1;

        }
    
    }
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
//        case ZHPayVCTypeShop: { //店铺消费
//        
//            self.paySceneManager.isInitiative = YES;
//            
//            //1.第一组
//            ZHPaySceneUIItem *priceItem = [[ZHPaySceneUIItem alloc] init];
//            priceItem.headerHeight = 10.0;
//            priceItem.footerHeight = 0.1;
//            priceItem.rowNum = 1;
//            
//            //2.优惠券
//            ZHPaySceneUIItem *couponItem = [[ZHPaySceneUIItem alloc] init];
//            couponItem.headerHeight = 10.0;
//            couponItem.footerHeight = 10.0;
//            couponItem.rowNum = 1;
//            
//            //3.支付
//            ZHPaySceneUIItem *payFuncItem = [[ZHPaySceneUIItem alloc] init];
//            payFuncItem.headerHeight = 30.0;
//            payFuncItem.footerHeight = 0.1;
//            payFuncItem.rowNum = self.pays.count;
//            
//            self.paySceneManager.groupItems = @[priceItem,couponItem,payFuncItem];
//        
//        } break;
            
//        case ZHPayVCTypeMonthCard: { //月卡
//            
//            self.paySceneManager.isInitiative = NO;
//            self.paySceneManager.amount = [self.monthCardModel.price convertToSimpleRealMoney];
//            //1.第一组
//            ZHPaySceneUIItem *priceItem = [[ZHPaySceneUIItem alloc] init];
//            priceItem.headerHeight = 10.0;
//            priceItem.footerHeight = 10.0;
//            priceItem.rowNum = 1;
//            
//            //2.支付
//            ZHPaySceneUIItem *payFuncItem = [[ZHPaySceneUIItem alloc] init];
//            payFuncItem.headerHeight = 30.0;
//            payFuncItem.footerHeight = 0.1;
//            payFuncItem.rowNum = self.pays.count;
//            
//            self.paySceneManager.groupItems = @[priceItem,payFuncItem];
//
//            //
//            if (!self.monthCardModel) {
//                [TLAlert alertWithHUDText:@"月卡信息呢？"];
//                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//                return;
//            }
//            [self setUpUI];
//            self.priceLbl.text = [self.monthCardModel.price convertToSimpleRealMoney];
//            self.amountTf.enabled = self.paySceneManager.isInitiative;
//            
//           self.amountTf.text = [self.monthCardModel.price convertToSimpleRealMoney];
//        
//            
//            
//        } break;
        
        case ZHPayVCTypeHZB: { //购买汇赚宝
            
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
            self.amountTf.text = self.paySceneManager.amount;
            self.priceLbl.text = self.paySceneManager.amount;

        } break;
            
//        case ZHPayVCTypeGoods: { //商品消费
//            
//            if (!self.orderAmount) {
//                [TLAlert alertWithHUDText:@"无法确定订单信息"];
//                return;
//            }
//            
//            self.paySceneManager.isInitiative = NO;
//            self.paySceneManager.amount = [self.orderAmount convertToSimpleRealMoney];
//            
//            //1.第一组
//            ZHPaySceneUIItem *priceItem = [[ZHPaySceneUIItem alloc] init];
//            priceItem.headerHeight = 10.0;
//            priceItem.footerHeight = 10.0;
//            priceItem.rowNum = 1;
//            
//            //2.支付
//            ZHPaySceneUIItem *payFuncItem = [[ZHPaySceneUIItem alloc] init];
//            payFuncItem.headerHeight = 30.0;
//            payFuncItem.footerHeight = 0.1;
//            payFuncItem.rowNum = self.pays.count;
//            self.paySceneManager.groupItems = @[priceItem,payFuncItem];
//            [self setUpUI];
//            self.amountTf.enabled = self.paySceneManager.isInitiative;
//            
//            if (self.amoutAttr) {
//                
////                self.amountTf.attributedText = self.amoutAttr;
//                [self.amountTf addSubview:self.tempAttrLbl];
//                self.amountTf.placeholder = nil;
////                [self.amountTf bringSubviewToFront:self.tempAttrLbl];
//                self.tempAttrLbl.attributedText = self.amoutAttr;
//                self.priceLbl.attributedText = self.amoutAttr;
//                self.amountTf.text = self.paySceneManager.amount;
//                self.amountTf.textColor = [UIColor clearColor];
//
//
//            } else {
//                
//                self.amountTf.text = self.paySceneManager.amount;
//                self.priceLbl.text = self.paySceneManager.amount;
//        
//            }
//            
//
//        } break;
            
//        case ZHPayVCTypeYYDB: {
//            
//            
//            self.paySceneManager.isInitiative = NO;
//            self.paySceneManager.amount = [self.orderAmount convertToSimpleRealMoney];
//            
//            //1.第一组
//            ZHPaySceneUIItem *priceItem = [[ZHPaySceneUIItem alloc] init];
//            priceItem.headerHeight = 10.0;
//            priceItem.footerHeight = 10.0;
//            priceItem.rowNum = 1;
//            
//            //2.支付
//            ZHPaySceneUIItem *payFuncItem = [[ZHPaySceneUIItem alloc] init];
//            payFuncItem.headerHeight = 30.0;
//            payFuncItem.footerHeight = 0.1;
//            payFuncItem.rowNum = self.pays.count;
//            self.paySceneManager.groupItems = @[priceItem,payFuncItem];
//            [self setUpUI];
//            self.amountTf.enabled = self.paySceneManager.isInitiative;
//            
//            
//            if (self.amoutAttr) {
//                [self.amountTf addSubview:self.tempAttrLbl];
////                [self.amountTf bringSubviewToFront:self.tempAttrLbl];
//
//                //self.amountTf.attributedText = self.amoutAttr;
//                self.amountTf.placeholder = nil;
//                self.tempAttrLbl.attributedText = self.amoutAttr;
//                self.priceLbl.attributedText = self.amoutAttr;
//                self.amountTf.text = self.paySceneManager.amount;
//                self.amountTf.textColor = [UIColor clearColor];
//
//                
//            } else {
//                
//                self.amountTf.text = self.paySceneManager.amount;
//                self.priceLbl.text = self.paySceneManager.amount;
//                
//
//            }
//
//        } break;
            
        case ZHPayVCTypeNewYYDB: { //2.0版本的一元夺宝
            
            
            self.paySceneManager.isInitiative = NO;
            self.paySceneManager.amount = [self.orderAmount convertToSimpleRealMoney];
            
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
                //                [self.amountTf bringSubviewToFront:self.tempAttrLbl];
                
                //self.amountTf.attributedText = self.amoutAttr;
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
    
    
    if (self.type == ZHPayVCTypeShop) { //优店
        
        //查询折扣券
        //0 未使用 1.已使用 2.已过期
        //  isExist用户是否拥有此折扣券 ，1代表有了，0 没有
        TLNetworking *http = [TLNetworking new];
        http.showView = self.view;
        http.code = @"808228";
        http.parameters[@"userId"] = [ZHUser user].userId;
        http.parameters[@"status"] = @"0";
        http.parameters[@"start"] = @"1";
        http.parameters[@"limit"] = @"1000";
        http.parameters[@"storeCode"] = self.shop.code;
        http.parameters[@"token"] = [ZHUser user].token;
        [http postWithSuccess:^(id responseObject) {
            
            self.coupons = [ZHCoupon tl_objectArrayWithDictionaryArray:responseObject[@"data"][@"list"]];
            
            if (self.coupons.count > 0) {
                self.selectedCoupon = self.coupons[0];
            }
            [self setUpUI];
            
        } failure:^(NSError *error) {
            
            
        }];
        
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
    
#pragma mark- 购买汇赚宝获取分润
    if (self.type == ZHPayVCTypeHZB) {
        
        TLNetworking *http = [TLNetworking new];
        //        http.showView = self.view;
        http.code = @"802503";
        http.parameters[@"token"] = [ZHUser user].token;
        http.parameters[@"userId"] = [ZHUser user].userId;
        http.parameters[@"currency"] = kFRB;
        [http postWithSuccess:^(id responseObject) {
            
            NSNumber *surplusMoney =  responseObject[@"data"][0][@"amount"];
            self.pays[0].payName = [NSString stringWithFormat:@"分润(%@)",[surplusMoney convertToRealMoney]];
            [self.payTableView reloadData];
            
        } failure:^(NSError *error) {
            
            
            
        }];
        
        return;
    }

    
#pragma mark- 除汇赚宝外  获得余额
    //首先获得总额
    TLNetworking *http2 = [TLNetworking new];
    http2.code = @"808801";
    http2.parameters[@"userId"] = [ZHUser user].userId;
    http2.parameters[@"token"] = [ZHUser user].token;
    [http2 postWithSuccess:^(id responseObject) {
        
      NSNumber *surplusMoney =  responseObject[@"data"];
      self.pays[0].payName = [NSString stringWithFormat:@"余额(%@)",[surplusMoney convertToRealMoney]];
      [self.payTableView reloadData];
        
        
    } failure:^(NSError *error) {
        
        
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

    if(self.type == ZHPayVCTypeHZB) {
        
        [self hzbPay:payType];
        
    } if (self.type == ZHPayVCTypeNewYYDB) {
        
        [self newYydbPay:payType];
        
    }
    
//    if (self.type == ZHPayVCTypeShop) {
//        
////        [self shopPay:payType];
//        
//    } else if(self.type == ZHPayVCTypeMonthCard) {
//    
////        [self monthCardPay:payType];
//    
//    } else if(self.type == ZHPayVCTypeHZB) {
//    
//        [self hzbPay:payType];
//        
//    } else if (self.type == ZHPayVCTypeGoods) {
//    
////        [self goodsPay:payType];
//        
//    } else if (self.type == ZHPayVCTypeYYDB) {
//    
////        [self yydbPay:payType];
//    } else if (self.type == ZHPayVCTypeNewYYDB) {
//    
//        [self newYydbPay:payType];
//
//    
//    }
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

#pragma mark- 2.0新一元夺宝支付
- (void)newYydbPay:(NSString *)payType {

    [TLNetworking GET:[TLNetworking ipUrl] parameters:nil success:^(NSString *msg, id data) {
        
        TLNetworking *http = [TLNetworking new];
        http.showView = self.view;
        http.code = @"808303";
        http.parameters[@"userId"] = [ZHUser user].userId;
        http.parameters[@"jewelCode"] = self.dbModel.code;
        http.parameters[@"times"] = [NSString stringWithFormat:@"%ld",self.dbModel.count];
        http.parameters[@"payType"] = payType;
        http.parameters[@"ip"] = data[@"ip"];
        
        //---//
        [http postWithSuccess:^(id responseObject) {
            
            if ([payType isEqualToString: @"2"]) {
                
                [self wxPayWithInfo:responseObject[@"data"]];
                
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

#pragma mark- 一元夺宝支付
//- (void)yydbPay:(NSString *)payType {
//
//    [TLNetworking GET:[TLNetworking ipUrl] parameters:nil success:^(NSString *msg, id data) {
//        
//        TLNetworking *http = [TLNetworking new];
//        http.showView = self.view;
//        http.code = @"808303";
//        http.parameters[@"userId"] = [ZHUser user].userId;
//        http.parameters[@"jewelCode"] = self.treasureModel.code;
//        http.parameters[@"times"] = [NSString stringWithFormat:@"%ld",self.treasureModel.count];
//        http.parameters[@"payType"] = payType;
//        http.parameters[@"ip"] = data[@"ip"];
//
//        //---//
//        [http postWithSuccess:^(id responseObject) {
//            
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
//            
//            
//            
//        } failure:^(NSError *error) {
//            
//        }];
//
//        
//        
//    } abnormality:nil failure:^(NSError *error) {
//        
//    }];
//   
//
//}


#pragma mark- 普通商品支付
//- (void)goodsPay:(NSString *)payType {
//
//    [TLNetworking GET:[TLNetworking ipUrl] parameters:nil success:^(NSString *msg, id data) {
//        
//        if (self.codeList) { //购物车批量购买
//            
//            TLNetworking *http = [TLNetworking new];
//            http.showView = self.view;
//            http.code = @"808060";
//            http.parameters[@"codeList"] = self.codeList;
//            http.parameters[@"payType"] = payType;
//            http.parameters[@"ip"] = data[@"ip"];
//            http.parameters[@"token"] = [ZHUser user].token;
//            http.parameters[@"applyUser"] = [ZHUser user].userId;
//
//        
//            [http postWithSuccess:^(id responseObject) {
//                
//                if ([payType isEqualToString: @"2"]) {
//                    
//                    [self wxPayWithInfo:responseObject[@"data"]];
//                    
//                } else {
//                    
//                    [TLAlert alertWithHUDText:@"支付成功"];
//                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//                    if (self.paySucces) {
//                        self.paySucces();
//                    }
//                }
//                
//            } failure:^(NSError *error) {
//                
//                
//            }];
//            
//            return;
//        }
//        
//        //单个商品购买
//        TLNetworking *http = [TLNetworking new];
//        http.showView = self.view;
////        http.code = @"808052";
//        http.code = @"808059";
//        http.parameters[@"payType"] = payType;
//        http.parameters[@"code"] = self.orderCode;
//        http.parameters[@"token"] = [ZHUser user].token;
//        http.parameters[@"ip"] = data[@"ip"];
//
//        [http postWithSuccess:^(id responseObject) {
//            
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
// 
//        } failure:^(NSError *error) {
//            
//            
//        }];
//
//    } abnormality:^{
//       
//        
//    } failure:^(NSError *error) {
//        
//        [TLAlert alertWithHUDText:@"获取支付信息失败"];
//        
//    }];
//    
//}

#pragma mark- 汇赚宝支付
- (void)hzbPay:(NSString *)payType {
    
    
    [TLNetworking GET:[TLNetworking ipUrl] parameters:nil success:^(NSString *msg, id data) {
        
        TLNetworking *http = [TLNetworking new];
        http.showView = self.view;
        http.code = @"808452";
        http.parameters[@"hzbCode"] = self.HZBModel.code;
        http.parameters[@"payType"] = payType;
        http.parameters[@"token"] = [ZHUser user].token;
        http.parameters[@"userId"] = [ZHUser user].userId;
        http.parameters[@"ip"] = data[@"ip"];
        
        [http postWithSuccess:^(id responseObject) {
            
            if ([payType isEqualToString:@"2"]) {
                
                [self wxPayWithInfo:responseObject[@"data"]];
                
            } else {
                
                [TLAlert alertWithHUDText:@"购买成功,等待激活"];
                [self.navigationController dismissViewControllerAnimated:YES completion:^{
                    
                    if (self.paySucces) {
                        self.paySucces();
                    }
                    
                }];
                
            }
            
            
        } failure:^(NSError *error) {
            
        }];
        
    } abnormality:nil failure:^(NSError *error) {
        
    }];
    
}




#pragma mark - tableView代理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (self.type == ZHPayVCTypeShop && indexPath.section == 1 && self.coupons.count > 0) { //选择折扣券
        
        ZHCouponSelectedVC *selectedVC = [[ZHCouponSelectedVC alloc] init];
        selectedVC.coupons = self.coupons;
        selectedVC.selected = ^(ZHCoupon *coupon) {
        
            self.couponsCell.infoLbl.text = [NSString stringWithFormat:@"满 %@ 减 %@",[coupon.ticketKey1 convertToRealMoney],[coupon.ticketKey2 convertToRealMoney]];
            self.selectedCoupon = coupon;
            
            //重新计算金额
            if (self.amountTf.text && [self.amountTf.text greaterThanOrEqual:self.selectedCoupon.ticketKey1]) {
                
                CGFloat num = [self.amountTf.text floatValue] - [[self.selectedCoupon.ticketKey2 convertToRealMoney] floatValue];
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

    if (self.type == ZHPayVCTypeShop) {
        
        if (section == 2) {
            return [self payFuncHeaderView];
        }
        
    } else {
        
        if (section == 1) {
            return [self payFuncHeaderView];
        }
        
    }
 
    return nil;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if ((self.type == ZHPayVCTypeShop && indexPath.section == 2) || (self.type != ZHPayVCTypeShop && indexPath.section == 1)) {
        
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

    } else if (indexPath.section == 1 && self.type == ZHPayVCTypeShop) {
        
        //
        infoCell.titleLbl.text = @"使用抵扣券";
        if (self.coupons.count > 0) {
            
            infoCell.infoLbl.text =  [NSString stringWithFormat:@"满 %@ 减 %@",[self.coupons[0].ticketKey1 convertToSimpleRealMoney],[self.coupons[0].ticketKey2 convertToSimpleRealMoney]];
            
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


#pragma mark- 优店支付
//- (void)shopPay:(NSString *)payType {
//
//    [TLNetworking GET:[TLNetworking ipUrl] parameters:nil success:^(NSString *msg, id data) {
//
//        TLNetworking *http = [TLNetworking new];
//        http.showView = self.view;
//        http.code = @"808210";
//        http.parameters[@"userId"] = [ZHUser user].userId;
//        http.parameters[@"storeCode"] = self.shop.code;
//        if (self.selectedCoupon && [self.amountTf.text greaterThanOrEqual:self.selectedCoupon.ticketKey1]) {
//
//            http.parameters[@"ticketCode"] = self.selectedCoupon.code; //优惠券编号
//        }
//
//        http.parameters[@"amount"] = [self.amountTf.text convertToSysMoney];
//        http.parameters[@"token"] = [ZHUser user].token;
//        http.parameters[@"ip"] = data[@"ip"];
//        http.parameters[@"payType"] = payType;
//
////        payType = http.parameters[@"payType"];
//
//        [http postWithSuccess:^(id responseObject) {
//
//
//            if ([payType isEqualToString: @"2"]) {
//
//                [self wxPayWithInfo:responseObject[@"data"]];
//
//            } else {
//
//                [TLAlert alertWithHUDText:@"支付成功"];
//                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//            }
//
//        } failure:^(NSError *error) {
//
//        }];
//
//    } abnormality:nil failure:^(NSError *error) {
//
//
//    }];
//
//}


#pragma mark-- 月卡
//- (void)monthCardPay:(NSString *)payType {
//
////    @"http://121.43.101.148:5601/forward-service/ip"
//  [TLNetworking GET:[TLNetworking ipUrl] parameters:nil success:^(NSString *msg, id data) {
//
//      TLNetworking *http = [TLNetworking new];
//      http.showView = self.view;
//      http.code = @"808403";
//      http.parameters[@"code"] = self.monthCardModel.code;
//      http.parameters[@"userId"] = [ZHUser user].userId;
//      http.parameters[@"token"] = [ZHUser user].token;
//      //1.内部 2.微信 3.支付宝
//      http.parameters[@"payType"] = payType;
//
//      if ([payType isEqualToString: @"2"]) {
//
//          http.parameters[@"ip"] = data[@"ip"];
//
//      }
//
//      [http postWithSuccess:^(id responseObject) {
//
//          if ([payType isEqualToString: @"2"]) {
//
//              [self wxPayWithInfo:responseObject[@"data"]];
//
//          } else {
//
//              [TLAlert alertWithHUDText:@"购买月卡成功"];
//
//              [self.navigationController dismissViewControllerAnimated:YES completion:^{
//
//                  if (self.paySucces) {
//                      self.paySucces();
//                  }
//
//              }];
//
//          }
//
//
//
//      } failure:^(NSError *error) {
//
//
//      }];
//
//
//  } abnormality:nil failure:^(NSError *error) {
//
//  }];
//
//
//}

@end