//
//  ZHChatMerchantCell.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/4.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHChatMerchantCell : UITableViewCell

+ (ZHChatMerchantCell *)celllWithTableView:(UITableView *)tableV indexPath:(NSIndexPath *)idx

                                 model:(id)model;
+ (CGFloat)rowHeight;

@end
