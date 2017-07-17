//
//  ZHPayInfoView.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/7/17.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHPayInfoView.h"

@implementation ZHPayInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.titleLbl = [UILabel labelWithFrame:CGRectZero
                                   textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor whiteColor]
                                           font:[UIFont secondFont]
                                      textColor:[UIColor textColor]];
;
        [self addSubview:self.titleLbl];
        
        //
        self.contentLbl = [UILabel labelWithFrame:CGRectZero
                                     textAligment:NSTextAlignmentLeft
                                  backgroundColor:[UIColor whiteColor]
                                             font:[UIFont secondFont]
                                        textColor:[UIColor themeColor]];
        [self addSubview:self.contentLbl];
        self.contentLbl.numberOfLines = 0;
        
        
        //
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
      
        [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLbl.mas_right).offset(15);
            make.right.lessThanOrEqualTo(self.mas_right).offset(-15);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        
        
        
    }
    
    return self;
    
}

@end
