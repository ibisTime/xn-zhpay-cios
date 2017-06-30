//
//  ZHBankCard.h
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/24.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHBankCard : TLBaseModel

@property (nonatomic,strong) NSNumber *bankId;

@property (nonatomic,copy) NSString *bankcardNumber;
@property (nonatomic,copy) NSString *subbranch;


@property (nonatomic,copy) NSString *code;
@property (nonatomic,copy) NSString *bankCode;
@property (nonatomic,copy) NSString *bankName;
@property (nonatomic,copy) NSString *bindMobile;
@property (nonatomic,copy) NSString *channelType;
@property (nonatomic,copy) NSString *payType;//
@property (nonatomic,copy) NSString *status;
@property (nonatomic,strong) NSString *realName;

/**只读渠道银行代号*/
@property (nonatomic,copy) NSString *paybank; //


//bankName = "\U4e2d\U56fd\U5de5\U5546\U94f6\U884c";
//bankcardNumber = 6227002451621164355;
//bindMobile = 15737935671;
//code = CT2017011616073230011;
//createDatetime = "Jan 16, 2017 4:07:32 PM";
//currency = CNY;
//realName = "\U7530\U78ca";
//status = 1;
//subbranch = "\U604d\U604d\U60da\U60da";
//systemCode = "CD-CZH000001";
//type = B;
//userId = U2017011704242588411;
@end


