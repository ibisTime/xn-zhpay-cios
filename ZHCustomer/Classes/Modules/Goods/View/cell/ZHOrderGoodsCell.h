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



/**
 直接立即购买界面,进入传递该模型
 */
@property (nonatomic,strong) ZHGoodsModel *goods;


/**
 从购物清单列表进入传入该模型
 */
@property (nonatomic, strong) ZHOrderModel *order;


@property (nonatomic,copy) void(^comment)(NSString *code);


+ (CGFloat)rowHeight;

@end
