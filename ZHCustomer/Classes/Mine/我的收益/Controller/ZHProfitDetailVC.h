//
//  ZHProfitDetailVC.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/3/22.
//  Copyright © 2017年  tianlei. All rights reserved.
//  所有分红权的列表，，，， 下一级为单个分红权的详情 对应的VC 为singleProfitVC

#import "TLBaseVC.h"
#import "ZHEarningModel.h"

@interface ZHProfitDetailVC : TLBaseVC

@property (nonatomic, copy) NSArray <ZHEarningModel *>*myEarningRoom;

@end
