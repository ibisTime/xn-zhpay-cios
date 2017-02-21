//
//  ZHUserHeaderView.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/20.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHUserHeaderView.h"

@implementation ZHUserHeaderView

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        
        self.image = [UIImage imageNamed:@"我的背景"];
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
        self.userInteractionEnabled = YES;
        
        CGFloat h = 69;
        //
        UIImageView *avatar = [[UIImageView alloc] init];
        [self addSubview:avatar];
        self.avatarImageV = avatar;
        avatar.layer.cornerRadius = h/2.0;
        avatar.clipsToBounds = YES;
        avatar.contentMode = UIViewContentModeScaleAspectFill;
        avatar.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choosePhoto)];
        [avatar addGestureRecognizer:tap];

        [avatar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.width.mas_equalTo(@(h));
            make.height.mas_equalTo(@(h));
            make.centerY.equalTo(self.mas_centerY);

        }];
        
        //
        self.nameLbl = [UILabel labelWithFrame:CGRectZero
                                         textAligment:NSTextAlignmentLeft
                                      backgroundColor:[UIColor clearColor]
                                                 font:FONT(13)
                                            textColor:[UIColor whiteColor]];
        
        [self addSubview:self.nameLbl];
        [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatarImageV.mas_right).offset(20);
            make.top.equalTo(self.mas_top).offset(25);
        }];
        
        //
        self.mobileLbl = [UILabel labelWithFrame:CGRectZero
                                         textAligment:NSTextAlignmentLeft
                                      backgroundColor:[UIColor clearColor]
                                                 font:FONT(13)
                                            textColor:[UIColor whiteColor]];
        
        [self addSubview:self.mobileLbl];
        [self.mobileLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatarImageV.mas_right).offset(20);
            make.top.equalTo(self.nameLbl.mas_bottom).offset(10);
            make.right.lessThanOrEqualTo(self.mas_right);
        }];
        
        //
        self.hintLbl = [UILabel labelWithFrame:CGRectZero
                                           textAligment:NSTextAlignmentLeft
                                        backgroundColor:[UIColor clearColor]
                                                   font:FONT(15)
                                              textColor:[UIColor whiteColor]];
        
        [self addSubview:self.hintLbl];
        [self.hintLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatarImageV.mas_right).offset(20);
            make.top.equalTo(self.mobileLbl.mas_bottom).offset(10);
            make.right.lessThanOrEqualTo(self.mas_right);
        }];
        
        

        
        
    }
    return self;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (self.tapAction) {
        self.tapAction();
    }

}


- (void)choosePhoto {

    if (self.changePhoto) {
        self.changePhoto();
    }

}

@end
