//
//  ZHPayVC.h
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/25.
//  Copyright © 2016年  tianlei. All rights reserved.
//  只负责优店支付

#import "TLBaseVC.h"
#import "ZHShopVC.h"

#import "ZHPaySceneManager.h"

typedef NS_ENUM(NSInteger,ZHShopPayType){
    
    //各种都有
    ZHShopPayTypeShop = 0,
    ZHShopPayTypeGift = 1,
    
    
};

@class ZHShop;

@interface ZHPayVC : TLBaseVC

//优店支付所需要的模型
@property (nonatomic,strong) ZHShop *shop;

//
@property (nonatomic,copy) void(^paySucces)();

@end
