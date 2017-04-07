//
//  ZHParameterCell.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/4/6.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHParameterCell.h"

@implementation ZHParameterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.keyLbl = [UILabel labelWithFrame:CGRectZero
                                 textAligment:NSTextAlignmentLeft
                              backgroundColor:[UIColor whiteColor]
                                         font:FONT(15)
                                    textColor:[UIColor zh_textColor]];
        [self.contentView addSubview:self.keyLbl];
        self.keyLbl.numberOfLines = 0;

        
        self.valueLbl = [UILabel labelWithFrame:CGRectZero
                                 textAligment:NSTextAlignmentLeft
                              backgroundColor:[UIColor whiteColor]
                                         font:FONT(15)
                                    textColor:[UIColor colorWithHexString:@"#606060"]];
        [self.contentView addSubview:self.valueLbl];
        self.valueLbl.numberOfLines = 0;
        
        CGFloat margin = 15;
        //
        [self.keyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(margin);
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.width.mas_equalTo(70);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-margin);
        }];
        
        [self.valueLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.keyLbl.mas_top);
            make.left.equalTo(self.keyLbl.mas_right).offset(15);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-margin);

        }];
        
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor zh_lineColor];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.keyLbl.mas_left);
            make.width.equalTo(self.mas_width);
            make.height.mas_equalTo(LINE_HEIGHT);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
    }

    return self;
    
}

@end
