//
//  ZHOrderGoodsCell.h
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/29.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHGoodsModel.h"
//#import "ZHCartGoodsModel.h"
#import "ZHOrderDetailModel.h"
//#import "ZHTreasureModel.h"
#import "ZHGoodsModel.h"

@class ZHOrderModel;

// 购物清单cell  立刻支付中的cell
//订单cell
@interface ZHOrderGoodsCell : UITableViewCell

@property (nonatomic,strong) ZHGoodsModel *goods;//直接立即购买的界面


//@property (nonatomic,strong) ZHCartGoodsModel *cartGoods;//从购物车进入的

//@property (nonatomic,strong) ZHOrderDetailModel *orderGoods;//从购物清单

@property (nonatomic, strong) ZHOrderModel *order;

@property (nonatomic,copy) void(^comment)(NSString *code);


+ (CGFloat)rowHeight;

@end
