//
//  ZHDBHistoryModel.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/22.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"
#import "ZHDBModel.h"
@interface ZHDBHistoryModel : TLBaseModel

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *investDatetime;

@property (nonatomic, strong) ZHDBModel *jewel;


@property (nonatomic, copy) NSString *jewelCode;
//号码
//@property (nonatomic, copy) NSArray *jewelRecordNumberList;



@property (nonatomic, copy) NSString *myInvestTimes;

@property (nonatomic, strong) NSNumber *payAmount;
@property (nonatomic, copy) NSString *payDatetime;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSNumber *times;
@property (nonatomic, copy) NSString *photo;

@property (nonatomic, copy) NSString *ip;
@property (nonatomic, copy) NSString *city;

//投资者信息
@property (nonatomic, strong) NSDictionary *user;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *nickname;

//中奖 或者 参与
- (NSString *)getNowResultName;
- (NSMutableAttributedString *)getNowResultContent;


@end

//code = JR201704011132131594;
//companyCode = "CD-CZH000001";
//investDatetime = "Apr 1, 2017 11:32:13 AM";
//ip = "101.71.255.238";
//jewelCode = J201704011131055480;
//payAmount = 10000;
//payDatetime = "2017-04-01 11:32:13:160";
//status = 3;
//systemCode = "CD-CZH000001";
//times = 1;
//user =                 {
//    identityFlag = 1;
//    loginName = 18984955240;
//    mobile = 18984955240;
//    nickname = 74410381;
//    photo = "ANDROID_1490874687342_0_0.jpg";
//    userId = U2017032913574410381;
//    userReferee = U2017010713451027748;
//};
//userId = U2017032913574410381;
