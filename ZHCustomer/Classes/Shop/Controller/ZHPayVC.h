//
//  ZHPayVC.h
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/25.
//  Copyright © 2016年  tianlei. All rights reserved.
//  负责普通商品和优店的支付

#import "TLBaseVC.h"
#import "ZHShopVC.h"
#import "ZHShop.h"
#import "ZHMonthCardModel.h"
#import "ZHPaySceneManager.h"
#import "ZHHZBModel.h"
//#import "ZHTreasureModel.h"
#import "ZHDBModel.h"

//typedef NS_ENUM(NSInteger,ZHPayVCType){
//
////    ZHPayVCTypeShop = 0,
////    ZHPayVCTypeGoods //商品购买
//
//};
@interface ZHPayVC : TLBaseVC

//优店支付所需要的模型
@property (nonatomic,strong) ZHShop *shop;
//@property (nonatomic,assign) ZHPayVCType type;

//
@property (nonatomic,copy) void(^paySucces)();

//月卡
//@property (nonatomic,strong) ZHMonthCardModel *monthCardModel;

//汇赚宝
//@property (nonatomic,strong) ZHHZBModel *HZBModel;

//普通商品的订单编号和价格
//订单编号
//@property (nonatomic,copy) NSString *orderCode;
//@property (nonatomic,copy) NSArray *codeList;


//折扣券
@property (nonatomic,strong) NSMutableArray <ZHCoupon *>*coupons;
@property (nonatomic,strong) ZHCoupon *selectedCoupon;

//人民币价格
//各种总金额----富文本
@property (nonatomic,copy) NSAttributedString *amoutAttr;

@property (nonatomic,strong) NSNumber *orderAmount;

//一元夺宝所需要的支付模型
//@property (nonatomic,strong) ZHTreasureModel *treasureModel;

//2.0一元夺宝所需要的支付模型
//@property (nonatomic,strong) ZHDBModel *dbModel;


@end
