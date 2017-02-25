//
//  ZHShareView.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/25.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHShareView : UIControl

- (instancetype)init;
- (void)show;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *shareUrl;

@end

//分享时：微信标题，描述，图片规定如下：
//注册页：正汇钱包邀您玩转红包；小目标，发一发，摇一摇，聊一聊各种红包玩法，大胸
//注册页：正汇钱包邀您玩转红包；小目标，发一发，摇一摇，聊一聊各种红包玩法，大胸图片
//目标详情页：小目标大玩法；正汇钱包邀您一元夺宝，大胸图片
//发一发：正汇钱包邀您领红包；千万红包免费领，快来快来快快来；大胸图片
