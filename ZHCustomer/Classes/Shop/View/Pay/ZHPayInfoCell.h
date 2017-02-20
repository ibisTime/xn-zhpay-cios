//
//  ZHPayInfoCell.h
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/25.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHPayInfoCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLbl;
@property (nonatomic,strong) UILabel *infoLbl;
@property (nonatomic,strong) UIImageView *arrowImageV;

@property (nonatomic,assign) BOOL hidenArrow;

@end
