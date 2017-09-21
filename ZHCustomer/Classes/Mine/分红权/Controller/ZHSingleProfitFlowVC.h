//
//  ZHSingleProfitDetailVC.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/4/3.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"
@class ZHEarningModel;

typedef NS_ENUM(NSUInteger, ZHSingleProfitFlowVCType) {
    
    ZHSingleProfitFlowVCTypeFenHongQuan,
    ZHSingleProfitFlowVCTypeBuTie
    
};

@interface ZHSingleProfitFlowVC : TLBaseVC

@property (nonatomic, strong) ZHEarningModel *earnModel;

@property (nonatomic, assign) ZHSingleProfitFlowVCType type;


@end
