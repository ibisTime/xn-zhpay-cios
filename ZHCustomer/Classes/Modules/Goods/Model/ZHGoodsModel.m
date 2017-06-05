//
//  ZHGoodsModel.m
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/17.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHGoodsModel.h"

@interface ZHGoodsModel()


@end

@implementation ZHGoodsModel

//+ (NSDictionary *)tl_replacedKeyFromPropertyName
//{
//    
//    return @{ @"description" : @"desc"};
//    
//}

- (NSNumber *)rmb {

    return self.price1;
}

- (NSNumber *)gwb {

    return self.price2;
}

- (NSNumber *)qbb {

    return self.price3;

}

- (void)setPic:(NSString *)pic {

    
    _pic = [pic copy];

}

- (NSArray *)pics {

    if (!_pics) {
        
        NSArray *imgs = [self.pic componentsSeparatedByString:@"||"];
        NSMutableArray *newImgs = [NSMutableArray arrayWithCapacity:imgs.count];
        [imgs enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [newImgs addObject:[obj  convertImageUrl]];
            
        }];
        
        _pics = newImgs;
        
    }

    return _pics;
    
}

- (NSArray<NSNumber *> *)imgHeights {
    
    if (!_imgHeights) {
        
        //未经转换的url
        NSArray *urls = [self.pic componentsSeparatedByString:@"||"];
        NSMutableArray *hs = [NSMutableArray arrayWithCapacity:urls.count];
        
        [urls enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            CGSize size = [obj imgSizeByImageName:obj];
            CGFloat scale = size.width*1.0/size.height;
            
            [hs addObject:@((SCREEN_WIDTH - 30)/scale)];
            
        }];
        _imgHeights = hs;
    }
    return _imgHeights;
}

- (CGFloat)detailHeight {
    
    CGSize size  =  [self.desc calculateStringSize:CGSizeMake(SCREEN_WIDTH - 30, 1000) font:FONT(13)];
    
    return size.height + 25;
}



- (NSString *)totalPrice {

    if (!_totalPrice) {
        
           //剔除为价格为 - 0 -的
//        NSMutableString *priceStr  = [NSMutableString string];
//        
//        if (![self.price1 isEqual:@0]) {
//            
//            [priceStr appendString:[NSString stringWithFormat:@"￥%@ +",[self coverMoney:self.price1]]];
//        }
//        
//        if (![self.price2 isEqual:@0]) {
//            
//            [priceStr appendString:[NSString stringWithFormat:@" 购物币%@ +",[self coverMoney:self.price2]]];
//        } else {
//            
//            if (priceStr.length > 0) {
//              priceStr = [[NSMutableString alloc] initWithString:[priceStr substringWithRange:NSMakeRange(0, priceStr.length - 1)]];
//            }
//     
//        }
//        
//        
//        if (![self.price3 isEqual:@0]) {
//            
//            [priceStr appendString:[NSString stringWithFormat:@" 钱包币%@",[self coverMoney:self.price3]]];
//            
//        } else {
//            
//            if (priceStr.length > 0) {
//                priceStr = [[NSMutableString alloc] initWithString:[priceStr substringWithRange:NSMakeRange(0, priceStr.length - 1)]];
//            }
//        }
        
        _totalPrice = [ZHCurrencyHelper totalPriceWithQBB:self.qbb GWB:self.gwb RMB:self.rmb];
    }
    
    return _totalPrice;

}

- (NSString *)coverMoney:(NSNumber *)priceNum {
    
    NSInteger pr = [priceNum integerValue];
    CGFloat newPr = pr/1000.0;
    return [NSString stringWithFormat:@"%.1f",newPr];
    
}


//神奇
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    if ([key isEqualToString:@"description"]) {
        self.desc = value;
    }
    
}

- (NSNumber *)RMB {

    return self.price1;
}

- (NSNumber *)GWB {
    
    return self.price2;
}

- (NSNumber *)QBB {
    
    return self.price3;
}

@end
