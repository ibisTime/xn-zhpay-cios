//
//  UIButton+convience.h
//  WeRide
//
//  Created by  tianlei on 2016/12/5.
//  Copyright © 2016年 trek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (convience)

- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state;

- ( instancetype )initWithFrame:(CGRect)frame
                          title:(NSString *)title
                backgroundColor:(UIColor *)color;

+ (UIButton *)zhBtnWithFrame:(CGRect) frame title:(NSString *)title;

+ (UIButton *)borderBtnWithFrame:(CGRect)frame title:(NSString *)title borderColor:(UIColor *)borderColor;

@end
