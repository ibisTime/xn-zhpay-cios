//
//  ZHDuoBaoCell.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/20.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHDuoBaoCell.h"
#import "ZHProgressView.h"
#import "ZHTwoLineView.h"

@interface ZHDuoBaoCell()

@property (nonatomic,strong) UIImageView *bgImageV;
@property (nonatomic,strong) UILabel *priceLbl;


@property (nonatomic,strong) UILabel *numberLbl;

@property (nonatomic,strong) UILabel *receiverPeopleLbl;
@property (nonatomic,strong) ZHProgressView *progressView;

@property (nonatomic, strong) ZHTwoLineView *accountView;
@property (nonatomic, strong) ZHTwoLineView *surplusView;
@property (nonatomic, strong) ZHTwoLineView *priceView;

@end

@implementation ZHDuoBaoCell

- (void)setDbModel:(ZHDBModel *)dbModel {

    _dbModel = dbModel;
    
    self.priceLbl.text = [_dbModel getPriceDetail];
    
    self.numberLbl.text = [NSString stringWithFormat:@"第 %@ 期",_dbModel.periods];
    
    self.progressView.progress = [_dbModel getProgress];
    

    self.accountView.bottomLbl.text = [NSString stringWithFormat:@"%@",_dbModel.totalNum];
    self.surplusView.bottomLbl.text = [NSString stringWithFormat:@"%ld",[_dbModel getSurplusPeople]];
    self.priceView.bottomLbl.text = [_dbModel.price convertToSimpleRealMoney];
    

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = [UIColor zh_backgroundColor];
        self.bgImageV = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.bgImageV];
        [self.bgImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(10);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.mas_equalTo(@135);
        }];
        
        //期号
        CGFloat w = 27;
        self.numberLbl = [UILabel labelWithFrame:CGRectZero
                                    textAligment:NSTextAlignmentCenter
                                 backgroundColor:[UIColor zh_themeColor]
                                            font:FONT(12)
                                       textColor:[UIColor whiteColor]];
        [self.bgImageV addSubview:self.numberLbl];
        self.numberLbl.layer.cornerRadius = w/2.0;
        self.numberLbl.layer.masksToBounds = YES;
        
        [self.numberLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bgImageV.mas_top);
            make.width.mas_equalTo(102);
            make.right.equalTo(self.bgImageV.mas_right).offset(13.5);
            make.height.mas_equalTo(27);
        }];
        
        //价格
        self.priceLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor clearColor]
                                          font:FONT(22)
                                     textColor:[UIColor whiteColor]];
        [self.bgImageV addSubview:self.priceLbl];
        [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgImageV.mas_left).offset(15);
            make.top.equalTo(self.bgImageV.mas_top).offset(30);
            
        }];
        
        //进度
        self.progressView = [[ZHProgressView alloc] initWithFrame:CGRectMake(0, 0, 0, 10)];
        [self.bgImageV addSubview:self.progressView];
        [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.priceLbl.mas_right).offset(18);
            make.width.mas_equalTo(155);
            make.centerY.equalTo(self.priceLbl.mas_centerY);
            make.height.mas_equalTo(10);
        }];
        
        //总需
        self.accountView = [[ZHTwoLineView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.accountView];

        //剩余人次
        self.surplusView = [[ZHTwoLineView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.surplusView];

        
        //单价
        self.priceView = [[ZHTwoLineView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.priceView];
        
        
        //
        [self.accountView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.priceLbl.mas_bottom).offset(21);
            make.left.equalTo(self.mas_left);
            make.height.mas_equalTo(45);
            make.right.equalTo(self.surplusView.mas_left);
            
            
            make.width.equalTo(self.surplusView);
        }];
        
        [self.surplusView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.priceLbl.mas_bottom).offset(21);
            make.height.mas_equalTo(45);

            make.width.equalTo(self.priceView);

            make.left.equalTo(self.accountView.mas_right);
            make.right.equalTo(self.priceView.mas_left);

            
        }];
        
        [self.priceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.priceLbl.mas_bottom).offset(21);
            make.right.equalTo(self.mas_right);
            make.height.mas_equalTo(45);
            make.left.equalTo(self.surplusView.mas_right);
            
        }];
        
        
        //
        self.accountView.topLbl.text = @"总需人次";
        self.surplusView.topLbl.text = @"剩余人次";
        self.priceView.topLbl.text = @"单价";
    
        
    }
    return self;
    
}

- (void)data {

    //

}


- (void)setType:(NSString *)type {

    UIColor *textColor ;
    if ([type isEqualToString:@"0"]) {
        self.bgImageV.image = [UIImage imageNamed:@"orangeBg"];
        self.progressView.backgroundView.backgroundColor = [UIColor colorWithHexString:@"#fec878"];
            self.progressView.forgroundView.backgroundColor = [UIColor colorWithHexString:@"#fb9f18"];
        
        textColor = [UIColor colorWithHexString:@"#974b05"];

        
    } else if ([type isEqualToString:@"1"]) {
        self.bgImageV.image = [UIImage imageNamed:@"yellowBg"];
        self.progressView.backgroundView.backgroundColor = [UIColor colorWithHexString:@"#f5e586"];
          self.progressView.forgroundView.backgroundColor = [UIColor colorWithHexString:@"#e9c905"];
        textColor = [UIColor colorWithHexString:@"#974b05"];

        
    } else if ([type isEqualToString:@"2"]) {
        self.bgImageV.image = [UIImage imageNamed:@"greenBg"];
        self.progressView.backgroundView.backgroundColor = [UIColor colorWithHexString:@"#8be9a1"];
             self.progressView.forgroundView.backgroundColor = [UIColor colorWithHexString:@"#10c060"];
        textColor = [UIColor colorWithHexString:@"#045f19"];


    }
    
    self.accountView.bottomLbl.textColor = textColor;
    self.priceView.bottomLbl.textColor = textColor;
    self.surplusView.bottomLbl.textColor = textColor;



}
@end
