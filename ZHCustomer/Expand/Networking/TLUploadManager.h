//
//  TLUploadManager.h
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/16.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "QiniuSDK.h"

@interface TLUploadManager : NSObject

+ (instancetype)manager;

+ (NSString *)imageNameByImage:(UIImage *)img;

- (void)getTokenShowView:(UIView *)showView succes:(void(^)(NSString * token))success
                 failure:(void(^)(NSError *error))failure;

@end
