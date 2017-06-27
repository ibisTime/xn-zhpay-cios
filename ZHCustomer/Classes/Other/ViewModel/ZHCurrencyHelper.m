//
//  ZHCurrencyHelper.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/29.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHCurrencyHelper.h"

@implementation ZHCurrencyHelper


+ (NSMutableAttributedString *)totalPriceAttrWithQBB:(NSString *)qbb GWB:(NSString *)gwb RMB:(NSString *)rmb  {
    
    CGRect bBouns = CGRectMake(0, -2, 15, 15);
    return [self totalPriceAttrWithQBB:qbb GWB:gwb RMB:rmb bouns:bBouns];
}

+ (NSMutableAttributedString *)totalPriceAttr2WithQBB:(NSNumber *)qbb GWB:(NSNumber *)gwb RMB:(NSNumber *)rmb bouns:(CGRect)bouns {

    NSString *rmbStr = nil;
    NSString *qbbStr = nil;
    NSString *gwbStr = nil;
    
    if (![rmb isEqual:@0]) {
        rmbStr = [NSString stringWithFormat:@"%.2f",[rmb longValue]/1000.0];
    }
    
    if (![qbb isEqual:@0]) {
        
        qbbStr = [NSString stringWithFormat:@"%.2f",[qbb longValue]/1000.0];
    }
    
    
    if (![gwb isEqual:@0]) {
        
        gwbStr = [NSString stringWithFormat:@"%.2f",[gwb longValue]/1000.0];
        
    }
    
    return [self totalPriceAttrWithQBB:qbbStr GWB:gwbStr RMB:rmbStr bouns:bouns];

}

+ (NSMutableAttributedString *)totalPriceAttr2WithQBB:(NSNumber *)qbb GWB:(NSNumber *)gwb RMB:(NSNumber *)rmb {

    NSString *rmbStr = nil;
    NSString *qbbStr = nil;
    NSString *gwbStr = nil;
    
    if (![rmb isEqual:@0]) {
        rmbStr = [NSString stringWithFormat:@" %.2f",[rmb longValue]/1000.0];
    }
    
    if (![qbb isEqual:@0]) {
        
        qbbStr = [NSString stringWithFormat:@" %.2f",[qbb longValue]/1000.0];
    }
    
    if (![gwb isEqual:@0]) {
        
        gwbStr = [NSString stringWithFormat:@" %.2f",[gwb longValue]/1000.0];
        
    }
    
    return [self totalPriceAttrWithQBB:qbbStr GWB:gwbStr RMB:rmbStr];

}

+ (NSMutableAttributedString *)calculatePriceWithQBB:(NSNumber *)qbb GWB:(NSNumber *)gwb RMB:(NSNumber *)rmb count:(NSInteger)count addPostageRmb:(NSNumber *)postage {


    
    NSNumber *price1 = rmb;
    NSNumber *price2 = gwb;
    NSNumber *price3 = qbb;
    NSInteger num = count;
    
    //把空的剔除掉
    NSString *rmbStr = nil;
    NSString *qbbStr = nil;
    NSString *gwbStr = nil;
    
    if (![price1 isEqual:@0]) {
        rmbStr = [NSString stringWithFormat:@"%.2f",([price1 longValue]*num + [postage longValue])/1000.0];
    }
    
    if (![price3 isEqual:@0]) {
        qbbStr = [NSString stringWithFormat:@"%.2f",[price3 longValue]*num/1000.0];
    }
    
    if (![price2 isEqual:@0]) {
        gwbStr = [NSString stringWithFormat:@"%.2f",[price2 longValue]*num/1000.0];
    }
    
    return [self totalPriceAttrWithQBB:qbbStr GWB:gwbStr RMB:rmbStr];


}


