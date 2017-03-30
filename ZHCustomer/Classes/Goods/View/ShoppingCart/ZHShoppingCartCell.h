//
//  ZHShoppingCartCell.h
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/28.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHCartGoodsModel.h"


@interface ZHShoppingCartCell : UITableViewCell

+ (CGFloat)rowHeight;
@property (nonatomic,strong) ZHCartGoodsModel *item;

@property (nonatomic,copy) void(^deleteFromCart)(ZHCartGoodsModel *item);

@end

FOUNDATION_EXTERN NSString *const kSelectedAllCartGoodsNotification;
FOUNDATION_EXTERN NSString *const kSelectedCartGoodsCountChangeNotification;


