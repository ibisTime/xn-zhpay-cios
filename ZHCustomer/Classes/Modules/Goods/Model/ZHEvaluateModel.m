//
//  ZHEvaluateModel.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/7.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHEvaluateModel.h"

@implementation ZHEvaluateModel

- (NSString *)nickname {

    return self.user[@"nickname"];

}

- (NSString *)photo {

    return self.user[@"photo"];
}
@end
