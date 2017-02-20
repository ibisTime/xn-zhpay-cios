//
//  ZHCartManager.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/30.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHCartManager.h"
#import "ZHCartGoodsModel.h"
 NSString *const kShoopingCartCountChangeNotification = @"zh_kShoopingCartCountChangeNotification";

@implementation ZHCartManager

+ (instancetype)manager {

    static  ZHCartManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[ZHCartManager alloc] init];
        manager.count = 0;
        
    });

    return manager;
    
}

- (void)setCount:(NSInteger)count {

    if (count < 0) {
        _count = 0;
    } else {
    
         _count = count;
    }
   

        [[NSNotificationCenter defaultCenter] postNotificationName:kShoopingCartCountChangeNotification object:nil];    
    
}

- (void)reset {

    self.count = 0;

}

- (void)getCount {

    TLNetworking *http = [TLNetworking new];
    http.isShowMsg = NO;
    http.code = @"808041";
    
    if ([ZHUser user].userId) {
        
        http.parameters[@"userId"] = [ZHUser user].userId;
        http.parameters[@"token"] = [ZHUser user].token;
        [http postWithSuccess:^(id responseObject) {
            
            NSArray *arr = responseObject[@"data"];
            
            NSArray <ZHCartGoodsModel *> *goods = [ZHCartGoodsModel tl_objectArrayWithDictionaryArray:arr];
            
           __block NSInteger totalCount = 0;
            [goods enumerateObjectsUsingBlock:^(ZHCartGoodsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                totalCount  = totalCount + [obj.quantity integerValue];
            }];
            self.count = totalCount;
            
//            [[NSNotificationCenter defaultCenter] postNotificationName:kShoopingCartCountChangeNotification object:nil];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }



}

@end
