//
//  ZHCartManager.h
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/30.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHCartManager : NSObject

+ (instancetype)manager;

@property (nonatomic,assign) NSInteger count;

- (void)getCount;
- (void)reset;

@end




FOUNDATION_EXTERN NSString *const kShoopingCartCountChangeNotification;
