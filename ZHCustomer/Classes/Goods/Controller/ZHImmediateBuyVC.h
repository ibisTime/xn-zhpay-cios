//
//  ZHImmediateBuyVC.h
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/27.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"
#import "ZHGoodsModel.h"
#import "ZHCartGoodsModel.h"
#import "ZHTreasureModel.h"

typedef NS_ENUM(NSInteger,ZHIMBuyType){
    
    ZHIMBuyTypeSingle = 0, //单个商品
    ZHIMBuyTypeAll, //购物车商品
    ZHIMBuyTypeYYDB,
    ZHIMBuyTypeYYDBChooseAddress //作为一元夺宝 选择地址界面
    
};

@interface ZHImmediateBuyVC : TLBaseVC

@property (nonatomic,assign) ZHIMBuyType type;

//普通商品
@property (nonatomic,strong) NSArray<ZHGoodsModel *> *goodsRoom;

//购物商品
@property (nonatomic,strong) NSArray<ZHTreasureModel*> *treasureRoom;

//购物车商品
@property (nonatomic,strong) NSArray<ZHCartGoodsModel *> *cartGoodsRoom;

@property (nonatomic,copy) NSAttributedString *priceAttr;

//一元夺宝，
@property (nonatomic,copy) NSString *yydbResCode;

@property (nonatomic,copy) void(^chooseYYDBSuccess)();

@property (nonatomic,copy) void(^placeAnOrderSuccess)();



@end
