//
//  TLRealmPlayground.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/15.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLRealmPlayground.h"
#import "TLPerson.h"
#import "RLMRealm.h"

@implementation TLRealmPlayground

+ (void)play {
    
    TLPerson *person = [TLPerson new];
    person.name = @"田磊";
    person.wife = nil;
    person.age = 20;
    
    //创建狗
    TLDog *dog1 = [TLDog new];
    dog1.name = @"dog1";
    dog1.age = 12;
    
    TLDog *dog2 = [TLDog new];
    dog2.name = @"dog2";
    dog2.age = 22;
    
    [person.dogs addObject:dog1];
    [person.dogs addObject:dog2];

    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        
        [realm addObject:person];
        
    }];
    
    RLMResults<TLPerson *> *result01 = [TLPerson objectsWhere:@"age == 12"];
    NSInteger msgCount = result01.count; //数量
    RLMResults<TLPerson *> *result02 = [TLPerson allObjects];

    NSMutableArray *resultPerson = [[NSMutableArray alloc] init];
    for (TLPerson *person in result02) {
       
        [resultPerson addObject:person];
        
    }
    
}

@end
