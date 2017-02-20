//
//  ZHCartGoodsModel.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/30.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHCartGoodsModel.h"

@implementation ZHCartGoodsModel

- (long )totalGWB {

    return [self.gwb longValue]*[self.quantity longValue];
}

- (long )totalQBB {

    return [self.qbb longValue]*[self.quantity longValue];

}

- (long )totalRMB {
    
    return [self.rmb longValue]*[self.quantity longValue];
    
}



- (NSNumber *)rmb {
    
    return self.price1;
}

- (NSNumber *)gwb {
    
    return self.price2;
}

- (NSNumber *)qbb {
    
    return self.price3;
    
}

@end
