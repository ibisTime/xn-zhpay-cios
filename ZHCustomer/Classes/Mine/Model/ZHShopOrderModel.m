//
//  ZHShopOrderModel.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/4.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHShopOrderModel.h"
#import "ZHPayService.h"
#import "TLHeader.h"
#import "UIColor+theme.h"
#import "ZHUser.h"

@implementation ZHShopOrderModel

- (NSString *)getStatusName {
    
    NSDictionary *dict = @{
                           
                           @"0" : @"待支付",
                           @"1" : @"已支付",
                           @"2" : @"已取消"
                           };
    
    return dict[self.status];
    
}

- (NSAttributedString *)displayPayStr {

    
    NSString *str = [NSString stringWithFormat:@"%@%@",[self priceUnit], [self.price convertToRealMoney]];
    
    NSMutableAttributedString *attrPr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"消费：%@",str]];
    [attrPr addAttribute:NSForegroundColorAttributeName value:[UIColor textColor] range:NSMakeRange(0, 3)];
    
    return attrPr;

    

    

}

- (NSString *)priceUnit {

    if ([self.payType isEqualToString:kZHGiftPayTypeCode]) {
        
        return @"礼品券";
    } else if([self.payType isEqualToString:kZHLMBPayTypeCode]) {
    
        return @"联盟券";
        
    } else {
    
        return @"￥";
    }

}

- (BOOL)isGiftShop {

    return [self.payType isEqualToString: kZHGiftPayTypeCode];
    
}


@end
