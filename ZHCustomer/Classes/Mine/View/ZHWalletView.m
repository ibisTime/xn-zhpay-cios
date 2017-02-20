//
//  ZHWalletView.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/20.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHWalletView.h"

@implementation ZHWalletView

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
       
        self.typeLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor whiteColor]
                                          font:FONT(12)
                                     textColor:[UIColor zh_textColor]];
        [self addSubview:self.typeLbl];
        
        [self.typeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.mas_left).offset(15);
            make.top.equalTo(self.mas_top).offset(5);
        }];
        
        
        //
        self.moneyLbl = [UILabel labelWithFrame:CGRectZero
                                   textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor whiteColor]
                                           font:FONT(17)
                                      textColor:[UIColor zh_themeColor]];
        [self addSubview:self.moneyLbl];
        self.moneyLbl.font = [UIFont fontWithName:@"Impact" size:17];
        [self.moneyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.mas_right).offset(-23);
            make.top.equalTo(self.mas_top).offset(27);
            
        }];
        
        self.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
        
        
        
    }
    
    return self;
}

- (void)tapAction {

    if (self.action) {
        self.action(self.code);
    }

}

@end
