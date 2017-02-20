//
//  ZHOrderDetailVC.h
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/31.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"
#import "ZHOrderModel.h"

@interface ZHOrderDetailVC : TLBaseVC

@property (nonatomic,strong) ZHOrderModel *order;

@property (nonatomic,copy) void(^paySuccess)();
@property (nonatomic,copy) void(^cancleSuccess)();
@property (nonatomic,copy) void(^confirmReceiveSuccess)();

@end
