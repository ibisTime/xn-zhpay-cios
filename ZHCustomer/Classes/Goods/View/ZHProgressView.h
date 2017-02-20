//
//  ZHProgressView.h
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/26.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHProgressView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic,strong) UIView *forgroundView;
@property (nonatomic,strong) UIView *backgroundView;

@property (nonatomic,assign) CGFloat progress;

@end
