//
//  TLPageDataHelper.h
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/17.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TLPageDataHelper : NSObject

@property (nonatomic,assign) NSInteger start;
@property (nonatomic,assign) NSInteger limit;

//网络请求的code
@property (nonatomic,copy) NSString *code;

//设置改值后外界只需要 调用reloadData
@property (nonatomic,weak) TLTableView *tableView;

//除start 和 limit 外的其它请求参数
@property (nonatomic,strong) NSMutableDictionary *parameters;
- (void)modelClass:(Class)className;


- (void)refresh:(void(^)(NSMutableArray *objs,BOOL stillHave))refresh failure:(void(^)(NSError *error))failure;

- (void)loadMore:(void(^)(NSMutableArray *objs,BOOL stillHave))loadMore failure:(void(^)(NSError *error))failure;

@end
