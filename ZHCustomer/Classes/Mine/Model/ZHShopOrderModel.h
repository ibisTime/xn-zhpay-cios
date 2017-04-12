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

@property (nonatomic,strong) NSNumber *payAmount2;
@property (nonatomic,strong) NSNumber *payAmount3;

@property (nonatomic,strong) NSNumber *price; //实际消费


@property (nonatomic,copy) NSString *code;
@property (nonatomic,copy) NSString *createDatetime;
@property (nonatomic,copy) NSString *jourCode;
@property (nonatomic,copy) NSString *payType;
@property (nonatomic,copy) NSString *remark;
@property (nonatomic,copy) NSString *status;

@property (nonatomic,copy) NSString *storeCode;
@property (nonatomic,copy) NSString *systemCode;
@property (nonatomic,copy) NSString *userId;

@property (nonatomic,strong) ZHShop *store; //店铺
@property (nonatomic,strong) ZHCoupon *storeTicket;

//code = XF201704072234037989;
//companyCode = "CD-CZH000001";
//createDatetime = "Apr 7, 2017 10:34:03 PM";
//payAmount2 = 0;
//payAmount3 = 8000;
//payDatetime = "Apr 7, 2017 10:34:03 PM";
//payType = 1;
//price = 8000;
//remark = "\U4f59\U989d\U652f\U4ed8O2O\U6d88\U8d39";
//status = 1;
//storeCode = SJ201704071916221314;
//storeTicket =                 {
//    code = ZKQ201704072159487938;
//    companyCode = "CD-CZH000001";
//    createDatetime = "Apr 7, 2017 9:59:48 PM";
//    currency = QBB;
//    description = "\U604d\U604d\U60da\U60da\U604d\U604d\U60da\U60da\U7ea2\U7ea2\U706b\U706b";
//    key1 = 10000;
//    key2 = 2000;
//    name = iOS;
//    price = 2000;
//    status = 1;
//    storeCode = SJ201704071916221314;
//    systemCode = "CD-CZH000001";
//    type = 1;
//    validateEnd = "Apr 10, 2017 11:59:59 PM";
//    validateStart = "Apr 7, 2017 12:00:00 AM";
//};
//systemCode = "CD-CZH000001";
//ticketCode = UT201704072204231656;
//userId = U2017040717590812033;
//
//store =                 {
//    address = "\U9690\U9690\U7ea6\U7ea6";
//    advPic = "IOS_1491563815353436_950_1280.jpg";
//    area = "\U4e0a\U57ce\U533a";
//    bookMobile = 13868074590;
//    city = "\U676d\U5dde\U5e02";
//    code = SJ201704071916221314;
//    companyCode = "CD-CZH000001";
//    contractNo = "ZHS-201704072158345502";
//    description = "\U604d\U604d\U60da\U60da";
//    isDefault = 1;
//    latitude = "30.28818948867784";
//    legalPersonName = "\U604d\U604d\U60da\U60da";
//    level = 2;
//    longitude = "120.00159844957810";
//    name = iOS;
//    owner = U2017040716091756386;
//    pic = "IOS_1491563815569674_950_1280.jpg";
//    province = "\U6d59\U6c5f\U7701";
//    rate1 = "0.1";
//    rate2 = "0.1";
//    rate3 = 0;
//    slogan = "\U604d\U604d\U60da\U60da";
//    smsMobile = 13868074590;
//    status = 2;
//    systemCode = "CD-CZH000001";
//    totalDzNum = 0;
//    totalJfNum = 0;
//    totalRmbNum = 0;
//    totalScNum = 0;
//    type = 5;
//    uiLocation = 0;
//    uiOrder = 1;
//    updateDatetime = "Apr 7, 2017 9:58:54 PM";
//    updater = admin;
//    userReferee = U2017040717590812033;
//};

- (NSString *)getStatusName;
@end
