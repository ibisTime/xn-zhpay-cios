//
//  ZHReferralModel.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/7.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModal.h"

//#import <HyphenateLite/HyphenateLite.h>
//#import "EMConversation.h"

@interface ZHReferralModel : TLBaseModal

@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *nickname;
//@property (nonatomic,copy) NSString *refeereLevel;

@property (nonatomic,copy) NSDictionary *userExt;
@property (nonatomic, copy) NSString *level;

@property (nonatomic, copy) NSString *createDatetime;


//会话对象
//@property (nonatomic,strong) EMConversation *conversion;

//@property (nonatomic,copy) NSString *<#name#>;
//@property (nonatomic,copy) NSString *<#name#>;
//@property (nonatomic,copy) NSString *<#name#>;
//@property (nonatomic,copy) NSString *<#name#>;



//"userId": "U2016121519373971225",
//"loginName": "18984955240",
//"nickname": "73971225",
//"loginPwdStrength": "1",
//"kind": "f1",
//"level": "0",
//"userReferee": "",
//"mobile": "18984955240",
//"status": "0",
//"updater": "U2016121519373971225",
//"updateDatetime": "Dec 15, 2016 7:37:39 PM",
//"remark": "前端个人用户",
//"amount": 0,
//"ljAmount": 0,
//"systemCode": "CD-CZH000001",
//"refeereLevel": 1

@end
