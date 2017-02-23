//
//  ZHDuoBaoRecordCell.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHDuoBaoRecordCell.h"


@interface ZHDuoBaoRecordCell()

@property (nonatomic, strong) UIImageView *avatarImageV;
@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *ipLbl;
@property (nonatomic, strong) UILabel *contentLbl;



@end


@implementation ZHDuoBaoRecordCell


- (void)setHistoryModel:(ZHDBHistoryModel *)historyModel {

    _historyModel = historyModel;
    
    
    if (_historyModel.photo) {
        [self.avatarImageV sd_setImageWithURL:[NSURL URLWithString:[_historyModel.photo convertThumbnailImageUrl]] placeholderImage:[UIImage imageNamed:@"user_placeholder"]];

    } else {
    
        self.avatarImageV.image = [UIImage imageNamed:@"user_placeholder"];
        
    }
    
    self.nameLbl.text = _historyModel.nickname;
    
    if (_historyModel.city) {
        
        self.ipLbl.text = [NSString stringWithFormat:@"(%@ %@)",_historyModel.city ,_historyModel.ip];

    } else {
        
        self.ipLbl.text = [NSString stringWithFormat:@"(%@)",_historyModel.ip];
        
        [TLNetworking GET:[NSString stringWithFormat:@"http://ip.taobao.com/service/getIpInfo.php?ip=%@",_historyModel.ip]
               parameters:nil success:^(NSString *msg, id data) {
                   
                   if (![data[@"code"] isEqual:@1]) {
                       
                       _historyModel.city =  data[@"data"][@"city"];
                       
                       if ([data[@"data"][@"ip"] isEqualToString:_historyModel.ip]) {
                           
                           self.ipLbl.text = [NSString stringWithFormat:@"(%@ %@)",_historyModel.city ,_historyModel.ip];
                           
                       }
                   }
                   
               } abnormality:nil failure:nil];
    
    }
    
  

    
    NSString *dateStr = [_historyModel.investDatetime convertToDetailDate];
    if ([_historyModel.jewel.status isEqual:@1]) { //已中奖
        
        NSString *priceStr = [_historyModel.jewel getPriceDetail];
        NSString *allStr = [NSString stringWithFormat:@"中了%@大奖 %@",priceStr,dateStr];
        
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:allStr];
        
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor zh_themeColor] range:NSMakeRange(2, priceStr.length)];
        
       [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#999999"] range:NSMakeRange(6 + priceStr.length, dateStr.length)];

        self.contentLbl.attributedText = attr;
        
    } else {// 参与
        
        NSString *countStr = [NSString stringWithFormat:@"%@",_historyModel.times];
        
        NSString *allStr = [NSString stringWithFormat:@"参与了%@人次 %@",countStr,dateStr];
    
        
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:allStr];
        
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor zh_themeColor] range:NSMakeRange(3, countStr.length)];
       [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#999999"] range:NSMakeRange(6 + countStr.length, dateStr.length)];
        self.contentLbl.attributedText = attr;

    
    }
    

}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //线
        UIView *topLine = [[UIView alloc] init];
        topLine.backgroundColor = [UIColor colorWithHexString:@"#999999"];
        [self.contentView addSubview:topLine];

        //头像
        CGFloat avatarW = 35;
        self.avatarImageV = [[UIImageView alloc] init];
        [self.contentView addSubview:self.avatarImageV];
        self.avatarImageV.layer.cornerRadius = avatarW/2.0;
        self.avatarImageV.clipsToBounds = YES;
        
        
        [self.avatarImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView.mas_left).offset(15);
            make.width.height.mas_equalTo(avatarW);
            make.top.equalTo(self.contentView.mas_top).offset(10);
            
        }];
        
        [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.contentView.mas_top);
            make.width.mas_equalTo(1);
//            make.height.mas_equalTo(55);
            make.centerX.equalTo(self.avatarImageV.mas_centerX);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-1);
            
        }];
        
        //名字
        self.nameLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor clearColor]
                                          font:FONT(12)
                                     textColor:[UIColor colorWithHexString:@"#2570fd"]];
        [self.contentView addSubview:self.nameLbl];
        [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarImageV.mas_top);
            make.left.equalTo(self.avatarImageV.mas_right).offset(12);

        }];
        
        //ip
        self.ipLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor clearColor]
                                          font:FONT(12)
                                     textColor:[UIColor colorWithHexString:@"#999999"]];
        [self.contentView addSubview:self.ipLbl];
        [self.ipLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.nameLbl.mas_bottom).offset(6);
            make.left.equalTo(self.nameLbl.mas_left);
            
        }];
        
        
        //--内容
        self.contentLbl = [UILabel labelWithFrame:CGRectZero
                                textAligment:NSTextAlignmentLeft
                             backgroundColor:[UIColor clearColor]
                                        font:FONT(12)
                                   textColor:[UIColor zh_textColor]];
        [self.contentView addSubview:self.contentLbl];
        [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.ipLbl.mas_bottom).offset(5);
            make.left.equalTo(self.nameLbl.mas_left);
            
        }];
        
    }
    
    return self;
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
