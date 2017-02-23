//
//  TLGroupModel.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/23.
//  Copyright © 2017年  tianlei. All rights reserved.
//  书写静态tableView界面

#import <Foundation/Foundation.h>
#import "TLCellModel.h"

@interface TLGroupModel : NSObject

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *footerView;

@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, assign) CGFloat footerHeight;

@property (nonatomic, strong) NSMutableArray <TLCellModel *>*cellModelRoom;

@end
