//
//  TLShopingListCategoryVC.h
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/30.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"


typedef NS_ENUM(NSInteger,ZHOrderStatus){
    
    ZHOrderStatusAll = 0, //全部
    ZHOrderStatusWillPay = 1, //待支付支付
    ZHOrderStatusWillSend = 2, //待发货
    ZHOrderStatusDidPay = 3 //已经支付
    
};


@interface ZHShoppingListCategoryVC : TLBaseVC

@property (nonatomic,assign) ZHOrderStatus status;
@property (nonatomic,copy) NSString *statusCode;


@end
