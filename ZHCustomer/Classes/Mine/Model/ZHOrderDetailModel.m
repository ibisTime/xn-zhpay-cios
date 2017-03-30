//
//  ZHOrderDetailModel.m
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/17.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHOrderDetailModel.h"

@implementation ZHOrderDetailModel

- (NSString *)productName {

    return self.product[@"name"];
}

- (NSString *)advPic {

    return self.product[@"advPic"];

    
}

@end
