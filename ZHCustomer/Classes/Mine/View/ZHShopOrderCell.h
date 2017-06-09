//
//  ZHShopOrderCell.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/4.
//  Copyright © 2017年  tianlei. All rights reserved.
//  店铺消费清单

#import <UIKit/UIKit.h>
#import "ZHShopOrderModel.h"

@interface ZHShopOrderCell : UITableViewCell

+ (CGFloat)rowHeight;
@property (nonatomic,strong) ZHShopOrderModel *shopOrderModel;

@end
