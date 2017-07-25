//
//  ZHGoodsCategoryManager.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/2.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHGoodsCategoryManager.h"

@implementation ZHGoodsCategoryManager

+ (instancetype)manager {

    static ZHGoodsCategoryManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[ZHGoodsCategoryManager alloc] init];
        //FL201600000000000001 剁手合集
        //FL201600000000000002 一元夺宝
        //FL201600000000000003 零元试购
    });
    
    return manager;

}

- (void)getAllCategory {

    TLNetworking *http = [TLNetworking new];
    http.code = @"808006";
    http.isShowMsg = NO;


    [http postWithSuccess:^(id responseObject) {
        
        NSArray <ZHCategoryModel *>*data = [ZHCategoryModel tl_objectArrayWithDictionaryArray:responseObject[@"data"]] ;
        
        if (data.count == 0) {
            return ;
        }
        NSMutableArray *big = [NSMutableArray array];
        NSMutableArray *dshj = [NSMutableArray array];
        NSMutableArray *zeroBuy = [NSMutableArray array];
        
      


        [data enumerateObjectsUsingBlock:^(ZHCategoryModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            
            
            if ([obj.parentCode isEqualToString:@"0"]) {
                
                [big addObject:obj];
                
            } else if ([obj.parentCode isEqualToString:@"FL201600000000000001"]) {
                [dshj addObject:obj];
            
            } else if ([obj.parentCode isEqualToString:@"FL201600000000000003"]) {
            
                [zeroBuy addObject:obj];
            }
            
        }];
        
        self.bigCategories = big;
        self.dshjCategories = dshj;
        self.lysgCategories = zeroBuy;
        
    } failure:^(NSError *error) {
        
        
        
    }];


}

- (void)getBigCategory {

    TLNetworking *http = [TLNetworking new];
    http.code = @"808006";
    http.isShowMsg = NO;
    http.parameters[@"parentCode"] = @"0";
    [http postWithSuccess:^(id responseObject) {
        
        NSArray *category = responseObject[@"data"];
        
        self.bigCategories = [ZHCategoryModel tl_objectArrayWithDictionaryArray:category];
        
    } failure:^(NSError *error) {
        
        
    }];

}

- (void)getDSHJCategory {

    TLNetworking *http = [TLNetworking new];
    http.code = @"808006";
    http.isShowMsg = NO;
    http.parameters[@"parentCode"] = @"FL201600000000000001";
    [http postWithSuccess:^(id responseObject) {
        
        NSArray *category = responseObject[@"data"];
        
     self.dshjCategories = [ZHCategoryModel tl_objectArrayWithDictionaryArray:category];
        
    } failure:^(NSError *error) {
        
        
    }];

}

- (void)getZeroBuyCategory {
    
    TLNetworking *http = [TLNetworking new];
    http.code = @"808006";
    http.isShowMsg = NO;
    http.parameters[@"parentCode"] = @"FL201600000000000003";
    [http postWithSuccess:^(id responseObject) {
        
        NSArray *category = responseObject[@"data"];
        
        self.lysgCategories = [ZHCategoryModel tl_objectArrayWithDictionaryArray:category];
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

@end
