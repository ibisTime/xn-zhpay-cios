//
//  ZHBank.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/16.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@interface ZHBank : TLBaseModel

@property (nonatomic,copy) NSString *bankCode;
@property (nonatomic,copy) NSString *bankName;
@property (nonatomic,copy) NSString *channelType;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *status;


//bankCode = ICBC;
//bankName = "\U4e2d\U56fd\U5de5\U5546\U94f6\U884c";
//channelType = 40;
//id = 1;
//status = 1;

@end
