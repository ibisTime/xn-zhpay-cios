//
//  ZHDefaultGoodsVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/26.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHDefaultGoodsVC.h"
#import "ZHGoodsModel.h"
#import "ZHGoodsCell.h"
#import "ZHGoodsDetailVC.h"
#import "UIColor+theme.h"

@interface ZHDefaultGoodsVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) TLTableView *goodsTableView;
@property (nonatomic,strong) NSMutableArray <ZHGoodsModel *>*goods;
@property (nonatomic,assign) BOOL isFirst;

@end


@implementation ZHDefaultGoodsVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isFirst = YES;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
}

//
- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    if (self.isFirst) {
        
        [self.goodsTableView beginRefreshing];
        self.isFirst = NO;

    }

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //
    TLTableView *tableView = [TLTableView tableViewWithframe:CGRectZero delegate:self dataSource:self];
    [self.view addSubview:tableView];
    tableView.rowHeight = 96;
    self.goodsTableView = tableView;
    tableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无商品"];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    //// 0 待发布 1 已上架 2已下架
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    helper.code = @"808028";
    
    helper.parameters[@"type"] = self.categoryCode;
    helper.parameters[@"status"] = @"3";
    helper.isDeliverCompanyCode = NO;
    helper.tableView = self.goodsTableView;
    [helper modelClass:[ZHGoodsModel class]];
    
    //
    __weak typeof(self) weakSelf = self;
    [self.goodsTableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.goods = objs;
            [weakSelf.goodsTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    //---//
    [self.goodsTableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.goods = objs;
            [weakSelf.goodsTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    [self.goodsTableView endRefreshingWithNoMoreData_tl];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    ZHGoodsDetailVC *detailVC = [[ZHGoodsDetailVC alloc] init];
    detailVC.goods = self.goods[indexPath.row];
    detailVC.detailType = ZHGoodsDetailTypeDefault;
    [self.navigationController pushViewController:detailVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.goods.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *zhGoodsCellId = @"ZHGoodsCell";
    ZHGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:zhGoodsCellId];
    if (!cell) {
        
        cell = [[ZHGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:zhGoodsCellId];
        
    }
    cell.goods = self.goods[indexPath.row];
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {

    UITableViewHeaderFooterView *hfv = (UITableViewHeaderFooterView *)view;
    hfv.contentView.backgroundColor = [UIColor zh_backgroundColor];

}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
    
}


@end
