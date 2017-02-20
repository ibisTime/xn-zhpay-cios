//
//  ZHCouponsDetailVC.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/6.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"
#import "ZHCoupon.h"

@interface ZHCouponsDetailVC : TLBaseVC

@property (nonatomic,strong) ZHCoupon *coupon;
@property (nonatomic,assign) BOOL isMine;

@end
