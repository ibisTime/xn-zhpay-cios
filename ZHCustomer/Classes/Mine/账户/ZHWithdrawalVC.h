//
//  TLWithdrawalVC.h
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/24.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"

@interface ZHWithdrawalVC : TLBaseVC

//余额
@property (nonatomic,strong) NSNumber *balance;

//分润的账户编码
@property (nonatomic,strong) NSString *accountNum;

@property (nonatomic,strong) void (^success)();

@end
