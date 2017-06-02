//
//  ZHGoodsCategoryManager.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/2.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHCategoryModel.h"

@interface ZHGoodsCategoryManager : NSObject

+ (instancetype)manager;


//- (void)getAllCategory;

//大类名称
//- (void)getBigCategory;

//剁手合集的小类
//- (void)getDSHJCategory;
//- (void)getZeroBuyCategory;


@property (nonatomic,strong) NSArray <ZHCategoryModel *>*bigCategories;

@property (nonatomic,strong) NSArray <ZHCategoryModel *>*dshjCategories;
@property (nonatomic,strong) NSArray <ZHCategoryModel *>*lysgCategories;


@end
