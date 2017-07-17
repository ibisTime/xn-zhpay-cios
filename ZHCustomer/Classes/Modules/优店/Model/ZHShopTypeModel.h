//
//  ZHShopTypeModel.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/4/1.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@interface ZHShopTypeModel : TLBaseModel

//0 未上架 1已上架 2已下架

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *status;

//@property (nonatomic, copy) NSString *code;
//@property (nonatomic, copy) NSString *code;
//code = FL201703301952430774;

//companyCode = "CD-CZH000001";
//name = "\U81ea\U52a9\U9910";
//orderNo = 2;
//parentCode = FL201703301952165460;
//parentName = "\U9910\U996e\U7f8e\U98df";
//pic = "OSS_1490874767568_1024_640.jpg";
//status = 0;
//systemCode = "CD-CZH000001";
//type = 2;

@end
