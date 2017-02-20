//
//  ZHShopOrderModel.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/4.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModal.h"
#import "ZHShop.h"

@interface ZHShopOrderModel : TLBaseModal

//@property (nonatomic,copy) NSString *code;
//@property (nonatomic,copy) NSString *userId;
//@property (nonatomic,strong) NSNumber *amount;
//@property (nonatomic,copy) NSString *createDatetime;
//@property (nonatomic,copy) NSString *storeCode;
//@property (nonatomic,copy) NSString *systemCode;

@property (nonatomic,strong) NSNumber *amount1;

@property (nonatomic,copy) NSString *code;
@property (nonatomic,copy) NSString *createDatetime;
@property (nonatomic,copy) NSString *jourCode;
@property (nonatomic,copy) NSString *payType;
@property (nonatomic,copy) NSString *remark;
@property (nonatomic,copy) NSString *status;

@property (nonatomic,copy) NSString *storeCode;
@property (nonatomic,copy) NSString *systemCode;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,strong) ZHShop *store;
@property (nonatomic,strong) ZHCoupon *storeTicket;

//amount1 = 100000;
//amount2 = 100000;
//amount3 = 0;
//code = XF201701170742385842;
//createDatetime = "Jan 17, 2017 7:42:38 AM";
//payType = 1;
//remark = "ios\U5e97\U94fa \U6d88\U8d39100.00\U5143";
//status = 1;
//store =                 {
//    adPic = "IOS_1484486218974364_1280_950.jpg";
//    address = "\U4f59\U676d\U54ea\U91cc";
//    approveDatetime = "Jan 17, 2017 6:57:01 AM";
//    approver = admin;
//    area = "\U957f\U5174\U53bf";
//    bookMobile = 13868074590;
//    city = "\U6e56\U5dde\U5e02";
//    code = SJ201701170429427443;
//    description = "\U604d\U604d\U60da\U60da\U604d\U604d\U60da\U60da\U54c8\U54c8\U54c8\U8fd9\U70b9\U4e0a\U73ed\U8def\U516c\U4ea4\U8f66\U4e13\U7528\U9053";
//    latitude = "30.28754643010961";
//    legalPersonName = "\U7530\U78ca";
//    longitude = "120.00069604342106";
//    name = "ios\U5e97\U94fa";
//    owner = U201701170427197658;
//    pic = "IOS_1484486219145374_1280_950.jpg||IOS_1484486219181269_950_1280.jpg";
//    province = "\U6d59\U6c5f\U7701";
//    rate1 = "0.99";
//    rate2 = "0.95";
//    remark = "bu tong guo";
//    slogan = "\U9690\U9690\U7ea6\U7ea6";
//    status = 2;
//    systemCode = "CD-CZH000001";
//    totalDzNum = 0;
//    totalJfNum = 0;
//    type = 3;
//    updateDatetime = "Jan 17, 2017 6:59:36 AM";
//    userReferee = U2017010713451027748;
//};
//storeCode = SJ201701170429427443;
//systemCode = "CD-CZH000001";
//userId = U2017011704242588411;
- (NSString *)getStatusName;
@end
