//
//  ZHReceivingAddress.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/29.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHReceivingAddress.h"

@implementation ZHReceivingAddress

- (NSString *)totalAddress {

    return [[[self.province add:self.city] add:self.district] add:self.detailAddress];

}
@end
