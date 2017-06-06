//
//  ZHStepView.h
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/27.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ZHStepViewType){
    
    ZHStepViewTypeSimple = 0, //简版
    ZHStepViewTypeDefault //带有数量提示，和包尾按钮
};

@interface ZHStepView : UIView

- (instancetype)initWithFrame:(CGRect)frame type:(ZHStepViewType)type;

//yes  默认无包尾
@property (nonatomic,assign) BOOL isDefault;
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,copy)  void(^countChange)(NSUInteger count);
@property (nonatomic,copy)  void(^buyAllAction)();

//所能达到的最大数量
@property (nonatomic, assign) NSInteger maxCount;
@property (nonatomic,strong) UILabel *hintLbl;


@end
