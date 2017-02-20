//
//  ZHBillCell.m
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/24.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHBillCell.h"

@interface ZHBillCell()

@property (nonatomic,strong) UILabel *nameLbl;
@property (nonatomic,strong) UILabel *moneyLbl;
@property (nonatomic,strong) UILabel *detailLbl;
@property (nonatomic,strong) UILabel *timeLbl;



@end
@implementation ZHBillCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        CGFloat left = 15;
        CGFloat timeW = 100;
        self.nameLbl = [UILabel labelWithFrame:CGRectMake(left, 15, SCREEN_WIDTH - left - timeW - 15, 20) textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor clearColor]
                                          font:[UIFont secondFont]
                                     textColor:[UIColor zh_textColor]];
        self.nameLbl.height = [[UIFont secondFont] lineHeight];
        [self addSubview:self.nameLbl];
        //钱
        self.moneyLbl = [UILabel labelWithFrame:CGRectMake(left,self.nameLbl.yy + 15, SCREEN_WIDTH - 30, 100) textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor clearColor]
                                          font:[UIFont firstFont]
                                     textColor:[UIColor zh_themeColor]];
        self.moneyLbl.height = [[UIFont firstFont] lineHeight];
        [self  addSubview:self.moneyLbl];
        
        self.timeLbl = [UILabel labelWithFrame:CGRectMake(left,15, timeW, self.nameLbl.height) textAligment:NSTextAlignmentRight
                               backgroundColor:[UIColor clearColor]
                                          font:[UIFont secondFont]
                                     textColor:[UIColor zh_textColor2]];
        self.timeLbl.xx_size = SCREEN_WIDTH - 15;
        [self  addSubview:self.timeLbl];
        
        [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.mas_right).offset(-15);
            make.top.equalTo(self.mas_top).offset(15);
            
        }];
        
        //详情
        self.detailLbl = [UILabel labelWithFrame:CGRectMake(left,self.moneyLbl.yy + 15, self.moneyLbl.width, self.nameLbl.height) textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor clearColor]
                                           font:FONT(14)
                                      textColor:[UIColor zh_textColor2]];
//        self.detailLbl.height = [FONT(14) lineHeight];
        [self  addSubview:self.detailLbl];
        
        self.detailLbl.numberOfLines = 0;
        [self.detailLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.moneyLbl.mas_bottom).offset(15);
            make.left.equalTo(self.moneyLbl.mas_left);
            make.right.equalTo(self.mas_right).offset(-15);
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

- (void)setBillModel:(ZHBillModel *)billModel {

    _billModel = billModel;

    self.nameLbl.text = [_billModel getBizName] ? : _billModel.bizType;
    
    long long money = [_billModel.transAmount longLongValue];
    if (money > 0) {
        self.moneyLbl.text = [NSString stringWithFormat:@"+%@", [_billModel.transAmount convertToRealMoney ]];

    } else if (money < 0) {
    
        self.moneyLbl.text = [NSString stringWithFormat:@"%@", [_billModel.transAmount convertToRealMoney ]];

    
    }
    self.detailLbl.text = _billModel.bizNote;

    self.timeLbl.text = [_billModel.createDatetime convertToDetailDate];
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