+ (NSMutableAttributedString *)calculatePriceWithQBB:(NSNumber *)qbb GWB:(NSNumber *)gwb RMB:(NSNumber *)rmb count:(NSInteger)count {

    NSNumber *price1 = rmb;
    NSNumber *price2 = gwb;
    NSNumber *price3 = qbb;
    NSInteger num = count;

    //把空的剔除掉
    NSString *rmbStr = nil;
    NSString *qbbStr = nil;
    NSString *gwbStr = nil;
    
    if (![price1 isEqual:@0]) {
        rmbStr = [NSString stringWithFormat:@"%.2f",[price1 longValue]*num/1000.0];
    }
    
    if (![price3 isEqual:@0]) {
        qbbStr = [NSString stringWithFormat:@"%.2f",[price3 longValue]*num/1000.0];
    }
    
    if (![price2 isEqual:@0]) {
        gwbStr = [NSString stringWithFormat:@"%.2f",[price2 longValue]*num/1000.0];
    }

    return [self totalPriceAttrWithQBB:qbbStr GWB:gwbStr RMB:rmbStr];
    
}

+ (NSAttributedString *)QBBWithBouns:(CGRect)bouns {

  return  [NSAttributedString coverImg:[UIImage imageNamed:@"钱包币"] bounds:bouns];

}

+ (NSMutableAttributedString *)stepPriceWithQBB:(NSNumber *)qbb GWB:(NSNumber *)gwb RMB:(NSNumber *)rmb bounds:(CGRect)bounds count:(NSInteger)count {

    
        CGRect bBouns = bounds;
    
        NSAttributedString *RMBAttr = [NSAttributedString coverImg:[UIImage imageNamed:@"人民币"] bounds:bBouns];
        
        NSAttributedString *QBBAttr = [NSAttributedString coverImg:[UIImage imageNamed:@"钱包币"] bounds:bBouns];
        
        //钱包 购物 人民
        NSAttributedString *GWBAttr = [NSAttributedString coverImg:[UIImage imageNamed:@"购物币"] bounds:bBouns];
    
    
    NSNumber *price1 = rmb;
    NSNumber *price2 = gwb;
    NSNumber *price3 = qbb;
    NSInteger num = count;
    
    //把空的剔除掉
    NSString *rmbStr = nil;
    NSString *qbbStr = nil;
    NSString *gwbStr = nil;
    
    if (![price1 isEqual:@0]) {
        rmbStr = [NSString stringWithFormat:@"%.2f",[price1 longValue]*num/1000.0];
    }
    
    if (![price3 isEqual:@0]) {
        qbbStr = [NSString stringWithFormat:@"%.2f",[price3 longValue]*num/1000.0];
    }
    
    if (![price2 isEqual:@0]) {
        gwbStr = [NSString stringWithFormat:@"%.2f",[price2 longValue]*num/1000.0];
    }
        
        
        //人民币
        NSMutableAttributedString *mutableAttr = [[NSMutableAttributedString alloc] init];
        
        if (![rmb isEqual:@0]) {
            
            [mutableAttr appendAttributedString:RMBAttr];
            NSString *str1 = [@" " add: [rmbStr add:@"\n"]];
            [mutableAttr appendAttributedString:[str1 attrStr]];
        }
        
        
        //购物币
        if (![gwb isEqual:@0]) {
            
            [mutableAttr appendAttributedString:GWBAttr];
            NSString *str2 = [NSString stringWithFormat:@" %@\n",gwbStr];
            [mutableAttr appendAttributedString:[str2 attrStr]];
        }
        
        
        //钱宝币
        if (![qbb isEqual:@0]) {
            
            [mutableAttr appendAttributedString:QBBAttr];
            NSString *str3 = [NSString stringWithFormat:@" %@\n",qbbStr];
            [mutableAttr appendAttributedString:[str3 attrStr]];
        }
        
        return mutableAttr;


}

