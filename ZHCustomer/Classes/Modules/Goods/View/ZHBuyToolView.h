//
//  ZHBuyToolView.h
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/27.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLMsgBadgeView.h"

typedef NS_ENUM(NSInteger,ZHBuyType){
    
    ZHBuyTypeDefault = 0,
    ZHBuyTypeLookForTreasure
};

@protocol  ZHBuyToolViewDelegate  <NSObject>

- (void)buy;
- (void)chat;
- (void)addToShopCar;
- (void)openShopCar;

@end

@interface ZHBuyToolView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic, weak) id<ZHBuyToolViewDelegate> delegate;

@property (nonatomic, assign) ZHBuyType type;

@property (nonatomic, strong) TLMsgBadgeView *countView;

//价格lbl
@property (nonatomic, strong) UILabel *priceLbl;

//提示客服是否有消息
@property (nonatomic, strong) UIView *kefuMsgHintView;



@end
