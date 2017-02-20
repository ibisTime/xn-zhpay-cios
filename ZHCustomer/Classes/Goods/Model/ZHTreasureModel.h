//
//  ZHTreasureModel.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/11.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@interface ZHTreasureModel : TLBaseModel

@property (nonatomic,copy) NSString *advPic; //广告图

@property (nonatomic,copy) NSString *approveDatetime;
@property (nonatomic,copy) NSString *code;

@property (nonatomic,copy) NSString *descriptionPic;//详情图片
@property (nonatomic,copy) NSString *descriptionText;//详情文字

@property (nonatomic,copy) NSString *name;

//price 1 人民币 price2 购物币，price 3 钱包币
@property (nonatomic,strong) NSNumber *price1;
@property (nonatomic,strong) NSNumber *price2;
@property (nonatomic,strong) NSNumber *price3;

@property (nonatomic,strong) NSNumber *raiseDays; //募集天数
@property (nonatomic,copy) NSString *remark;
@property (nonatomic,copy) NSString *slogan; //广告语
@property (nonatomic,copy) NSString *startDatetime;
//0 待审批 1 审批通过 2 审批不通过 3 夺宝进行中 4 强制下架 5 到期流标 6 夺宝成功，待开奖 7 已开奖，待发货 8 已发货，待收货 9 已收货
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *storeCode;

@property (nonatomic, strong) NSNumber *totalNum; //总量
@property (nonatomic, strong) NSNumber *investNum; //总量
@property (nonatomic, assign) NSInteger count;

@property (nonatomic,copy) NSString *winUserId;
@property (nonatomic,copy) NSString *winNumber;

//
@property (nonatomic,copy) NSArray <NSNumber *>*imgHeights;
@property (nonatomic,copy) NSArray *pics;

- (CGFloat)detailHeight;

- (CGFloat)getProgress;
- (NSString *)getSurplusTime;

//advPic = "IOS_1484104999321146_3000_2002.jpg";
//approveDatetime = "Jan 12, 2017 11:49:46 PM";
//approver = admin;
//code = IW201701121834162328;
//
//descriptionPic = "IOS_1484104999321201_3000_2002.jpg";
//descriptionText = "duo bao la";
//name = "To yuan duo nap";
//price1 = 10000;
//price2 = 100000;
//price3 = 1000000;
//raiseDays = 4;
//remark = "\U62d6\U8fc7";
//slogan = "Moment hao";
//startDatetime = "Jan 12, 2017 11:50:22 PM";
//
//status = 3;
//storeCode = U2017010615020673490;
//systemCode = "CD-CZH000001";
//totalNum = 1000;
//updateDatetime = "Jan 12, 2017 11:50:22 PM";
//updater = admin;

@end
