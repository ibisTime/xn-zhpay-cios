//
//  TLWithdrawalVC.h
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/24.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"

typedef NS_ENUM(NSUInteger, WithdrawType) {
    WithdrawTypeFRB,
    WithdrawTypeBTB
};

@interface ZHWithdrawalVC : TLBaseVC

@property (nonatomic, assign) WithdrawType withdrawType;

//余额
//@property (nonatomic,strong) NSNumber *balance;
@property (nonatomic,strong) NSString *accountNum;
@property (nonatomic,strong) void (^success)();

@end
