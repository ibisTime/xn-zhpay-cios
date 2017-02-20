//
//  ZHDiscountInfoCell.h
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/23.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHDiscountInfoCell : UITableViewCell

+ (CGFloat)rowHeight;

@property (nonatomic,strong) UILabel *mainLbl;
@property (nonatomic,strong) UILabel *subLbl;

@end
