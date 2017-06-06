//
//  CDGoodsParameterChooseView.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/6/5.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CDGoodsParameterModel;
@class CDGoodsParameterChooseView;

 typedef NS_ENUM(NSUInteger, GoodsParameterChooseType) {
     
    GoodsParameterChooseCancle = 0,
    GoodsParameterChooseConfirm
     
};


@protocol GoodsParameterChooseDelegate <NSObject>

- (void)finishChooseWithType:(GoodsParameterChooseType)type chooseView:(CDGoodsParameterChooseView *)chooseView parameter:(CDGoodsParameterModel *)parameterModel count:(NSInteger)count;

@end

@interface CDGoodsParameterChooseView : UIControl

@property (nonatomic, weak) id<GoodsParameterChooseDelegate> delegate;

+ (instancetype)chooseView;

@property (nonatomic, copy) NSString *coverImageUrl;


- (void)show;
- (void)dismiss;

- (void)loadArr:(NSArray <CDGoodsParameterModel *>*)strArr;

@end
