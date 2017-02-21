//
//  ZHTwoLineView.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/20.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHTwoLineView.h"

@interface ZHTwoLineView()

@end

@implementation ZHTwoLineView

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        //
        self.topLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentCenter
                               backgroundColor:[UIColor clearColor]
                                          font:FONT(12)
                                     textColor:[UIColor whiteColor]];
        [self addSubview:self.topLbl];
        
        [self.topLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.mas_left);
            make.top.equalTo(self.mas_top);
            make.right.equalTo(self.mas_right);
            
            

        }];
        //
        self.bottomLbl = [UILabel labelWithFrame:CGRectZero
                                 textAligment:NSTextAlignmentCenter
                              backgroundColor:[UIColor clearColor]
                                         font:FONT(16)
                                    textColor:[UIColor whiteColor]];
        [self addSubview:self.bottomLbl];
        
        [self.bottomLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.mas_left);
            make.top.equalTo(self.topLbl.mas_bottom).offset(12);
            make.right.equalTo(self.mas_right);
            
        }];
        
        
    }
    
    return self;

}

@end
