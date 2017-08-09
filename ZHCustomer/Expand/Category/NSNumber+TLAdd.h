//
//  NSNumber+TLAdd.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/5.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (TLAdd)

//转换金额
- (NSString *)convertToRealMoney;


/**
 正常转换
*/
- (NSString *)convertToRealMoneyRuleBySystem;


//能去掉小数点的尽量去掉小数点
- (NSString *)convertToSimpleRealMoney;

- (NSString *)convertToRealMoneyWithCount:(NSInteger)count;

//- (NSString *)covertToRealMoney;
//
//- (NSString *)covertToSimpleRealMoney;

@end
