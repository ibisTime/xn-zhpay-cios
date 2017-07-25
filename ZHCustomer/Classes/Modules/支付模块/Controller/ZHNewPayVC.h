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
    ZHPayViewCtrlTypeNewGoods //购物车支付 和 单个商品支付
    
};

@interface ZHNewPayVC : TLBaseVC

//优店支付所需要的模型
@property (nonatomic,assign) ZHPayViewCtrlType type;

//
@property (nonatomic,copy) void(^paySucces)();



/**
 3.4.0以后为    商品为单一币种，分润（人民币）
 */
@property (nonatomic,copy) NSAttributedString *amoutAttr;


/**
 小目标中有效，其它类型支付，该字段无效
 */
@property (nonatomic,strong) NSNumber *rmbAmount;


////2.0 一元夺宝所需要的支付模型
//@property (nonatomic,strong) ZHDBModel *dbModel;

//商品支付
@property (nonatomic, copy) NSArray <NSString *>*goodsCodeList;

/**
 商品购买 显示分润还是余额
 */
@property (nonatomic, assign) BOOL isFRBAndGXZ;


@end
