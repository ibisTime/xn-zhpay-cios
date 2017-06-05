//
//  ZHFRBToOtherPeopleVC.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/6/5.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"

@interface ZHFRBToOtherPeopleVC : TLBaseVC

@property (nonatomic, strong) NSNumber *frbSysMoney;
@property (nonatomic, copy) void(^success)(NSNumber *frbSysMoney);

@end
