//
//  ZHShopOrderCell.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/4.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHShopOrderCell.h"

@interface ZHShopOrderCell()

@property (nonatomic,strong) UILabel *orderLbl;
@property (nonatomic,strong) UILabel *timeLbl;

@property (nonatomic,strong) UIImageView *coverImageView;
@property (nonatomic,strong) UILabel *nameLbl;

//discountLbl
@property (nonatomic,strong) UILabel *statusLbl;
//@property (nonatomic,strong) UILabel *couponsLbl;//使用折扣券

@property (nonatomic,strong) UILabel *priceLbl; //价格
//@property (nonatomic,strong) UILabel *discountPriceLbl; //优惠后的价格


@end

@implementation ZHShopOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
       
        [self setUpUI];
        
    }
    
    return self;
    
}

- (void)setShopOrderModel:(ZHShopOrderModel *)shopOrderModel {

    _shopOrderModel = shopOrderModel;
    self.orderLbl.text = [NSString stringWithFormat:@"订单编号: %@",_shopOrderModel.code];
    self.timeLbl.text = [_shopOrderModel.createDatetime convertDate];
    
    
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:[_shopOrderModel.store.advPic convertThumbnailImageUrl]]];
    
    
    self.nameLbl.text = _shopOrderModel.store.name;

    //消费金额
    self.priceLbl.attributedText = [_shopOrderModel displayPayStr];

}


+ (CGFloat)rowHeight {

    return 134;
    
}


- (void)setUpUI {

    self.orderLbl = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_MARGIN, 0, SCREEN_WIDTH - 30 - 150, 39)
                                      textAligment:NSTextAlignmentLeft
                                   backgroundColor:[UIColor whiteColor]
                                              font:FONT(11)
                                         textColor:[UIColor zh_textColor2]];
    [self addSubview:self.orderLbl];
    
    //时间
    self.timeLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.orderLbl.xx, 0, 150, self.orderLbl.height)
                                     textAligment:NSTextAlignmentRight
                                  backgroundColor:[UIColor whiteColor]
                                             font:FONT(11)
                                        textColor:[UIColor zh_textColor2]];
    [self addSubview:self.timeLbl];
    
    //线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.orderLbl.yy, SCREEN_WIDTH, LINE_HEIGHT)];
    line.backgroundColor = [UIColor zh_lineColor];
    [self addSubview:line];
    
    //
    self.coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, line.yy + 15, 80, 65)];
    self.coverImageView.layer.borderWidth = 0.5;
    self.coverImageView.layer.borderColor = [UIColor colorWithHexString:@"#dedede"].CGColor;
    self.coverImageView.layer.cornerRadius = 2;
    self.coverImageView.layer.masksToBounds = YES;
    self.coverImageView.backgroundColor = [UIColor lightGrayColor];
    self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.coverImageView];
    
    //
    self.nameLbl = [UILabel labelWithFrame:CGRectMake(self.coverImageView.xx + 14, self.coverImageView.y + 5, SCREEN_WIDTH - self.coverImageView.xx - 28, 20)
                              textAligment:NSTextAlignmentLeft
                           backgroundColor:[UIColor clearColor]
                                      font:[UIFont secondFont]
                                 textColor:[UIColor zh_textColor]];
    self.nameLbl.height = [[UIFont secondFont] lineHeight];
    [self addSubview:self.nameLbl];
    
    
    //消费金额
    self.priceLbl = [UILabel labelWithFrame:CGRectZero
                               textAligment:NSTextAlignmentLeft
                            backgroundColor:[UIColor clearColor]
                                       font:FONT(13)
                                  textColor:[UIColor themeColor]];
    [self addSubview:self.priceLbl];
    [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLbl.mas_left  );
        make.top.equalTo(self.nameLbl.mas_bottom).offset(15);
    }];
    

    


}


@end
