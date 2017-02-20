//
//  ZHOrderModel.h
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/17.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLBaseModal.h"
#import "ZHOrderDetailModel.h"

@interface ZHOrderModel : TLBaseModal

@property (nonatomic,copy) NSString *code;

@property (nonatomic,copy) NSString *receiver; //收货人
@property (nonatomic,copy) NSString *reMobile; //电话
@property (nonatomic,copy) NSString *reAddress; //地址
@property (nonatomic,copy) NSString *type; //类型
@property (nonatomic,copy) NSString *applyNote; //商家嘱托

//物品数组 <ZHOrderDetailModel *>
@property (nonatomic,copy) NSArray <ZHOrderDetailModel *> *productOrderList;

//1待支付 2 已支付待发货 3 已发货待收货 4 已收货 91用户取消 92 商户取消 93 快递异常
@property (nonatomic,copy) NSString *status; //状态

@property (nonatomic,copy) NSString *deliveryDatetime; //发货时间
@property (nonatomic,copy) NSString *applyDatetime; //发货时间

@property (nonatomic,copy) NSString *logisticsCode; //快递编号
@property (nonatomic,copy) NSString *logisticsCompany; //快递公司

@property (nonatomic,strong) NSNumber *payAmount1;
@property (nonatomic,strong) NSNumber *payAmount2;
@property (nonatomic,strong) NSNumber *payAmount3;

@property (nonatomic,strong) NSNumber *amount1;
@property (nonatomic,strong) NSNumber *amount2;
@property (nonatomic,strong) NSNumber *amount3;

- (NSString *)getStatusName;

//下单数量
//买家嘱托
@end

//填写快递号
//填写单号
//amount1 = 2000;
//amount2 = 0;
//amount3 = 0;
//applyDatetime = "Dec 24, 2016 4:04:24 PM";
//applyNote = "";
//applyUser = U2016121720245823318;
//code = DD201612241604242097;
//companyCode = U2016121720251308788;
//mobile = 18984955240;
//payAmount1 = 0;
//payAmount2 = 0;
//payAmount3 = 0;
//productOrderList =                 (
//                                    {
//                                        advPic = "IOS_1482566155905185_3000_2002.jpg";
//                                        code = CD201612241604242120;
//                                        orderCode = DD201612241604242097;
//                                        price1 = 1000;
//                                        price2 = 0;
//                                        price3 = 0;
//                                        productCode = CP201612241555388096;
//                                        productName = Test00;
//                                        quantity = 1;
//                                    },
//                                    {
//                                        advPic = "IOS_1482566201980224_3000_2002.jpg";
//                                        code = CD201612241604242168;
//                                        orderCode = DD201612241604242097;
//                                        price1 = 1000;
//                                        price2 = 0;
//                                        price3 = 0;
//                                        productCode = CP201612241556244853;
//                                        productName = Test01;
//                                        quantity = 1;
//                                    }
//                                    );
//promptTimes = 0;
//reAddress = "\U676d\U5dde \U6e29\U5dde \U54ea\U4e2a\U533a 222222";
//reMobile = 18984955270;
//receiptTitle = "";
//receiptType = "";
//receiver = "\U96f7\U9ed4";
//status = 1;
//type = 1;
//yunfei = 12000;



