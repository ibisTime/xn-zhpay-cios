//
//  ZHGiftVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/7/25.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHGiftVC.h"
#import "ZHShop.h"
#import <CoreLocation/CoreLocation.h>
#import "TLUpdateAppService.h"
#import "ZHShopCell.h"
#import "ZHShopDetailVC.h"
#import "TLLocationService.h"


@interface ZHGiftVC ()

@property (nonatomic,strong) TLTableView *shopTableView;
@property (nonatomic,strong) TLPageDataHelper *pageDataHelper;
@property (nonatomic,strong) NSMutableArray <ZHShop *>*shops;
@property (nonatomic, strong) NSDate *lastLocationSuccessDate;

@end

//
@implementation ZHGiftVC

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"礼品中心";
    
    TLTableView *tableView = [TLTableView tableViewWithframe:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49)
                                                    delegate:self
                                                  dataSource:self];
    [self.view addSubview:tableView];
    tableView.rowHeight = [ZHShopCell rowHeight];
    self.shopTableView = tableView;
    
    
#pragma mark- 店铺列表
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    helper.code = @"808217";
    helper.parameters[@"uiLocation"] = @"1";
    helper.tableView = self.shopTableView;
    [helper modelClass:[ZHShop class]];
    
    self.pageDataHelper = helper;
    __weak typeof(self) weakSelf = self;
    
    [self.shopTableView addRefreshAction:^{
        
        //店铺数据
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
    
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationSuccess) name:kLocationServiceSuccessNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationFailure) name:kLocationServiceFailureNotification object:nil];
    
    [TLUpdateAppService updateAppWithVC:self];
    
    [[TLLocationService service] startService];
//    [[TLLocationService service] checkLocation];

}

- (void)locationFailure {

    [self.shopTableView beginRefreshing];

}


- (void)locationSuccess {

    if (self.lastLocationSuccessDate && ([[NSDate date] timeIntervalSinceDate:self.lastLocationSuccessDate] <60*3)) {
        
        return;
    }
    
    //获取当前位置
    self.lastLocationSuccessDate = [NSDate date];
    CLLocation *location = [TLLocationService service].locationManager.location;
    //
    self.pageDataHelper.parameters[@"longitude"] = [NSString stringWithFormat:@"%.10f",location.coordinate.longitude];
    //
    self.pageDataHelper.parameters[@"latitude"] = [NSString stringWithFormat:@"%.10f",location.coordinate.latitude];
    //
    [self.shopTableView beginRefreshing];
    
}





#pragma mark- tableView  --- delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZHShopDetailVC *detailVC = [[ZHShopDetailVC alloc] init];
    detailVC.shop = self.shops[indexPath.row];
    //
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
    cell.shop = self.shops[indexPath.row];
    return cell;
}





@end
