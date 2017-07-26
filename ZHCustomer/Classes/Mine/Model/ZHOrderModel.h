//
//  ZHOrderModel.h
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/17.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"
#import "ZHOrderDetailModel.h"
#import "ZHGoodsModel.h"

@interface ZHOrderModel : TLBaseModel

@property (nonatomic,copy) NSString *code;

@property (nonatomic,copy) NSString *receiver; //收货人
@property (nonatomic,copy) NSString *reMobile; //电话
@property (nonatomic,copy) NSString *reAddress; //地址

@property (nonatomic,copy) NSString *type; //类型
@property (nonatomic,copy) NSString *applyNote; //商家嘱托

//物品数组 <ZHOrderDetailModel *>
//@property (nonatomic,copy) NSArray <ZHOrderDetailModel *> *productOrderList;
@property (nonatomic, strong) NSNumber *yunfei;


@property (nonatomic, strong) ZHGoodsModel *product;

//1待支付 2 已支付待发货 3 已发货待收货 4 已收货 91用户取消 92 商户取消 93 快递异常
@property (nonatomic,copy) NSString *status; //状态

@property (nonatomic,copy) NSString *deliveryDatetime; //发货时间
@property (nonatomic,copy) NSString *applyDatetime; //发货时间

@property (nonatomic,copy) NSString *logisticsCode; //快递编号
@property (nonatomic,copy) NSString *logisticsCompany; //快递公司

@property (nonatomic, strong) NSNumber *quantity;



//规格价格，和规格名称
@property (nonatomic, copy) NSString *productSpecsName;
@property (nonatomic, strong) NSNumber *price1;
//@property (nonatomic, strong) NSNumber *price2;
//@property (nonatomic, strong) NSNumber *price3;

@property (nonatomic, strong) NSNumber *amount1;
//@property (nonatomic, strong) NSNumber *amount2;
//@property (nonatomic, strong) NSNumber *amount3;

- (NSString *)getStatusName;


/**
 包裹运费的订单总价
 */
- (NSString *)displayOrderPriceStr;

/**
 订单商品中的单价
 */
- (NSString *)displayUnitPriceStr;


@end

//---------------//
//填写快递号
//填写单号
//amount1 = 10000;
//amount2 = 10000;
//amount3 = 10000;
//applyDatetime = "Mar 29, 2017 9:18:24 PM";
//applyUser = U2017032915445414717;
//code = DD201703292118247828731;
//companyCode = "CD-CZH000001";
//payAmount1 = 0;
//payAmount2 = 0;
//payAmount3 = 0;
//productOrderList =                 (
//                                    {
//                                        code = CD201703292118247827;
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
//                                    }
//                                    );
//promptTimes = 0;
//reAddress = "\U6d59\U6c5f\U7701\U676d\U5dde\U5e02\U4e0a\U57ce\U533a\U604d\U604d\U60da\U60da\U604d\U604d\U60da\U60da";
//reMobile = 13868074590;
//receiver = "\U9690\U9690\U7ea6\U7ea6";
//remark = "\U53d6\U6d88\U8ba2\U5355\U6536\U8d27";
//status = 91;
//systemCode = "CD-CZH000001";
//type = 1;
//updateDatetime = "Mar 30, 2017 11:06:10 AM";
//updater = U2017032915445414717;
//yunfei = 0;




