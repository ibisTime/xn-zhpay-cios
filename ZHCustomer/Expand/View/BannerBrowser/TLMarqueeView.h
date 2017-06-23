//
//  TLMarqueeView.h
//  paoMaDeng
//
//  Created by  tianlei on 2017/6/22.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLMarqueeView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

- (void)begin;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;


//向数组中加入播放信息就行

@end
