//
//  ZHMineTreasureModel.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/12.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHMineTreasureModel.h"

@implementation ZHMineTreasureModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{ @"jewelRecordNumberList" : [ZHTreasureRecordModel class]};
    
}

- (BOOL)isAnnounced {

    return [self.jewel.investNum isEqual:self.jewel.totalNum];

}


@end
