//
//  ZHTreasureInfoView.h
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/27.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHProgressView.h"
#import "ZHDoubleTitleView.h"

@interface ZHTreasureInfoView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

//进度条
@property (nonatomic,strong) ZHProgressView *progress;
@property (nonatomic,strong) ZHDoubleTitleView *peopleView; //人数
//@property (nonatomic,strong) ZHDoubleTitleView *priceView; //单价
@property (nonatomic,strong) ZHDoubleTitleView *dayView; //天数

@end
