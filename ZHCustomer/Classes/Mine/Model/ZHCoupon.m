//
//  ZHCoupon.m
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/20.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHCoupon.h"

@implementation ZHCoupon


- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

    if ([key isEqualToString:@"description"]) {
        if (value) {
            
            self.desc = value;

        }
    }
}

- (NSAttributedString *)discountInfoDescription01IsIng:(BOOL)isIng {

    NSString *prc1;
    NSString *prc2;

 
        
        prc1 = [self.key1 convertToSimpleRealMoney];
        prc2 = [self.key2 convertToSimpleRealMoney];
        
    
    
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"满 %@ 减 %@",prc1,prc2]];
    if (isIng) {
       
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor zh_themeColor] range:NSMakeRange(2, prc1.length)];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor zh_themeColor] range:NSMakeRange(2 + prc1.length + 3 , prc2.length)];
    }

    return attrStr;



}

- (NSString *)discountInfoDescription01 {
    
    

     return [NSString stringWithFormat:@"满 %@ 减 %@",[self.key1 convertToSimpleRealMoney],[self.key2 convertToSimpleRealMoney]];
        
    
}
- (NSString *)discountInfoDescription02 {

    
//    if (self.storeTicket) { //我的折扣券
    
        return [NSString stringWithFormat:@"满 %@\n减 %@",[self.key1 convertToSimpleRealMoney],[self.key2 convertToSimpleRealMoney]];
        
//    }
    
    
//    else { //商铺这口儿去年前
//        
//        return [NSString stringWithFormat:@"满 %@\n减 %@",[self.ticketKey1 convertToSimpleRealMoney],[self.ticketKey2 convertToSimpleRealMoney]];
//        
//    }
    

}


@end
