//
//  TLShopingListCategoryVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/30.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHShoppingListCategoryVC.h"
#import "ZHOrderModel.h"
#import "ZHOrderGoodsCell.h"
#import "ZHOrderFooterView.h"
#import "ZHOrderDetailVC.h"
#import "TLHeader.h"
#import "ZHUser.h"
#import "UIColor+theme.h"

@interface ZHShoppingListCategoryVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) TLTableView *shoppingListTableV;
@property (nonatomic,strong) NSMutableArray <ZHOrderModel *>*orderGroups;
@property (nonatomic,assign) BOOL isFirst;

@end

@implementation ZHShoppingListCategoryVC

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    if (self.isFirst) {

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.shoppingListTableV beginRefreshing];
            self.isFirst = NO;
            
        });
   
        
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFirst = YES;
    
    TLTableView *tableView = [TLTableView groupTableViewWithframe:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40) delegate:self dataSource:self];
    [self.view addSubview:tableView];
    tableView.rowHeight = 100;
    
    self.shoppingListTableV = tableView;
    tableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无订单"];
    
    //--//
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    helper.code = @"808068";
    helper.parameters[@"token"] = [ZHUser user].token;
    helper.parameters[@"applyUser"] = [ZHUser user].userId;
    helper.isDeliverCompanyCode = NO;
  
    if (self.status == ZHOrderStatusWillPay) {
        
        helper.parameters[@"status"] = @"1";
        
    } else if(self.status == ZHOrderStatusDidPay) {
    
        helper.parameters[@"status"] = @"3";

    } else if(self.status == ZHOrderStatusWillSend)  {
        
        helper.parameters[@"status"] = @"2";
     
    } else if(self.status == ZHOrderStatusDidFinish) {//全部
    
        helper.parameters[@"status"] = @"4";

    
    }
    
//    1待支付 2 已支付待发货 3 已发货待收货 4 已收货 91用户取消 92 商户取消 93 快递异常
    
//    if (self.statusCode) {
//        helper.parameters[@"status"] = self.statusCode;
//    }
    
    
    helper.tableView = self.shoppingListTableV;
    [helper modelClass:[ZHOrderModel class]];
    
    //-----//
    __weak typeof(self) weakSelf = self;
    [self.shoppingListTableV addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.orderGroups = objs;
            [weakSelf.shoppingListTableV reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    [self.shoppingListTableV addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.orderGroups = objs;
            [weakSelf.shoppingListTableV reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    [self.shoppingListTableV endRefreshingWithNoMoreData_tl];
    
}

- (void)qx {

    //取消订单
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"808052";
    http.parameters[@"code"] = @"";
    http.parameters[@"token"] = [ZHUser user].token;
    [http postWithSuccess:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];

}


#pragma mark- delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    ZHOrderDetailVC *vc = [[ZHOrderDetailVC alloc] init];
    vc.order = self.orderGroups[indexPath.section];
    
    //未支付订单，支付成功
    vc.paySuccess = ^(){
    
        [self.shoppingListTableV beginRefreshing];
    };
    
    vc.cancleSuccess = ^(){
    
        [self.shoppingListTableV beginRefreshing];
    };
    
    vc.confirmReceiveSuccess = ^(){
    
        [self.shoppingListTableV beginRefreshing];
    
    };
    
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}


#pragma mark- datasourece
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    ZHOrderModel *model = self.orderGroups[section];
    return [self headerViewWithOrderNum:model.code date:model.applyDatetime];

}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    static NSString * footerId = @"ZHOrderFooterViewId";
    ZHOrderFooterView *footerView = [[ZHOrderFooterView alloc] initWithReuseIdentifier:footerId];
    footerView.order = self.orderGroups[section];
    return footerView;

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 108;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 50;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.orderGroups.count;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    NSArray *arr = self.orderGroups[section].productOrderList;
//    return arr.count;
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *zhOrderGoodsCellId = @"ZHOrderGoodsCell";
    ZHOrderGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:zhOrderGoodsCellId];
    if (!cell) {
        
        cell = [[ZHOrderGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:zhOrderGoodsCellId];
        
    }
//    NSArray *arr =  self.orderGroups[indexPath.section].productOrderList;
//    cell.orderGoods = arr[indexPath.row];
//    ZHGoodsModel *model = self.orderGroups[indexPath.row].product;
//    model.currentParameterPriceRMB = self.orderGroups[indexPath.row].price1;
//    model.currentParameterPriceGWB = self.orderGroups[indexPath.row].price2;
//    model.currentParameterPriceQBB = self.orderGroups[indexPath.row].price3;
    
    cell.order = self.orderGroups[indexPath.section];
    
    return cell;
    
}


- (UIView *)headerViewWithOrderNum:(NSString *)num date:(NSString *)date {
    
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 40)];
    
    headerV.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 30)];
    v.backgroundColor = [UIColor whiteColor];
    [headerV addSubview:v];
    
    UILabel *lbl1 = [UILabel labelWithFrame:CGRectZero
                               textAligment:NSTextAlignmentLeft
                            backgroundColor:[UIColor whiteColor]
                                       font:FONT(11)
                                  textColor:[UIColor zh_textColor2]];
    [headerV addSubview:lbl1];
    [lbl1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerV.mas_left).offset(15);
        make.top.equalTo(headerV.mas_top).offset(10);
        make.bottom.equalTo(headerV.mas_bottom);
    }];
    lbl1.text = [NSString stringWithFormat:@"订单编号：%@",num];
    
    //
    UILabel *lbl2 = [UILabel labelWithFrame:CGRectZero
                               textAligment:NSTextAlignmentLeft
                            backgroundColor:[UIColor whiteColor]
                                       font:FONT(11)
                                  textColor:[UIColor zh_textColor2]];;
    [headerV addSubview:lbl2];
    [lbl2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbl1.mas_right).offset(-15);
        make.top.equalTo(lbl1.mas_top);
        make.bottom.equalTo(headerV.mas_bottom);
        make.right.equalTo(headerV.mas_right).offset(-15);
    }];
    lbl2.text = [date convertDate];
    
    //
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, headerV.height - 0.7, SCREEN_WIDTH, 0.7)];
    line.backgroundColor = [UIColor zh_lineColor];
    [headerV addSubview:line];

    return headerV;
    
}

@end
