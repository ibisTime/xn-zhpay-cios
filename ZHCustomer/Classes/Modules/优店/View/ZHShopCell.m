//
//  ZHShopCell.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/23.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHShopCell.h"
#import "TLHeader.h"
#import "UIColor+theme.h"

@interface ZHShopCell()

@property (nonatomic,strong) UIImageView *coverImageView;
//
@property (nonatomic,strong) UILabel *nameLbl;
@property (nonatomic,strong) UILabel *advLbl; //广告语

//优惠
//@property (nonatomic,strong) UIImageView *discountImageView;
@property (nonatomic,strong) UILabel *discountLbl;

//优惠
@property (nonatomic,strong) UIImageView *locationImageView;
@property (nonatomic,strong) UILabel *distanceLbl;

@property (nonatomic,copy) NSAttributedString *locationAttrStr;



@end

@implementation ZHShopCell

+ (CGFloat)rowHeight {
    
    return 96;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.isShowLocation = YES;
        self.isShowShopStatus = NO;
        [self setUpUI];
        
    }
//    [self data];
    return self;
}

//- (void)setIsShowShopStatus:(BOOL)isShowShopStatus {
//
//    _isShowShopStatus = isShowShopStatus;
//    
//    if (!self.shop) {
//        return;
//    }
//    
//    if (self.shop.status isEqualToString:@"3") {
//        <#statements#>
//    }
//    self.nameLbl.text = [NSString stringWithFormat:@"%@",self.shop.name,];
//    
//}

- (void)setIsShowLocation:(BOOL)isShowLocation {

    _isShowLocation = isShowLocation;
    
    self.distanceLbl.hidden = !isShowLocation;
    
}

- (NSAttributedString *)locationAttrStr {

    if (!_locationAttrStr) {
        
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
        textAttachment.image = [UIImage imageNamed:@"位置"];
        textAttachment.bounds = CGRectMake(0, -2, 9, 12);
        _locationAttrStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
        
    }
    return _locationAttrStr;

}

- (void)data {

//  [self.coverImageView sd_setImageWithURL:[NSURL new] placeholderImage:nil];
    self.nameLbl.text = @"天使村餐厅蓝蓝蓝";
    self.advLbl.text = @"特别娜娜娜娜呢";
    self.discountLbl.text = @"满50减20";

    NSMutableAttributedString *mutableAttr = [[NSMutableAttributedString alloc] initWithAttributedString:self.locationAttrStr];
    [mutableAttr appendAttributedString: [[NSAttributedString alloc] initWithString:@" 3.4KM"]];
    self.distanceLbl.attributedText = mutableAttr;
    
}

- (void)setShop:(ZHShop *)shop {

    _shop = shop;
    NSString *coverUrl = [_shop.advPic convertThumbnailImageUrl];
    
    [self.coverImageView sd_setImageWithURL:[[NSURL alloc] initWithString:coverUrl] placeholderImage:nil];
    
    NSString *shopNameStr = nil;
    if (self.isShowShopStatus) {
        
        if ([_shop isOpen]) {
            
            shopNameStr = [NSString stringWithFormat:@"%@(营业中)",self.shop.name];
            
        } else {
        
            shopNameStr = _shop.name;

        }
        
    } else {
    
    
        shopNameStr = _shop.name;

    }
   
    self.nameLbl.text = shopNameStr;

    self.discountLbl.text = [_shop isGiftMerchant] ? @"礼品商" : @"普通商家";
    
    self.advLbl.text = _shop.slogan;
    
    //
    NSMutableAttributedString *mutableAttr = [[NSMutableAttributedString alloc] initWithAttributedString:self.locationAttrStr];
    [mutableAttr appendAttributedString: [[NSAttributedString alloc] initWithString:[_shop distanceDescription]]];
    self.distanceLbl.attributedText = mutableAttr;

}

- (void)setUpUI {

    self.coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 80, 65)];
    self.coverImageView.layer.borderWidth = 0.5;
    self.coverImageView.layer.borderColor = [UIColor colorWithHexString:@"#dedede"].CGColor;
    self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.coverImageView.layer.cornerRadius = 2;
    self.coverImageView.layer.masksToBounds = YES;
    self.coverImageView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.coverImageView];
    
    //
    self.nameLbl = [UILabel labelWithFrame:CGRectMake(self.coverImageView.xx + 14, self.coverImageView.y - 1, SCREEN_WIDTH - self.coverImageView.xx - 28, 20)
                              textAligment:NSTextAlignmentLeft
                           backgroundColor:[UIColor clearColor]
                                      font:[UIFont secondFont]
                                 textColor:[UIColor zh_textColor]];
    self.nameLbl.height = [[UIFont secondFont] lineHeight];
    [self addSubview:self.nameLbl];
    
    //
    self.advLbl = [UILabel labelWithFrame:CGRectMake(self.nameLbl.x, self.nameLbl.yy + 3, self.nameLbl.width, ceilf([FONT(11) lineHeight]*2))
                             textAligment:NSTextAlignmentLeft
                          backgroundColor:[UIColor whiteColor]
                                     font:FONT(11)
                                textColor:[UIColor zh_textColor2]];
//    self.advLbl.height = [FONT(11) lineHeight];
    self.advLbl.numberOfLines = 2;
    [self addSubview:self.advLbl];
    
    //
//    self.discountImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.nameLbl.x, self.advLbl.yy + 3, 15, 15)];
//    //抵
//    self.discountImageView.image = [UIImage imageNamed:@"减"];
//    [self addSubview:self.discountImageView];
//
    
    
    //
//    CGFloat disCountLblW = SCREEN_WIDTH - self.discountImageView.xx - 5 - 120;
    
    self.discountLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor whiteColor]
                                          font:FONT(11)
                                     textColor:[UIColor zh_textColor2]];
    [self addSubview:self.discountLbl];
    
    [self.discountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.nameLbl.mas_left);
        make.top.equalTo(self.advLbl.mas_bottom).offset(3);
        make.height.mas_equalTo(15);
        
    }];
    
    
    //位置
    self.distanceLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentRight
                               backgroundColor:[UIColor whiteColor]
                                          font:FONT(11)
                                     textColor:[UIColor zh_textColor]];
    [self addSubview:self.distanceLbl];
    [self.distanceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.centerY.equalTo(self.discountLbl.mas_centerY);
        make.height.mas_equalTo(15);
    }];
    
    
//    [self.discountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_discountImageView.mas_right).offset(5);
//        make.top.equalTo(self.discountImageView.mas_top).offset(5);
//        make.right.lessThanOrEqualTo(self.distanceLbl.mas_left);
//    }];
//    
//    [self.distanceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.greaterThanOrEqualTo(self.discountImageView.mas_right);
//        make.top.equalTo(self.discountLbl.mas_top);
//        make.right.equalTo(self.mas_right).offset(-15);
//    }];

    //
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, [[self class] rowHeight] - 0.5, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    [self addSubview:line];
    
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
