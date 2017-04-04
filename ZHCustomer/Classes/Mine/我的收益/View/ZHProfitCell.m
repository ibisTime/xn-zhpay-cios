//
//  ZHProfitCell.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/3/23.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHProfitCell.h"
#import "ZHEarningModel.h"

@interface ZHProfitCell()

@property (nonatomic, strong) UILabel *todayProfitLbl; //今日返利
@property (nonatomic, strong) UILabel *totalProfitLbl;
@property (nonatomic, strong) UILabel *conditionLbl;

//状态
@property (nonatomic, strong) UILabel *stateLbl;
@property (nonatomic, strong) UILabel *obtainProfitLbl; //获的返利
@property (nonatomic, strong) UILabel *timeLbl; //

@end

@implementation ZHProfitCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setUpUI];
        
    
        
     
   
    }
    return self;

}

- (void)setEarningModel:(ZHEarningModel *)earningModel {

    _earningModel = earningModel;
    
    //状态
    self.stateLbl.text = [_earningModel getStatusName];
    
    //返利总额
    self.totalProfitLbl.attributedText= [self attrWithString:[NSString stringWithFormat: @"返利总额：%@",[_earningModel.profitAmount convertToRealMoney]] contentStr:nil];
    
    
    //已收返利
    self.obtainProfitLbl.attributedText = [self attrWithString:[NSString stringWithFormat: @"已收返利：%@",[self detailMoneyWithMoney:_earningModel.backAmount]] contentStr:nil];
                                           
//    [_earningModel.backAmount convertToRealMoney]
    //
    self.todayProfitLbl.attributedText = [self attrWithString:[NSString stringWithFormat: @"今日返利：%@",[self detailMoneyWithMoney:_earningModel.todayAmount]] contentStr:nil];;
//    [_earningModel.todayAmount convertToRealMoney]
    
    //固定
    self.conditionLbl.attributedText =
    [self attrWithString: [NSString stringWithFormat:@"获得条件：满%@消费额",[_earningModel.costAmount convertToRealMoney]] contentStr:nil];
    
    //时间
    self.timeLbl.text = [_earningModel.createDatetime convertDate];

}

- (NSString *)detailMoneyWithMoney:(NSNumber *)money {


    return [NSString stringWithFormat:@"%.3lf",[money longLongValue]/1000.0];
}

- (NSAttributedString *)attrWithString:(NSString *)str contentStr:(NSString *)contentStr {

    NSMutableAttributedString *mutableAttr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{
                                                                                                               NSForegroundColorAttributeName : [UIColor zh_themeColor]
                                                                                                               }];
    [mutableAttr addAttribute:NSForegroundColorAttributeName value:[UIColor zh_textColor] range:NSMakeRange(0, 5)];
    
    return mutableAttr;
    

}

- (void)setUpUI {

    self.todayProfitLbl = [UILabel labelWithFrame:CGRectZero
                                     textAligment:NSTextAlignmentLeft backgroundColor:[UIColor whiteColor]
                                             font:FONT(14)
                                        textColor:[UIColor zh_themeColor]];
    [self.contentView addSubview:self.todayProfitLbl];
    
    self.totalProfitLbl = [UILabel labelWithFrame:CGRectZero
                                     textAligment:NSTextAlignmentLeft backgroundColor:[UIColor whiteColor]
                                             font:FONT(14)
                                        textColor:[UIColor zh_themeColor]];
    [self.contentView addSubview:self.totalProfitLbl];
    
    self.conditionLbl = [UILabel labelWithFrame:CGRectZero
                                   textAligment:NSTextAlignmentLeft backgroundColor:[UIColor whiteColor]
                                           font:FONT(14)
                                      textColor:[UIColor zh_themeColor]];
    [self.contentView addSubview:self.conditionLbl];
    
    self.stateLbl = [UILabel labelWithFrame:CGRectZero
                               textAligment:NSTextAlignmentRight
                            backgroundColor:[UIColor whiteColor]
                                       font:FONT(14)
                                  textColor:[UIColor zh_themeColor]];
    [self.contentView addSubview:self.stateLbl];
    
    self.obtainProfitLbl = [UILabel labelWithFrame:CGRectZero
                                      textAligment:NSTextAlignmentRight
                                   backgroundColor:[UIColor whiteColor]
                                              font:FONT(14)
                                         textColor:[UIColor zh_themeColor]];
    [self.contentView addSubview:self.obtainProfitLbl];
    
    self.timeLbl = [UILabel labelWithFrame:CGRectZero
                              textAligment:NSTextAlignmentRight
                           backgroundColor:[UIColor whiteColor]
                                      font:FONT(14)
                                 textColor:[UIColor zh_textColor2]];
    [self.contentView addSubview:self.timeLbl];
    
    
    //今日
    [self.todayProfitLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.contentView.mas_top).offset(15);
    }];
    
    //状态
    [self.stateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(self.contentView.mas_top).offset(15);
    }];
    
    //总额
    [self.totalProfitLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.todayProfitLbl.mas_left);
        make.top.equalTo(self.todayProfitLbl.mas_bottom).offset(15);
        
    }];
    
    //已收
    [self.obtainProfitLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(self.totalProfitLbl.mas_top);
        
    }];
    
    //条件
    [self.conditionLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.totalProfitLbl.mas_bottom).offset(15);
        
    }];
    
    [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.stateLbl);
        make.top.equalTo(self.conditionLbl.mas_top);
        
//        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
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

@end
