//
//  ZHHZBModel.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/8.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

//我的汇赚宝状态：TO_PAY("0", "待支付"),
//ACTIVATED("1", "激活"),
//OFFLINE("91", "人为下架"),
//DIED("92","正常耗尽");

@interface ZHHZBModel : TLBaseModel

@property (nonatomic,copy) NSString *code;
@property (nonatomic,copy) NSString *CNY;
@property (nonatomic,copy) NSString *desc;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *pic;
@property (nonatomic,strong) NSNumber *price;
//@property (nonatomic,copy) NSString *ID;

@property (nonatomic,copy, readonly) NSString *mobile;

@property (nonatomic,copy) NSString *shareUrl;

//携带的用户信息
@property (nonatomic, strong) NSDictionary *user;

@property (nonatomic, copy,readonly) NSString *nickname;


//我的HUB
@property (nonatomic,strong) NSNumber *totalRockNum; //总的被摇次数
@property (nonatomic,strong) NSNumber *periodRockNum; //历史被摇次数

@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSNumber *distance;
@property (nonatomic,copy) NSString *userId;


@property (nonatomic, strong) NSNumber *backAmount1;
@property (nonatomic, strong) NSNumber *backAmount2;
@property (nonatomic, strong) NSNumber *backAmount3;

- (BOOL)isAbandon;

//backAmount1 = 0;
//backAmount2 = 0;
//backAmount3 = 0;
//code = H201703301257284684;
//companyCode = "CD-CZH000001";
//createDatetime = "Mar 30, 2017 12:57:28 PM";
//currency = CNY;
//distance = 0;
//payAmount1 = 0;
//payAmount2 = 10000;
//payAmount3 = 0;
//payDatetime = "Mar 30, 2017 12:57:28 PM";
//periodRockNum = 0;
//price = 10000;
//shareUrl = "http://www.sina.com.cn";
//status = 1;
//systemCode = "CD-CZH000001";
//templateCode = HT201700000000000001;
//totalRockNum = 0;
//user =             {
//    identityFlag = 1;
//    loginName = 13868074590;
//    mobile = 13868074590;
//    nickname = 45414717;
//    userId = U2017032915445414717;
//    userReferee = U2017010713451027748;
//};
//userId = U2017032915445414717;

- (NSString *)getStatusName;




@end
