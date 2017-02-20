//
//  ZHLocationManager.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/14.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapLocationKit/AMapLocationKit.h>

@interface ZHLocationManager : NSObject

+ (instancetype)manager;

@property (nonatomic,strong) AMapLocationManager *mapLocationManager;

@property (nonatomic,strong) void (^locationCallBack)(NSError *error,CLLocation *locaton,AMapLocationReGeocode *reGeocode);

//经度---纬度
@property (nonatomic,strong) NSString *longitude;
@property (nonatomic,strong) NSString *latitude;

@end
