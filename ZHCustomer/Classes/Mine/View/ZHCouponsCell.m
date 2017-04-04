//
//  ZHCouponsCell.m
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/20.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHCouponsCell.h"
#import "ZHShop.h"

@interface ZHCouponsCell()

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *soldOutImageView;

@property (nonatomic,strong) UILabel *infoLbl;

@property (nonatomic,strong) UILabel *titleLbl;

@property (nonatomic,strong) UILabel *time1Lbl;
@property (nonatomic,strong) UILabel *time2Lbl;

//@property (nonatomic,strong) UILabel *price1Lbl;
//@property (nonatomic,strong) UILabel *price2Lbl;


@end

@implementation ZHCouponsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH - 30, 120)];
        [self addSubview:self.backgroundImageView];
        self.backgroundColor = [UIColor clearColor];
        
        self.soldOutImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, 60, 60)];
        self.soldOutImageView.xx_size = self.backgroundImageView.width - 10;
        [self.backgroundImageView addSubview:self.soldOutImageView];
        
        //
        self.infoLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor clearColor]
                                          font:FONT(17)
                                     textColor:[UIColor zh_textColor2]];
        [self.backgroundImageView addSubview:self.infoLbl];
        
        [self.infoLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.backgroundImageView.mas_left).offset(15);
            make.centerY.equalTo(self.backgroundImageView.mas_centerY);
            
        }];
        
//        self.price1Lbl = [UILabel labelWithFrame:CGRectZero
//                                    textAligment:NSTextAlignmentLeft
//                                 backgroundColor:[UIColor clearColor]
//                                            font:FONT(18)
//                                       textColor:[UIColor zh_textColor]];
//        [self.backgroundImageView addSubview:self.price1Lbl];
        
//        [self.price1Lbl mas_makeConstraints:^(MASConstraintMaker *make) {
//            
//            make.left.equalTo(self.backgroundImageView.mas_left).offset(20);
//            make.bottom.equalTo(self.backgroundImageView.mas_centerY).offset(-2);
//        }];
//        
//        //
//        self.price2Lbl = [UILabel labelWithFrame:CGRectZero
//                                    textAligment:NSTextAlignmentLeft
//                                 backgroundColor:[UIColor clearColor]
//                                            font:FONT(18)
//                                       textColor:[UIColor zh_textColor]];
//        [self.backgroundImageView addSubview:self.price2Lbl];
//        [self.price2Lbl mas_makeConstraints:^(MASConstraintMaker *make) {
//            
//            make.left.equalTo(self.backgroundImageView.mas_left).offset(20);
//            make.top.equalTo(self.backgroundImageView.mas_centerY).offset(2);
//        }];
        
        //
        self.titleLbl = [UILabel labelWithFrame:CGRectMake(SCREEN_WIDTH/2.0, 30, SCREEN_WIDTH/2.0 - 15, [FONT(17) lineHeight])
                                   textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor clearColor]
                                           font:FONT(17)
                                      textColor:[UIColor zh_textColor]];
        [self addSubview:self.titleLbl];
        self.titleLbl.height = [FONT(17) lineHeight];
        self.titleLbl.text = @"抵扣券";
        //
        
        //开始日期
        self.time1Lbl = [UILabel labelWithFrame:CGRectZero textAligment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor] font:FONT(12) textColor:[UIColor zh_textColor2]];
        [self addSubview:self.time1Lbl];
        
        [self.time1Lbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLbl.mas_left);
            make.top.equalTo(self.titleLbl.mas_bottom).offset(10);
        }];
        
        //结束日期
        self.time2Lbl = [UILabel labelWithFrame:CGRectZero textAligment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor] font:FONT(12) textColor:[UIColor zh_textColor2]];
        [self addSubview:self.time2Lbl];
        
        [self.time2Lbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.titleLbl.mas_left);
            make.top.equalTo(self.time1Lbl.mas_bottom).offset(5);
            
        }];
        
        
    }
    return self;

}


