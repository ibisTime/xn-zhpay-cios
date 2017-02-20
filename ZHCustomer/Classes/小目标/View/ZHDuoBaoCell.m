//
//  ZHDuoBaoCell.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/20.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHDuoBaoCell.h"
#import "ZHProgressView.h"

@interface ZHDuoBaoCell()

@property (nonatomic,strong) UIImageView *bgImageV;
@property (nonatomic,strong) UILabel *priceLbl;


@property (nonatomic,strong) UILabel *numberLbl;

@property (nonatomic,strong) UILabel *receiverPeopleLbl;
@property (nonatomic,strong) ZHProgressView *progressView;


@end

@implementation ZHDuoBaoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    
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
                                          font:FONT(25)
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
            make.width.mas_equalTo(@155);
            make.centerY.equalTo(self.priceLbl.mas_centerY);
        }];
        
        
        
     
    
        
    }
    [self data];
    return self;
    
}

- (void)data {

    //
    self.priceLbl.text = @"100分润";
    self.numberLbl.text = @"第1213期";
    self.progressView.progress = 0.42;
}

- (void)setType:(NSString *)type {

    if ([type isEqualToString:@"1"]) {
        self.bgImageV.image = [UIImage imageNamed:@"orangeBg"];
        self.progressView.backgroundView.backgroundColor = [UIColor colorWithHexString:@"#fec878"];
            self.progressView.forgroundView.backgroundColor = [UIColor colorWithHexString:@"#fb9f18"];

        
    } else if ([type isEqualToString:@"2"]) {
        self.bgImageV.image = [UIImage imageNamed:@"yellowBg"];
        self.progressView.backgroundView.backgroundColor = [UIColor colorWithHexString:@"#f5e586"];
          self.progressView.forgroundView.backgroundColor = [UIColor colorWithHexString:@"#e9c905"];

        
    } else if ([type isEqualToString:@"3"]) {
        self.bgImageV.image = [UIImage imageNamed:@"greenBg"];
        self.progressView.backgroundView.backgroundColor = [UIColor colorWithHexString:@"#10c060"];

    }

}
@end
