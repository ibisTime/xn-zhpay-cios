//
//  ZHGoodsCategoryVC.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/10.
//  Copyright © 2017年  tianlei. All rights reserved.
//  包含小类 切换的控制器，-- 下面商品列表又是下一级控制器

#import "TLBaseVC.h"
#import "ZHCategoryModel.h"

@interface ZHGoodsCategoryVC : TLBaseVC

@property (nonatomic,strong) NSArray <ZHCategoryModel *>*smallCategories;

@end
