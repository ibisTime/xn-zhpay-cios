//
//  ZHBuyToolView.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/27.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHBuyToolView.h"
#import "TLHeader.h"
#import "UIColor+theme.h"

@interface ZHBuyToolView ()

@property (nonatomic,strong) UIButton *buyBtn;
@property (nonatomic,strong) UIButton *addShopCarBtn;
@property (nonatomic,strong) UIButton *kefuBtn;

//购物车
@property (nonatomic,strong) UIButton *shopCarBtn;

@end

@implementation ZHBuyToolView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        //客服按钮
        [self addSubview:self.kefuBtn];
        
        [self addSubview:self.shopCarBtn];

        CGFloat w = (SCREEN_WIDTH - self.shopCarBtn.xx)/2.0;
        
        //右边添加购物车
        [self addSubview:self.addShopCarBtn];
        self.addShopCarBtn.frame = CGRectMake(self.shopCarBtn.xx, 0, w, self.height);
        
        //右边购买
        [self addSubview:self.buyBtn];
          self.buyBtn.frame = CGRectMake(self.addShopCarBtn.xx, 0, w, self.height);

        //顶部的线
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width , LINE_HEIGHT)];
        topLine.backgroundColor = [UIColor zh_lineColor];
        [self addSubview:topLine];
        
        
    }
    
    return self;
    
}

- (UIButton *)kefuBtn {

    if (!_kefuBtn) {
        //左边背景btn
        UIButton *kefuBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 67, self.height)];
        [kefuBtn addTarget:self action:@selector(goKefu) forControlEvents:UIControlEventTouchUpInside];
        _kefuBtn = kefuBtn;
        
        
        //
        UIImageView *kefuImageV = [[UIImageView alloc] initWithFrame:CGRectMake(25, 8, 17, 17)];
        kefuImageV.image = [UIImage imageNamed:@"客服"];
        [kefuBtn addSubview:kefuImageV];
        
        CGFloat hintW = 10;
        UIView *hintView = [[UIView alloc] init];
        hintView.backgroundColor = [UIColor redColor];
        hintView.layer.cornerRadius = hintW/2.0;
        hintView.layer.masksToBounds = YES;
        [kefuImageV addSubview:hintView];
        self.kefuMsgHintView = hintView;
        hintView.hidden = YES;
        
        [hintView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(hintW);
            make.height.mas_equalTo(hintW);
            make.right.equalTo(kefuImageV.mas_right).offset(4);
            make.top.equalTo(kefuImageV.mas_top).offset(-3);
        }];
        
        
        UILabel *kefuLbl = [UILabel labelWithFrame:CGRectMake(0, kefuImageV.yy + 5, kefuBtn.width, 10) textAligment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor] font:FONT(10) textColor:[UIColor zh_textColor]];
        kefuLbl.text = @"客服";
        [kefuBtn addSubview:kefuLbl];
        
        //中部线
        UIView *kefuLine = [[UIView alloc] initWithFrame:CGRectMake(kefuBtn.xx - LINE_HEIGHT, 0, LINE_HEIGHT, kefuBtn.height)];
        kefuLine.backgroundColor = [UIColor zh_lineColor];
        [kefuBtn addSubview:kefuLine];
    }
    
    return _kefuBtn;

}


