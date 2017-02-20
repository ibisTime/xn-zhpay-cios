//
//  TLCaptchaView.m
//  WeRide
//
//  Created by  tianlei on 2016/12/7.
//  Copyright © 2016年 trek. All rights reserved.
//

#import "TLCaptchaView.h"

@implementation TLCaptchaView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUIWith:frame];
        
    }
    return self;
}

- (void)setUpUIWith:(CGRect)frame
{
    
    
    self.captchaTf = [[TLTextField alloc] initWithframe:CGRectMake(0, 0,frame.size.width, frame.size.height)
                                           leftTitle:@"验证码"
                                          titleWidth:90
                                         placeholder:@"请输入验证码"];
    [self addSubview:self.captchaTf];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 95, frame.size.height)];

    //获得验证码按钮
    TLTimeButton *captchaBtn = [[TLTimeButton alloc] initWithFrame:CGRectMake(0, 0, 85, frame.size.height - 15) totalTime:60.0];
    captchaBtn.centerY = rightView.height/2.0;
    self.captchaBtn = captchaBtn;
    captchaBtn.titleLabel.font = [UIFont thirdFont];
    self.captchaTf.keyboardType = UIKeyboardTypeNumberPad;
    captchaBtn.layer.cornerRadius = 4;
    captchaBtn.clipsToBounds = YES;
    captchaBtn.backgroundColor = [UIColor zh_themeColor];
    [captchaBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightView addSubview:captchaBtn];
    
    self.captchaTf.rightView = rightView;

    
    //2.1 添加分割线
//    UIView *sLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2, 20)];
//    sLine.centerY = captchaBtn.centerY;
//    sLine.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
//    [captchaBtn addSubview:sLine];
    
}

@end
