//
//  ZHCouponSelectedVC.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/6.
//  Copyright © 2017年  tianlei. All rights reserved.
//  折扣券选择

#import "TLBaseVC.h"
#import "ZHCoupon.h"

@interface ZHCouponSelectedVC : TLBaseVC

@property (nonatomic,strong) NSMutableArray <ZHCoupon *>*coupons;
@property (nonatomic,copy)  void(^selected)(ZHCoupon *coupon);

@end