- (UIButton *)shopCarBtn {
    
    if (!_shopCarBtn) {
        
        _shopCarBtn =  [[UIButton alloc] initWithFrame:CGRectMake(self.kefuBtn.xx, 0, 67, self.height)];
        [_shopCarBtn addTarget:self action:@selector(goShopCar) forControlEvents:UIControlEventTouchUpInside];
        //
        UIImageView *carImageV = [[UIImageView alloc] initWithFrame:CGRectMake(25, 8, 17, 17)];
        carImageV.centerX = _shopCarBtn.width/2.0;
        carImageV.image = [UIImage imageNamed:@"shop_car_small"];
        [_shopCarBtn addSubview:carImageV];
        
        //数量
        _countView = [[TLMsgBadgeView alloc] initWithFrame:CGRectMake(carImageV.centerX + 2, 0, 14, 14)];
        _countView.centerY = carImageV.y + 2;
        //        _countView.msgCount = 32;
        [_shopCarBtn addSubview:_countView];
        
        
        
        //
        UILabel *carLbl = [UILabel labelWithFrame:CGRectMake(0, carImageV.yy + 5, _shopCarBtn.width, 10) textAligment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor] font:FONT(10) textColor:[UIColor zh_textColor]];
        carLbl.text = @"购物车";
        [_shopCarBtn addSubview:carLbl];
        
        UIView *carLine = [[UIView alloc] initWithFrame:CGRectMake(_shopCarBtn.width - 1, 0, LINE_HEIGHT, _shopCarBtn.height)];
        carLine.backgroundColor = [UIColor zh_lineColor];
        [_shopCarBtn addSubview:carLine];
        
        
    }
    
    return _shopCarBtn;
    
}


- (UIButton *)buyBtn {

    if (!_buyBtn) {
        
//        CGFloat buyBtnW = 120;
//        if (SCREEN_WIDTH == 320) {
//            buyBtnW = 95;
//        }
        UIButton *buyBtn = [[UIButton alloc] initWithFrame:CGRectZero title:@"立即购买" backgroundColor:[UIColor zh_themeColor]];
        _buyBtn = buyBtn;
        [buyBtn addTarget:self action:@selector(buy) forControlEvents:UIControlEventTouchUpInside];
        buyBtn.titleLabel.font = FONT(18);
    }
    return _buyBtn;
}

- (UIButton *)addShopCarBtn {

    if (!_addShopCarBtn) {
        
        _addShopCarBtn = [[UIButton alloc] initWithFrame:CGRectZero title:@"加入购物车" backgroundColor:[UIColor whiteColor]];
        [_addShopCarBtn addTarget:self action:@selector(addShopCar) forControlEvents:UIControlEventTouchUpInside];
        [_addShopCarBtn setTitleColor:[UIColor zh_themeColor] forState:UIControlStateNormal];
        _addShopCarBtn.titleLabel.font = FONT(18);

        
    }
    return _addShopCarBtn;
}



- (UILabel *)priceLbl {

    if (!_priceLbl) {
        
        CGFloat w = self.width - self.kefuBtn.width -  self.buyBtn.width - 9;
        _priceLbl = [UILabel labelWithFrame:CGRectMake(self.kefuBtn.xx + 5, 1, w , self.height - 1)
                               textAligment:NSTextAlignmentLeft
                            backgroundColor:[UIColor whiteColor]
                                       font:FONT(12)
                                  textColor:[UIColor zh_themeColor]];
        _priceLbl.numberOfLines = 0;
    }
    return _priceLbl;

}



- (void)setType:(ZHBuyType)type {

    _type = type;
    if (_type == ZHBuyTypeDefault) { //带有客服和 购物车
        
        
    } else {//夺宝 去除购物车和 加入购物车
    
        [self.addShopCarBtn removeFromSuperview];
        [self.shopCarBtn removeFromSuperview];
        [self addSubview:self.priceLbl];
        [self.buyBtn setTitle:@"参与夺宝" forState:UIControlStateNormal];
    }

}



//前往购物车
- (void)goShopCar {

    if (self.delegate && [self.delegate respondsToSelector:@selector(openShopCar)]) {
        
        [self.delegate openShopCar];
        
    }

}

//加入购物车
- (void)addShopCar {

    if (self.delegate && [self.delegate respondsToSelector:@selector(addToShopCar)]) {
        
        [self.delegate addToShopCar];
        
    }

}

//买
- (void)buy {

    if (self.delegate && [self.delegate respondsToSelector:@selector(buy)]) {
        
        [self.delegate buy];
        
    }
    
}

- (void)goKefu {
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(chat)]) {
        
        [self.delegate chat];
        
    }

}

@end
