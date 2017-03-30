//
//  ZHOrderDetailModel.h
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/17.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHOrderDetailModel : NSObject


@property (nonatomic,copy) NSString *productName;
@property (nonatomic,strong) NSNumber *quantity;



@property (nonatomic, strong) NSDictionary *product;
@property (nonatomic,copy) NSString *code;
@property (nonatomic,copy) NSString *advPic;
@property (nonatomic,copy) NSString *orderCode;

@property (nonatomic,strong) NSNumber *price1;
@property (nonatomic,strong) NSNumber *price2;
@property (nonatomic,strong) NSNumber *price3;

@property (nonatomic,copy) NSString *productCode;

//advPic = "IOS_1481961635815530_4288_2848.jpg";
////                                            code = CD201612171924475778;
////                                            orderCode = DD201612171924475754;
////                                            price1 = 1000000;
////                                            price2 = 0;
////                                            price3 = 0;
////                                            productCode = CP201612171601102692;
////                                            productName = "Shang pin 2";
////                                            quantity = 1;


@end
