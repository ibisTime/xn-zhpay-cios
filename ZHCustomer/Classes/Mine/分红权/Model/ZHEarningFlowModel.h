//
//  ZHEarningFlowModel.h
//  ZHBusiness
//
//  Created by  tianlei on 2017/4/5.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@interface ZHEarningFlowModel : TLBaseModel

@property (nonatomic, strong) NSNumber *toAmount; //返还金额
@property (nonatomic, copy) NSString *toCurrency; //返还币种
@property (nonatomic, copy) NSString *createDatetime; //返还时间

//companyCode = "CD-CZH000001";
//createDatetime = "Apr 5, 2017 12:04:00 AM";
//fundCode = "STORE_POOL_ZHPAY";
//id = 16;
//stockCode = STOCK201704042155183980;
//systemCode = "CD-CZH000001";
//toAmount = 200000;
//toCurrency = FRB;
//toUser = U2017032911375586527;

@end
