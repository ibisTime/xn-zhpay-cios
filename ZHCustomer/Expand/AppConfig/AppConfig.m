//
//  AppConfig.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/12.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "AppConfig.h"

@implementation AppConfig

+ (instancetype)config {

    static dispatch_once_t onceToken;
    static AppConfig *config;
    dispatch_once(&onceToken, ^{
        
        config = [[AppConfig alloc] init];
        
    });

    return config;
}

- (NSString *)pushKey {

    return @"b1f02271d1f6708671c4b002";

}

- (NSString *)aliMapKey {

    return @"a3bd76e7d3689fccd4604861cc83450e";

}

- (NSString *)wxKey {

    return @"wx3eb3d4d796093674";
}


- (NSString *)addr {

    if (self.runEnv == RunEnvDev) {
        
      return @"http://121.43.101.148:5601"; //dev

    } else {
    
      return @"http://139.224.200.54:5601"; //test

    }

    
}

@end
