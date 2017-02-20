//
//  ZHRecordListCell.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/13.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHRecordListCell.h"

@interface ZHRecordListCell()

//时间
@property (nonatomic,strong) UILabel *timeLbl;
@property (nonatomic,strong) UILabel *countLbl;
@property (nonatomic,strong) UILabel *lookLbl;

@end

@implementation ZHRecordListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        //时间
        self.timeLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor whiteColor] font:FONT(12) textColor:[UIColor zh_textColor]];
        [self addSubview:self.timeLbl];
        self.timeLbl.text = @"2017-0123";
        [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        
        //
        self.lookLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor whiteColor]
                                          font:FONT(12)
                                     textColor:[UIColor zh_themeColor]];
        self.lookLbl.text = @"查看号码";
        [self addSubview:self.lookLbl];
        
        [self.lookLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
            make.right.equalTo(self.mas_right).offset(-15);
        }];
        
        //
        self.countLbl = [UILabel labelWithFrame:CGRectZero textAligment:NSTextAlignmentRight backgroundColor:[UIColor whiteColor] font:FONT(12) textColor:[UIColor zh_textColor]];
        [self addSubview:self.countLbl];
        [self.countLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
            make.right.equalTo(self.lookLbl.mas_left).offset(-25);
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

- (void)setRecord:(ZHMineTreasureModel *)record {

    _record = record;
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
    
     NSDate *date = [TLTool getDateByString:record.createDatetime];
     NSString *timeStr =  [formatter stringFromDate:date];
    
    
    self.timeLbl.text = timeStr;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld人次",self.record.jewelRecordNumberList.count]];
    
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor zh_themeColor] range:NSMakeRange(0, [NSString stringWithFormat:@"%ld",self.record.jewelRecordNumberList.count].length)];
    self.countLbl.attributedText = attrStr;
    

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
