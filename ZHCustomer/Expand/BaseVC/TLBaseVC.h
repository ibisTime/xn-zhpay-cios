//
//  TLBaseVC.h
//  WeRide
//
//  Created by  tianlei on 2016/11/25.
//  Copyright © 2016年 trek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLBaseVC : UIViewController

@property (nonatomic,strong) UIView *tl_placeholderView;

- (UIView *)tl_placholderViewWithTitle:(NSString *)title opTitle:(NSString *)opTitle;
- (void)tl_placeholderOperation;

@end
