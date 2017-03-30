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
@property (nonatomic, copy) NSString *slogan;
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


//code = HM201703301257326994454;
//companyCode = "CD-CZH000001";
//createDatetime = "Mar 30, 2017 12:00:00 AM";
//hzbCode = H201703301257284684;
//owner = U2017032915445414717;
//ownerAmount = 5000;
//ownerCurrency = HBYJ;
//ownerUser =                 {
//    identityFlag = 1;
//    loginName = 13868074590;
//    mobile = 13868074590;
//    nickname = 45414717;
//    userId = U2017032915445414717;
//    userReferee = U2017010713451027748;
//};
//receiveAmount = 5000;
//receiveCurrency = GXJL;
//remark = "\U7a0b\U5e8f\U6bcf\U65e5\U81ea\U52a8\U751f\U6210\U7684\U5b9a\U5411\U7ea2\U5305";
//slogan = "\U5c0f\U5c0f\U5fc3\U610f";
//status = 0;
//systemCode = "CD-CZH000001";

