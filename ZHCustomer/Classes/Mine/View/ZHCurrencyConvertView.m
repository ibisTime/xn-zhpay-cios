//
//  ZHCurrencyConvertView.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHCurrencyConvertView.h"

@implementation ZHCurrencyConvertView

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        //
        self.typeLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor whiteColor]
                                          font:FONT(12)
                                     textColor:[UIColor zh_textColor2]];
        [self addSubview:self.typeLbl];
        
        //钱数
        self.moneyLbl = [UILabel labelWithFrame:CGRectZero textAligment:NSTextAlignmentLeft backgroundColor:[UIColor whiteColor]
                                           font:[UIFont secondFont]
                                      textColor:[UIColor zh_textColor]];
        [self addSubview:self.moneyLbl];
        
        //
        [self.typeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.mas_left).offset(15);
            make.top.equalTo(self.mas_top).offset(23);
            
        }];
        
        [self.moneyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.mas_left).offset(15);
            make.top.equalTo(self.typeLbl.mas_bottom).offset(7);
            
        }];
        
        //
        self.leftBtn = [UIButton zhBtnWithFrame:CGRectZero title:@"left"];
        [self addSubview:self.leftBtn];
        self.leftBtn.titleLabel.font = FONT(13);
        
        self.rightBtn = [UIButton zhBtnWithFrame:CGRectZero title:@"right"];
        [self addSubview:self.rightBtn];
        self.rightBtn.titleLabel.font = FONT(13);

        
        //----//
        [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self.mas_centerY);
            make.width.mas_equalTo(56);
            make.height.mas_equalTo(30);
            
            make.right.equalTo(self.mas_right).offset(-15);
            make.left.equalTo(self.leftBtn.mas_right).offset(30);
        }];
        
        [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.width.mas_equalTo(56);
            make.height.mas_equalTo(30);
            make.right.equalTo(self.rightBtn.mas_left).offset(-30);
        }];
        
        
//        self.moneyLbl.text = @"钱";
//        self.typeLbl.text = @"累死你个";
        
        
  
        
        
    }
    
    return self;

}

@end
