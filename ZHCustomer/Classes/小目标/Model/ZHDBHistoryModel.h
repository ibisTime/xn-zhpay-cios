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

@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *myInvestTimes;

@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, strong) NSNumber *payAmount;
@property (nonatomic, copy) NSString *payDatetime;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSNumber *times;
@property (nonatomic, copy) NSString *photo;

@property (nonatomic, copy) NSString *ip;
@property (nonatomic, copy) NSString *city;

//中奖 或者 参与

- (NSString *)getNowResultName;
- (NSMutableAttributedString *)getNowResultContent;


@end


//code = JR201702221356574805;
//investDatetime = "Feb 22, 2017 1:56:57 PM";
//jewel =                 {
//    advPic = "\U5ba3\U4f20\U56fe";
//    advText = "\U5ba3\U4f20\U6587\U5b57";
//    amount = 10000;
//    code = J201702212016103067;
//    createDatetime = "Feb 21, 2017 8:16:10 PM";
//    currency = FRB;
//    investNum = 0;
//    maxInvestNum = 1000;
//    periods = 2;
//    price = 10000;
//    status = 0;
//    systemCode = "CD-CZH000001";
//    templateCode = JT201702212000179938;
//    totalNum = 100;
//};
//jewelCode = J201702212016103067;
//jewelRecordNumberList =                 (
//);
//mobile = 15888888888;
//myInvestTimes = 0;
//nickname = 34980222;
//payAmount = 0;
//payDatetime = "Feb 22, 2017 1:56:57 PM";
//remark = "\U5df2\U5206\U914d\U53f7\U7801\Uff0c\U5f85\U5f00\U5956";
//status = 1;
//systemCode = "CD-CZH000001";
//times = 0;
//userId = U2017022117434980222;
