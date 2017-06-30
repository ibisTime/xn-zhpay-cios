//
//  ZHCategoryModel.h
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/16.
//  Copyright © 2016年  tianlei. All rights reserved.
//  商品分类的模型

#import "TLBaseModel.h"

@interface ZHCategoryModel : TLBaseModel

@property (nonatomic,copy) NSString *code;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *parentCode; //大类 值为0, 小类为大类的Code

@property (nonatomic,copy) NSString *type;  //1.产品分类 2.产品位置
@property (nonatomic,copy) NSString *systemCode;
@property (nonatomic,copy) NSString *orderNo;

@end
