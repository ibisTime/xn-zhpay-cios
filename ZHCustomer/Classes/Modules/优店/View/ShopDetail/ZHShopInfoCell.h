//
//  ZHShopInfoCell.h
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/23.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ShopInfoType) {

    ShopInfoTypeLocation = 0,
    ShopInfoTypeCall,
    ShopInfoTypeGoods

};

@interface ZHShopInfoCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath info:(NSString *)info;

@property (nonatomic,copy) NSString *info;

@property (nonatomic,assign) ShopInfoType infoType;

+ (CGFloat)rowHeight;

@end
