//
//  ZHCoupon.h
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/20.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"
@class ZHShop;

@interface ZHCoupon : TLBaseModel

@property (nonatomic,copy) NSString *code;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,strong) NSNumber *key1; //满足金额
@property (nonatomic,strong) NSNumber *key2; //减免 或者 返现金额
@property (nonatomic,strong) NSNumber *price;

@property (nonatomic,copy) NSString *desc;

@property (nonatomic,copy) NSString *currency; //币种

//@property (nonatomic,strong) ZHShop *store;
//@property (nonatomic,strong) ZHCoupon *storeTicket;


//0. 未使用 1.已经使用 2.过期
@property (nonatomic,copy) NSString *status;//
@property (nonatomic,copy) NSString *storeCode; //店铺编号
@property (nonatomic,copy) NSString *systemCode; //系统编号

@property (nonatomic,copy) NSString *validateStart; //开始时间
@property (nonatomic,copy) NSString *validateEnd; //结束时间

//我的折扣券--查出列表
//@property (nonatomic,copy) NSString *ticketCode;
//@property (nonatomic,strong) NSNumber *ticketKey1;
//@property (nonatomic,strong) NSNumber *ticketKey2;
//@property (nonatomic,strong) NSString *ticketName; //店铺名称


//@property (nonatomic,strong) NSString *ticketCode;
//@property (nonatomic,strong) NSString *ticketCode;

- (NSAttributedString *)discountInfoDescription01IsIng:(BOOL)isIng;

- (NSString *)discountInfoDescription01;
- (NSString *)discountInfoDescription02;


// 店铺折扣券查询，数据结构




@end

