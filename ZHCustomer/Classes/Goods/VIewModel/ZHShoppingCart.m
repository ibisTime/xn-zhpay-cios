//
//  ZHShoppingCart.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/28.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHShoppingCart.h"

@implementation ZHShoppingCart

+ (instancetype)shoppingCart {

    static ZHShoppingCart *sc;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sc = [[ZHShoppingCart alloc] init];
    });
    
    return sc;

}

@end
