//
//  ZHMineTreasureModel.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/12.
//  Copyright © 2017年  tianlei. All rights reserved.
//  我的夺宝记录 MODEL

#import "TLBaseModel.h"
#import "ZHTreasureModel.h"
#import "ZHTreasureRecordModel.h"

@interface ZHMineTreasureModel : TLBaseModel

//宝贝状态 -- 负责查询
//NEW("0", "待审批"), PASS("1", "审批通过"),
//UNPASS("2", "审批不通过"), PUT_ON("3", "夺宝进行中"),
//PUT_OFF("4", "强制下架"), EXPIRED("5", "到期流标"),
//SUCCESSED("6", "夺宝成功，待开奖"), TO_SEND("7", "已开奖，待发货");
// 看到： 3 5 6 7
@property (nonatomic,copy) NSString *code;
@property (nonatomic,copy) NSString *createDatetime;

@property (nonatomic,strong) ZHTreasureModel *jewel;
@property (nonatomic,copy) NSString *jewelCode;

@property (nonatomic,copy) NSArray <ZHTreasureRecordModel *>*jewelRecordNumberList;

@property (nonatomic,copy) NSString *nickname;
@property (nonatomic,copy) NSString *remark;
@property (nonatomic,strong) NSNumber *payAmount1;


@property (nonatomic,strong) NSNumber *times; //每次投资的次数

@property (nonatomic,strong) NSNumber *myInvestTimes; //我的投资次数

@property (nonatomic,copy) NSString *reAddress; //地址
@property (nonatomic,copy) NSString *reMobile; //手机号
@property (nonatomic,copy) NSString *receiver; //收货人

//只有在已中奖的时候，该字段才具有判断作用
@property (nonatomic,copy) NSString *status;


//是否揭晓
@property (nonatomic,assign,readonly) BOOL isAnnounced;



//id = 30;
//jewelCode = IW201701130052260172;
//number = 10000065;
//recordCode = IR201701130458540905;

@end

//宝贝状态---内部
//NEW("0", "待审批"), PASS("1", "审批通过"), UNPASS("2", "审批不通过"),
//PUT_ON("3", "夺宝进行中"),
//PUT_OFF("4", "下架"),
//EXPIRED("5", "到期流标"),
//TO_SEND("7","已开奖");

//宝贝记录状态---外层----status--
//TO_PAY("0", "待支付"), LOTTERY("1", "待开奖"),
//WINNING("2", "已中奖"), LOST("3","未中奖"),
//TO_SEND("4", "已填写地址，待发货"),
//SENT("5", "已发货"), SIGN("6","已签收");
