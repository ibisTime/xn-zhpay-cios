//
//  ZHShopListVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/23.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "RecommendMerchantVC.h"

#import "ZHShopCell.h"
#import "TLPageDataHelper.h"
#import "ZHShopDetailVC.h"
#import "TLHeader.h"
#import "ZHUser.h"


@interface RecommendMerchantVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) TLTableView *shopTableView;
//公告view
@property (nonatomic,strong) NSMutableArray *shops;
@property (nonatomic,assign) BOOL isFirst;


@end

@implementation RecommendMerchantVC

- (void)loadView
{
    [super loadView];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    if (self.isFirst) {
        self.isFirst = NO;
        [self.shopTableView beginRefreshing];
        
    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"推荐商家";
    self.isFirst  = YES;
    TLTableView *tableView = [TLTableView tableViewWithframe:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) delegate:self dataSource:self];
    [self.view addSubview:tableView];
    tableView.rowHeight = [ZHShopCell rowHeight];
    self.shopTableView = tableView;
    self.shopTableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"没有发现店铺"];
    
    //
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    helper.code = @"808217";
    helper.parameters[@"userReferee"] = [ZHUser user].userId;
    
    helper.tableView = self.shopTableView;
    [helper modelClass:[ZHShop class]];
    
    //
    __weak typeof(self) weakSelf = self;
    [self.shopTableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            
            weakSelf.shops = objs;
            [weakSelf.shopTableView reloadData_tl];
            
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    [self.shopTableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.shops = objs;
            [weakSelf.shopTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    [self.shopTableView endRefreshingWithNoMoreData_tl];
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZHShopDetailVC *detailVC = [[ZHShopDetailVC alloc] init];
    
    ZHShop *shop = self.shops[indexPath.row];
    detailVC.shopCode = shop.code;
    [self.navigationController pushViewController:detailVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark- dasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.shops.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *zhShopCellId = @"zhShopCellId";
    ZHShopCell *cell = [tableView dequeueReusableCellWithIdentifier:zhShopCellId];
    if (!cell) {
        
        cell = [[ZHShopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:zhShopCellId];
        
    }
    
    //
    cell.isShowLocation = NO;
    cell.isShowShopStatus = YES;
    cell.shop = self.shops[indexPath.row];
    //
    return cell;
    
}

@end
