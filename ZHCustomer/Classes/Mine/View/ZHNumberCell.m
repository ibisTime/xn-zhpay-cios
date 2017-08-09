//
//  ZHNumberCell.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/23.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHNumberCell.h"
#import "TLHeader.h"
#import "ZHUser.h"
#import "UIColor+theme.h"

@implementation ZHNumberCell



- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]) {
        
        self.textLbl = [UILabel labelWithFrame:CGRectZero textAligment:NSTextAlignmentCenter backgroundColor:[UIColor zh_backgroundColor] font:FONT(13) textColor:[UIColor zh_textColor]];
        [self.contentView addSubview:self.textLbl];
        [self.textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(self.contentView).offset(0);
            
        }];
        
    }
    
    
    return self;
    
}

@end
