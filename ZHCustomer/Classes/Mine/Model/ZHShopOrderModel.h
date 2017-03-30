//
//  ZHShopOrderModel.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/4.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModal.h"
#import "ZHShop.h"

@interface ZHShopOrderModel : TLBaseModal

//@property (nonatomic,copy) NSString *code;
//@property (nonatomic,copy) NSString *userId;
//@property (nonatomic,strong) NSNumber *amount;
//@property (nonatomic,copy) NSString *createDatetime;
//@property (nonatomic,copy) NSString *storeCode;
//@property (nonatomic,copy) NSString *systemCode;

@property (nonatomic,strong) NSNumber *payAmount1; //总消费
@property (nonatomic,strong) NSNumber *price;


@property (nonatomic,copy) NSString *code;
@property (nonatomic,copy) NSString *createDatetime;
@property (nonatomic,copy) NSString *jourCode;
@property (nonatomic,copy) NSString *payType;
@property (nonatomic,copy) NSString *remark;
@property (nonatomic,copy) NSString *status;

@property (nonatomic,copy) NSString *storeCode;
@property (nonatomic,copy) NSString *systemCode;
@property (nonatomic,copy) NSString *userId;

@property (nonatomic,strong) ZHShop *store; //店铺
@property (nonatomic,strong) ZHCoupon *storeTicket;


//code = XF201703301408148466;
//companyCode = "CD-CZH000001";
//createDatetime = "Mar 30, 2017 2:08:14 PM";
//payAmount1 = 10;
//payCode = AJ2017033014081486894;
//payDatetime = "Mar 30, 2017 2:08:26 PM";
//payGroup = XF201703301408148465;
//payType = 3;
//price = 10;
//remark = "\U652f\U4ed8\U5b9d\U652f\U4ed8O2O\U6d88\U8d39";
//status = 1;
//storeCode = SJ201703291152426359;
//systemCode = "CD-CZH000001";
//userId = U2017032915445414717;

- (NSString *)getStatusName;
@end
