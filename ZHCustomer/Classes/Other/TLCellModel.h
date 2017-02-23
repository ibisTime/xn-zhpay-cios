//
//  TLCellModel.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/23.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TLCellModel : NSObject

@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, copy) void(^action)(id args);

@end
