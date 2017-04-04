//
//  ZHCouponsMgtVC.m
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/20.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHCouponsMgtVC.h"
//#import "ZHCouponsAddVC.h"
#import "ZHCouponsCell.h"
#import "TLPageDataHelper.h"
//#import "ZHCoupon.h"
#import "ZHMineCouponModel.h"

#import "ZHCouponsDetailVC.h"

@interface ZHCouponsMgtVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) TLTableView *couponsTableView;
@property (nonatomic,strong) NSMutableArray <ZHMineCouponModel *>*coupons; //优惠券
@property (nonatomic,assign) BOOL isFirst;

@end

@implementation ZHCouponsMgtVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"折扣券管理";

    if (self.shop) {
        self.title = @"商家抵扣券";
    }

    _isFirst = YES;
    TLTableView *tableView = [TLTableView tableViewWithframe:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) delegate:self dataSource:self];
    [self.view addSubview:tableView];
    tableView.rowHeight = 130;
    self.couponsTableView = tableView;
    tableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无折扣券"];
    
    __weak typeof(self) weakself = self;
    TLPageDataHelper *goodsHelper = [[TLPageDataHelper alloc] init];
    goodsHelper.tableView = self.couponsTableView;
    goodsHelper.code = @"808265";
    goodsHelper.parameters[@"userId"] = [ZHUser user].userId;
    goodsHelper.parameters[@"token"] = [ZHUser user].token;

    
    if (self.shop) {
        
        goodsHelper.parameters[@"storeCode"] = self.shop.code;

    }
    
    [goodsHelper modelClass:[ZHMineCouponModel class]];
    [self.couponsTableView addRefreshAction:^{
        
        [goodsHelper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakself.coupons = objs;
            [weakself.couponsTableView reloadData_tl];

            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    [self.couponsTableView addLoadMoreAction:^{
        
        [goodsHelper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakself.coupons = objs;
            [weakself.couponsTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    if (_isFirst) {
        [self.couponsTableView beginRefreshing];
        _isFirst = NO;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

//    ZHCouponsAddVC *vc = [[ZHCouponsAddVC alloc] init];
//    vc.coupon = self.coupons[indexPath.row];
//    [self.navigationController pushViewController:vc animated:YES];
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //
    
    ZHCouponsDetailVC *detailVC = [[ZHCouponsDetailVC alloc] init];
    detailVC.mineCoupon = self.coupons[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.coupons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString * couponsCellId = @"couponsCellId";
    ZHCouponsCell *cell = [tableView dequeueReusableCellWithIdentifier:couponsCellId];
    
    if (!cell) {
        cell = [[ZHCouponsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:couponsCellId];
    }
    ZHMineCouponModel *mineCoupon = self.coupons[indexPath.row];
    cell.mineCoupon = mineCoupon;
    return cell;
}

//
//- (void)add {
//
//    ZHCouponsAddVC *vc = [[ZHCouponsAddVC alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
//    
//}

@end
