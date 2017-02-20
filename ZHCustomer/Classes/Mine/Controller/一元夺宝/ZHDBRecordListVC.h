//
//  ZHDBRecordListVC.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/3.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"

@interface ZHDBRecordListVC : TLBaseVC

//根据状态进行查询
@property (nonatomic,copy) NSString *status;

// yes 为我的中奖记录
@property (nonatomic,assign) BOOL isMineGetRecord;


@end
