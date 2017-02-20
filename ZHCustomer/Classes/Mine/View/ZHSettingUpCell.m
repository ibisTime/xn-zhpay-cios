//
//  ZHSettingUpCell.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/28.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHSettingUpCell.h"


@interface ZHSettingUpCell()


@property (nonatomic,strong) UIImageView *leftImageView;
@property (nonatomic,strong) UILabel *textLbl;


@end

@implementation ZHSettingUpCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.leftImageView = [[UIImageView alloc] init];
        [self addSubview:self.leftImageView];
        [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@18);
            make.height.equalTo(@18);
            make.left.equalTo(self.mas_left).offset(19);
            make.centerY.equalTo(self);
        }];
        
        self.textLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor whiteColor]
                                          font:FONT(14)
                                     textColor:[UIColor zh_textColor]];
        [self addSubview:self.textLbl];
        [self.textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftImageView.mas_right).offset(9);
            make.centerY.equalTo(self);
        }];
        
        
        UIImageView *arrow =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_more"]];
        [self addSubview:arrow];
        arrow.contentMode = UIViewContentModeScaleAspectFit;
        [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.mas_right).offset(-15);
            make.width.mas_equalTo(@6);
            make.height.mas_equalTo(@10);
            make.centerY.equalTo(self);
            
        }];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor zh_lineColor];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.textLbl.mas_left);
            make.height.mas_equalTo(@0.5);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
    }
    
    return self;
}


- (void)setItem:(ZHSettingModel *)item {

    
    _item = item;
    
    self.leftImageView.image = [UIImage imageNamed:_item.imgName];
    self.textLbl.text =  _item.text;
    

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
