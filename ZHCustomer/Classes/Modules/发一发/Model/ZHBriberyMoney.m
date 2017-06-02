//
//  ZHBriberyMoney.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/23.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHBriberyMoney.h"

@implementation ZHBriberyMoney


- (NSString *)receiverUserName {

    return self.receiverUser[@"nickname"] ? : @"???";
}

- (NSString *)receiverMobile {
    
    return self.receiverUser[@"mobile"] ? : @"???";

}
@end
