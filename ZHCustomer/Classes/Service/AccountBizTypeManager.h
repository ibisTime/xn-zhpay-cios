//
//  AccountBizTypeManager.h
//  ZHBusiness
//
//  Created by  tianlei on 2017/9/26.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountBizTypeManager : NSObject

+ (instancetype)manager;

//
- (void)getDataSuccess:(void(^)())success failure:(void(^)())failure;

//
- (NSString *)getBizNameByType:(NSString *)type;
@end
