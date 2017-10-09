//
//  ZHGoodsModel.h
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/17.
//  Copyright © 2016年  tianlei. All rights reserved.
//  普通商品的模型

#import "TLBaseModel.h"
#import "ZHCurrencyProtocol.h"

#import "CDGoodsParameterModel.h"

//@class CDGoodsParameterModel;
#import "ZHShop.h"

#define RMB_CURRENCY @"2"
#define QBB_CURRENCY @"4"

@interface ZHGoodsModel : TLBaseModel<ZHCurrencyProtocol>

@property (nonatomic,copy) NSString *advPic; //封面图片
@property (nonatomic, strong) NSNumber *boughtCount;
@property (nonatomic,copy) NSString *slogan;
//@property (nonatomic,copy) NSString *category; 大类

@property (nonatomic,copy) NSString *code;
@property (nonatomic,copy) NSString *companyCode;
@property (nonatomic,copy) NSString *costPrice;
@property (nonatomic,copy) NSString *location;

@property (nonatomic,copy) NSString *desc;

@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSString *pic;

@property (nonatomic,copy) NSString *orderNo;
@property (nonatomic,strong) NSNumber *quantity;
// 0 已提交 1.审批通过 2.审批不通过 3.已上架 4.已下架
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *type;
@property (nonatomic, strong) ZHShop *store;

@property (nonatomic, copy) NSString *payCurrency;
@property (nonatomic, copy) NSString *payType;



//由pic1 转化成的 数组,eg: http://wwwa.dfdsf.dcom
@property (nonatomic,copy) NSArray *pics;
@property (nonatomic, copy) NSArray <CDGoodsParameterModel*> *productSpecsList;




//购买选择数量后，设置的数量
@property (nonatomic, assign) NSInteger currentCount;
@property (nonatomic, strong) NSNumber *currentParameterPriceRMB;
//@property (nonatomic, strong) NSNumber *currentParameterPriceQBB;
//@property (nonatomic, strong) NSNumber *currentParameterPriceGWB;
@property (nonatomic, strong) CDGoodsParameterModel *currentParameterModel;


/**
 合并后的价格
 */
//@property (nonatomic,copy,readonly) NSString *totalPrice;



/**
 ￥ 或者 礼品券
 */
- (NSString *)priceUnit;

/**
 展示价格
 */
- (NSString *)displayPriceStr;

/**
 商品
 */
- (NSString *)displayPriceStrCurrentParameter;

//图片高度存储,计算得到
@property (nonatomic,strong) NSArray <NSNumber *>* imgHeights;
- (CGFloat)detailHeight;


/**
 是否为礼品 yes 是
 */
- (BOOL)isGift;


@end
