//
//  ZHGoodsKeyValue.h
//  ZHBusiness
//
//  Created by  tianlei on 2017/4/6.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@interface ZHGoodsKeyValue : TLBaseModel

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *dkey;
@property (nonatomic, copy) NSString *dvalue;
@property (nonatomic, strong) NSNumber *orderNo;

@end
