//
//  ZHDBModel.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/22.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@interface ZHDBModel : TLBaseModel

@property (nonatomic, copy) NSString *advPic;
@property (nonatomic, copy) NSString *advText;

@property (nonatomic, copy) NSString *templateCode;

@property (nonatomic, strong) NSNumber *amount; //中奖金额
@property (nonatomic, copy) NSString *currency; //中奖币种

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *createDatetime;

@property (nonatomic, strong) NSNumber *investNum;
@property (nonatomic, strong) NSNumber *totalNum;
@property (nonatomic, strong) NSNumber *maxInvestNum; //每人最大投

@property (nonatomic, strong) NSNumber *periods;

@property (nonatomic, strong) NSNumber *price; //购买金额

//0 募集中，1--已揭晓
@property (nonatomic, strong) NSNumber *status;

//反向次数
@property (nonatomic, assign) NSInteger count;

@property (nonatomic, copy) NSString *winDatetime; //获奖时间
@property (nonatomic, copy) NSString *winNumber; //获奖号码
@property (nonatomic, copy) NSString *winUser; //获奖用户



- (NSString *)getPriceDetail;
- (float )getProgress;

- (NSInteger)getSurplusPeople;


//advPic = "\U5ba3\U4f20\U56fe";
//advText = "\U5ba3\U4f20\U6587\U5b57";
//amount = 10000;
//code = J201702212016103067;
//createDatetime = "Feb 21, 2017 8:16:10 PM";
//currency = FRB;
//investNum = 0;
//maxInvestNum = 1000;
//periods = 2;
//price = 10000;
//status = 0;
//systemCode = "CD-CZH000001";
//templateCode = JT201702212000179938;
//totalNum = 100;

@end
