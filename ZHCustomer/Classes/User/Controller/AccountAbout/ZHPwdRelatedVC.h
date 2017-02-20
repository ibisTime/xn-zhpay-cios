//
//  ZHPwdRelatedVC.h
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/12.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHAccountSetBaseVC.h"


typedef  NS_ENUM(NSInteger,ZHPwdType) {
    
    ZHPwdTypeForget = 0, //忘记密码
    ZHPwdTypeReset, //重设密码
    ZHPwdTypeTradeReset //交易密码
};

@interface ZHPwdRelatedVC : ZHAccountSetBaseVC

- (instancetype)initWith:(ZHPwdType)type;

@property (nonatomic,copy)  void(^success)();


@end
