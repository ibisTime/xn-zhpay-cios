//
//  ZHHZBCell.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/9.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHHZBCell.h"

@interface ZHHZBCell()

@property (nonatomic,strong) UILabel *contentLbl;
@property (nonatomic,strong) UILabel *distanceLbl;

@end


@implementation ZHHZBCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentLbl = [UILabel labelWithFrame:CGRectZero
                                     textAligment:NSTextAlignmentLeft
                                  backgroundColor:[UIColor clearColor]
                                             font:FONT(13)
                                        textColor:[UIColor zh_textColor]];
        [self addSubview:self.contentLbl];
        [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(13);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
            
        }];
        
        
        //距离
        self.distanceLbl = [UILabel labelWithFrame:CGRectZero
                                     textAligment:NSTextAlignmentLeft
                                  backgroundColor:[UIColor clearColor]
                                             font:FONT(13)
                                        textColor:[UIColor zh_textColor]];
        [self addSubview:self.distanceLbl];
        [self.distanceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentLbl.mas_top);
            make.right.equalTo(self.mas_right).offset(-LEFT_MARGIN);
            make.bottom.equalTo(self.contentLbl.mas_bottom);
        }];
        
//        //分享按钮
//        UIButton  *shareBtn = [[UIButton alloc] initWithFrame:CGRectZero title:@"分享" backgroundColor:[UIColor zh_themeColor]];
//        [self addSubview:shareBtn];
//        [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            
//            make.width.equalTo(@80);
//            
//        }];
        
        
        
        //hintlbl
//        UILabel *lbl = [UILabel labelWithFrame:CGRectZero textAligment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor] font:FONT(12) textColor:[UIColor zh_textColor2]];
//        [self addSubview:lbl];
//        lbl.text = @"分享过后即可领取奖励";
        
//        [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
//            
//            make.left.equalTo(self.mas_left).offset(LEFT_MARGIN);
//            maket.top.eq
//        }];
        
        
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

- (void)setHzb:(ZHHZBModel *)hzb {

    _hzb = hzb;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ 的汇赚宝",_hzb.mobile]];
    [attrStr addAttributes:@{
                             NSForegroundColorAttributeName : [UIColor zh_themeColor]
                             
                             } range:NSMakeRange(0, _hzb.mobile.length)];
    
    self.contentLbl.attributedText = attrStr;
    
    if ([_hzb.distance floatValue] > 1000) {
        
        NSString *disStr = [NSString stringWithFormat:@"%.2f",[_hzb.distance floatValue]/1000.0];
      self.distanceLbl.text =    [NSString stringWithFormat:@" %@ KM",disStr];
        
    } else {
        
     self.distanceLbl.text =  [NSString stringWithFormat:@" %@ M",_hzb.distance];
        
    }
    
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
