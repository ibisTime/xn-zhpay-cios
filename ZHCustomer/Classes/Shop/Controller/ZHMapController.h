//
//  ZHMapController.h
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/14.
//  Copyright © 2016年  tianlei. All rights reserved.
//  店铺位置的控制器

#import "TLBaseVC.h"
#import <CoreLocation/CoreLocation.h>

@interface ZHMapController : TLBaseVC
@property (nonatomic,copy)  void(^confirm)(CLLocationCoordinate2D point);

//
@property (nonatomic,copy) NSString *shopName;

//外传
@property (nonatomic,assign) CLLocationCoordinate2D point;

@end
