//
//  ZHChatMerchantCell.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/4.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHChatMerchantCell.h"

@interface ZHChatMerchantCell()

@property (nonatomic,strong) UIImageView *iconImageV;
@property (nonatomic,strong) UILabel *nameLbl;
@property (nonatomic,strong) UILabel *timeLbl;
@property (nonatomic,strong) UILabel *totalMoneyLbl;

@end


@implementation ZHChatMerchantCell

+ (ZHChatMerchantCell *)celllWithTableView:(UITableView *)tableV indexPath:(NSIndexPath *)idx
                                     model:(id)model {
    
    
    static NSString *zhChatMerchantCellId = @"zhChatMerchantCell";
    ZHChatMerchantCell *cell = [tableV dequeueReusableCellWithIdentifier:zhChatMerchantCellId];
    if (!cell) {
        cell = [[ZHChatMerchantCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:zhChatMerchantCellId];
    }
    
    
//    cell.iconImageV.image = [UIImage imageNamed:@"user_placeholder"];
//    cell.nameLbl.text = @"名字";
//    cell.typeLbl.text = @"直接推荐";
//
    [cell data];
    return cell;



}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.iconImageV = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_MARGIN, LEFT_MARGIN, 45, 45)];
        [self addSubview:self.iconImageV];
        
        //
        self.nameLbl = [UILabel labelWithFrame:CGRectMake(self.iconImageV.xx + 10, 20, SCREEN_WIDTH - (self.iconImageV.xx + 10), [FONT(15) lineHeight]) textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor clearColor]
                                          font:[UIFont secondFont]
                                     textColor:[UIColor zh_textColor]];
        [self addSubview:self.nameLbl];
        
        
        //时间
        self.timeLbl = [UILabel labelWithFrame:CGRectMake( self.nameLbl.x, self.nameLbl.yy + 8, self.nameLbl.width, [FONT(11) lineHeight]) textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor whiteColor]
                                          font:FONT(11)
                                     textColor:[UIColor zh_textColor2]];
        [self addSubview:self.timeLbl];
        
        //
        self.totalMoneyLbl = [UILabel labelWithFrame:CGRectMake( self.nameLbl.x, self.timeLbl.yy + 7, self.nameLbl.width, [FONT(11) lineHeight]) textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor clearColor]
                                          font:FONT(11)
                                     textColor:[UIColor zh_textColor2]];
        [self addSubview:self.totalMoneyLbl];
        
        
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

- (void)data {

    self.iconImageV.image = [UIImage imageNamed:@"user_placeholder"];
    self.nameLbl.text = @"xxxxx";
    self.timeLbl.text = @"签约时间：2016-11-09 14:30";
    self.totalMoneyLbl.text = @"累计营业额：￥1000003";

}

+ (CGFloat)rowHeight {


    return 89;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
