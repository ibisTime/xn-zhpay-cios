//
//  ZHMineTreasureCell.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/12.
//  Copyright © 2017年  tianlei. All rights reserved.
//  我的夺宝记录cell

#import <UIKit/UIKit.h>
#import "ZHMineTreasureModel.h"

@interface ZHMineTreasureCell : UITableViewCell


@property (nonatomic,strong) ZHMineTreasureModel *mineTreasure;

@property (nonatomic,assign) BOOL isMineGet; //是否是我获得记录


@end
