//
//  ZHOrderDetailModel.h
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/17.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHOrderDetailModel : NSObject


@property (nonatomic, copy, readonly) NSString *productName;
@property (nonatomic, copy, readonly) NSString *advPic;

@property (nonatomic,strong) NSNumber *quantity; //数量

@property (nonatomic, strong) NSDictionary *product;

@property (nonatomic,copy) NSString *code;
@property (nonatomic,copy) NSString *orderCode;

@property (nonatomic,strong) NSNumber *price1;
@property (nonatomic,strong) NSNumber *price2;
@property (nonatomic,strong) NSNumber *price3;

@property (nonatomic,copy) NSString *productCode;

//code = CD201703292118247827;
//                                        companyCode = "CD-CZH000001";
//                                        orderCode = DD201703292118247828731;
//                                        price1 = 10000;
//                                        price2 = 10000;
//                                        price3 = 10000;
//                                        product =                         {
//                                            advPic = "ANDROID_1490779593774_612_344.jpg";
//                                            name = "we bare bears";
//                                        };
//                                        productCode = CP201703291727333540;
//                                        quantity = 1;
//                                        systemCode = "CD-CZH000001";

@end
