//
//  ZHMineTreasureCell.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/12.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHMineTreasureCell.h"
#import "ZHProgressView.h"
#import "ZHDoubleTitleView.h"
#import "ZHGoodsDetailVC.h"

@interface ZHMineTreasureCell ()


@property (nonatomic,strong) UIImageView *coverImageV;
@property (nonatomic,strong) UILabel *nameLbl;
@property (nonatomic,strong) UILabel *adLbl;

@property (nonatomic,strong) UILabel *priceLbl;
@property (nonatomic,strong) UILabel *countLbl;
@property (nonatomic,strong) UILabel *hintLbl;

//进度条
@property (nonatomic,strong) ZHProgressView *progress;

@property (nonatomic,strong) UIButton *statusBtn;
@end


@implementation ZHMineTreasureCell


- (UIButton *)statusBtn {

    if (!_statusBtn) {
        
     _statusBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 25) title:@"" backgroundColor:[UIColor zh_themeColor]];
        _statusBtn.titleLabel.font = FONT(11);
        _statusBtn.layer.cornerRadius = 4;
        _statusBtn.layer.masksToBounds = YES;
        [_statusBtn addTarget:self action:@selector(buy) forControlEvents:UIControlEventTouchUpInside];
    }
    return _statusBtn;

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.coverImageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 80, 65)];
        self.coverImageV.layer.masksToBounds  = YES;
        self.coverImageV.layer.cornerRadius = 2;
        self.coverImageV.layer.borderWidth = 0.5;
        self.coverImageV.layer.borderColor = [UIColor colorWithHexString:@"#dedede"].CGColor;
        self.coverImageV.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.coverImageV];
        
        //状态按钮
        self.statusBtn.y = 12;
        self.statusBtn.x = SCREEN_WIDTH - 66;
        [self addSubview:self.statusBtn];
        
        //名称
        self.nameLbl = [UILabel labelWithFrame:CGRectZero textAligment:NSTextAlignmentLeft backgroundColor:[UIColor whiteColor] font:[UIFont secondFont] textColor:[UIColor zh_textColor]];
        [self addSubview:self.nameLbl];
        [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.coverImageV.mas_right).offset(15);
            make.top.equalTo(self.coverImageV.mas_top);
            make.right.equalTo(self.statusBtn.mas_left).offset(-5);
        }];
        
        
        //广告语
        self.adLbl = [UILabel labelWithFrame:CGRectZero
                                textAligment:NSTextAlignmentLeft
                             backgroundColor:[UIColor whiteColor]
                                        font:FONT(11)
                                   textColor:[UIColor zh_textColor2]];
        [self addSubview:self.adLbl];
        [self.adLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLbl.mas_left);
            make.right.equalTo(self.nameLbl.mas_right);
            make.top.equalTo(self.nameLbl.mas_bottom).offset(8);
            
        }];
        
        //分割线
        UIView *bottomLine = [[UIView alloc] init];
        bottomLine.backgroundColor = [UIColor zh_lineColor];
        [self addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self);
            make.height.mas_equalTo(0.5);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        //
        CGFloat topProgressMargin = 33 + [FONT(11) lineHeight] + [[UIFont secondFont] lineHeight];
        
        UILabel *proLbl = [UILabel labelWithFrame:CGRectMake(self.coverImageV.xx + 14, topProgressMargin, 55, [FONT(11) lineHeight])
                                      textAligment:NSTextAlignmentLeft
                                   backgroundColor:[UIColor clearColor]
                                              font:FONT(11)
                                         textColor:[UIColor zh_textColor2]];
        [self addSubview:proLbl];
        proLbl.text = @"购买进度:";
        
        //
        self.progress = [[ZHProgressView alloc] initWithFrame:CGRectMake(proLbl.xx + 3, topProgressMargin, 250, 10)];
        [self addSubview:self.progress];
        
        self.progress.centerY = proLbl.centerY;
        
