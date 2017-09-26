//
//  AccountBizTypeManager.m
//  ZHBusiness
//
//  Created by  tianlei on 2017/9/26.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "AccountBizTypeManager.h"
#import "TLNetworking.h"
#import "AppConfig.h"

@interface AccountBizTypeManager()

@property (nonatomic, strong) NSMutableDictionary *bizDict;

@end

@implementation AccountBizTypeManager
+ (instancetype)manager {
    
    static AccountBizTypeManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AccountBizTypeManager alloc] init];
        manager.bizDict = [[NSMutableDictionary alloc] init];
    });
    
    return manager;
    
}

- (NSString *)getBizNameByType:(NSString *)type {
    
    if (!type || !self.bizDict) {
        return @"";
    }
    
    return self.bizDict[type] ? self.bizDict[type] : @"";
}

- (void)getDataSuccess:(void(^)())success failure:(void(^)())failure {
    
    if (self.bizDict.allKeys && self.bizDict.allKeys.count > 0) {
        
    }
    TLNetworking *http = [TLNetworking new];
    http.code = @"802006";
    http.parameters[@"systemCode"] = @"CD-CZH000001";
    http.parameters[@"parentKey"] = @"biz_type";
    [http postWithSuccess:^(id responseObject) {
        
        NSArray <NSDictionary *>*arr = responseObject[@"data"];
        [arr enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            _bizDict[obj[@"dkey"]] = obj[@"dvalue"];
            
        }];
        if (success) {
            success();
        }
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure();
        }
    }];

    
}

@end
