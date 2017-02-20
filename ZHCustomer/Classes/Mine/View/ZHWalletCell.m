//
//  ZHWalletCell.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/3.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHWalletCell.h"
#import "ZHBillVC.h"

@interface ZHWalletCell()

@property (nonatomic,strong) UIImageView *rightArrowImageV;
@property (nonatomic,strong) UIImageView *downArrowImageV;

@end

@implementation ZHWalletCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //
        self.typeLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor clearColor]
                                          font:FONT(12)
                                     textColor:[UIColor zh_textColor2]];
        [self addSubview:self.typeLbl];
        
        //钱数
        self.moneyLbl = [UILabel labelWithFrame:CGRectZero textAligment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor] font:[UIFont secondFont] textColor:[UIColor zh_textColor]];
        [self addSubview:self.moneyLbl];
    
        //右边标题
        self.accessoryLbl = [UILabel labelWithFrame:CGRectZero
                                       textAligment:NSTextAlignmentRight
                                    backgroundColor:[UIColor clearColor]
                                               font:FONT(14)
                                          textColor:[UIColor zh_themeColor]];
        [self addSubview:self.accessoryLbl];
        
        
        [self.typeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.mas_left).offset(15);
            make.top.equalTo(self.mas_top).offset(7);
//            make.width.mas_equalTo(@(SCREEN_WIDTH - 115));
            make.right.equalTo(self.accessoryLbl.mas_left);
            
        }];
        
        [self.moneyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.mas_left).offset(15);
            make.top.equalTo(self.typeLbl.mas_bottom).offset(5);
            make.right.equalTo(self.accessoryLbl.mas_left);
            
        }];
        
        [self.accessoryLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
//            make.left.equalTo(self.typeLbl.mas_left);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
            make.right.equalTo(self.mas_right).offset(-40);
            
        }];
        


        
        [self addSubview:self.rightArrowImageV];
        [self addSubview:self.downArrowImageV];
        
        //查看账单的btn
        UIButton *looDetailBtn = [[UIButton alloc] init];
        [self addSubview:looDetailBtn];
        [looDetailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.top.equalTo(self.mas_top).offset(5);
            make.bottom.equalTo(self.mas_bottom).offset(-5);
            make.width.equalTo(@(SCREEN_WIDTH*0.75));
        }];
        [looDetailBtn addTarget:self action:@selector(lookBill) forControlEvents:UIControlEventTouchUpInside];
        
        //
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor zh_lineColor];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.width.equalTo(self.mas_width);
            make.height.mas_equalTo(@(LINE_HEIGHT));
            make.bottom.equalTo(self.mas_bottom);
        }];
        //
        
    }

    return self;
}

- (void)lookBill {

    ZHBillVC *billVC = [[ZHBillVC alloc] init];
    billVC.accountNumber = self.currencyModel.accountNumber;
    [UINavigationController pushViewControllerHiddenBottomBar:billVC];

}

- (UIImageView *)rightArrowImageV {

    if (!_rightArrowImageV) {
        
        _rightArrowImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"更多"]];
        _rightArrowImageV.frame = CGRectMake(SCREEN_WIDTH - 25, 16.5, 10, 17);
    }
    return _rightArrowImageV;

}

- (UIImageView *)downArrowImageV {

    if (!_downArrowImageV) {
        
        _downArrowImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_down"]];
        _downArrowImageV.frame = CGRectMake(SCREEN_WIDTH - 32, 20, 17, 10);
        
    }

    return _downArrowImageV;
}


- (void)setType:(NSString *)type {

    _type = [type copy];
    if ([_type isEqualToString:@"0"]) {
        
        self.rightArrowImageV.hidden = YES;
        self.downArrowImageV.hidden = YES;
        
    } else if([_type isEqualToString:@"1"]) {
    
        self.rightArrowImageV.hidden = NO;
        self.downArrowImageV.hidden = YES;
        
    } else {
    
        self.rightArrowImageV.hidden = YES;
        self.downArrowImageV.hidden = NO;
    
    }

}

//- (void)sw {
//
//    if (0) { //右边没东西
//        
//        [self addSubview:self.rightArrowImageV];
//        
//    } else if(1) { //
//        
//        [self.imageView addSubview:self.downArrowImageV];
//    
//    } else {
//    
//    
//    }
//
//}

@end
