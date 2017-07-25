//
//  TLLocationService.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/7/25.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLLocationService.h"
#import <CoreLocation/CoreLocation.h>


 NSString * const kLocationServiceFailureNotification = @"kLocationServiceFailureNotification";

NSString * const kLocationServiceSuccessNotification = @"kLocationServiceSuccessNotification";

@interface TLLocationService()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager  *sysLocationManager;
@property (nonatomic, strong) NSDate *lastPostSuccessDate;

@end

@implementation TLLocationService

+ (instancetype)service {

    static TLLocationService *service;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        service = [[TLLocationService alloc] init];
        
    });
    
    return service;
    

}

- (void)startService {

    [self.sysLocationManager startUpdatingLocation];
}


- (CLLocationManager *)locationManager {

    return self.sysLocationManager;
}

- (CLLocationManager *)sysLocationManager {
    
    if (!_sysLocationManager) {
        
        _sysLocationManager = [[CLLocationManager alloc] init];
        _sysLocationManager.delegate = self;
        _sysLocationManager.distanceFilter = 500.0;
        //        [_sysLocationManager requestLocation]; //只定为一次
    }
    
    return _sysLocationManager;
}

//- (void)checkLocation {
//
//    if (self.isSuccess && self) {
//        
//    }
//
//}


- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    
    self.isSuccess =  NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:kLocationServiceFailureNotification object:nil];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    self.isSuccess =  YES;
    

    
    if (!self.lastPostSuccessDate) {
       
        //
        self.lastPostSuccessDate = [NSDate date];
        [[NSNotificationCenter defaultCenter] postNotificationName:kLocationServiceSuccessNotification object:nil];
        return;
    }
    
//    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastPostSuccessDate];
//    if ( timeInterval < 60*2) {
//        
//        return;
//    }
    
    //
    self.lastPostSuccessDate = [NSDate date];
    [[NSNotificationCenter defaultCenter] postNotificationName:kLocationServiceSuccessNotification object:nil];
    
}


@end
