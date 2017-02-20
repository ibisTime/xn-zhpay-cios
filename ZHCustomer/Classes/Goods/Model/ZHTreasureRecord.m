//
//  ZHTreasureRecord.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/18.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHTreasureRecord.h"

@implementation ZHTreasureRecord

- (NSNumber *)payRMB {

    return self.payAmount1;

}

- (NSNumber *)payQBB {

    return self.payAmount3;
}

- (NSNumber *)payGWB {
    
    return self.payAmount2;
    
}
@end
