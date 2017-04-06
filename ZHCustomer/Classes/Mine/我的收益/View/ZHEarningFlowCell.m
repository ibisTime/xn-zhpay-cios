//
//  ZHEarningFlowCell.m
//  ZHBusiness
//
//  Created by  tianlei on 2017/4/5.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHEarningFlowCell.h"
#import "ZHCurrencyModel.h"

@interface ZHEarningFlowCell()

@property (nonatomic, strong) UILabel *backMoneyLbl;
@property (nonatomic, strong) UILabel *backTimeLbl;

@end

@implementation ZHEarningFlowCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        self.backMoneyLbl = [UILabel labelWithFrame:CGRectZero textAligment:NSTextAlignmentLeft backgroundColor:[UIColor whiteColor] font:FONT(14) textColor:[UIColor zh_textColor]];
        [self.contentView addSubview:self.backMoneyLbl];
        
        //
        self.backTimeLbl = [UILabel labelWithFrame:CGRectZero textAligment:NSTextAlignmentLeft backgroundColor:[UIColor whiteColor] font:FONT(14) textColor:[UIColor zh_textColor]];
        [self.contentView addSubview:self.backTimeLbl];
        
        
        [self.backMoneyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(15);
            make.top.equalTo(self.contentView.mas_top).offset(10);
            
        }];
        
        [self.backTimeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(15);
            make.top.equalTo(self.backMoneyLbl.mas_bottom).offset(10);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        }];
        
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor zh_lineColor];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.width.equalTo(self.mas_width);
            make.height.mas_equalTo(1);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
    }
    
    return self;

}

- (void)setFlowModel:(ZHEarningFlowModel *)flowModel {

    _flowModel = flowModel;
    
    NSDictionary *dict = @{
                           kFRB : @"分润",
                           kGXB : @"贡献值",
                           kQBB : @"钱包币",
                           kGWB : @"购物币",
                           kHBYJ : @"红包业绩",
                           kHBB : @"红包币"
                           };
    
    
    self.backMoneyLbl.text = [NSString stringWithFormat:@"返还金额： %@%@",[self detailMoneyWithMoney:_flowModel.toAmount],dict[_flowModel.toCurrency]];
    self.backTimeLbl.text = [NSString stringWithFormat:@"返还时间：%@",[_flowModel.createDatetime convertToDetailDate]];
    
}

- (NSString *)detailMoneyWithMoney:(NSNumber *)money {
    
    
    return [NSString stringWithFormat:@"%.3lf",[money longLongValue]/1000.0];
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
