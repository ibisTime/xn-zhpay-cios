//
//  UIView+Frame.h
//  OMMO
//
//  Created by 田磊 on 16/4/3.
//  Copyright © 2016年 OMMO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

//终点y
//@property (nonatomic, assign) CGFloat bootom;


/** 终点x */
@property (nonatomic, assign) CGFloat xx;

/** 终点y */  //set为起点不变 增加高度
@property (nonatomic, assign) CGFloat yy;

/** 终点y */  //set为改变起点，size不变
@property (nonatomic, assign) CGFloat yy_size;

/** 终点y */  //set为改变起点，size不变
@property (nonatomic, assign) CGFloat xx_size;

@end
