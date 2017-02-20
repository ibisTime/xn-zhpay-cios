//
//  TLPerson.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/15.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <Realm/Realm.h>
#import "TLDog.h"

@interface TLPerson : RLMObject


@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *wife;

@property (nonatomic,assign) NSInteger age;

@property  RLMArray<TLDog *><TLDog> *dogs;

//@property (nonatomic,) <#NSString#> *<#name#>;

@end

//RLM_ARRAY_TYPE(TLPerson)


