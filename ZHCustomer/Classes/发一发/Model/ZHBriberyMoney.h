//
//  ZHBriberyMoney.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/23.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

typedef NS_ENUM(NSUInteger, ZHBriberyMoneyStatus) {
    
    ZHBriberyMoneyStatusUnSend = 0,
    ZHBriberyMoneyStatusUnReceive = 1,
    ZHBriberyMoneyStatusReceiverd = 2,
    ZHBriberyMoneyStatusOutOfDate = 3
    
};

@interface ZHBriberyMoney : TLBaseModel

//0=待转发 1=待领取 2=已领取 3=已失效

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *advTitle;
@property (nonatomic, copy) NSString *owner;
@property (nonatomic, copy) NSString *ownerCurrency;

@property (nonatomic, strong) NSNumber *ownerAmount;
@property (nonatomic, copy) NSString *receiveCurrency;

@property (nonatomic, strong) NSNumber *receiveAmount;
@property (nonatomic, copy) NSString *receiver; //领取人
@property (nonatomic, copy) NSString *receiverMobile; //领取人



@property (nonatomic, copy) NSString *receiveDatetime;

@property (nonatomic, assign) ZHBriberyMoneyStatus status;

@property (nonatomic, copy) NSString *createDatetime;
@property (nonatomic, copy) NSString *remark;

@end


//"code": "HB000000000001",
//"advTitle": "广告语",
//"owner": " U201701111041093806",
//"ownerCurrency": "CNY",
//"ownerAmount": "100",
//"receiveCurrency": "U201701111041093806",
//"receiveAmount": "100",
//"receiver": "U201701111041093806",
//"receiveDatetime": "2016-03-02 00:00:00",
//"status": "1",
//"createDatetime": "2016-03-02 00:00:00",
//"remark": "备注"

