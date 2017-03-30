//
//  ZHCoupon.h
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/20.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLBaseModal.h"
@class ZHShop;

@interface ZHCoupon : TLBaseModal

@property (nonatomic,copy) NSString *code;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,strong) NSNumber *key1; //满足金额
@property (nonatomic,strong) NSNumber *key2; //减免 或者 返现金额
@property (nonatomic,strong) NSNumber *price;

@property (nonatomic,copy) NSString *desc;

@property (nonatomic,copy) NSString *currency; //币种

@property (nonatomic,strong) ZHShop *store;
@property (nonatomic,strong) ZHCoupon *storeTicket;


//0. 未使用 1.已经使用 2.过期
@property (nonatomic,copy) NSString *status;  //
@property (nonatomic,copy) NSString *storeCode; //店铺编号
@property (nonatomic,copy) NSString *systemCode; //系统编号

@property (nonatomic,copy) NSString *validateStart; //开始时间
@property (nonatomic,copy) NSString *validateEnd; //结束时间

//我的折扣券--查出列表
@property (nonatomic,copy) NSString *ticketCode;
@property (nonatomic,strong) NSNumber *ticketKey1;
@property (nonatomic,strong) NSNumber *ticketKey2;

@property (nonatomic,strong) NSString *ticketName; //店铺名称


//@property (nonatomic,strong) NSString *ticketCode;
//@property (nonatomic,strong) NSString *ticketCode;

- (NSAttributedString *)discountInfoDescription01IsIng:(BOOL)isIng;

- (NSString *)discountInfoDescription01;
- (NSString *)discountInfoDescription02;


// 我的折扣券
//code = UT201701061232276735;
//createDatetime = "Jan 6, 2017 12:32:27 PM";
//status = 0;
//systemCode = "CD-CZH000001";
//ticketCode = ZKQ201701052055232041;
//ticketKey1 = 100000;
//ticketKey2 = 10000;
//ticketName = "Iosios--2-2";
//ticketType = 1;
//userId = U2017010321173181049;

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
//
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