//        CGFloat totalW = SCREEN_WIDTH - self.coverImageV.xx - 15;
        //人数
        
        
        //1.价格
        UILabel *priceLbl = [UILabel labelWithFrame:CGRectMake(proLbl.x , self.progress.yy + 10, SCREEN_WIDTH - proLbl.x, 20) textAligment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor] font:FONT(13) textColor:[UIColor zh_themeColor]];
        [self addSubview:priceLbl];
        self.priceLbl = priceLbl;
        
        UILabel *countLbl = [UILabel labelWithFrame:CGRectZero
                                       textAligment:NSTextAlignmentLeft
                                    backgroundColor:[UIColor clearColor]
                                               font:FONT(12)
                                          textColor:[UIColor zh_textColor2]];
        [self addSubview:countLbl];
        self.countLbl = countLbl;
        [countLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(proLbl.mas_left);
            make.top.equalTo(priceLbl.mas_bottom).offset(10);
        }];
        
        //
        UILabel *hintLbl = [UILabel labelWithFrame:CGRectZero
                                      textAligment:NSTextAlignmentRight
                                   backgroundColor:[UIColor clearColor]
                                              font:FONT(12)
                                         textColor:[UIColor zh_themeColor]];
        [self addSubview:hintLbl];
        [hintLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-10);
            make.top.equalTo(countLbl.mas_top);
            make.left.equalTo(self.countLbl.mas_right).offset(5);
        }];
        self.hintLbl = hintLbl;
        

        
    }
    return self;
    
}

- (void)buy { //追加按钮

    if ([self.mineTreasure.jewel.status isEqualToString:@"3"] || [self.mineTreasure.jewel.status isEqualToString:@"6"]) {//可以追加
        
        
        UITabBarController *tabbarCtrl =  (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        ZHGoodsDetailVC *goodsDetailVC = [[ZHGoodsDetailVC alloc] init];
        goodsDetailVC.detailType = ZHGoodsDetailTypeLookForTreasure;
        goodsDetailVC.treasure = self.mineTreasure.jewel;
        [tabbarCtrl.selectedViewController pushViewController:goodsDetailVC animated:YES];
        
    }

}


- (void)setMineTreasure:(ZHMineTreasureModel *)mineTreasure {

    _mineTreasure = mineTreasure;
    
    ZHTreasureModel *treasureItem = _mineTreasure.jewel;
    
    
    [self.coverImageV sd_setImageWithURL:[NSURL URLWithString:[treasureItem.advPic convertThumbnailImageUrl]]
                        placeholderImage:[UIImage imageNamed:@"goods_placeholder"]];
    
    
    //价格
    self.priceLbl.attributedText = [ZHCurrencyHelper totalPriceAttr2WithQBB:_mineTreasure.jewel.price3 GWB:_mineTreasure.jewel.price2 RMB:_mineTreasure.jewel.price1 bouns:CGRectMake(0, -3, 15, 15)];
    
    NSString *countStr;
    if (_mineTreasure.myInvestTimes) { //我的总共投资次数
        
      countStr  = [NSString stringWithFormat:@"%@",_mineTreasure.myInvestTimes];

    } else { //每次投资次数，只有已中奖了才会有该字段
        
        countStr  = [NSString stringWithFormat:@"%@",_mineTreasure.times];

    }
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[@"购买份数：" add:countStr]];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor zh_themeColor] range:NSMakeRange(5, countStr.length)];
    self.countLbl.attributedText = attrStr;
    
    self.nameLbl.text = _mineTreasure.jewel.name;
    self.adLbl.text = _mineTreasure.jewel.slogan;
    self.progress.progress = [_mineTreasure.jewel getProgress];
    
    
    
    NSString *status = _mineTreasure.jewel.status; //记录状态
    //根据宝贝的状态判断
    if ([status isEqualToString:@"3"] || [status isEqualToString:@"6"]) { //进行中
        
        [self.statusBtn setTitle:@"追加" forState:UIControlStateNormal];
        [self. statusBtn setBackgroundColor:[UIColor zh_themeColor] forState:UIControlStateNormal];
        
    } else if ([status isEqualToString:@"5"]) { //流标
    
        [self.statusBtn setTitle:@"已退款" forState:UIControlStateNormal];
        self.statusBtn.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    
    } else if([status isEqualToString:@"7"]) { //已经开奖
    
        if ([_mineTreasure.jewel.winUserId isEqualToString:[ZHUser user].userId]) {//中奖
            [self.statusBtn setTitle:@"已中奖" forState:UIControlStateNormal];
            self.statusBtn.backgroundColor = [UIColor zh_themeColor];
            
        } else { //未中奖
        
            [self.statusBtn setTitle:@"未中奖" forState:UIControlStateNormal];
            self.statusBtn.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
            
        }
    
    }
    
    if (self.isMineGet) {//我获得了该奖品
       
        NSString *status =  _mineTreasure.status ;
        
        if (!status && !_mineTreasure.reAddress) {

           [self.statusBtn setTitle:@"已中奖" forState:UIControlStateNormal];
            self.hintLbl.text = @"确认收货地址";
            
        } else {
            
//            self.hintLbl.text = @"查看号码";

            if ( [status isEqualToString:@"4"]) { //已经发货
                
                [self.statusBtn setTitle:@"待发货" forState:UIControlStateNormal];
                
            } else if([status isEqualToString:@"5"]) {
                
                [self.statusBtn setTitle:@"已发货" forState:UIControlStateNormal];
                
            } else if([status isEqualToString:@"6"]) {
                
                [self.statusBtn setTitle:@"已签收" forState:UIControlStateNormal];
                
            }
            
        }
        
        
    }
    
    
}

