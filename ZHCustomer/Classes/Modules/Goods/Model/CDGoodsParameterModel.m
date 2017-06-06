//
//  CDGoodsParameterModel.m
//  ZHBusiness
//
//  Created by  tianlei on 2017/6/4.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CDGoodsParameterModel.h"

@implementation CDGoodsParameterModel

+ (NSString *)randomCode {

    return [NSString stringWithFormat:@"%f%u",[[NSDate date] timeIntervalSince1970],arc4random()%1000
];
    
}

- (NSString *)getCountDesc {

    
    return [NSString stringWithFormat:@"库存%@件",self.quantity];

}

- (NSString *)getPrice {

    return [ZHCurrencyHelper totalPriceWithQBB:self.price1 GWB:self.price2 RMB:self.price3];
}

- (NSString *)getDetailText {

//    return [NSString stringWithFormat:@"%@ 人民币/%@  购物币/%@ 钱包币/%@\n重量：%@kg  库存：%@  发货地:%@",self.name,[self.price1 convertToRealMoney],[self.price2 convertToRealMoney],[self.price3 convertToRealMoney],self.weight,self.quantity,self.province];
    
     return [NSString stringWithFormat:@"%@  重量：%@kg   发货地:%@",self.name,self.weight,self.province];

}


- (NSDictionary *)toDictionry {

    NSDictionary *dict = @{
                           
                           @"code" : self.code,
                           @"name" : self.name,
                           @"price1" : self.price1,
                           @"price2" : self.price2,
                           @"price3" : self.price3,
                           @"quantity" : self.quantity,
                           @"province" : self.province,
                           @"weight" : self.weight,


                           };
    
    return dict;

}

@end
