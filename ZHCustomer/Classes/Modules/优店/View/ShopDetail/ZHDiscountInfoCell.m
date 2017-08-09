//
//  ZHDiscountInfoCell.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/23.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHDiscountInfoCell.h"
#import "TLHeader.h"
#import "ZHUser.h"
#import "UIColor+theme.h"

@interface ZHDiscountInfoCell()


@end


@implementation ZHDiscountInfoCell

+ (CGFloat)rowHeight {

    return 63;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 15, 0.5)];
        lineView.backgroundColor = [UIColor zh_lineColor];
        [self addSubview:lineView];
        
     self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"更多"]];
        
  
    self.mainLbl = [UILabel labelWithFrame:CGRectMake(15, 13, SCREEN_WIDTH -35,0)
                              textAligment:NSTextAlignmentLeft
                           backgroundColor:[UIColor clearColor]
                                      font:[UIFont secondFont]
                                 textColor:[UIColor zh_themeColor]];
        
    [self addSubview:self.mainLbl];
     self.mainLbl.height = [[UIFont secondFont] lineHeight];
        
    self.subLbl = [UILabel labelWithFrame:CGRectMake(15,self.mainLbl.yy +  4,  self.mainLbl.width,0)
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor clearColor]
                                          font:FONT(13)
                                     textColor:[UIColor zh_textColor]];
    self.subLbl.height = [FONT(13) lineHeight];
    [self addSubview:self.subLbl];
        
        
    
    }
    return self;
    
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
