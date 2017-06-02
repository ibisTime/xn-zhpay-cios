//
//  ZHPayInfoCell.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/25.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHPayInfoCell.h"
#import "Masonry.h"

@interface ZHPayInfoCell()



@end

@implementation ZHPayInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.titleLbl = [UILabel labelWithFrame:CGRectZero
                                   textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor whiteColor]
                                           font:[UIFont secondFont]
                                      textColor:[UIColor zh_textColor]];
        [self addSubview:self.titleLbl];
        
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.centerY.equalTo(self);
            make.width.mas_equalTo(70);
        }];
        
        //
        self.arrowImageV = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.arrowImageV];
        self.arrowImageV.image = [UIImage imageNamed:@"more"];
        [self.arrowImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.mas_right).offset(-15);
            make.centerY.equalTo(self);
            make.width.mas_equalTo(@10);
            make.height.mas_equalTo(@17);
        }];
        
        //
        self.infoLbl = [UILabel labelWithFrame:CGRectZero
                                   textAligment:NSTextAlignmentRight
                                backgroundColor:[UIColor whiteColor]
                                           font:FONT(14)
                                      textColor:[UIColor zh_themeColor]];
        [self addSubview:self.infoLbl];
        [self.infoLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.titleLbl.mas_right);
//            make.right.equalTo(self.arrowImageV.mas_left).offset(-15);
            make.right.equalTo(self.mas_right).offset(-15);
            make.centerY.equalTo(self);
            
        }];
        
        //
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor zh_lineColor];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.width.equalTo(self.mas_width);
            make.height.mas_equalTo(LINE_HEIGHT);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
    }
    
    return self;

}

- (void)setHidenArrow:(BOOL)hidenArrow {

    _hidenArrow = hidenArrow;
    if (_hidenArrow) {
        
        [self.infoLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.titleLbl.mas_right);
            //            make.right.equalTo(self.arrowImageV.mas_left).offset(-15);
            make.right.equalTo(self.mas_right).offset(-15);
            make.centerY.equalTo(self);
            
        }];
     
        
    } else {
        
        [self.infoLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.arrowImageV.mas_left).offset(-15);
            make.centerY.equalTo(self);
        }];
        
    }
    
}

//- (void)data {
//
//    self.titleLbl.text = @"消费金额";
//    self.infoLbl.text = @"满1000减100";
//
//}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
