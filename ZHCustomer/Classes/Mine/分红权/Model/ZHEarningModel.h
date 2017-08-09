//
//  ZHEarningModel.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/4/3.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@interface ZHEarningModel : TLBaseModel

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *fundCode;

//2 未返利 3.返利中 4.已返利
@property (nonatomic, copy) NSString *status; //状态
@property (nonatomic, strong) NSNumber *costAmount; //消费额



@property (nonatomic, strong) NSNumber *todayAmount; //今日返利
@property (nonatomic, strong) NSNumber *backAmount; //已返利金额

@property (nonatomic, strong) NSNumber *profitAmount; //收益金额

@property (nonatomic, copy) NSString *profitCurrency; //收益币种


//

@property (nonatomic, copy) NSString *createDatetime; //时间

- (NSString *)getStatusName;

//backAmount = 1;
//backCount = 1;
//backInterval = 5;
//code = S201703282124304490;
//companyCode = "CD-CZH000001";
//costAmount = 500000;
//costCurrency = FRB;
//fundCode = "USER_POOL_ZHPAY";
//nextBackDate = "Mar 28, 2017 9:24:30 PM";
//profitAmount = 1000;
//profitCurrency = FRB;
//status = 4;
//systemCode = "CD-CZH000001";
//todayAmount = 1;
//userId = U2017032913574410381;

@end
