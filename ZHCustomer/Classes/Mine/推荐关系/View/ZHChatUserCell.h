//
//  ZHChatUserCell.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/4.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHReferralModel.h"

@interface ZHChatUserCell : UITableViewCell

+ (ZHChatUserCell *)celllWithTableView:(UITableView *)tableV indexPath:(NSIndexPath *)idx

                                 model:(id)model;
+ (CGFloat)rowHeight;


@property (nonatomic,strong) ZHReferralModel *referral;
@property (nonatomic, copy) NSString *level;

@end
