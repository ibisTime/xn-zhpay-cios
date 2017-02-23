//
//  ZHDBHistoryModel.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/22.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHDBHistoryModel.h"

@implementation ZHDBHistoryModel

- (NSString *)getNowResultName {

    if ([self.jewel.status isEqual:@1]) {
        
        return @"中奖";
        
    } else {
    
        return @"参与";
    }

}

- (NSMutableAttributedString *)getNowResultContent {

    NSString *securityMobile = [self.mobile stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    
    if ([self.jewel.status isEqual:@1]) { //已经揭晓
        
        NSString *allStr = [NSString stringWithFormat:@"%@ 中得 %@",securityMobile,[self.jewel getPriceDetail]];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:allStr];
        
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor zh_themeColor] range:NSMakeRange(0, securityMobile.length)];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor zh_themeColor] range:NSMakeRange(securityMobile.length + 4, [self.jewel getPriceDetail].length)];
        
        return attr;
        
    } else {
        
        NSString *countStr = [NSString stringWithFormat:@"%@",self.times];
        
        NSString *allStr = [NSString stringWithFormat:@"%@ 参与 %@ 次抢红包",securityMobile,countStr];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:allStr];
        
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor zh_themeColor] range:NSMakeRange(0, securityMobile.length)];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor zh_themeColor] range:NSMakeRange(securityMobile.length + 4, countStr.length)];
        
        return attr;
    }
    
    

}

@end
