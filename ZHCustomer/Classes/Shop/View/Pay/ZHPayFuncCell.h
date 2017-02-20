//
//  ZHPayFuncCell.h
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/25.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHPayFuncModel.h"

@interface ZHPayFuncCell : UITableViewCell

@property (nonatomic,strong) UILabel *infoLbl;
@property (nonatomic,strong) UIImageView *funcTypeImageV;
@property (nonatomic,strong) UIButton *selectedBtn;
@property (nonatomic,strong) ZHPayFuncModel *pay;

@end
