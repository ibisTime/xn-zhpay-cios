//
//  ZHCurrencyHelper.h
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/29.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHCurrencyHelper.h"
#import <UIKit/UIKit.h>
@interface ZHCurrencyHelper : NSObject

+ (NSMutableAttributedString *)totalPriceAttr2WithQBB:(NSNumber *)qbb GWB:(NSNumber *)gwb RMB:(NSNumber *)rmb bouns:(CGRect)bouns;

/**
 把各种币转换为属字符串，只负责组装，不负责

 @param qbb 钱包币
 @param gwb 购物币
 @param rmb 人民币
 @return 总额
 */
+ (NSMutableAttributedString *)totalPriceAttrWithQBB:(NSString *)qbb GWB:(NSString *)gwb RMB:(NSString *)rmb;

+ (NSMutableAttributedString *)totalPriceAttr2WithQBB:(NSNumber *)qbb GWB:(NSNumber *)gwb RMB:(NSNumber *)rmb;

/**
 直接把系统的 以厘为单位钱币进行转换

 @param qbb 钱包币
 @param gwb 购物币
 @param rmb 人民币
 @return 总额
 */
+ (NSString *)totalPriceWithQBB:(NSNumber *)qbb GWB:(NSNumber *)gwb RMB:(NSNumber *)rmb;

//根据单价 和 数量计算总价
+ (NSMutableAttributedString *)calculatePriceWithQBB:(NSNumber *)qbb GWB:(NSNumber *)gwb RMB:(NSNumber *)rmb count:(NSInteger)count;

+ (NSMutableAttributedString *)calculatePriceWithQBB:(NSNumber *)qbb GWB:(NSNumber *)gwb RMB:(NSNumber *)rmb count:(NSInteger)count addPostageRmb:(NSNumber *)postage;

//如下表现形式
// 人民币 100 呈阶梯装
// 购物币 100
// 钱宝币 100
+ (NSMutableAttributedString *)stepPriceWithQBB:(NSNumber *)qbb GWB:(NSNumber *)gwb RMB:(NSNumber *)rmb bounds:(CGRect)bounds count:(NSInteger)count;

+ (NSAttributedString *)QBBWithBouns:(CGRect)bouns;

//
+ (NSAttributedString *)totalRMBWithPrice:(NSNumber *)price count:(NSInteger)count;
+ (NSAttributedString *)totalPriceWithPrice:(NSNumber *)price count:(NSInteger)count;

@end
