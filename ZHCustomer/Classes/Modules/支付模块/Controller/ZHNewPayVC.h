//
//  ZHNewPayVC.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/23.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"
#import "ZHPaySceneManager.h"
//#import "ZHDBModel.h"

//正汇系统无人民币概念
typedef NS_ENUM(NSInteger,ZHPayViewCtrlType){
    
    //各种都有
    ZHPayViewCtrlTypeNewGoods = 0,//购物车支付 和 单个商品支付
    
    ZHPayViewCtrlTypeBuyGift//礼品购买
    
};

@interface ZHNewPayVC : TLBaseVC

//优店支付所需要的模型
@property (nonatomic,assign) ZHPayViewCtrlType type;

//
@property (nonatomic,copy) void(^paySucces)();



/**
 3.4.0以后为 商品为单一币种，分润（人民币）
 */
@property (nonatomic, copy) NSString *amoutAttr;
@property (nonatomic, strong) NSNumber *totalPrice;

//商品支付
@property (nonatomic, copy) NSArray <NSString *>*goodsCodeList;

/**
 商品购买 显示分润还是余额
 */
@property (nonatomic, copy) NSString *payCurrency;

//@property (nonatomic, assign) BOOL isFRBAndGXZ;

@end
