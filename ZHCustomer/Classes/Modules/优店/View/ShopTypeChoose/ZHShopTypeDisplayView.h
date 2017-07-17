//
//  ZHShopTypeDisplayView.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/4/1.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHShopTypeDisplayView : UIView

- (instancetype)init;

@end



@interface ZHShopDisplayCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLbl;


@end
