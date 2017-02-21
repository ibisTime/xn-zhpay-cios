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

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor whiteColor];
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
                                   textColor:[UIColor colorWithHexString:@"#999999"]];
        [self.contentView addSubview:self.contentLbl];
        [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.ipLbl.mas_bottom).offset(5);
            make.left.equalTo(self.nameLbl.mas_left);
            
        }];
        
        
        
    }
    
    [self data];
    return self;
}

- (void)data {

    
    self.avatarImageV.image = [UIImage imageNamed:@"user_placeholder"];
    self.nameLbl.text = @"名字";
    self.ipLbl.text = @"（北京 IP：117：132：322）";
    self.contentLbl.text = @"中了100分润";
    

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
