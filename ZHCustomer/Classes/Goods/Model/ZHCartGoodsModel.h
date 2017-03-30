//
//  ZHCartGoodsModel.h
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/30.
//  Copyright © 2016年  tianlei. All rights reserved.
//  购物车商品   模型

#import <Foundation/Foundation.h>
#import "ZHGoodsModel.h"
@interface ZHCartGoodsModel : TLBaseModal

@property (nonatomic,strong) NSString *code;
@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *productCode; //产品编号
@property (nonatomic,strong) NSNumber *quantity; //数量

@property (nonatomic, strong) ZHGoodsModel *product;

//@property (nonatomic,strong) NSString *advPic; //广告图
//@property (nonatomic,strong) NSString *productName; //产品名称

//@property (nonatomic,strong) NSNumber *price1; //人民币
//@property (nonatomic,strong) NSNumber *price2; //购物币
//@property (nonatomic,strong) NSNumber *price3; //钱宝币

@property (nonatomic,strong,readonly) NSNumber *gwb; //人民币
@property (nonatomic,strong,readonly) NSNumber *qbb; //钱包币
@property (nonatomic,strong,readonly) NSNumber *rmb; //购物币

//计算属性，根据商品数量进行的计算
@property (nonatomic,assign) long totalRMB;
@property (nonatomic,assign) long totalGWB;
@property (nonatomic,assign) long totalQBB;



//附属判断，购物车选择我时
@property (nonatomic,assign) BOOL isSelected;



//code = GW201703291947104002;
//companyCode = "CD-CZH000001";
//product =                 {
//    advPic = "ANDROID_1490779593774_612_344.jpg";
//    code = CP201703291727333540;
//    companyCode = "CD-CZH000001";
//    name = "we bare bears";
//    price1 = 10000;
//    price2 = 10000;
//    price3 = 10000;
//    systemCode = "CD-CZH000001";
//};
//productCode = CP201703291727333540;
//quantity = 4;
//systemCode = "CD-CZH000001";
//userId = U2017032915445414717;

@end
