//
//  ZHPaySceneManager.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/8.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHPaySceneUIItem.h"
@interface ZHPaySceneManager : NSObject

//分几组
//每组显示什么
//每组的个数

//金额是主动提供--还是用户输入 yes = 手输入
@property (nonatomic, assign) BOOL isInitiative; //
@property (nonatomic, copy) NSString *amount; //总额

@property (nonatomic,copy) NSArray <ZHPaySceneUIItem *>*groupItems;

@end
