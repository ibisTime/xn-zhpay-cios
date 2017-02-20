//
//  ZHCaptchaView.h
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/12.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHAccountTf.h"
@interface ZHCaptchaView : UIView

@property (nonatomic,strong) ZHAccountTf *captchaTf;
@property (nonatomic,strong) TLTimeButton *captchaBtn;

@end
