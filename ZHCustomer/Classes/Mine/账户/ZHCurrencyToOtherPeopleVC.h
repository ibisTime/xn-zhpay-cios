//
//  ZHFRBToOtherPeopleVC.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/6/5.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"

@interface ZHCurrencyToOtherPeopleVC : TLBaseVC

//@property (nonatomic, strong) NSNumber *sysMoney;

@property (nonatomic, copy) NSString *accountNumber;
@property (nonatomic, copy) void(^success)(NSNumber *sysMoney);

@end
