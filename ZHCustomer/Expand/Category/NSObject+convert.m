//
//  NSObject+convert.m
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/17.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "NSObject+convert.h"

@implementation NSObject (convert)

- (NSString *)toString {

    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

}

@end
