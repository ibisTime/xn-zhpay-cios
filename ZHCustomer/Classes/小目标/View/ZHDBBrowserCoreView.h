//
//  ZHDBBrowserCoreView.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/28.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHDBHistoryModel.h"

@interface ZHDBBrowserCoreView : UIView

@property (nonatomic, assign) NSInteger displayTag;

@property (nonatomic, strong) NSMutableArray <ZHDBHistoryModel *>*historyModels;

@end
