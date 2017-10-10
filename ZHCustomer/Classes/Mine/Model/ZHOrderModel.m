//
//  ZHOrderModel.m
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/17.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHOrderModel.h"
#import "ZHOrderDetailModel.h"
#import "ZHPayService.h"
#import "TLHeader.h"

@implementation ZHOrderModel


+ (NSDictionary *)mj_objectClassInArray {

    return @{ @"productOrderList" : [ZHOrderDetailModel class]};

}


- (NSString *)getStatusName {

    
    //1待支付 2 已支付待发货 3 已发货待收货 4 已收货 91用户取消 92 商户取消 93 快递异常

    NSDictionary *dict = @{
                           @"1" : @"待支付",
                           @"2" : @"待发货",
                           @"3" : @"待收货",
                           @"4" : @"已收货",
                           @"91" : @"已取消",
                           @"92" : @"商户取消",
                           @"93" : @"快递异常"
                                                      };
    
    return dict[self.status];

}


- (NSString *)displayOrderPriceStr {

    
//    NSString *priceUnit = nil;
//    
//    if (self.payType == kZHLMBPayTypeCode) {
//        
//        priceUnit = @"联盟券";
//        
//    } else if (self.payType == kZHGiftPayTypeCode) {
//    
//        priceUnit = @"礼品券";
//
//    } else {
//    
//        priceUnit = @"￥";
//
//    }
    
    if (![self.yunfei isEqual:@0]) {
        
        
      return  [NSString stringWithFormat:@"%@ %@ + 邮费 %@",[self.product priceUnit],[self.amount1 convertToRealMoney],[self.yunfei convertToRealMoney]];
        
    } else {
    
        return   [NSString stringWithFormat:@"%@ %@",[self.product priceUnit],[self.amount1 convertToRealMoney]];

    }
    
    

}


- (NSString *)displayUnitPriceStr {

    NSString *priceUnit;

    if (self.product.isGift) {
        
        priceUnit = @"礼品券";

    } else {
    
        priceUnit = [self.product priceUnit];
    }
    
    
    return [NSString stringWithFormat:@"%@ %@",priceUnit,[self.price1 convertToRealMoney]];
        

}

- (NSString *)deliveryDatetime {

    return _deliveryDatetime ? : @"--";
    
}

- (NSString *)productSpecsName {

    if (_productSpecsName) {
        
        return _productSpecsName;
        
    }
    //
    return @"无";

}

@end


