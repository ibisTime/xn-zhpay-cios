//
//  ZHProfitDetailVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/3/22.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHProfitDetailVC.h"
#import "ZHProfitCell.h"


@interface ZHProfitDetailVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ZHProfitDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分红权详情";
   
    //
    TLTableView *tableView = [TLTableView tableViewWithframe:CGRectZero delegate:self dataSource:self];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];

    tableView.estimatedRowHeight = 150;
#pragma mark- 店铺列表
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    helper.code = @"808207";
    helper.parameters[@"status"] = @"2";

    
//    [self.shopTableView addRefreshAction:^{
//        
//        //店铺数据
//        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
//            
//            weakSelf.shops = objs;
//            [weakSelf.shopTableView reloadData_tl];
//            
//        } failure:^(NSError *error) {
//            
//            
//        }];
//        
//    }];
//    
//    
//    [self.shopTableView addLoadMoreAction:^{
//        
//        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
//            
//            weakSelf.shops = objs;
//            [weakSelf.shopTableView reloadData_tl];
//            
//        } failure:^(NSError *error) {
//            
//            
//        }];
//        
//    }];
    
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ZHProfitCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZHProfitCellID"];
    if (!cell) {
        
        cell = [[ZHProfitCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZHProfitCellID"];
        
    }
    
    return cell;

}


@end
