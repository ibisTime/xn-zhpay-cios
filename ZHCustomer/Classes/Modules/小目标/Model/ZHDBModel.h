//
//  ZHDBModel.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/22.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@interface ZHDBModel : TLBaseModel


@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *createDatetime;
@property (nonatomic, copy) NSString *advPic;
@property (nonatomic, copy) NSString *slogan;
@property (nonatomic, copy) NSString *templateCode;

//from to 相对平台而言 ----
@property (nonatomic, strong) NSNumber *fromAmount; //单价
@property (nonatomic, copy) NSString *fromCurrency; //单价币种
@property (nonatomic, strong) NSNumber *toAmount; //中奖金额
@property (nonatomic, copy) NSString *toCurrency; //中奖币种

@property (nonatomic, strong, readonly) NSNumber *amount; //中奖金额
@property (nonatomic, copy, readonly) NSString *currency; //中奖币种
@property (nonatomic, strong, readonly) NSNumber *price; //购买金额

@property (nonatomic, strong) NSNumber *maxNum; //每人最大投
@property (nonatomic, strong) NSNumber *periods;//期数
@property (nonatomic, strong) NSNumber *investNum;
@property (nonatomic, strong) NSNumber *totalNum;


//0 募集中，1--已揭晓
@property (nonatomic, strong) NSNumber *status;

//反向次数
@property (nonatomic, assign) NSInteger count;

//历史记录可能出现的字段
@property (nonatomic, strong) NSDictionary *user; //获奖用户

@property (nonatomic, copy, readonly) NSString *winUserNickName; //获奖时间
@property (nonatomic, copy) NSString *winDatetime; //获奖时间
@property (nonatomic, copy) NSString *winNumber; //获奖号码
@property (nonatomic, copy) NSString *winUser; //获奖用户

- (NSString *)getPriceDetail;

- (NSString *)getPriceCurrencyName;

- (float )getProgress;

//剩余人数
- (NSInteger)getSurplusPeople;

//advPic = "\U5ba3\U4f20\U56feupdate";
//code = J201703221710011129;
//companyCode = "CD-CZH000001";
//fromAmount = 10;
//fromCurrency = FRB;
//investNum = 3;
//maxNum = 10;

//periods = 2;

//slogan = "\U5ba3\U4f20\U6587\U5b57update";
//startDatetime = "Mar 22, 2017 5:10:01 PM";
//status = 0;
//systemCode = "CD-CZH000001";
//templateCode = JT201703221427246662;

//toAmount = 10;
//toCurrency = FRB;

//totalNum = 10;
@end
