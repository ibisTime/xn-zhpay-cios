//
//  ZHMsgContent.h
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/24.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@interface ZHMsgContent : TLBaseModel

@property (nonatomic,copy) NSString *code;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *toCompany;
@property (nonatomic,copy) NSString *toLevel;
@property (nonatomic,copy) NSString *toUser;
@property (nonatomic,copy) NSString *companyCode;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *updater;
@property (nonatomic,copy) NSString *updateDatetime;

@end

