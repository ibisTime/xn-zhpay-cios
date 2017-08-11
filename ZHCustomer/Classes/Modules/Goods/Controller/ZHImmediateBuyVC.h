//
//  ZHImmediateBuyVC.h
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/27.
//  Copyright © 2016年  tianlei. All rights reserved.

#import "TLBaseVC.h"
#import "ZHGoodsModel.h"
#import "CDGoodsParameterModel.h"


@interface ZHImmediateBuyVC : TLBaseVC


//普通商品
@property (nonatomic,strong) NSArray<ZHGoodsModel *> *goodsRoom;

@property (nonatomic,copy) void(^placeAnOrderSuccess)();

@end
