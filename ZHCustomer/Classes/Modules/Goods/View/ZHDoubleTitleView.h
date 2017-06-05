//
//  ZHDoubleTiitleView.h
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/26.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHDoubleTitleView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

- (instancetype)initWithFrameLayout:(CGRect)frame;



//frame布局计算出来的
//+ (ZHDoubleTitleView *)viewWithFrame:(CGRect)frame;

@property (nonatomic,strong) UILabel* topLbl;
@property (nonatomic,strong) UILabel* bootomLbl;

//@property (nonatomic,strong) CALayer* topLayer;
//@property (nonatomic,strong) CALayer* bootomLbl;

@end
