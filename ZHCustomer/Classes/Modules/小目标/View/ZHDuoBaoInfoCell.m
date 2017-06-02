//
//  ZHDuoBaoInfoCell.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHDuoBaoInfoCell.h"

@implementation ZHDuoBaoInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    
        self.textLbl = [UILabel labelWithFrame:CGRectZero
                                   textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor clearColor]
                                           font:FONT(15)
                                      textColor:[UIColor zh_textColor]];
        [self.contentView addSubview:self.textLbl];
        [self.textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(15);
            make.right.lessThanOrEqualTo(self.contentView);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
        //箭头
        UIImageView *imageV = [[UIImageView alloc] init];
        [self.contentView addSubview:imageV];
        imageV.image = [UIImage imageNamed:@"支付更多"];
        imageV.contentMode = UIViewContentModeScaleAspectFill;
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.contentView).offset(-15);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.mas_offset(7);
            make.height.mas_equalTo(15);
            
        }];
        
        //
        
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


@end
