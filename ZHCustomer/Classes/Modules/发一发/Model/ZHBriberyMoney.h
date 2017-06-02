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



@property (nonatomic, copy) NSString *receiveDatetime;

@property (nonatomic, assign) ZHBriberyMoneyStatus status;

@property (nonatomic, copy) NSString *createDatetime;
@property (nonatomic, copy) NSString *remark;


@property (nonatomic, strong) NSDictionary *ownerUser; //所属用户
@property (nonatomic, strong) NSDictionary *receiverUser; //受到用户
@property (nonatomic, copy, readonly) NSString *receiverUserName;
@property (nonatomic, copy, readonly) NSString *receiverMobile;



@end


//code = HM201704042024164784437;
//companyCode = "CD-CZH000001";
//createDatetime = "Apr 4, 2017 12:00:00 AM";
//hzbCode = H201704042024004361;
//owner = U2017032915445414717;
//ownerAmount = 5000;
//ownerCurrency = HBYJ;
//ownerUser =                 {
//    area = "\U4f59\U676d\U533a";
//    city = "\U676d\U5dde\U5e02";
//    identityFlag = 1;
//    loginName = 13868074590;
//    mobile = 13868074590;
//    nickname = 45414717;
//    photo = "IOS_1490927644354443_750_1334.jpg";
//    province = "\U6d59\U6c5f\U7701";
//    userId = U2017032915445414717;
//    userReferee = U2017010713451027748;
//};
//receiveAmount = 5000;
//receiveCurrency = GXJL;
//receiveDatetime = "Apr 4, 2017 8:37:46 PM";
//receiver = U2017040319554119943;
//receiverUser =                 {
//    area = "\U4f59\U676d\U533a";
//    city = "\U676d\U5dde\U5e02";
//    identityFlag = 0;
//    loginName = 15737935671;
//    mobile = 15737935671;
//    nickname = 54119943;
//    province = "\U6d59\U6c5f\U7701";
//    userId = U2017040319554119943;
//    userReferee = U2017032915445414717;
//};
//remark = "\U8be5\U7ea2\U5305\U5df2\U7ecf\U88ab\U9886\U53d6";
//slogan = "\U5c0f\U5c0f\U5fc3\U610f";
//status = 2;
//systemCode = "CD-CZH000001";

