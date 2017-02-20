//
//  ZHUserAvatar.h
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/28.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHUserAvatar : UIView

- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic,strong) UIImageView *avatar;
@property (nonatomic,strong) UILabel  *nameLbl;

@end
