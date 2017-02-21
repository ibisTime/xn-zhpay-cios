//
//  ZHDuoBaoTimeCell.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHDuoBaoTimeCell.h"

@interface ZHDuoBaoTimeCell()

@property (nonatomic, strong) UILabel *timeLbl;

@end

@implementation ZHDuoBaoTimeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    
        self.timeLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor clearColor]
                                          font:FONT(12)
                                     textColor:[UIColor colorWithHexString:@"#2570fd"]];
        [self.contentView addSubview:self.timeLbl];
        self.timeLbl.layer.cornerRadius = 10;
        self.timeLbl.clipsToBounds = YES;
        self.timeLbl.backgroundColor = [UIColor colorWithHexString:@"#f8f8f8"];
        self.timeLbl.layer.borderColor = [UIColor colorWithHexString:@"#2570fd"].CGColor;
        self.timeLbl.layer.borderWidth = 1;
        
        
        [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.contentView.mas_top).offset(10);
            make.height.mas_equalTo(20);
            make.left.equalTo(self.contentView.mas_left).offset(15);
            
        }];
        
        
        //
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor zh_lineColor];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.mas_left).offset(24.5);
            make.width.mas_equalTo(1);
            make.top.equalTo(self.contentView.mas_top);
            make.bottom.equalTo(self.contentView.mas_bottom);
            
        }];
        
    
    }
    [self data];
    
    return self;
    
}

- (void)data {

   self.timeLbl.text = @"2013-32-33";
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
