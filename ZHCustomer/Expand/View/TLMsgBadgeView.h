//
//  TLMsgBadgeView.h
//  WeRide
//
//  Created by  tianlei on 2016/12/4.
//  Copyright © 2016年 trek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLMsgBadgeView : UILabel

@property (nonatomic,assign) NSInteger msgCount;
- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic,assign) BOOL isRightResize;
@property (nonatomic,assign) CGFloat padding;


@end
