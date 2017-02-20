//
//  ZHBillModel.h
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/24.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHBillModel : TLBaseModal

@property (nonatomic,copy) NSString *accountNumber;
@property (nonatomic,copy) NSString *bizNote; //备注

@property (nonatomic,copy) NSString *bizType;
@property (nonatomic,copy) NSString *channelType;
@property (nonatomic,copy) NSString *code;
@property (nonatomic,copy) NSString *createDatetime;
@property (nonatomic,copy) NSString *postAmount;
@property (nonatomic,copy) NSString *preAmount;
@property (nonatomic,copy) NSString *realName;

@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *systemCode;
@property (nonatomic,strong) NSNumber *transAmount;

@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *workDate; //工作日期


- (NSString *)getBizName;
- (CGFloat)dHeightValue;

@end


//accountNumber = A2017010713460440141;
//bizNote = "A\U4e70\U7b2c\U4e00\U6863\U798f\U5229\U6708\U5361\Uff0cA\U548c\U5404\U8f96\U533a\U5206\U9500\U5206\U6210,A\U7528\U6237\U5206\U6210\U5206\U6da6";
//bizType = "-34";
//channelType = 0;
//code = AJ2017010714091449794;
//createDatetime = "Jan 7, 2017 2:09:14 PM";
//postAmount = 2000;
//preAmount = 1000;
//realName = 18767101910;
//status = 1;
//systemCode = "CD-CZH000001";
//transAmount = 1000;
//userId = U2017010713462735019;
//workDate = 20170107;
