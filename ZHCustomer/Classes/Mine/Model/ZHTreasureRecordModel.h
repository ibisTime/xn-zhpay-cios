//
//  ZHTreasureModel.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/4.
//  Copyright © 2017年  tianlei. All rights reserved.
//  我每次购买记录的模型

#import "TLBaseModel.h"

@interface ZHTreasureRecordModel : TLBaseModel

@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *jewelCode; //宝贝编号
@property (nonatomic,copy) NSString *number;
@property (nonatomic,copy) NSString *recordCode; //记录编号


//id = 30;
//jewelCode = IW201701130052260172;
//number = 10000065;
//recordCode = IR201701130458540905;


@end
