//
//  ZHSendBriberyMoneyCell.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/20.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHSendBriberyMoneyCell.h"
#import "ZHBriberyMoney.h"

@interface ZHSendBriberyMoneyCell()

@property (nonatomic,strong) UIImageView *bgImageV;
@property (nonatomic,strong) UILabel *nameLbl;
@property (nonatomic,strong) UILabel *numberLbl;
@property (nonatomic,strong) UILabel *receiverPeopleLbl;



@end

@implementation ZHSendBriberyMoneyCell


- (void)setBriberMoney:(ZHBriberyMoney *)briberMoney {

    _briberMoney = briberMoney;
    
    //待领取背景 已领取背景
    ZHBriberyMoneyStatus status = _briberMoney.status;
    NSString *receiverText;
    if (status == ZHBriberyMoneyStatusUnSend) {
        
        self.bgImageV.image = [UIImage imageNamed:@"未发送背景"];
        receiverText = @"待发送";


    } else if(status == ZHBriberyMoneyStatusUnReceive) {
    
        self.bgImageV.image = [UIImage imageNamed:@"待领取背景"];
        receiverText = @"已发送,未领取";

    } else if (status == ZHBriberyMoneyStatusReceiverd ) { //已领取
    
        self.bgImageV.image = [UIImage imageNamed:@"已领取背景"];
        receiverText = [NSString stringWithFormat:@"领取人:%@   手机号:%@",_briberMoney.receiverUserName,_briberMoney.receiverMobile];

    } else if (status == ZHBriberyMoneyStatusOutOfDate) { //过期
        
        self.bgImageV.image = [UIImage imageNamed:@"待领取背景"];
        receiverText = @"已过期";
    
    }
    
    self.receiverPeopleLbl.text = receiverText;
    self.nameLbl.text = _briberMoney.slogan;
    self.numberLbl.text = [NSString stringWithFormat:@"红包编号%@",_briberMoney.code];
        
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.bgImageV = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.bgImageV];
        [self.bgImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left).offset(5);
            make.right.equalTo(self.mas_right).offset(-5);
            make.height.mas_equalTo(@103);
        }];
        
        //
        self.nameLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor clearColor]
                                          font:FONT(16)
                                     textColor:[UIColor whiteColor]];
        [self.bgImageV addSubview:self.nameLbl];
        [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgImageV.mas_left).offset(10);
            make.top.equalTo(self.bgImageV.mas_top).offset(18);
            
        }];
        
        //
        self.numberLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor clearColor]
                                          font:FONT(14)
                                     textColor:[UIColor whiteColor]];
        [self.bgImageV addSubview:self.numberLbl];
        [self.numberLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgImageV.mas_left).offset(10);
            make.top.equalTo(self.nameLbl.mas_bottom).offset(11);
            
        }];
        
        //
        self.receiverPeopleLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor clearColor]
                                          font:FONT(13)
                                     textColor:[UIColor whiteColor]];
        [self.bgImageV addSubview:self.receiverPeopleLbl];
        [self.receiverPeopleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.bgImageV.mas_left).offset(10);
            make.top.equalTo(self.numberLbl.mas_bottom).offset(18);
            
        }];
        
    }
    
    
    return self;

}

- (void)data {



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
