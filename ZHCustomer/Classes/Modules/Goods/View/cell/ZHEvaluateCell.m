//
//  ZHEvaluateCell.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/27.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHEvaluateCell.h"
#import "TLHeader.h"
#import "UIColor+theme.h"

@interface ZHEvaluateCell()

@property (nonatomic,strong) UIImageView *avatar;
@property (nonatomic,strong) UILabel *nameLbl;

@property (nonatomic,strong) UIImageView *evaluateImageV;
@property (nonatomic,strong) UILabel *evaluateLbl;

@end
@implementation ZHEvaluateCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    
        self.avatar = [[UIImageView alloc] initWithFrame:CGRectMake(15, 9, 32, 32)];
        [self addSubview:self.avatar];
        self.avatar.image = [UIImage imageNamed:@"user_placeholder"];
        self.avatar.layer.cornerRadius = 16;
        self.avatar.clipsToBounds = YES;
//        self.evaluateLbl.layer.masksToBounds = YES;
//        self.evaluateLbl.clipsToBounds = YES;
        
        //
        self.nameLbl = [UILabel labelWithFrame:CGRectMake(self.avatar.xx + 23,0, SCREEN_WIDTH - self.avatar.xx - 100, [[self class] rowHeight])
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor whiteColor]
                                          font:[UIFont secondFont]
                                     textColor:[UIColor zh_textColor]];
        [self addSubview:self.nameLbl];
        
        //
        self.evaluateLbl = [UILabel labelWithFrame:CGRectZero
                                      textAligment:NSTextAlignmentCenter
                                   backgroundColor:[UIColor whiteColor]
                                              font:[UIFont secondFont]
                                         textColor:[UIColor zh_textColor]];
        [self addSubview:self.evaluateLbl];
        [self.evaluateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-15);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        //
        self.evaluateImageV = [[UIImageView alloc] init];
        [self addSubview:self.evaluateImageV];

        [self.evaluateImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.evaluateLbl.mas_left).offset(-9);
            make.centerY.equalTo(self.mas_centerY);
            make.height.mas_equalTo(@18);
            make.width.mas_equalTo(@18);

        }];
        //
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor zh_lineColor];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.top.mas_equalTo(49.5);
            make.height.equalTo(@(LINE_HEIGHT));
        }];
        
    
    }
    
 
    
    return self;
}


- (void)setEvaluateModel:(ZHEvaluateModel *)evaluateModel {
    _evaluateModel = evaluateModel;
    
    if ([evaluateModel.photo isKindOfClass:[NSNull class]]) {
        self.avatar.image = [UIImage imageNamed:@"user_placeholder"];

    } else {
    
        [self.avatar sd_setImageWithURL:[NSURL URLWithString:[evaluateModel.photo convertThumbnailImageUrl]] placeholderImage:[UIImage imageNamed:@"user_placeholder"]];
                                                                   
    }
    
    self.nameLbl.text = evaluateModel.nickname;
    
    NSString *evaluteText = @"好评";
    
//    if([_evaluateModel.evaluateType isEqualToString:@"A"]){ //好评
//        
//        
//    } else if([_evaluateModel.evaluateType isEqualToString:@"B"]) { //中评
//        evaluteText = @"中评";
//        
//    } else { //差评
//        evaluteText = @"差评";
//        
//    }
    
    self.evaluateLbl.text = evaluteText;
    self.evaluateImageV.image = [UIImage imageNamed:evaluteText];
    
}


+ (CGFloat)rowHeight {

    return 50.0;

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
