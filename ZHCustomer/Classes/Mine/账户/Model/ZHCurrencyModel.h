//
//  ZHCurrencyModel.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/5.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@interface ZHCurrencyModel : TLBaseModel

//分润币 贡献币 FRB GXB
//钱包币 QBB  购物币 GWB
//红包业绩 HBYJ 红包币 HBB
//CNY 人民币
@property (nonatomic,copy) NSString *accountNumber;

@property (nonatomic,strong) NSNumber *amount; //总额

@property (nonatomic,copy) NSString *createDatetime;
@property (nonatomic,copy) NSString *currency;
@property (nonatomic,strong) NSNumber *frozenAmount; //冻结金额
@property (nonatomic,copy) NSString *md5;
@property (nonatomic,copy) NSString *realName;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *systemCode;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *userId;

- (NSString *)getTypeName;
//accountNumber = A2017010321173200113;
//amount = 0;
//createDatetime = "Jan 3, 2017 9:17:32 PM";
//currency = CNY;
//frozenAmount = 0;
//md5 = f0ed31502f5d1f206753a5e8114c87e0;
//realName = 13868074590;
//status = 0;
//systemCode = "CD-CZH000001";
//type = C;
//userId = U2017010321173181049;


@end

FOUNDATION_EXTERN NSString *const kFRB;
FOUNDATION_EXTERN NSString *const kGXB;
FOUNDATION_EXTERN NSString *const kQBB;
FOUNDATION_EXTERN NSString *const kGWB;
FOUNDATION_EXTERN NSString *const kHBYJ;
FOUNDATION_EXTERN NSString *const kHBB;
FOUNDATION_EXTERN NSString *const kCNY;


