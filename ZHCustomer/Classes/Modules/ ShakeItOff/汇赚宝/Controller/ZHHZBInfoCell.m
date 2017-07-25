//
//  ZHHZBInfoCell.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/24.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHHZBInfoCell.h"

@implementation ZHHZBInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {


    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
       
        self.titleLbl = [UILabel labelWithFrame:CGRectZero
                                   textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor whiteColor]
                                           font:FONT(15)
                                      textColor:[UIColor zh_textColor]];
        [self.contentView addSubview:self.titleLbl];
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.bottom.equalTo(self.contentView);
            make.left.equalTo(self.contentView.mas_left).offset(15);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.mas_equalTo(110);
            
        }];
        
        //
        self.contentLbl = [UILabel labelWithFrame:CGRectZero
                                   textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor whiteColor]
                                           font:FONT(15)
                                      textColor:[UIColor zh_themeColor]];
        [self.contentView addSubview:self.contentLbl];
        [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.bottom.equalTo(self.contentView);
            make.left.equalTo(self.titleLbl.mas_right).offset(10);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).offset(-25);
            
        }];
        
        //箭头
        UIImageView *imageV = [[UIImageView alloc] init];
        [self.contentView addSubview:imageV];
        self.arrowImageView = imageV;
        imageV.image = [UIImage imageNamed:@"支付更多"];
        imageV.contentMode = UIViewContentModeScaleAspectFill;
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.contentView).offset(-15);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.mas_offset(7);
            make.height.mas_equalTo(15);
            
        }];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor zh_lineColor];
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left);
            make.width.equalTo(self.contentView.mas_width);
            make.height.mas_equalTo(@(LINE_HEIGHT));
            make.top.equalTo(self.contentView.mas_top);
        }];
        
        
        
    }
    
    return self;

}



- (TLTextField *)tfByframe:(CGRect)frame
                 leftTitle:(NSString *)leftTitle
                titleWidth:(CGFloat)titleW
               placeholder:(NSString *)placeholder {
    
    TLTextField *tf = [[TLTextField alloc] initWithframe:frame leftTitle:leftTitle titleWidth:titleW placeholder:placeholder];
    UILabel *lbl = (UILabel *)tf.leftView.subviews[0];
    lbl.textColor = [UIColor zh_textColor2];
    tf.textColor = [UIColor zh_textColor];
    
    tf.enabled = NO;
    return tf;
    
}
@end
