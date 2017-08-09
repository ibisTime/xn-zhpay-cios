//
//  ZHBillVC.h
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/24.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"
#import "ZHCurrencyModel.h"

@interface ZHBillVC : TLBaseVC

@property (nonatomic,strong) ZHCurrencyModel *currencyModel;
//账户名称
//@property (nonatomic,copy) NSString *accountNumber;

//从汇赚包，跳过来的特有链接
@property (nonatomic, copy) NSString *bizType;

@end
