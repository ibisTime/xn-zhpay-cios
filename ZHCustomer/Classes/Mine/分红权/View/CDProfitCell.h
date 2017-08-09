//
//  CDProfitCell.h
//  ZHBusiness
//
//  Created by  tianlei on 2017/5/31.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZHEarningModel;


@interface CDProfitCell : UITableViewCell

@property (nonatomic, strong) ZHEarningModel *earningModel;
@property (nonatomic, assign) BOOL isSimpleUI;

+ (CGFloat)rowHeight;

@end
