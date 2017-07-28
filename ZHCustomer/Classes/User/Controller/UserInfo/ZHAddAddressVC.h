//
//  ZHAddAddressVC.h
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/29.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"
#import "ZHReceivingAddress.h"

@interface ZHAddAddressVC : TLBaseVC

//地址新增
@property (nonatomic,strong) void(^addAddress)(ZHReceivingAddress *address);

//地址编辑
@property (nonatomic,strong) void(^editSuccess)(ZHReceivingAddress *address);
@property (nonatomic,strong) ZHReceivingAddress *address;



@end
