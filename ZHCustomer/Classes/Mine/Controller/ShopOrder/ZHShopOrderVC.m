//
//  ZHShopOrderVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/4.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHShopOrderVC.h"
#import "ZHShopOrderCell.h"
#import "ZHShopOrderDetailVC.h"
#import "ZHShopOrderModel.h"
#import "TLHeader.h"
#import "ZHUser.h"


@interface ZHShopOrderVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) TLTableView *shopOrderTableV;
@property (nonatomic,strong) NSMutableArray <ZHShopOrderModel *>*shopOrders;

@property (nonatomic,assign) BOOL isFirst;

@end



@implementation ZHShopOrderVC

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    
    if (self.isFirst) {
        [self.shopOrderTableV beginRefreshing];
        self.isFirst = NO;
    }
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的优店";
    self.isFirst = YES;
    
    
    self.shopOrderTableV = [TLTableView groupTableViewWithframe:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) delegate:self dataSource:self];
    [self.view addSubview:self.shopOrderTableV];
    self.shopOrderTableV.rowHeight = [ZHShopOrderCell rowHeight];
    self.shopOrderTableV.placeHolderView =
    [TLPlaceholderView placeholderViewWithText:@"您还没有消费记录"];
    
    //
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    helper.code = @"808245";
    
//    helper.isDeliverCompanyCode = NO;
    
    helper.parameters[@"userId"] = [ZHUser user].userId;
    helper.parameters[@"token"] = [ZHUser user].token;
    helper.parameters[@"status"] = @"1";


    helper.tableView = self.shopOrderTableV;
    
    [helper modelClass:[ZHShopOrderModel class]];
    
    //
    __weak typeof(self) weakSelf = self;
    [self.shopOrderTableV addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            
            weakSelf.shopOrders = objs;
            [weakSelf.shopOrderTableV reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    [self.shopOrderTableV addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.shopOrders = objs;
            [weakSelf.shopOrderTableV reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    [self.shopOrderTableV endRefreshingWithNoMoreData_tl];
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZHShopOrderDetailVC *vc = [[ZHShopOrderDetailVC alloc] init];
    vc.shopOrder = self.shopOrders[indexPath.section];
    [self.navigationController pushViewController:vc                            animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}


#pragma mark- dasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.shopOrders.count;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *zhShopOrderCellId = @"zhShopOrderCellId";
    ZHShopOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:zhShopOrderCellId];
    if (!cell) {
        
        cell = [[ZHShopOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:zhShopOrderCellId];
        
    }
    
    cell.shopOrderModel = self.shopOrders[indexPath.section];
    return cell;
}

@end
