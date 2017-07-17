//
//  ZHShopSearchVC.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/17.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"

typedef NS_ENUM(NSInteger, ZHSearchVCType){

    ZHSearchVCTypeShop = 0,
    ZHSearchVCTypeYYDB,
    ZHSearchVCTypeDefaultGoods
    
};


@interface ZHSearchVC : TLBaseVC


@property (nonatomic,assign) ZHSearchVCType type;

@property (nonatomic,copy) NSString *lon;
@property (nonatomic,copy) NSString *lat;


@end
