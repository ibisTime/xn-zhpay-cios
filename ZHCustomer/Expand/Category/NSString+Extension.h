//
//  NSString+Extension.h
//  OMMO
//
//  Created by haiqingzheng on 15/12/7.
//  Copyright © 2015年 OMMO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

//拼接字符串
- (NSString *)add:(NSString *)appendStr;
- (NSAttributedString *)attrStr;

- (BOOL)isBlank;
- (BOOL)isNotBlank;

- (BOOL)isPhoneNum;

/** 是否为正确的银行名称 */
- (BOOL)isBlankName;
//是否为银行卡号
- (BOOL)isBankCardNo;

//指定长度的字符串是否为数字
- (BOOL)isDigital:(NSUInteger)length;
- (BOOL)isDigital;

//判断为字母或者数字的组合
- (BOOL)isDigitalOrLetter;

//检测
- (BOOL)isChinese;

//
- (BOOL)isLegal;

/** 返回加密MD5 string  32位字符串*/
- (NSString *)md5String;
//基本验证 不为nil ， 且长度不为0
- (BOOL)valid;

//处理图片的url
- (NSString *)convertThumbnailImageUrl;
- (NSString *)convertImageUrl;
- (CGSize)imgSizeByImageName:(NSString *)imageName;

- (CGSize)calculateStringSize:(CGSize)size font:(UIFont *)font;

//以元为单位的str 和以厘为单位的 钱比较大小
- (BOOL)greaterThan:(NSNumber *)num;
- (BOOL)greaterThanOrEqual:(NSNumber *)num;


//122.89元  转换为  122890厘
- (NSString *)convertToSysMoney;


//时间转换  Jan 5, 2017 12:00:00 AM -> 2016-02-02
- (NSString *)convertToDetailDate; //带有时分秒
- (NSString *)converDate;
- (NSString *)convertDate;

@end
