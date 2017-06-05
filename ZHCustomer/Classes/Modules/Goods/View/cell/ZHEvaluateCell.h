//
//  ZHEvaluateCell.h
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/27.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHEvaluateModel.h"

@interface ZHEvaluateCell : UITableViewCell

+ (CGFloat)rowHeight;
@property (nonatomic,strong) ZHEvaluateModel *evaluateModel;

@end
