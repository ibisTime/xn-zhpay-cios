//
//  ZHCurrencyProtocol.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/6.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ZHCurrencyProtocol <NSObject>

@optional

- (NSNumber *)RMB;
- (NSNumber *)GWB;
- (NSNumber *)QBB;

@optional

- (NSNumber *)payRMB;
- (NSNumber *)payGWB;
- (NSNumber *)payQBB;

@end
