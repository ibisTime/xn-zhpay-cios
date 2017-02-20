//
//  ZHGoodsCell.h
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/26.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHGoodsModel.h"

@interface ZHGoodsCell : UITableViewCell

@property (nonatomic,strong) ZHGoodsModel *goods;

+ (CGFloat)rowHeight;

@end
