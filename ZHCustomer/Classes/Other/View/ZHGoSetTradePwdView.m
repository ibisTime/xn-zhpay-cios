//
//  ZHGoSetTradePwdView.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/5/15.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHGoSetTradePwdView.h"

@implementation ZHGoSetTradePwdView

+ (ZHGoSetTradePwdView *)setTradeView {

    return [[ZHGoSetTradePwdView alloc] init];

}

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 50)];
    if (self) {
        
        //
        UILabel *hintLbl = [UILabel labelWithFrame:CGRectMake(0, 0, self.width, 40)
                                       textAligment:NSTextAlignmentCenter
                                    backgroundColor:[UIColor clearColor]
                                               font:FONT(14)
                                          textColor:[UIColor zh_textColor]];
                             
        [self addSubview:hintLbl];
        hintLbl.text = @"您还未设置支付密码";
        
        //btn
        UIButton *goBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, hintLbl.yy, 250, 40)];
        goBtn.centerX = self.width/2.0;
        [goBtn setTitle:@"前往设置" forState:UIControlStateNormal];
        [goBtn setTitleColor:[UIColor zh_themeColor] forState:UIControlStateNormal];
        [self addSubview:goBtn];
        goBtn.layer.borderColor = [UIColor zh_themeColor].CGColor;
        goBtn.titleLabel.font = FONT(14);
        goBtn.layer.borderWidth = 1;
        goBtn.layer.cornerRadius = 5;
        goBtn.layer.masksToBounds = YES;
        
        [goBtn addTarget:self action:@selector(goAction) forControlEvents:UIControlEventTouchUpInside];
        //
        
    }
    return self;
}

- (void)goAction {

    if (self.goSetTradePwd) {
        self.goSetTradePwd();
    }

}

@end
