//
//  ZHBriberyMoneyVC.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/20.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"

typedef NS_ENUM(NSUInteger, ZHBriberyMoneyVCType) {
    
    ZHBriberyMoneyVCTypeFirstUI = 0, //一级界面
    ZHBriberyMoneyVCTypeSecondUI = 1, //二级界面
    ZHBriberyMoneyVCTypeHistory  //作为历史记录控制器
    
};

@interface ZHBriberyMoneyVC : TLBaseVC

@property (nonatomic, assign) ZHBriberyMoneyVCType displayType;

@end
