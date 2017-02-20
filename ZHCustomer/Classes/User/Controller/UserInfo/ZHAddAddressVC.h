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

//地址新怎
@property (nonatomic,strong)  void(^addAddress)(ZHReceivingAddress *address);

//地址便捷
@property (nonatomic,strong)  void(^editSuccess)();
@property (nonatomic,strong) ZHReceivingAddress *address;



@end