+ (NSMutableAttributedString *)totalPriceAttrWithQBB:(NSString *)qbb GWB:(NSString *)gwb RMB:(NSString *)rmb bouns:(CGRect)bouns {

    CGRect bBouns = bouns;
    NSAttributedString *QBBAttr = [NSAttributedString coverImg:[UIImage imageNamed:@"钱包币"] bounds:bBouns];
    //钱包 购物 人民
    NSAttributedString *GWBAttr = [NSAttributedString coverImg:[UIImage imageNamed:@"购物币"] bounds:bBouns];
    NSAttributedString *RMBAttr = [NSAttributedString coverImg:[UIImage imageNamed:@"人民币"] bounds:bBouns];
    
    NSMutableAttributedString *bAttr = [[NSMutableAttributedString alloc] initWithString:@""];
    
    
    if ([rmb valid]) {
        
        //        [bAttr appendAttributedString:[@"  " attrStr]];
        [bAttr appendAttributedString:RMBAttr];
        [bAttr appendAttributedString:[[NSString stringWithFormat:@"%@ +",rmb ] attrStr]];
    }
    
    if ([gwb valid]) {
        
        [bAttr appendAttributedString:[@"  " attrStr]];
        [bAttr appendAttributedString:GWBAttr];
        [bAttr appendAttributedString:[[NSString stringWithFormat:@"%@ +",gwb ] attrStr]];
    }
    
    if ([qbb valid]) {
        
        [bAttr appendAttributedString:[@"  " attrStr]];
        [bAttr appendAttributedString:QBBAttr];
        [bAttr appendAttributedString:[qbb attrStr]];
        
    }  else  {
        
        if ([bAttr.string hasSuffix:@"+"]) {
            
            bAttr =[[NSMutableAttributedString alloc] initWithAttributedString:[bAttr attributedSubstringFromRange:NSMakeRange(0, bAttr.length - 1)]];
            
        }
        
    }
    
    [bAttr addAttribute:NSFontAttributeName value:[UIFont secondFont] range:NSMakeRange(0, bAttr.length)];
    
    if (bAttr.length) {
        
        return bAttr;
        
    } else {
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@"0"];
        return  attrStr;
    }



}




+ (NSString *)totalPriceWithQBB:(NSNumber *)qbb GWB:(NSNumber *)gwb RMB:(NSNumber *)rmb {
    
    NSMutableString *priceStr  = [NSMutableString string];
    
    if (![rmb isEqual:@0]) {
        
        [priceStr appendString:[NSString stringWithFormat:@"￥%@ +",[self coverMoney:rmb]]];
    }
    
    if (![gwb isEqual:@0]) {
        
        [priceStr appendString:[NSString stringWithFormat:@" 购物币%@ +",[self coverMoney:gwb]]];
    }
    
    
    if (![qbb isEqual:@0]) {
        
        [priceStr appendString:[NSString stringWithFormat:@" 钱包币%@",[self coverMoney:qbb]]];
        
    } else {
        
        if ([priceStr hasSuffix:@"+"]) {
            
                 priceStr = [[NSMutableString alloc] initWithString:[priceStr substringWithRange:NSMakeRange(0, priceStr.length - 1)]];
        }
   
    }
    
    //三种币都为0
    if ([rmb isEqual:@0] && [gwb isEqual:@0] && [qbb isEqual:@0]) {
        
//        return @"￥0 + 购物币0 + 钱包币0";
        return @"￥0";

    }
    
    return priceStr;
    
}


+ (NSString *)coverMoney:(NSNumber *)priceNum {
    
    NSInteger pr = [priceNum integerValue];
    CGFloat newPr = pr/1000.0;
    return [NSString stringWithFormat:@"%.2f",newPr];
    
}

+ (NSAttributedString *)totalRMBWithPrice:(NSNumber *)price count:(NSInteger)count {

    NSString *priceStr = [NSString stringWithFormat:@"%@",[@([price longLongValue]*count) convertToRealMoney]];
    NSAttributedString *attr = [[NSAttributedString alloc] initWithString:priceStr attributes:@{
                                                                                                NSForegroundColorAttributeName: [UIColor zh_themeColor]

}];
    
    return attr;
    

}

+ (NSAttributedString *)totalPriceWithPrice:(NSNumber *)price count:(NSInteger)count {
    
    NSString *priceStr = [NSString stringWithFormat:@"%@",[@([price longLongValue]*count) convertToRealMoney]];
    NSAttributedString *attr = [[NSAttributedString alloc] initWithString:priceStr attributes:@{
                                                                                                NSForegroundColorAttributeName: [UIColor zh_themeColor]
                                                                                                
                                                                                                }];
    
    return attr;
    
    
}

@end
