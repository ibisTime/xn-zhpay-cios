//
//  ZHBuyerCell.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/27.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHBuyerCell.h"

@interface ZHBuyerCell()

@property (nonatomic,strong) UIImageView *avatar;
@property (nonatomic,strong) UILabel *nameLbl;
@property (nonatomic,strong) UILabel *timeLbl;
@property (nonatomic,strong) UILabel *moneyLbl;

@end

@implementation ZHBuyerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.avatar = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 45, 45)];
        self.avatar.image = [UIImage imageNamed:@"user_placeholder"];
        [self addSubview:self.avatar];
        self.avatar.contentMode=  UIViewContentModeScaleAspectFill;
        self.avatar.layer.cornerRadius = 22.5;
        self.avatar.layer.masksToBounds = YES;
        
        //
        self.nameLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor whiteColor]
                                          font:[UIFont secondFont]
                                     textColor:[UIColor zh_textColor]];
        [self addSubview:self.nameLbl];
        
        [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.avatar.mas_right).offset(10);
            make.top.equalTo(self.mas_top).offset(18);
            make.height.mas_equalTo(@20);
            
        }];
        
        //购买时间
        self.timeLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor whiteColor]
                                          font:[UIFont thirdFont]
                                     textColor:[UIColor zh_textColor2]];
        [self addSubview:self.timeLbl];
        
        [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLbl.mas_left);
            make.top.equalTo(self.nameLbl.mas_bottom).offset(4);
            
        }];
        
        //
        self.moneyLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor whiteColor]
                                          font:FONT(14)
                                     textColor:[UIColor zh_themeColor]];
        [self addSubview:self.moneyLbl];
        self.moneyLbl.numberOfLines = 0;
        
        [self.moneyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self.mas_centerY);
            make.top.equalTo(self.mas_top).offset(5);
            
            make.bottom.equalTo(self.mas_bottom).offset(-5);
            make.right.equalTo(self.mas_right).offset(-15);
//            make.height.mas_equalTo(@30);
            
        }];
        
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor zh_lineColor];
        [self addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.width.equalTo(self.mas_width);
            make.height.mas_equalTo(@(LINE_HEIGHT));
            make.bottom.equalTo(self.mas_bottom);
         }];
        
        
    }
    
    

    return self;

}

- (void)setTreasureRecord:(ZHTreasureRecord *)treasureRecord {

    _treasureRecord = treasureRecord;
    
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:[_treasureRecord.photo convertThumbnailImageUrl]] placeholderImage:[UIImage imageNamed:@"user_placeholder"]];
    
    self.nameLbl.text = _treasureRecord.nickname;
    self.timeLbl.text = [NSString stringWithFormat:@"购买时间：%@",[_treasureRecord.createDatetime convertToDetailDate]];
    self.moneyLbl.attributedText = [self attr];
}


+ (CGFloat)rowHeight {

    return 75;
}


- (NSMutableAttributedString *) attr {
    
    CGRect bBouns = CGRectMake(-2, -2, 13, 13);
    
    
    NSAttributedString *RMBAttr = [NSAttributedString coverImg:[UIImage imageNamed:@"人民币"] bounds:bBouns];
    
    NSAttributedString *QBBAttr = [NSAttributedString coverImg:[UIImage imageNamed:@"钱包币"] bounds:bBouns];
    
    //钱包 购物 人民
    NSAttributedString *GWBAttr = [NSAttributedString coverImg:[UIImage imageNamed:@"购物币"] bounds:bBouns];
    
    
    //人民币
    NSMutableAttributedString *mutableAttr = [[NSMutableAttributedString alloc] init];
    
    if (![self.treasureRecord.payAmount1 isEqual:@0]) {
        
        [mutableAttr appendAttributedString:RMBAttr];
        NSString *str1 = [@" " add: [[self.treasureRecord.payAmount1 convertToRealMoney] add:@"\n"]];
        [mutableAttr appendAttributedString:[str1 attrStr]];
    }
    
    
    //购物币
    if (![self.treasureRecord.payAmount2 isEqual:@0]) {
        
        [mutableAttr appendAttributedString:GWBAttr];
        NSString *str2 = [NSString stringWithFormat:@" %@\n",[self.treasureRecord.payAmount2 convertToRealMoney]];
        [mutableAttr appendAttributedString:[str2 attrStr]];
    }
    
    
    //钱宝币
    if (![self.treasureRecord.payAmount3  isEqual:@0]) {
        
        [mutableAttr appendAttributedString:QBBAttr];
        NSString *str3 = [NSString stringWithFormat:@" %@\n",[self.treasureRecord.payAmount3 convertToRealMoney]];
        [mutableAttr appendAttributedString:[str3 attrStr]];
    }
    
    return mutableAttr;
}


@end
