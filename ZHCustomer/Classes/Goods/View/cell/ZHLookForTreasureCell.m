//
//  ZHLookForTreasureCell.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/26.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHLookForTreasureCell.h"
#import "ZHProgressView.h"
#import "ZHDoubleTitleView.h"
#import "ZHTreasureInfoView.h"

@interface ZHLookForTreasureCell()

@property (nonatomic,strong) UIImageView *coverImageV;
@property (nonatomic,strong) UILabel *nameLbl;
@property (nonatomic,strong) UILabel *adLbl;

@property (nonatomic,strong) UILabel *priceLbl;


//夺宝信息
@property (nonatomic,strong) ZHTreasureInfoView *infoView;

//进度条
@property (nonatomic,strong) ZHProgressView *progress;

//--//
@property (nonatomic,strong) ZHDoubleTitleView *peopleView; //人数
//@property (nonatomic,strong) ZHDoubleTitleView *priceView; //单价
@property (nonatomic,strong) ZHDoubleTitleView *dayView; //天数


@end

@implementation ZHLookForTreasureCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.coverImageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 80, 65)];
        self.coverImageV.layer.masksToBounds  = YES;
        self.coverImageV.layer.cornerRadius = 2;
        self.coverImageV.layer.borderWidth = 0.5;
        self.coverImageV.layer.borderColor = [UIColor colorWithHexString:@"#dedede"].CGColor;
        self.coverImageV.clipsToBounds = YES;
        self.coverImageV.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.coverImageV];
        
        //名称
        self.nameLbl = [UILabel labelWithFrame:CGRectZero textAligment:NSTextAlignmentLeft backgroundColor:[UIColor whiteColor] font:[UIFont secondFont] textColor:[UIColor zh_textColor]];
        [self addSubview:self.nameLbl];
        [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.coverImageV.mas_right).offset(14);
            make.top.equalTo(self.coverImageV.mas_top);
            make.right.equalTo(self.mas_right).offset(-15);
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
            make.right.equalTo(self.mas_right).offset(-15);
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
        
        UILabel *hintLbl = [UILabel labelWithFrame:CGRectMake(self.coverImageV.xx + 14, topProgressMargin, 55, [FONT(11) lineHeight])
                                      textAligment:NSTextAlignmentLeft
                                   backgroundColor:[UIColor clearColor]
                                              font:FONT(11)
                                         textColor:[UIColor zh_textColor2]];
        [self addSubview:hintLbl];
        hintLbl.text = @"购买进度:";

        
        //
        self.progress = [[ZHProgressView alloc] initWithFrame:CGRectMake(hintLbl.xx + 3, topProgressMargin, 250, 10)];
        [self addSubview:self.progress];
        
        self.progress.centerY = hintLbl.centerY;
        
        CGFloat totalW = SCREEN_WIDTH - self.coverImageV.xx - 15;
        //人数
        CGFloat w = totalW/3.0;
        CGFloat topMargin = 95;

        self.peopleView = [[ZHDoubleTitleView alloc] initWithFrameLayout:CGRectMake(self.coverImageV.xx, topMargin, w, 30)];
        [self addSubview:self.peopleView];
        
        //1.线
        
        // --- // 天数
        self.dayView = [[ZHDoubleTitleView alloc] initWithFrameLayout:CGRectMake(self.peopleView.xx + w, topMargin, w, 30)];
        [self addSubview:self.dayView];

        //钱
//        CGRectMake(self.peopleView.xx, self.peopleView.y - 5, w, self.peopleView.height)
        self.priceLbl = [UILabel labelWithFrame:CGRectZero textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor whiteColor]
                                           font:FONT(12)
                                      textColor:[UIColor zh_themeColor]];
        self.priceLbl.numberOfLines = 0;
        [self addSubview:self.priceLbl];
        [self.priceLbl  mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(self.peopleView.mas_top).offset(-8);
            make.left.equalTo(self.peopleView.mas_right).offset(20);
//            make.right.equalTo(self.dayView.mas_left).offset(-5);
//            make.centerX.mas_equalTo(@(1.5*w + self.coverImageV.xx));
            make.bottom.equalTo(self.mas_bottom).offset(-1);
            
        }];
        
        //第一条线
        UIView *line0 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 20)];
        line0.backgroundColor = [UIColor zh_lineColor];
        line0.x  = self.peopleView.xx;
        line0.centerY = self.peopleView.centerY;
        [self addSubview:line0];
        
        //第二条线
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 20)];
        line1.backgroundColor = [UIColor zh_lineColor];
        line1.x  = self.dayView.x;
        line1.centerY = self.peopleView.centerY;
        [self addSubview:line1];
        
        
    }
    return self;

}


- (void)setTreasure:(ZHTreasureModel *)treasure {

    _treasure = treasure;
    NSString *urlStr = [_treasure.advPic convertThumbnailImageUrl];
    [self.coverImageV sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"goods_placeholder"]];
    self.nameLbl.text = _treasure.name;
    self.adLbl.text = _treasure.slogan;
    
    //进度
    CGFloat pr =  [_treasure getProgress];
    self.progress.progress = pr;
//
    
    //人数
    self.peopleView.topLbl.text =  @"参与人数";
    self.peopleView.bootomLbl.text = [NSString stringWithFormat:@"%ld",[_treasure.investNum integerValue]];
    
    //天数
    self.dayView.topLbl.text = @"剩余时间";
    self.dayView.bootomLbl.text = [_treasure getSurplusTime];
    
    self.priceLbl.attributedText = [self attr];
    
}

- (NSMutableAttributedString *) attr {

    CGRect bBouns = CGRectMake(-2, 0, 9, 9);
    
    
    NSAttributedString *RMBAttr = [NSAttributedString coverImg:[UIImage imageNamed:@"人民币"] bounds:bBouns];
    
    NSAttributedString *QBBAttr = [NSAttributedString coverImg:[UIImage imageNamed:@"钱包币"] bounds:bBouns];
    
    //钱包 购物 人民
    NSAttributedString *GWBAttr = [NSAttributedString coverImg:[UIImage imageNamed:@"购物币"] bounds:bBouns];

    
    //人民币
    NSMutableAttributedString *mutableAttr = [[NSMutableAttributedString alloc] init];
    
    if (![self.treasure.price1 isEqual:@0]) {
        
        [mutableAttr appendAttributedString:RMBAttr];
        NSString *str1 = [@" " add: [[self.treasure.price1 convertToRealMoney] add:@"\n"]];
        [mutableAttr appendAttributedString:[str1 attrStr]];
    }

    
    //购物币
    if (![self.treasure.price2 isEqual:@0]) {

     [mutableAttr appendAttributedString:GWBAttr];
     NSString *str2 = [NSString stringWithFormat:@" %@\n",[self.treasure.price2 convertToRealMoney]];
     [mutableAttr appendAttributedString:[str2 attrStr]];
    }
    
    
    //钱宝币
    if (![self.treasure.price3 isEqual:@0]) {

     [mutableAttr appendAttributedString:QBBAttr];
     NSString *str3 = [NSString stringWithFormat:@" %@\n",[self.treasure.price3 convertToRealMoney]];
     [mutableAttr appendAttributedString:[str3 attrStr]];
    }
    
    return mutableAttr;
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
