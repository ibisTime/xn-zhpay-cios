//
//  ZHMineNumberVC.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"
//#import "ZHDBHistoryModel.h"
#import "ZHDBModel.h"


@interface ZHMineNumberVC : TLBaseVC

//@property (nonatomic, strong) ZHDBHistoryModel *historyModel;
@property (nonatomic, strong) ZHDBModel *dbModel;
@property (nonatomic, assign) BOOL isMineHistory;


@end
