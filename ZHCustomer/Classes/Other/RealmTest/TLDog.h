//
//  TLDog.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/15.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <Realm/Realm.h>

@interface TLDog : RLMObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) NSInteger age;


@end

RLM_ARRAY_TYPE(TLDog)
