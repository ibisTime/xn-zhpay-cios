//
//  CDFHQTopBottomView.m
//  ZHBusiness
//
//  Created by  tianlei on 2017/5/31.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CDFHQTopBottomView.h"
#import "UIColor+theme.h"
#import "ZHUser.h"
#import "TLHeader.h"


@implementation CDFHQTopBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.topLbl = [UILabel labelWithFrame:CGRectZero
                                 textAligment:NSTextAlignmentCenter
                              backgroundColor:[UIColor whiteColor] font:FONT(18)
                                    textColor:[UIColor shopThemeColor]];
        [self addSubview:self.topLbl];
        
        //
        self.bottomLbl = [UILabel labelWithFrame:CGRectZero
                                 textAligment:NSTextAlignmentCenter
                              backgroundColor:[UIColor whiteColor] font:FONT(12)
                             textColor:[UIColor textColor]];
        [self addSubview:self.bottomLbl];
        
        //
        [self.topLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);

        }];
        
        [self.bottomLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.mas_centerY).offset(5);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            
        }];
        
        
        
    }
    return self;
}
@end
