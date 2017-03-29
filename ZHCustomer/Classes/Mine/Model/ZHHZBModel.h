//
//  ZHHZBModel.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/8.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@interface ZHHZBModel : TLBaseModel

@property (nonatomic,copy) NSString *code;
@property (nonatomic,copy) NSString *CNY;
@property (nonatomic,copy) NSString *desc;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *pic;

@property (nonatomic,strong) NSNumber *price;
@property (nonatomic,copy) NSString *ID;


@property (nonatomic,copy) NSString *mobile;
@property (nonatomic,copy) NSString *shareUrl;

//我的HUB
@property (nonatomic,strong) NSNumber *totalRockNum;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSNumber *distance;
@property (nonatomic,copy) NSString *userId;


- (NSString *)getStatusName;

//currency = CNY;
//hzbCode = HZB001;
//id = 7;
//periodRockNum = 0;
//price = 2000000;
//status = 1;
//systemCode = "CD-CZH000001";
//totalRockNum = 0;
//userId = U2017010615181802379;


//--------///
//"name": "汇赚宝",
//"pic": "http://123/default.jpg",
//"price": "2000000",
//"currency": "CNY",
//"periodRockNum": "10",
//"totalRockNum": "CNY",
//"backAmount1": "0",
//"backAmount2": "0",
//"backAmount3": "0",
//"updater": "admin",
//"remark": "备注",
//"systemCode": "CD-CZH000001",
//"companyCode": "CD-CZH000001",
//"token": "token"


@end
