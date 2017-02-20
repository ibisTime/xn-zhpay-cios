//
//  ZHReceivingAddress.h
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/29.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLBaseModal.h"

@interface ZHReceivingAddress : TLBaseModal
@property (nonatomic,strong) NSString *code;

@property (nonatomic,strong) NSString *addressee; //收货人
@property (nonatomic,strong) NSString *province;
@property (nonatomic,strong) NSString *city;
@property (nonatomic,strong) NSString *district;

@property (nonatomic,strong) NSString *detailAddress;

@property (nonatomic,strong) NSString *mobile;
@property (nonatomic,strong) NSString *userId;

@property (nonatomic,copy) NSString *totalAddress;

//是否是 -- 临时选择
@property (nonatomic,assign) BOOL isSelected;

@end
