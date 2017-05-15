//
//  ZHGoSetTradePwdView.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/5/15.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHGoSetTradePwdView : UIView

+ (ZHGoSetTradePwdView *)setTradeView;
@property (nonatomic, copy) void(^goSetTradePwd)();

@end
