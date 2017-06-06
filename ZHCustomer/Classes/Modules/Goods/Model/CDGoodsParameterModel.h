//
//  CDGoodsParameterModel.h
//  ZHBusiness
//
//  Created by  tianlei on 2017/6/4.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@interface CDGoodsParameterModel : TLBaseModel

//已存在的为从服务器获取, 新增的为自己生成
@property (nonatomic, strong) NSString *code;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSNumber *price1;
@property (nonatomic, strong) NSNumber *price2;
@property (nonatomic, strong) NSNumber *price3;

@property (nonatomic, strong) NSNumber *quantity;

@property (nonatomic, strong) NSString *province; //市
@property (nonatomic, strong) NSString *weight; //重量

- (NSDictionary *)toDictionry;

- (NSString *)getDetailText;
- (NSString *)getPrice;
+ (NSString *)randomCode;
- (NSString *)getCountDesc;

//"price1": "1000",
//"price2": "1000",
//"price3": "1000",
//"kuncun": "10",
//"province": "浙江省",
//"weight": "10",
//"orderNo": "1"


@end
