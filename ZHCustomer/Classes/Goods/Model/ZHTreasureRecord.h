//
//  ZHTreasureRecord.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/18.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"
#import "ZHCurrencyProtocol.h"

@interface ZHTreasureRecord : TLBaseModel<ZHCurrencyProtocol>

@property (nonatomic,copy) NSString *code;
@property (nonatomic,copy) NSString *createDatetime;
@property (nonatomic,copy) NSString *jewelCode;


@property (nonatomic,strong) NSNumber *myInvestTimes;
@property (nonatomic,copy) NSString *times;

@property (nonatomic,copy) NSString *photo;
@property (nonatomic,copy) NSString *nickname;

@property (nonatomic,strong) NSNumber *payAmount1;
@property (nonatomic,strong) NSNumber *payAmount2;
@property (nonatomic,strong) NSNumber *payAmount3;

//myInvestTimes = 46;
//nickname = "\U9690\U9690\U7ea6\U7ea6";
//payAmount1 = 0;
//payAmount2 = 400000;
//payAmount3 = 0;
//photo = "IOS_1484536903784790_950_1280.jpg";
//remark = "\U5df2\U5206\U914d\U593a\U5b9d\U53f7\Uff0c\U5f85\U5f00\U5956";
//status = 1;
//systemCode = "CD-CZH000001";
//times = 4;
//userId = U2017011704242588411;
//
//
//code = IR201701171955039342;
//createDatetime = "Jan 17, 2017 7:55:03 PM";

@end
