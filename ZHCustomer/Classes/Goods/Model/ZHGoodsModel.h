//
//  ZHGoodsModel.h
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/17.
//  Copyright © 2016年  tianlei. All rights reserved.
//  普通商品的模型

#import "TLBaseModal.h"
#import "ZHCurrencyProtocol.h"

@interface ZHGoodsModel : TLBaseModal<ZHCurrencyProtocol>

@property (nonatomic,copy) NSString *advPic; //封面图片
@property (nonatomic,copy) NSString *slogan;
@property (nonatomic,copy) NSString *category;
@property (nonatomic,copy) NSString *code;
@property (nonatomic,copy) NSString *companyCode;
@property (nonatomic,copy) NSString *costPrice;
@property (nonatomic,copy) NSString *location;

@property (nonatomic,copy) NSString *desc;
//@property (nonatomic,copy) NSString *description;

@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSString *pic;

@property (nonatomic,copy) NSString *orderNo;
@property (nonatomic,strong) NSNumber *quantity;
// 0 已提交 1.审批通过 2.审批不通过 3.已上架 4.已下架
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *type;

//由pic1 转化成的 数组,eg: http://wwwa.dfdsf.dcom
@property (nonatomic,copy) NSArray *pics;

//price 1 人民币 price2 购物币，price 3 钱包币

/**
 人民币
 */
@property (nonatomic,strong) NSNumber *price1; //人民币
@property (nonatomic,strong) NSNumber *rmb;
/**
 购物
 */
@property (nonatomic,strong) NSNumber *price2; //购物币
@property (nonatomic,strong) NSNumber *gwb;


/**
 钱宝币
 */
@property (nonatomic,strong) NSNumber *price3; //钱包币
@property (nonatomic,strong) NSNumber *qbb;


//图片高度存储,计算得到
@property (nonatomic,strong) NSArray <NSNumber *>* imgHeights;
- (CGFloat)detailHeight;

//数量
@property (nonatomic,assign) NSInteger count;

/**
 合并后的价格
 */
@property (nonatomic,copy) NSString *totalPrice;


@end