//NEW("0", "待审批"), PASS("1", "审批通过"),
//UNPASS("2", "审批不通过"), PUT_ON("3", "夺宝进行中"),
//PUT_OFF("4", "强制下架"), EXPIRED("5", "到期流标"),
//SUCCESSED("6", "夺宝成功，待开奖"), TO_SEND("7", "已开奖，待发货");
// 看到： 3 5 6 7



//        // --- // 天数
//        self.dayView = [[ZHDoubleTitleView alloc] initWithFrameLayout:CGRectMake(self.peopleView.xx + w, topMargin, w, 30)];
//        [self addSubview:self.dayView];
//
//        //钱
//        //        CGRectMake(self.peopleView.xx, self.peopleView.y - 5, w, self.peopleView.height)
//        self.priceLbl = [UILabel labelWithFrame:CGRectZero textAligment:NSTextAlignmentLeft
//                                backgroundColor:[UIColor whiteColor]
//                                           font:FONT(12)
//                                      textColor:[UIColor zh_themeColor]];
//        self.priceLbl.numberOfLines = 0;
//        [self addSubview:self.priceLbl];
//        [self.priceLbl  mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.top.equalTo(self.peopleView.mas_top).offset(-8);
//            make.left.equalTo(self.peopleView.mas_right).offset(20);
//            //            make.right.equalTo(self.dayView.mas_left).offset(-5);
//            //            make.centerX.mas_equalTo(@(1.5*w + self.coverImageV.xx));
//            make.bottom.equalTo(self.mas_bottom).offset(-1);
//
//        }];
//
//        //第一条线
//        UIView *line0 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 20)];
//        line0.backgroundColor = [UIColor zh_lineColor];
//        line0.x  = self.peopleView.xx;
//        line0.centerY = self.peopleView.centerY;
//        [self addSubview:line0];
//
//        //第二条线
//        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 20)];
//        line1.backgroundColor = [UIColor zh_lineColor];
//        line1.x  = self.dayView.x;
//        line1.centerY = self.peopleView.centerY;
//        [self addSubview:line1];


@end
