//
//  ZHPayVC.h
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/25.
//  Copyright © 2016年  tianlei. All rights reserved.
//  支付逻辑的控制器

#import "TLBaseVC.h"
#import "ZHShopVC.h"
#import "ZHShop.h"
#import "ZHMonthCardModel.h"
#import "ZHPaySceneManager.h"
#import "ZHHZBModel.h"
#import "ZHTreasureModel.h"
#import "ZHDBModel.h"

typedef NS_ENUM(NSInteger,ZHPayVCType){

    ZHPayVCTypeShop = 0,
    ZHPayVCTypeGoods, //商品购买
    ZHPayVCTypeMonthCard, //福利月卡
    ZHPayVCTypeHZB, //汇赚宝
    ZHPayVCTypeYYDB, //一元夺宝
    ZHPayVCTypeNewYYDB //2.0版本的一元夺宝

};
@interface ZHPayVC : TLBaseVC

//优店支付所需要的模型
@property (nonatomic,strong) ZHShop *shop;
@property (nonatomic,assign) ZHPayVCType type;

//
@property (nonatomic,copy) void(^paySucces)();

//月卡
@property (nonatomic,strong) ZHMonthCardModel *monthCardModel;

//汇赚宝
@property (nonatomic,strong) ZHHZBModel *HZBModel;

//普通商品的订单编号和价格
//订单编号
@property (nonatomic,copy) NSString *orderCode;

@property (nonatomic,copy) NSArray *codeList;


//人民币价格
//各种总金额----富文本
@property (nonatomic,copy) NSAttributedString *amoutAttr;

@property (nonatomic,strong) NSNumber *orderAmount;

//一元夺宝所需要的支付模型
@property (nonatomic,strong) ZHTreasureModel *treasureModel;

//2.0一元夺宝所需要的支付模型
@property (nonatomic,strong) ZHDBModel *dbModel;


@end
