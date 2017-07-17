//
//  ZHPayFuncCell.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/25.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHPayFuncCell.h"

#define PAY_TYPE_CHANGE_NOTIFICATION @"PAY_TYPE_CHANGE_NOTIFICATION"
@implementation ZHPayFuncCell

-(void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payChange:) name:PAY_TYPE_CHANGE_NOTIFICATION object:nil];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.funcTypeImageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12.5, 25,25)];
        [self addSubview:self.funcTypeImageV];
        
        //
        self.selectedBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [self addSubview:self.selectedBtn];
        self.selectedBtn.userInteractionEnabled = NO;
        
        [self.selectedBtn setBackgroundImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
        [self.selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.height.mas_equalTo(@20);
            make.width.mas_equalTo(@20);
            make.right.equalTo(self.mas_right).offset(-15);
            make.centerY.equalTo(self);

        }];
        
        //
        self.infoLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor whiteColor]
                                          font:[UIFont secondFont]
                                     textColor:[UIColor zh_textColor]];
        [self addSubview:self.infoLbl];
        
        [self.infoLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.height.equalTo(self);
            make.left.equalTo(self.funcTypeImageV.mas_right).offset(10);
            make.right.equalTo(self.selectedBtn.mas_left);
        }];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor zh_lineColor];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.right.equalTo(self);
            make.bottom.equalTo(self.mas_bottom).offset(-0.3  );
            make.height.mas_equalTo(0.5);
        }];
        
        
    }

    return self;
}

- (void)setPay:(ZHPayFuncModel *)pay {

    _pay = pay;
    self.funcTypeImageV.image = [UIImage imageNamed:_pay.payImgName];
    self.infoLbl.text = _pay.payName;
    if (_pay.isSelected) {
        [self.selectedBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
    }
    
}

//- (void)selected {
//
//    if (!self.pay) {
//        
//        NSLog(@"支付模型，去哪了？");
//        return;
//    }
//    
//    if (_pay.isSelected) {
//        return;
//    }
//    
//    //此处应该使用KVO, 为了简单暂时使用通知
//    [[NSNotificationCenter defaultCenter] postNotificationName:PAY_TYPE_CHANGE_NOTIFICATION object:nil userInfo:@{@"sender" : self}];
//}


- (void)payChange:(NSNotification *)notification {

    id obj =  notification.userInfo[@"sender"];
    if ([obj isEqual:self]) {
        
       [self.selectedBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
        self.pay.isSelected = YES;
    } else {
    
        if (!self.pay.isSelected) {
            
            return;
        }
      [self.selectedBtn setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
        self.pay.isSelected = NO;

    }
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
