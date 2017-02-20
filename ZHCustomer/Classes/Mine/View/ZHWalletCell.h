//
//  ZHWalletCell.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/3.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHCurrencyModel.h"

@interface ZHWalletCell : UITableViewCell

@property (nonatomic,strong) UILabel *typeLbl;
@property (nonatomic,strong) UILabel *moneyLbl;

@property (nonatomic,strong) UILabel *accessoryLbl;

//0 右无  1. arrowLeft 2.arrowDown
@property (nonatomic,copy) NSString *type;

//钱币的模型
@property (nonatomic,strong) ZHCurrencyModel *currencyModel;

@end

