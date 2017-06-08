//
//  ZHBankCardCell.m
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/24.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHBankCardCell.h"

@interface ZHBankCardCell()

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *bankLogoImageV;

//银行名称
@property (nonatomic,strong) UILabel *bankNameLbl;
@property (nonatomic,strong) UILabel *typeLbl;

//银行开好
@property (nonatomic,strong) UILabel *bankNumLbl;

@end


@implementation ZHBankCardCell

- (void)setBankCard:(ZHBankCard *)bankCard {

    _bankCard = bankCard;
    
//    UIImage *iconImage = [UIImage imageNamed:_bankCard.bankCode];
    
    UIImage *bgImg = [UIImage imageNamed:[NSString stringWithFormat:@"%@_bg",_bankCard.bankCode]];
    if (bgImg) {
        self.backgroundImageView.image = bgImg;

    } else {
    
        self.backgroundImageView.image = [UIImage imageNamed:@"ICBC_bg"];

    }
    
    
    if (_bankCard.bankCode) {
        
        UIImage *img = [UIImage imageNamed:_bankCard.bankCode];
        
        if (img) {
            
            self.bankLogoImageV.image = img;

        } else {
            
            self.bankLogoImageV.image = [UIImage imageNamed:@"bank_icon_def"];

        }
        
    } else {
    
            self.bankLogoImageV.image = [UIImage imageNamed:@"bank_icon_def"];;
    
    }

    self.typeLbl.text = @"储蓄卡";
    self.bankNameLbl.text = _bankCard.bankName;
    
    //银行卡号
    NSString *subStr = [_bankCard.bankcardNumber substringWithRange:NSMakeRange(_bankCard.bankcardNumber.length - 4, 4)];
    NSString *str = [@"**** **** **** " add:subStr];
    self.bankNumLbl.text = str;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH - 30, 130)];
        [self addSubview:self.backgroundImageView];
        self.backgroundColor = [UIColor clearColor];
        
        //logo
        self.bankLogoImageV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 30, 37, 37)];
        [self.backgroundImageView addSubview:self.bankLogoImageV];
        
        //
        self.bankNameLbl = [UILabel labelWithFrame:CGRectMake(self.bankLogoImageV.xx + 15, 30, SCREEN_WIDTH - self.bankLogoImageV.xx - 15 , 30) textAligment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor] font:FONT(16) textColor:[UIColor whiteColor]];
        [self.backgroundImageView addSubview:self.bankNameLbl];
        self.bankNameLbl.height = [FONT(16) lineHeight];
        
        //
        self.typeLbl = [UILabel labelWithFrame:CGRectMake(self.bankNameLbl.x, self.bankNameLbl .yy + 1, SCREEN_WIDTH - self.bankLogoImageV.xx - 15 , 30) textAligment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor] font:FONT(14) textColor:[UIColor whiteColor]];
        self.typeLbl.height = [FONT(14) lineHeight];
        [self.backgroundImageView addSubview:self.typeLbl];
        
        //
        self.bankNumLbl = [UILabel labelWithFrame:CGRectMake(self.bankNameLbl.x, self.typeLbl.yy + 15, SCREEN_WIDTH - self.bankNameLbl.x , 30) textAligment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor] font:FONT(20) textColor:[UIColor whiteColor]];
        [self.backgroundImageView addSubview:self.bankNumLbl];
        
    }
    return self;
    
}

- (void)data {

    self.backgroundImageView.image = [UIImage imageNamed:@"工商背景"];
    self.bankLogoImageV.image = [UIImage imageNamed:@"工商logo"];
    self.bankNameLbl.text = @"工商银行";
    self.typeLbl.text = @"储蓄卡";
    self.bankNumLbl.text = @"**** **** **** 5009";

}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