#warning -可删除
//- (void)setCoupon:(ZHCoupon *)coupon {
//
//    _coupon = coupon;
//    
//    
//    self.infoLbl.text = [NSString stringWithFormat:@"满%@\n减%@",[_coupon.key1 convertToRealMoney],[_coupon.key2 convertToRealMoney]];
//    
//    NSString *price1Str;
//    NSString *price2Str;
////
//        price1Str = [_coupon.key1 convertToSimpleRealMoney];
//        price2Str = [_coupon.key2 convertToSimpleRealMoney];
//        
//        
//
////    //
//    NSMutableAttributedString *attr1Str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"满 %@",price1Str]];
//    [attr1Str addAttributes:@{
//                              NSForegroundColorAttributeName : [UIColor zh_themeColor]
//                              } range:NSMakeRange(2, price1Str.length)];
//    //--//
//    NSMutableAttributedString *attr2Str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"减 %@",price2Str]];
//    [attr2Str addAttributes:@{
//                              NSForegroundColorAttributeName : [UIColor zh_themeColor]
//                              } range:NSMakeRange(2, price2Str.length)];
//
//    //价格字符串
////    self.price1Lbl.attributedText = attr1Str;
////    self.price2Lbl.attributedText = attr2Str;
//
//  
//
////        self.time1Lbl.text = _coupon.bookMobile;
//        [NSString  stringWithFormat:@"起始日期: %@",[_coupon.validateStart converDate]];
//        self.time2Lbl.text = [NSString  stringWithFormat:@"有效期至: %@",[_coupon.validateEnd converDate]];
//        
////   }
//
//    
//
//  
////    self.titleLbl.text = self.coupon.store.name;
//    
//}

- (void)setMineCoupon:(ZHMineCouponModel *)mineCoupon {

    _mineCoupon = mineCoupon;
    
    
    
    self.infoLbl.text = [NSString stringWithFormat:@"满%@\n减%@",[_mineCoupon.storeTicket.key1 convertToRealMoney],[_mineCoupon.storeTicket.key2 convertToRealMoney]];
    
    NSString *price1Str;
    NSString *price2Str;
    //
    price1Str = [_mineCoupon.storeTicket.key1 convertToSimpleRealMoney];
    price2Str = [_mineCoupon.storeTicket.key2 convertToSimpleRealMoney];
    
    
    
    //    //
    NSMutableAttributedString *attr1Str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"满 %@",price1Str]];
    [attr1Str addAttributes:@{
                              NSForegroundColorAttributeName : [UIColor zh_themeColor]
                              } range:NSMakeRange(2, price1Str.length)];
    //--//
    NSMutableAttributedString *attr2Str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"减 %@",price2Str]];
    [attr2Str addAttributes:@{
                              NSForegroundColorAttributeName : [UIColor zh_themeColor]
                              } range:NSMakeRange(2, price2Str.length)];
    
    
    //店铺名称
    self.titleLbl.text = _mineCoupon.store.name;
    
    //时间
    
     self.time1Lbl.text = [NSString  stringWithFormat:@"起始日期: %@",[_mineCoupon.storeTicket.validateStart converDate]];
     self.time2Lbl.text = [NSString  stringWithFormat:@"有效期至: %@",[_mineCoupon.storeTicket.validateEnd converDate]];

    
    //状态
    if ([_mineCoupon.status isEqualToString:@"0"]) { //未使用
        
        self.soldOutImageView.image = [UIImage new];
        self.backgroundImageView.image = [UIImage imageNamed:@"抵扣券ing"];
        self.infoLbl.attributedText = [self.mineCoupon.storeTicket discountInfoDescription01IsIng:YES];
        
        
    } else if([_mineCoupon.status isEqualToString:@"1"]){ //已经使用
        
        self.soldOutImageView.image = [UIImage imageNamed:@"已使用"];
        self.backgroundImageView.image = [UIImage imageNamed:@"抵扣券ed"];
        self.infoLbl.attributedText = [self.mineCoupon.storeTicket  discountInfoDescription01IsIng:NO];
        
    } else { //2   ---- 已过期
        
        self.soldOutImageView.image = [UIImage imageNamed:@"已过期"];
        self.backgroundImageView.image = [UIImage imageNamed:@"抵扣券ed"];
        self.infoLbl.attributedText = [self.mineCoupon.storeTicket  discountInfoDescription01IsIng:NO];
    }

}


@end
