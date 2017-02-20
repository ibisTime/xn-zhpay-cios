//
//  ZHMonthCardModel.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/7.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModal.h"

@interface ZHMonthCardModel : TLBaseModal

@property (nonatomic,strong) NSNumber *backCount;

@property (nonatomic,copy) NSString *backInterval;
@property (nonatomic,copy) NSString *code;
@property (nonatomic,copy) NSString *currency;
@property (nonatomic,copy) NSString *name;

@property (nonatomic,strong) NSNumber *capital; //总股本




//@property (nonatomic,copy) NSString *description;
@property (nonatomic,copy) NSString *desc;
@property (nonatomic, strong) NSNumber *price; //价格
// 1 2已清算
@property (nonatomic,copy) NSString *status; //状态
@property (nonatomic,copy) NSString *type; //类型
@property (nonatomic,strong) NSNumber *welfare1;//已得奖励
@property (nonatomic,strong) NSNumber *welfare2;//下次奖励

@property (nonatomic,strong) ZHMonthCardModel *stock;
//
//backCount = 10;
//backInterval = 30;
//capital = 5000;
//code = ST00000004;
//currency = CNY;
//description = "\U80a1\U4efd50000";
//name = "\U80a1\U4efd\U4e94\U4e07";
//price = 50000000;
//status = 1;
//systemCode = "CD-CZH000001";
//type = D;
//welfare1 = 5000;
//welfare2 = 5000;

//我的月卡信息字段
@property (nonatomic,copy) NSString *nextBack; //下次返还时间
@property (nonatomic,strong) NSNumber *backNum; //下次返还时间
@property (nonatomic,strong) NSNumber *backWelfare1; //下次返还时间
@property (nonatomic,strong) NSNumber *backWelfare2; //下次返还时间
//@property (nonatomic,strong) NSNumber *id;

@property (nonatomic,copy) NSString *stockCode; //股票代码

- (NSString *)getStatusName;
//
//id = 3;
//nextBack = "Jan 9, 2017 12:00:00 AM";
//status = 1;
//stockCode = ST00000004;
//systemCode = "CD-CZH000001";
//userId = U2017010615181802379;

@end
