//
//  TLUploadManager.m
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/16.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLUploadManager.h"
#import <UIKit/UIKit.h>

@interface TLUploadManager()


//@property (nonatomic,strong) QNUploadManager *qnUploadManager;


@end

@implementation TLUploadManager

//- (QNUploadManager *)qnUploadManager {
//
//    if (!_qnUploadManager) {
//        
//        _qnUploadManager = [[QNUploadManager alloc] init];
//    }
//    
//    return _qnUploadManager;
//
//}

//+ (instancetype)manager {
//
//    static TLUploadManager *manager = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        manager = [[TLUploadManager alloc] init];
//    });
//
//    return manager;
//}
//
//- (void)images:(NSArray *)images {
//
//    
//
//}
//
//- (void)uploadImage:(UIImage *)image success:(void(^)())success failure:(void(^)())failure{
//
//    TLNetworking *getUploadToken = [TLNetworking new];
//    getUploadToken.code = @"807900";
//    getUploadToken.parameters[@"token"] = [ZHUser user].token;
//    [getUploadToken postWithSuccess:^(id responseObject) {
//     //获取token
//        
//        NSData *data = UIImageJPEGRepresentation(image, 1);
//        NSString *imageName = [[self class] imageNameByImage:image];
//        [self.qnUploadManager putData:data key:imageName token:@"" complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
//            
//            if (1) {
//                
//                
//                
//            } else {
//            
//                if (failure) {
//                    failure();
//                }
//            
//            }
//            
//        } option:nil];
//        
//        
//        
//    } failure:^(NSError *error) {
//        
//        if (failure) {
//            failure();
//        }
//        
//    }];
//    
//}
//
//- (void)getTokenShowView:(UIView *)showView succes:(void(^)(NSString * token))success
//                 failure:(void(^)(NSError *error))failure
//{
//
//    TLNetworking *getUploadToken = [TLNetworking new];
//    getUploadToken.showView = showView;
//    getUploadToken.code = @"807900";
//    getUploadToken.parameters[@"token"] = [ZHUser user].token;
//    [getUploadToken postWithSuccess:^(id responseObject) {
//        if (success) {
//            success(responseObject[@"data"][@"uploadToken"]);
//        }
//    } failure:^(NSError *error) {
//        if (failure) {
//            failure(error);
//        }
//    }];
//
//
//}
//

+ (NSString *)imageNameByImage:(UIImage *)img{
    CGSize imgSize = img.size;//
    
    NSDate *now = [NSDate date];
    NSString *timestamp = [NSString stringWithFormat:@"%f",now.timeIntervalSince1970];
    timestamp = [timestamp stringByReplacingOccurrencesOfString:@"." withString:@""];
 
    NSString *imageName = [NSString stringWithFormat:@"IOS_%@_%.0f_%.0f.jpg",timestamp,imgSize.width,imgSize.height];
    
    return imageName;
    
}


@end
