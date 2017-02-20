//
//  ZHLocationManager.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/14.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHLocationManager.h"

@interface ZHLocationManager()<AMapLocationManagerDelegate>


@end

@implementation ZHLocationManager

+ (instancetype)manager {

    static ZHLocationManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       
        manager = [[ZHLocationManager alloc] init];
        manager.mapLocationManager = [[AMapLocationManager alloc] init];
        manager.mapLocationManager.delegate = manager;
        manager.mapLocationManager.distanceFilter = 10.0;
        manager.mapLocationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        
    });
    
    return manager;

}

#pragma mark- 定位成功
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode {

    if (self.locationCallBack) {
        self.locationCallBack(nil,location,reGeocode);
    }
    
    //经度 -- 纬度
    self.longitude = [NSString stringWithFormat:@"%.10f",location.coordinate.longitude];
    self.latitude = [NSString stringWithFormat:@"%.10f",location.coordinate.latitude];
    
}

#pragma mark- 定位失败
- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error {

    if (self.locationCallBack) {
        self.locationCallBack(error,nil,nil);
    }
    
}

- (NSString *)longitude {
    
    if (!_longitude) {
        
        [self.mapLocationManager startUpdatingLocation];
        return nil;
    } else {
        
        return _longitude;
        
    }
    
}


- (NSString *)latitude {
    
    if (!_latitude) {
        
        [self.mapLocationManager startUpdatingLocation];
        return nil;
    } else {
        
        return _latitude;
        
    }
    
}
@end
