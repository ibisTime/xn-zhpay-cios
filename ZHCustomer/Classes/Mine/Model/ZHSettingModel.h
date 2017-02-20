//
//  ZHSettingModel.h
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/28.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHSettingModel : NSObject

@property (nonatomic,strong) NSString *imgName;
@property (nonatomic,strong) NSString *text;
@property (nonatomic,strong) void(^action)();

@end

