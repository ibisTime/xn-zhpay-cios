//
//  ZHCouponsDetailVC.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/6.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"

//#import "ZHCoupon.h"
#import "ZHMineCouponModel.h"

@interface ZHCouponsDetailVC : TLBaseVC

//商家
@property (nonatomic,strong) ZHCoupon *coupon;

//我的
@property (nonatomic, strong) ZHMineCouponModel *mineCoupon;
//@property (nonatomic,assign) BOOL isMine;

@end
