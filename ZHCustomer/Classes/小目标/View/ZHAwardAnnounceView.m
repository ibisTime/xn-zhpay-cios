//
//  ZHAwardAnnounceView.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/20.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHAwardAnnounceView.h"

@interface ZHAwardAnnounceView ()

@property (nonatomic, strong) UILabel *typeLbl;
@property (nonatomic, strong) UILabel *contentLbl;

@end


@implementation ZHAwardAnnounceView

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
       
        self.typeLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentCenter
                               backgroundColor:[UIColor whiteColor]
                                          font:FONT(10)
                                     textColor:[UIColor zh_themeColor]];
        [self addSubview:self.typeLbl];
        self.typeLbl.layer.cornerRadius = 3;
        self.typeLbl.layer.borderColor = [UIColor zh_themeColor].CGColor;
        self.typeLbl.layer.borderWidth = 0.5;

        [self.typeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
            make.width.mas_equalTo(@27);
        }];
        
        //
        self.contentLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentCenter
                               backgroundColor:[UIColor whiteColor]
                                          font:FONT(10)
                                     textColor:[UIColor colorWithHexString:@"#lalala"]];
        [self addSubview:self.contentLbl];
        [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.typeLbl.mas_right).offset(6);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        
    }
    
    [self data];
    return self;

}

- (void)data {

    self.typeLbl.text = @"中奖";
    self.contentLbl.text = @"123**$3543中得100分润大红包";

}

@end
