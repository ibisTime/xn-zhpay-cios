//
//  NSString+Extension.m
//  OMMO
//
//  Created by haiqingzheng on 15/12/7.
//  Copyright © 2015年 OMMO. All rights reserved.
//

#import "NSString+Extension.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Extension)

- (BOOL)isPhoneNum {

   NSString *str = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
//    NSRegularExpression *reg = [[NSRegularExpression alloc] initWithPattern:@"^1[3,4,5,7,8]\\d{9}$" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *regStr = @"^1[3,4,5,7,8]\\d{9}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regStr];
   return [predicate evaluateWithObject:str];

}

- (BOOL)isBlank
{
    NSString *s = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (s == nil || [s isEqualToString:@""]) {
        return true;
    }
    return false;
}

- (BOOL)isNotBlank
{
    NSString *s = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(s != nil && ![s isEqualToString:@""]) {
        return true;
    }
    return false;
}

- (BOOL)isBlankName
{
    if (self.length <= 0 || self.length > 40) {
        return NO;
    }
    
    if ([self isChinese]) {
        return YES;
    } else {
        return NO;
    }

}

- (NSAttributedString *)attrStr {

    return [[NSAttributedString alloc] initWithString:self];

}
- (NSString *)convertThumbnailImageUrl{
//  限定长边，生成不超过 300x300 的缩略图
    if ([self hasPrefix:@"http"] || [self hasPrefix:@"https"]) {
        
        return self;
        
    } else {
        
        return [[@"http:/7xnuu2.com1.z0.glb.clouddn.com/" add:self] add:@"?imageMogr2/auto-orient/strip/thumbnail/300x300/quality/60!"];
    }
    
}

- (CGSize)imgSizeByImageName:(NSString *)imageName {

    if ([imageName hasPrefix:@"http"]) {
       
        return CGSizeMake(4,3);
        
    } else {
    
        if ([imageName hasSuffix:@".jpg"] || [imageName hasSuffix:@".png"]) {
            
          NSString *urlName = [imageName substringWithRange:NSMakeRange(0, imageName.length - 4)];
          NSArray *arr = [urlName componentsSeparatedByString:@"_"];
            
          if (arr.count > 2) {
                
                CGFloat h = [arr[arr.count - 1] floatValue];
                CGFloat w = [arr[arr.count - 2] floatValue];
                return CGSizeMake(w, h);
          } else {
          
              return CGSizeMake(4, 3);

          }
            
        } else if ([imageName hasSuffix:@".jpeg"]) {
            
            NSString *urlName = [imageName substringWithRange:NSMakeRange(0, imageName.length - 5)];
            NSArray *arr = [urlName componentsSeparatedByString:@"_"];
            
            if (arr.count > 2) {
                
                CGFloat h = [arr[arr.count - 1] floatValue];
                CGFloat w = [arr[arr.count - 2] floatValue];
                return CGSizeMake(w, h);
            } else {
            
                return CGSizeMake(4, 3);

            }
            
        } else {
        
            return CGSizeMake(4, 3);
        }
    
    }

}

- (NSString *)convertImageUrl {

    //auto-orient 根据原信息 旋转
    //strip 取出图片原信息
    
    if ([self hasPrefix:@"http"]) {
        
        return self;
        
    } else {
    
        return [[@"http:/7xnuu2.com1.z0.glb.clouddn.com/" add:self] add:@"?imageMogr2/auto-orient/strip/quality/50!"];
        
    }


}


- (BOOL)isBankCardNo
{
    if ([self isDigital]) {
        
        if (self.length >= 6 && self.length <= 30) {
            
            return YES;
            
        } else {
            
            return NO;
        }
        
    } else {
        
        return NO;
        
    }
    
}

- (BOOL)isDigital:(NSUInteger)length
{
//    ^\d{n}$ n为数字
//    ^[0-9]*$ 是否为数字
    if (length == 18) {
        return YES;
    }
    
    BOOL result = false;
    NSString *regex = [NSString stringWithFormat:@"^\\d{%ld}$",length];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    result = [pred evaluateWithObject:self];
    return result;
    
}

- (BOOL)isDigital
{
    //    ^\d{n}$ n为数字
    //    ^[0-9]*$ 是否为数字
    if(0 == self.length) return NO;
    
    BOOL result = false;
    NSString *regex =@"^[0-9]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    result = [pred evaluateWithObject:self];
    return result;
}


- (BOOL)isDigitalOrLetter
{
    if (self.length == 0) {
        return NO;
    }
    BOOL result = false;
    NSString *regex =@"^[0-9a-zA-Z]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    result = [pred evaluateWithObject:self];
    return result;
}

- (BOOL)isLegal
{
    if (!self.length) {
        return NO;
    }
    BOOL result = false;
    NSString *regex = @"^[A-Za-z0-9\u3400-\u9FFF_-]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    result = [pred evaluateWithObject:self];

    return result;
    
}

- (BOOL)isChinese
{
    if (![self valid]) {
        return NO;
    }
    
    BOOL flag = YES;
     for(int i=0; i< [self length];i++)
     {
//       \u3400  \u9fcc
         int a = [self characterAtIndex:i];
         if( a >= 0x3400 && a <= 0x9fff){
         
         } else {
             flag = NO;
         }
     }
    return flag;
}

- (NSString *)md5String
{
    if(self == nil || [self length] == 0)
        return nil;
    
    const char *value = [self UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}

//获取app版本号
+ (NSString *)appVersionString {

    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

- (BOOL)valid {

    return  self != nil && self.length > 0;

}


- (CGSize)calculateStringSize:(CGSize)size font:(UIFont *)font
{
    CGSize stringSize;
    NSDictionary *dict = @{
                           NSFontAttributeName:font
                           };
    stringSize = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return stringSize;
}

- (NSString *)add:(NSString *)appendStr {

    return [self stringByAppendingString:appendStr];
}

- (BOOL)greaterThan:(NSNumber *)num {

    CGFloat v = [self floatValue];
    CGFloat t0 = v*1000;
    long long money = (long long)t0;
    if (money - [num longLongValue] > 0) {
        return YES;
    } else {
    
        return NO;
    }

}

- (BOOL)greaterThanOrEqual:(NSNumber *)num {

    if (!self) {
        return NO;
    }
    
    CGFloat v = [self floatValue];
    CGFloat t0 = v*1000;
    long long money = (long long)t0;
    if (money - [num longLongValue] >= 0) {
        return YES;
    } else {
        
        return NO;
    }

}




- (NSString *)convertToSysMoney {

    double v = [self doubleValue];
    double t0 = v*1000;
    long long money = (long long)t0;
    return [NSString stringWithFormat:@"%lld",money];
}
- (NSString *)convertToDetailDate {

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MMM dd, yyyy hh:mm:ss aa";
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    NSDate *date01 = [formatter dateFromString:self];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    formatter.locale = [NSLocale currentLocale];
    
    return [formatter stringFromDate:date01];
    
}


- (NSString *)convertDate {

    return [self converDate];
}


- (NSString *)converDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MMM dd, yyyy hh:mm:ss aa";
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    NSDate *date01 = [formatter dateFromString:self];
    formatter.dateFormat = @"yyyy-MM-dd";
    formatter.locale = [NSLocale currentLocale];
    
    return [formatter stringFromDate:date01];
}

@end
