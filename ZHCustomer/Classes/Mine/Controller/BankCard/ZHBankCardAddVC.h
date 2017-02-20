//
//  ZHBankCardAddVC.h
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/24.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"
#import "ZHBankCard.h"
@interface ZHBankCardAddVC : TLBaseVC

@property (nonatomic,copy)  void(^addSuccess)(ZHBankCard *bankCard);
@property (nonatomic,strong) ZHBankCard *bankCard;
@end
