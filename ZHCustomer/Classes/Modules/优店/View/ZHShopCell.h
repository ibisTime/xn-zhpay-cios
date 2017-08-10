//
//  ZHShopCell.h
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/23.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHShop.h"

@interface ZHShopCell : UITableViewCell

+ (CGFloat)rowHeight;
@property (nonatomic,strong) ZHShop *shop;
@property (nonatomic, assign) BOOL isShowLocation;


@end
