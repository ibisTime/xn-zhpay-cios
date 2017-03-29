//
//  ZHGoodsCell.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/26.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHGoodsCell.h"
#import "ZHCurrencyHelper.h"

@interface ZHGoodsCell()

@property (nonatomic,strong) UIImageView *coverImageV;
@property (nonatomic,strong) UILabel *nameLbl;
@property (nonatomic,strong) UILabel *adLbl;
@property (nonatomic,strong) UILabel *priceLbl;


@end


@implementation ZHGoodsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    
        self.coverImageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 80, 65)];
        self.coverImageV.layer.masksToBounds  = YES;
        self.coverImageV.layer.cornerRadius = 2;
        self.coverImageV.layer.borderWidth = 0.5;
        self.coverImageV.layer.borderColor = [UIColor colorWithHexString:@"#dedede"].CGColor;
        self.coverImageV.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.coverImageV];
        
        //名称
        self.nameLbl = [UILabel labelWithFrame:CGRectMake( self.coverImageV.xx + 13, 15, SCREEN_WIDTH - self.coverImageV.xx - 13, 10) textAligment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor] font:[UIFont secondFont] textColor:[UIColor zh_textColor]];
        [self addSubview:self.nameLbl];
        self.nameLbl.height = [[UIFont secondFont] lineHeight];

        
        //广告语
        self.adLbl = [UILabel labelWithFrame:CGRectMake(self.nameLbl.x, self.nameLbl.yy + 8, self.nameLbl.width, [FONT(11) lineHeight])
                                textAligment:NSTextAlignmentLeft
                             backgroundColor:[UIColor clearColor]
                                        font:FONT(11)
                                   textColor:[UIColor zh_textColor2]];
        [self addSubview:self.adLbl];
        //价格
        
        self.priceLbl = [UILabel labelWithFrame:CGRectMake(self.nameLbl.x, self.adLbl.yy + 10, self.nameLbl.width, [FONT(13) lineHeight])
                                textAligment:NSTextAlignmentLeft
                             backgroundColor:[UIColor clearColor]
                                        font:FONT(13)
                                   textColor:[UIColor zh_themeColor]];
        [self addSubview:self.priceLbl];
        
        //
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor zh_lineColor];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(@0.5);
        }];
        
        
    }
    return self;
}

+ (CGFloat)rowHeight {

    return 96;
}

- (void)setGoods:(ZHGoodsModel *)goods {

    _goods = goods;
    
    NSString *urlStr = [goods.advPic convertThumbnailImageUrl];
    [self.coverImageV sd_setImageWithURL:[NSURL URLWithString:urlStr]
                        placeholderImage:[UIImage imageNamed:@"goods_placeholder"]];
    self.nameLbl.text = goods.name;
    self.adLbl.text = goods.slogan;

//    self.priceLbl.text = [ZHCurrencyHelper totalPriceWithQBB:_goods.qbb GWB:_goods.gwb RMB:_goods.rmb];
    self.priceLbl.text = [ZHCurrencyHelper totalPriceWithQBB:[_goods QBB] GWB:[_goods GWB] RMB:[_goods RMB]];

}



@end
