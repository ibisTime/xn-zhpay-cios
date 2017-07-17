//
//  ZHShopListVC.h
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/23.
//  Copyright © 2016年  tianlei. All rights reserved.
//  店铺列表控制器

#import "TLBaseVC.h"

@interface ZHShopListVC : TLBaseVC
@property (nonatomic,copy) NSString *type;

@property (nonatomic, copy) NSString *lon;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *cityName;
@end
