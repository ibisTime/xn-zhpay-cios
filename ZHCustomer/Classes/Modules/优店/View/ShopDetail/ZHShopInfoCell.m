//
//  ZHShopInfoCell.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/23.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHShopInfoCell.h"

@interface ZHShopInfoCell()

@property (nonatomic,strong) UIImageView *infoIV;

@property (nonatomic,strong) UILabel *infoLbl;


@end


@implementation ZHShopInfoCell

+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath info:(NSString *)info  {

    static  NSString * reCellId = @"ZHShopInfoCellID";
    ZHShopInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:reCellId];
    if (!cell) {
        
        cell = [[ZHShopInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reCellId];
        
    }
    cell.info = info;
    return cell;

}

+ (CGFloat)rowHeight {

    return 42;
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor whiteColor];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 15, 0.5)];
        lineView.backgroundColor = [UIColor zh_lineColor];
        [self addSubview:lineView];
        
        self.infoIV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 9, 12)];
        self.infoIV.centerY = [[self class] rowHeight]/2.0;
        [self addSubview:self.infoIV];
        self.infoIV.image = [UIImage imageNamed:@"电话"];
        
        

        self.infoLbl = [UILabel labelWithFrame:CGRectMake(self.infoIV.xx + 6, 0.5, SCREEN_WIDTH - (self.infoIV.xx + 6) - 20, 42 - 0.5)
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor clearColor]
                                          font:[UIFont thirdFont]
                                     textColor:[UIColor zh_textColor]];
        [self addSubview:self.infoLbl];
        
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"更多"]];
        
        //
        [self.infoIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        //x
        [self.infoLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(35);
            make.centerY.equalTo(self.mas_centerY);
        }];
    
    }
    return self;

}

- (void)setInfoType:(ShopInfoType )infoType {

    switch (infoType) {
        case ShopInfoTypeCall :{
            
            self.infoIV.image = [UIImage imageNamed:@"电话"];

        } break;
            
        case ShopInfoTypeLocation :{
            
            self.infoIV.image = [UIImage imageNamed:@"位置"];

            
        } break;
          
        case ShopInfoTypeGoods :{
            
            self.infoIV.image = [UIImage imageNamed:@"商品"];

        } break;

    }

}

- (void)setInfo:(NSString *)info {

    _info = [info copy];
    self.infoLbl.text = _info;

}

@end
