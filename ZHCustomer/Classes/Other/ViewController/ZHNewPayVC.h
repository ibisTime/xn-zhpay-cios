//
//  ZHNewPayVC.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/23.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"
#import "ZHPaySceneManager.h"
#import "ZHHZBModel.h"
#import "ZHDBModel.h"

typedef NS_ENUM(NSInteger,ZHPayViewCtrlType){
    

    ZHPayViewCtrlTypeHZB = 0, //汇赚宝
    ZHPayViewCtrlTypeNewYYDB, //2.0版本的一元夺宝
    ZHPayViewCtrlTypeNewGoods //购物车支付 和 单个商品支付

    
};

@interface ZHNewPayVC : TLBaseVC

//优店支付所需要的模型
@property (nonatomic,assign) ZHPayViewCtrlType type;

//
@property (nonatomic,copy) void(^paySucces)();

//汇赚宝支付只需传该模型
@property (nonatomic,strong) ZHHZBModel *HZBModel;


//各种总金额----富文本
@property (nonatomic,copy) NSAttributedString *amoutAttr;

//人民币价格
@property (nonatomic,strong) NSNumber *rmbAmount;


//2.0一元夺宝所需要的支付模型
@property (nonatomic,strong) ZHDBModel *dbModel;

//商品支付
@property (nonatomic, copy) NSArray <NSString *>*goodsCodeList;


@end
