//
//  ZHOrderGoodsCell.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/29.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHOrderGoodsCell.h"
#import "ZHOrderModel.h"

@interface ZHOrderGoodsCell()

@property (nonatomic,strong) UIImageView *coverImageV;
@property (nonatomic,strong) UILabel *nameLbl;
@property (nonatomic,strong) UILabel *priceLbl;
@property (nonatomic, strong) UILabel *parameterLbl;

@property (nonatomic,strong) UILabel *numLbl; //数目

@end

//
@implementation ZHOrderGoodsCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.coverImageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 80, 65)];
        self.coverImageV.contentMode = UIViewContentModeScaleAspectFill;
        self.coverImageV.clipsToBounds = YES;
        self.coverImageV.layer.masksToBounds  = YES;
        self.coverImageV.layer.cornerRadius = 2;
        self.coverImageV.layer.borderWidth = 0.5;
        self.coverImageV.layer.borderColor = [UIColor colorWithHexString:@"#dedede"].CGColor;
        [self addSubview:self.coverImageV];
        
        //名称
        self.nameLbl = [UILabel labelWithFrame:CGRectMake( self.coverImageV.xx + 13, 15, SCREEN_WIDTH - self.coverImageV.xx - 13, 10) textAligment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor] font:[UIFont secondFont] textColor:[UIColor zh_textColor]];
        [self addSubview:self.nameLbl];
        self.nameLbl.height = [[UIFont secondFont] lineHeight];
        
        //规格

        
        
        //价格
        self.priceLbl = [UILabel labelWithFrame:CGRectMake(self.nameLbl.x, self.nameLbl.yy + 5, self.nameLbl.width, [FONT(13) lineHeight])
                                   textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor clearColor]
                                           font:FONT(13)
                                      textColor:[UIColor zh_themeColor]];
        [self addSubview:self.priceLbl];
        
        //规格
        self.parameterLbl = [UILabel labelWithFrame:CGRectMake(self.nameLbl.x, self.priceLbl.yy + 5, self.nameLbl.width, [FONT(13) lineHeight])
                                       textAligment:NSTextAlignmentLeft
                                    backgroundColor:[UIColor clearColor]
                                               font:FONT(13)
                                          textColor:[UIColor zh_themeColor]];
        [self addSubview:self.parameterLbl];
        
        //广告语
        self.numLbl = [UILabel labelWithFrame:CGRectMake(self.nameLbl.x, self.parameterLbl.yy + 5, self.nameLbl.width, [FONT(11) lineHeight])
                                textAligment:NSTextAlignmentLeft
                             backgroundColor:[UIColor clearColor]
                                        font:FONT(11)
                                   textColor:[UIColor zh_textColor2]];
        [self addSubview:self.numLbl];
        
        //评价的按钮
//        UIButton *pjBtn = [UIButton zhBtnWithFrame:CGRectMake(SCREEN_WIDTH - 10 - w, self.priceLbl.yy + 5, w, 25) title:@"评价"];
////        [self addSubview:pjBtn];
//        [pjBtn addTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
 
        
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


//- (void)commentAction {
//
//    if (self.comment) {
//        
//        self.comment(self.cartGoods.code);
//        
//    }
//
//}

//- (void)setCartGoods:(ZHCartGoodsModel *)cartGoods {
//
//    _cartGoods = cartGoods;
//    NSString *urlStr = _cartGoods.product.advPic;
//    [self.coverImageV sd_setImageWithURL:[NSURL URLWithString:[urlStr convertThumbnailImageUrl]] placeholderImage:[UIImage imageNamed:@"goods_placeholder"]];
//    //
//    self.nameLbl.text = _cartGoods.product.name;
//    self.priceLbl.text = [ZHCurrencyHelper totalPriceWithQBB:_cartGoods.qbb GWB:_cartGoods.gwb RMB:_cartGoods.rmb];
//    self.numLbl.text = [NSString stringWithFormat:@"X%@",_cartGoods.quantity];
//
//}

- (void)setGoods:(ZHGoodsModel *)goods {

    _goods = goods;
    NSString *urlStr = _goods.advPic;
    [self.coverImageV sd_setImageWithURL:[NSURL URLWithString:[urlStr convertThumbnailImageUrl]] placeholderImage:[UIImage imageNamed:@"goods_placeholder"]];
    //
    self.nameLbl.text = _goods.name;
    self.priceLbl.text = [_goods displayPriceStrCurrentParameter];
    self.parameterLbl.text = _goods.currentParameterModel.name;
    //
    self.numLbl.text = [NSString stringWithFormat:@"X%ld",_goods.currentCount];
    
}



- (void)setOrder:(ZHOrderModel *)order {

    _order = order;
    
    NSString *urlStr = _order.product.advPic;
    [self.coverImageV sd_setImageWithURL:[NSURL URLWithString:[urlStr convertThumbnailImageUrl]] placeholderImage:[UIImage imageNamed:@"goods_placeholder"]];
    //
    self.nameLbl.text = _order.product.name;
    self.parameterLbl.text = _order.productSpecsName;
    //
    self.priceLbl.text = [_order displayUnitPriceStr];
    
    //
    self.numLbl.text = [NSString stringWithFormat:@"X%@",_order.quantity];
    
    //
}

//- (void)setOrderGoods:(ZHGoodsModel *)orderGoods {
//
//    _orderGoods = orderGoods;
//    
//    NSString *urlStr = _orderGoods.advPic;
//    [self.coverImageV sd_setImageWithURL:[NSURL URLWithString:[urlStr convertThumbnailImageUrl]] placeholderImage:[UIImage imageNamed:@"goods_placeholder"]];
//    //
//    self.nameLbl.text = _orderGoods.name;
//    
//    self.priceLbl.text = [ZHCurrencyHelper totalPriceWithQBB:_orderGoods.currentParameterPriceQBB GWB:_orderGoods.currentParameterPriceGWB RMB:_orderGoods.currentParameterPriceRMB];
//    
//    self.numLbl.text = [NSString stringWithFormat:@"X%@",_orderGoods.quantity];
//    
//}

+ (CGFloat)rowHeight {

    return 96;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
