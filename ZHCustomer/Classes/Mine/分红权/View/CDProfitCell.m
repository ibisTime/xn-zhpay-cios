//
//  CDProfitCell.m
//  ZHBusiness
//
//  Created by  tianlei on 2017/5/31.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CDProfitCell.h"
#import "ZHEarningModel.h"
//#import "UIHeader.h"
#import "TLHeader.h"
#import "UIColor+theme.h"
#import "ZHCurrencyModel.h"

@interface CDProfitCell()

@property (nonatomic, strong) UILabel *idLbl;

@property (nonatomic, strong) UILabel *hasGetLbl;
@property (nonatomic, strong) UILabel *willGetLbl;
@property (nonatomic, strong) UILabel *timeLbl;

@property (nonatomic, strong) UILabel *lookDetailLbl;

@end

@implementation CDProfitCell

+ (CGFloat)rowHeight {

    return 70;
}


- (void)setEarningModel:(ZHEarningModel *)earningModel {
    
    _earningModel = earningModel;
    
    NSString *idPrefix = @"";
    
    if ([earningModel.profitCurrency isEqualToString:kBTB]) {
        
        idPrefix = @"BTID";
        
    } else if([earningModel.profitCurrency isEqualToString:kFRB]) {
        idPrefix = @"FHQID";
    }
    
    NSString *idCodeStr = [_earningModel.code substringFromIndex:_earningModel.code.length - 6];
    self.idLbl.text = [NSString stringWithFormat:@"%@%@",idPrefix,idCodeStr];
    
    NSNumber *willGetNum = @([_earningModel.profitAmount longLongValue] - [_earningModel.backAmount longLongValue]);
    
    //生效时间
    self.timeLbl.text = [NSString stringWithFormat:@"生效时间：%@",[_earningModel.createDatetime convertDate]];
    
    if (self.isSimpleUI) {
        
        self.lookDetailLbl.hidden = YES;
        self.idLbl.textColor = [UIColor shopThemeColor];
        self.willGetLbl.textColor = [UIColor shopThemeColor];
        self.hasGetLbl.textColor = [UIColor shopThemeColor];
        self.timeLbl.textColor = [UIColor shopThemeColor];

        
        
        //
        self.hasGetLbl.text = [NSString stringWithFormat: @"已领取：%@",[_earningModel.backAmount convertToRealMoney]];
        self.willGetLbl.text = [NSString stringWithFormat: @"未领取：%@",[willGetNum convertToRealMoney]];
        
        return;
    }

    self.lookDetailLbl.hidden = NO;

    
    //已领取
    self.hasGetLbl.attributedText = [self attrWithString:[NSString stringWithFormat: @"已领取：%@",[_earningModel.backAmount convertToRealMoney]] contentStr:nil len:4];
    
    //未领取
    self.willGetLbl.attributedText= [self attrWithString:[NSString stringWithFormat: @"未领取：%@",[willGetNum convertToRealMoney]] contentStr:nil len:4];
    
}

- (NSString *)detailMoneyWithMoney:(NSNumber *)money {
    
    
    return [NSString stringWithFormat:@"%.3lf",[money longLongValue]/1000.0];
}

- (NSAttributedString *)attrWithString:(NSString *)str contentStr:(NSString *)contentStr len:(NSInteger)len {
    
    NSMutableAttributedString *mutableAttr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{
                                                                                                                NSForegroundColorAttributeName : [UIColor zh_themeColor]
                                                                                                                }];
    [mutableAttr addAttribute:NSForegroundColorAttributeName value:[UIColor zh_textColor] range:NSMakeRange(0, len)];
    
    return mutableAttr;
    
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.isSimpleUI = NO;
        
        //
        UIView *decorateV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        [self.contentView addSubview:decorateV];
        decorateV.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        
        //
        self.idLbl = [UILabel labelWithFrame:CGRectZero
                                textAligment:NSTextAlignmentLeft
                             backgroundColor:[UIColor whiteColor]
                                        font:FONT(12)
                                   textColor:[UIColor textColor]];
        [self.contentView addSubview:self.idLbl];
        
        //
        self.hasGetLbl = [UILabel labelWithFrame:CGRectZero
                                    textAligment:NSTextAlignmentLeft
                                 backgroundColor:[UIColor whiteColor]
                                            font:FONT(12)
                                       textColor:[UIColor textColor]];
        [self.contentView addSubview:self.hasGetLbl];
        
        self.willGetLbl = [UILabel labelWithFrame:CGRectZero
                                textAligment:NSTextAlignmentLeft
                             backgroundColor:[UIColor whiteColor]
                                        font:FONT(12)
                                   textColor:[UIColor textColor]];
        [self.contentView addSubview:self.willGetLbl];
        
        //
        self.timeLbl = [UILabel labelWithFrame:CGRectZero
                                     textAligment:NSTextAlignmentLeft
                                  backgroundColor:[UIColor whiteColor]
                                             font:FONT(12)
                                        textColor:[UIColor textColor]];
        [self.contentView addSubview:self.timeLbl];
        
        //
        self.lookDetailLbl = [UILabel labelWithFrame:CGRectZero
                                        textAligment:NSTextAlignmentCenter
                                     backgroundColor:[UIColor whiteColor]
                                                font:FONT(12)
                                           textColor:[UIColor textColor]];
        [self.contentView addSubview:self.lookDetailLbl];
        self.lookDetailLbl.layer.borderWidth = 0.5;
        self.lookDetailLbl.layer.borderColor = [UIColor textColor2].CGColor;
        self.lookDetailLbl.layer.cornerRadius = 3;
        self.lookDetailLbl.text = @"查看";


        
        
        //
        [self.idLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(15);
            make.top.equalTo(self.contentView.mas_top).offset(22);
        }];
        
        //已领取
        [self.willGetLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-15);
            make.top.equalTo(self.idLbl.mas_top);
        }];
        
        //未领取
        [self.hasGetLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.willGetLbl.mas_top);
            make.right.equalTo(self.willGetLbl.mas_left).offset(-15);
        }];
        //
        [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.idLbl.mas_left);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        }];
        
        [self.lookDetailLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(20);
            make.width.mas_offset(60);
            make.centerY.equalTo(self.timeLbl.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).offset(-15);
            
        }];
        
        
        //
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor lineColor];
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.contentView.mas_right);
            make.height.mas_equalTo(0.7);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        
        
    }
    
    return self;

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
