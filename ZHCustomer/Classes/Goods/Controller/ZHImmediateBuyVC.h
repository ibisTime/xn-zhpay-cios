//
//  ZHImmediateBuyVC.h
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/27.
//  Copyright © 2016年  tianlei. All rights reserved.
//  单个购买和购物车购买 --- 都会归流到该 --- 控制器

#import "TLBaseVC.h"
#import "ZHGoodsModel.h"
#import "ZHCartGoodsModel.h"

typedef NS_ENUM(NSInteger,ZHIMBuyType){
    
    ZHIMBuyTypeSingle = 0, //单个商品
    ZHIMBuyTypeAll //购物车商品
    
};

@interface ZHImmediateBuyVC : TLBaseVC

@property (nonatomic,assign) ZHIMBuyType type;

//普通商品
@property (nonatomic,strong) NSArray<ZHGoodsModel *> *goodsRoom;

//购物车商品
@property (nonatomic,strong) NSArray<ZHCartGoodsModel *> *cartGoodsRoom;


//购物车专用
@property (nonatomic,copy) NSAttributedString *priceAttr;
@property (nonatomic,copy) NSAttributedString *priceAttrAddPostage;

@property (nonatomic,copy) void(^placeAnOrderSuccess)();

@property (nonatomic, strong) NSNumber *postage;

@end
