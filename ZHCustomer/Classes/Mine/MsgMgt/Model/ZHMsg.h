//
//  ZHMsg.h
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/24.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"
#import "ZHMsgContent.h"

@interface ZHMsg : TLBaseModel

//@property (nonatomic,strong) NSNumber *id;
//@property (nonatomic,copy) NSString *smsCode;
//@property (nonatomic,copy) NSString *userId;
//@property (nonatomic,copy) NSString *status;
//@property (nonatomic,copy) NSString *readDatetime;
//@property (nonatomic,strong) ZHMsgContent *b2cSms;

@property (nonatomic, copy) NSString *channelType;
@property (nonatomic, copy) NSString *createDatetime;
@property (nonatomic, copy) NSString *fromSystemCode;
@property (nonatomic, copy) NSString *pushType;
@property (nonatomic, copy) NSString *pushedDatetime;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *smsContent;
@property (nonatomic, copy) NSString *smsTitle;
@property (nonatomic, copy) NSString *smsType;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *toKind;
@property (nonatomic, copy) NSString *toSystemCode;


@property (nonatomic,assign) CGFloat contentHeight;



//channelType = 4;
//createDatetime = "Jan 19, 2017 2:03:27 PM";
//fromSystemCode = "CD-CZH000001";
//id = 2;
//pushType = 41;
//pushedDatetime = "Jan 19, 2017 2:03:38 PM";
//remark = "\U6d4b\U8bd5";
//smsContent = "<p>c\U7aef\U7528\U6237\U516c\U544a\Uff0c\U5f00\U4e1a\U53fb</p><p><br></p>";
//smsTitle = "c\U7aef\U7528\U6237\U516c\U544a";
//
//smsType = 1;
//status = 1;
//toKind = 1;
//toSystemCode = "CD-CZH000001";
//topushDatetime = "Jan 19, 2017 2:03:27 PM";
//updateDatetime = "Jan 19, 2017 2:03:38 PM";
//updater = admin;

@end



