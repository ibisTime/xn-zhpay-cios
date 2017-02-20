//
//  ZHWalletView.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/20.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHWalletView : UIView

@property (nonatomic, strong) UILabel *typeLbl;
@property (nonatomic, strong) UILabel *moneyLbl;
@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy)  void(^action)(NSString *code);

@end
