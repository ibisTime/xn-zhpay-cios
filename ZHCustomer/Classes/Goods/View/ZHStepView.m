//
//  ZHStepView.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/27.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHStepView.h"

@interface ZHStepView ()

@property (nonatomic,strong) UILabel *countLbl;
@property (nonatomic,strong) UIButton *buyAllBtn;
@property (nonatomic,strong) UILabel *hintLbl;

@property (nonatomic,strong) UIButton *leftBtn;//左减
@property (nonatomic,strong) UIButton *rightBtn;//右加

@end

@implementation ZHStepView

- (UILabel *)countLbl {

    if (!_countLbl) {
        _countLbl = [UILabel labelWithFrame:CGRectZero
                               textAligment:NSTextAlignmentCenter
                            backgroundColor:[UIColor whiteColor]
                                       font:[UIFont secondFont]
                                  textColor:[UIColor zh_textColor]];
    }
    
    return _countLbl;

}
- (UILabel *)hintLbl {

    if (!_hintLbl) {
        _hintLbl =  [UILabel labelWithFrame:CGRectMake(0, 0, 40, 0)
                               textAligment:NSTextAlignmentLeft
                            backgroundColor:[UIColor whiteColor]
                                       font:[UIFont secondFont]
                                  textColor:[UIColor zh_textColor]];
        _hintLbl.text = @"数量";

    }
    return _hintLbl;

}

- (UIButton *)buyAllBtn {

    if (!_buyAllBtn) {
        _buyAllBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_buyAllBtn setTitle:@"Max" forState:UIControlStateNormal];
        _buyAllBtn.layer.masksToBounds = YES;
        _buyAllBtn.layer.cornerRadius = 10;
        _buyAllBtn.layer.borderColor = [UIColor zh_themeColor].CGColor;
        _buyAllBtn.layer.borderWidth = 1;
        [_buyAllBtn setTitleColor:[UIColor zh_themeColor] forState:UIControlStateNormal];
        _buyAllBtn.titleLabel.font = FONT(11);
        [_buyAllBtn addTarget:self action:@selector(buyAll) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _buyAllBtn;

}

- (UIButton *)leftBtn {

    if (!_leftBtn) {
        _leftBtn = [self btnWithFrame:CGRectZero imageName:@"减少"];
        [_leftBtn addTarget:self action:@selector(reduce) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _leftBtn;

}

- (UIButton *)rightBtn {
    
    if (!_rightBtn) {
        _rightBtn = [self btnWithFrame:CGRectZero imageName:@"增加"];
        [_rightBtn addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _rightBtn;
    
}



- (instancetype)initWithFrame:(CGRect)frame type:(ZHStepViewType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.count = 1;
        
        [self addSubview:self.leftBtn];
        [self addSubview:self.countLbl];
        [self addSubview:self.rightBtn];
        if (type == ZHStepViewTypeDefault) {
            
            [self addSubview:self.hintLbl];
            [self addSubview:self.buyAllBtn];
            
            [self.hintLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left);
                make.top.equalTo(self.mas_top);
                make.bottom.equalTo(self.mas_bottom);
                make.width.mas_equalTo(@40);
            }];
            
            //
            [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.hintLbl.mas_right).offset(19);
                make.width.equalTo(self.mas_height);
                make.height.equalTo(self.mas_height);
                make.centerY.equalTo(self.mas_centerY);
            }];
            [self.countLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.leftBtn.mas_right);
                make.top.equalTo(self.mas_top);
                make.bottom.equalTo(self.mas_bottom);
                make.width.mas_equalTo(@100);
            }];
            
            [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.countLbl.mas_right);
                make.width.equalTo(self.mas_height);
                make.height.equalTo(self.mas_height);
                make.centerY.equalTo(self.mas_centerY);
            }];
            
            [self.buyAllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(self.rightBtn.mas_right).offset(20);
                make.width.mas_equalTo(@45);
                make.height.mas_equalTo(@20);
                make.centerY.equalTo(self.mas_centerY);
                
            }];
            
        } else {
        
        
            [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left);
                make.width.equalTo(self.mas_height);
                make.height.equalTo(self.mas_height);
                make.centerY.equalTo(self.mas_centerY);
            }];
            [self.countLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.leftBtn.mas_right);
                make.top.equalTo(self.mas_top);
                make.bottom.equalTo(self.mas_bottom);
                make.width.mas_equalTo(@100);
            }];
            
            [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.countLbl.mas_right);
                make.width.equalTo(self.mas_height);
                make.height.equalTo(self.mas_height);
                make.centerY.equalTo(self.mas_centerY);
//                make.right.equalTo(self.mas_right);
            }];

            
        }
        
    }
    
    return self;
    
}

- (void)buyAll {

    if (self.maxCount != 0) {
        self.count = self.maxCount;
    }
    
    if (self.buyAllAction) {
        self.buyAllAction();
    }
}


- (void)reduce {

    if (self.count <= 1) {
        return;
    }

    self.count --;
    self.countLbl.text = [NSString stringWithFormat:@"%ld",self.count];
    if (self.countChange) {
        self.countChange(self.count);
    }
    
}


- (void)add {

    if (self.maxCount != 0 && self.count >= self.maxCount) {
        return;
    }
    
    self.count ++;
    self.countLbl.text = [NSString stringWithFormat:@"%ld",self.count];
    if (self.countChange) {
        self.countChange(self.count);
    }
}

- (void)setCount:(NSInteger)count {

    _count = count;
    self.countLbl.text = [NSString stringWithFormat:@"%ld",count];
    
}

- (void)setIsDefault:(BOOL)isDefault {

    _isDefault = isDefault;
    
    if (_isDefault) {
        self.buyAllBtn.hidden = YES;
    } else {
    
        self.buyAllBtn.hidden = NO;
    }
    
}


- (UIButton *)btnWithFrame:(CGRect)frame imageName:(NSString *)name {

    UIButton *leftBtn = [[UIButton alloc] initWithFrame:frame];
    leftBtn.layer.masksToBounds = YES;
    leftBtn.layer.cornerRadius = 12.5;
    leftBtn.layer.borderColor = [UIColor zh_textColor].CGColor;
    leftBtn.layer.borderWidth = 1;
    
    [leftBtn setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];

    return leftBtn;
    
}

@end
