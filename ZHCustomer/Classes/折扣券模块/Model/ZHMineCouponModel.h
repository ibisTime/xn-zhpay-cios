//
//  ZHMineCouponModel.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/4/3.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"
#import "ZHCoupon.h"
#import "ZHShop.h"

@interface ZHMineCouponModel : TLBaseModel

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *createDatetime;
@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *userId; //所属人

//折扣券
@property (nonatomic, strong) ZHCoupon *storeTicket;

//所属店铺
@property (nonatomic, strong) ZHShop *store;


//code = UT201703301516274763;
//createDatetime = "Mar 30, 2017 3:16:27 PM";
//status = 0;

//storeTicket =                 {
//    code = ZKQ201703291508372122;
//    companyCode = "CD-CZH000001";
//    createDatetime = "Mar 29, 2017 3:08:37 PM";
//    currency = QBB;
//    description = "\U604d\U604d\U60da\U60da";
//    key1 = 100000;
//    key2 = 20000;
//    name = "Ios\U6298\U6263\U5238\U3002\U9690\U9690\U7ea6\U7ea6";
//    price = 20000;
//    status = 1;
//    storeCode = SJ201703291152426359;
//    systemCode = "CD-CZH000001";
//    type = 1;
//    validateEnd = "Apr 1, 2017 12:00:00 AM";
//    validateStart = "Mar 29, 2017 12:00:00 AM";
//};
//systemCode = "CD-CZH000001";
//ticketCode = ZKQ201703291508372122;
//userId = U2017032915445414717;
//store =                 {
//    address = "\U9690\U9690\U7ea6\U7ea6";
//    advPic = "IOS_1490768654437286_950_1280.jpg";
//    area = "\U4e0a\U57ce\U533a";
//    bookMobile = 1386855866;
//    city = "\U676d\U5dde\U5e02";
//    code = SJ201703291152426359;
//    companyCode = "CD-CZH000001";
//    description = "\U604d\U604d\U60da\U60da";
//    latitude = "30.28818213827786";
//    legalPersonName = "\U604d\U604d\U60da\U60da";
//    level = 1;
//    longitude = "120.00161517444184";
//    name = "\U604d\U604d\U60da\U60da";
//    owner = U2017032911375586527;
//    pic = "IOS_1490768666050592_800_600.jpg||IOS_1490768666039728_950_1280.jpg";
//    province = "\U6d59\U6c5f\U7701";
//    rate1 = "0.1";
//    rate2 = "0.1";
//    slogan = "\U604d\U604d\U60da\U60da";
//    smsMobile = 13868074590;
//    status = 2;
//    systemCode = "CD-CZH000001";
//    totalDzNum = 0;
//    totalJfNum = 0;
//    totalRmbNum = 0;
//    totalScNum = 0;
//    type = 2;
//    updateDatetime = "Mar 29, 2017 2:46:45 PM";
//    updater = U2017032911375586527;
//    userReferee = U2017010713451027748;
//};

@end
