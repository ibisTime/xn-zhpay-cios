//
//  ZHChatUserCell.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/4.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHChatUserCell.h"
//#import "EMConversation.h"
//#import <HyphenateLite/EMConversation.h>
//#import <HyphenateLite/EMMessage.h>

#import "TLMsgBadgeView.h"

@interface ZHChatUserCell()

@property (nonatomic,strong) UIImageView *iconImageV;
@property (nonatomic,strong) UILabel *nameLbl;
//@property (nonatomic,strong) UILabel *typeLbl;
@property (nonatomic,strong) UILabel *timeLbl;
//@property (nonatomic,strong) TLMsgBadgeView *msgBadgeView;


@end

@implementation ZHChatUserCell

+ (ZHChatUserCell *)celllWithTableView:(UITableView *)tableV indexPath:(NSIndexPath *)idx

                                 model:(id)model {

    static NSString *zhChatUserCellId = @"zhChatUserCellId";
    ZHChatUserCell *cell = [tableV dequeueReusableCellWithIdentifier:zhChatUserCellId];
    if (!cell) {
        cell = [[ZHChatUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:zhChatUserCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.referral = model;
    return cell;

}

- (void)setReferral:(ZHReferralModel *)referral {

    _referral = referral;
    
    if (referral.userExt[@"photo"]) {
        [self.iconImageV sd_setImageWithURL:[NSURL URLWithString:[referral.userExt[@"photo"] convertThumbnailImageUrl]] placeholderImage:[UIImage imageNamed:@"user_placeholder"]];

    } else {
    
        self.iconImageV.image = [UIImage imageNamed:@"user_placeholder"];

    }
    
    //
//    手机号：%@
    NSString *nickName = [NSString stringWithFormat:@"%@",_referral.nickname];
    
    CGSize size1 = [nickName calculateStringSize:CGSizeMake(100, 30) font:[UIFont secondFont]];
    self.nameLbl.width = size1.width;
    self.nameLbl.text = nickName;
    
    //
    
    NSString *str;
    UIColor *backgroundColor = [UIColor whiteColor];
    
    
    
    if ([self.level isEqualToString:@"1"]) {
        
        backgroundColor = [UIColor colorWithHexString:@"#fc8461"];

        
    } else if ([self.level isEqualToString:@"2"]) {
    
        backgroundColor = [UIColor colorWithHexString:@"#73cb98"];

    } else if ([self.level isEqualToString:@"3"]) {

        backgroundColor = [UIColor colorWithHexString:@"#60d4e5"];

    }
    
    
    
//    
//     if ([_referral.level isEqualToString:@"0"]) {
//        
//        str = @"P1";
//        
//        
//    } else if ([_referral.level isEqualToString:@"1"]  ) {
//        
//        str = @"C1";
//        backgroundColor = [UIColor colorWithHexString:@"#fc8461"];
//        
//    }  else if([_referral.level isEqualToString:@"2"]) {
//    
//        str = @"C2";
//        backgroundColor = [UIColor colorWithHexString:@"#73cb98"];
//        
//    } else  if ([_referral.level isEqualToString:@"3"]) {
//    
//        str = @"C3";
//        backgroundColor = [UIColor colorWithHexString:@"#60d4e5"];
//
//
//    }
    
    
    
    self.layer.backgroundColor = backgroundColor.CGColor;
    self.timeLbl.text = [NSString stringWithFormat:@"加入时间:%@",[_referral.createDatetime convertToDetailDate]];

//    CGSize size2 = [str calculateStringSize:CGSizeMake(100, 30) font:FONT(10)];
//    self.typeLbl.x = self.nameLbl.xx + 8;
//    self.typeLbl.width = size2.width + 16;
//    self.typeLbl.text = str;
    
    
//    EMConversation *conversion = self.referral.conversion;
    if (0) {
//
//        if (!conversion.latestMessage.localTime || conversion.latestMessage.localTime == 0) {
//            
//            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//            formatter.dateFormat = @"yyyy-MM-dd hh:mm";
//            //
//            self.timeLbl.text = [NSString stringWithFormat:@"来访时间：%@",[formatter stringFromDate:[NSDate date]]];
//            self.msgBadgeView.msgCount = conversion.unreadMessagesCount;
//            
//        } else {
//        
//            NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:conversion.latestMessage.localTime/1000.0];
//            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//            formatter.dateFormat = @"yyyy-MM-dd hh:mm";
//            //
//            self.timeLbl.text = [NSString stringWithFormat:@"来访时间：%@",[formatter stringFromDate:date]] ;
//            self.msgBadgeView.msgCount = conversion.unreadMessagesCount;
//        
//        }


    } else {
    

    }

}



+ (CGFloat)rowHeight {
    
    
    return 75;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.iconImageV = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_MARGIN, LEFT_MARGIN, 45, 45)];
        self.iconImageV.layer.cornerRadius = self.iconImageV.height/2.0;
        self.iconImageV.clipsToBounds = YES;
        [self addSubview:self.iconImageV];
        
        //消息提示
//        self.msgBadgeView = [[TLMsgBadgeView alloc] initWithFrame:CGRectMake(self.iconImageV.xx  - 15, 11, 20, 15)];
//        [self addSubview:self.msgBadgeView];
//        self.msgBadgeView.isRightResize = YES;
//
//        
        //
        self.nameLbl = [UILabel labelWithFrame:CGRectMake(self.iconImageV.xx + 10, 20, 10, [FONT(15) lineHeight]) textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor clearColor]
                                          font:[UIFont secondFont]
                                     textColor:[UIColor whiteColor]];
        [self addSubview:self.nameLbl];
        
        [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImageV.mas_right).offset(10);
            make.top.equalTo(self.mas_top).offset(20);
        }];
        
//        [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.iconImageV.mas_right).offset(10);
//            make.top.equalTo(self.mas_top).offset(20);
//
//        }];
        //
        //类型
//        self.typeLbl = [UILabel labelWithFrame:CGRectMake(0, self.nameLbl.y, 100, self.nameLbl.height)
//                                  textAligment:NSTextAlignmentCenter
//                               backgroundColor:[UIColor whiteColor]
//                                          font:FONT(10)
//                                     textColor:[UIColor zh_themeColor]];
////        [self addSubview:self.typeLbl];
//        self.typeLbl.layer.masksToBounds = YES;
//        self.typeLbl.layer.cornerRadius = [FONT(15) lineHeight]/2.0;
//        self.typeLbl.layer.borderWidth = 1;
//        self.typeLbl.layer.borderColor = [UIColor zh_themeColor].CGColor;
        
//        [self.typeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.nameLbl.mas_right).offset(8);
//            make.top.equalTo(self.mas_top).offset(20);
//            make.height.mas_equalTo(@([FONT(15) lineHeight]));
//            
//        }];
        
        //时间
        self.timeLbl = [UILabel labelWithFrame:CGRectZero textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor clearColor]
                                          font:FONT(11)
                                     textColor:[UIColor whiteColor]];
        [self addSubview:self.timeLbl];
        
        [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImageV.mas_right).offset(10);
            make.top.equalTo(self.nameLbl.mas_bottom).offset(8);
            
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

- (NSMutableAttributedString *)attStrWithStr:(NSString *)str {

    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.tailIndent = 15;
    style.firstLineHeadIndent = 10;
    style.alignment = NSTextAlignmentCenter;

    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{
                               NSParagraphStyleAttributeName : style
                                                                                                        }];
    return attr;
    
}

@end
