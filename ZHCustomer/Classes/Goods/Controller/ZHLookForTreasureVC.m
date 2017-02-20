//
//  ZHLookForTreasureVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/26.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHLookForTreasureVC.h"
#import "ZHLookForTreasureCell.h"
//#import "ZHGoodsModel.h"
#import "ZHGoodsDetailVC.h"
#import "ZHTreasureModel.h"
#import "ZHSearchVC.h"

@interface ZHLookForTreasureVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) TLTableView *treasureTableView;
@property (nonatomic,strong) NSMutableArray <ZHTreasureModel *>*treasures;
@property (nonatomic,assign) BOOL isRefreshed;

@end

@implementation ZHLookForTreasureVC

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    
    if (!self.isRefreshed) {
        [self.treasureTableView beginRefreshing];
        self.isRefreshed = YES;

    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"一元夺宝";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search"] style:UIBarButtonItemStylePlain target:self action:@selector(search)];
    
    TLTableView *tableView = [TLTableView tableViewWithframe:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) delegate:self dataSource:self];
    [self.view addSubview:tableView];
    tableView.rowHeight = 140;
    self.treasureTableView = tableView;
    tableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无商品"];
    
    //
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
//    helper.code = @"808020";
//    helper.parameters[@"category"] = @"FL201600000000000002";
    helper.code = @"808310";
    helper.parameters[@"status"] = @"3";
    helper.tableView = self.treasureTableView;
    [helper modelClass:[ZHTreasureModel class]];
    
    //
    __weak typeof(self) weakSelf = self;
    [self.treasureTableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            
            weakSelf.treasures = objs;
            [weakSelf.treasureTableView reloadData_tl];
            
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    [self.treasureTableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.treasures = objs;
            [weakSelf.treasureTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    [self.treasureTableView endRefreshingWithNoMoreData_tl];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(treasureSuccess) name:@"dbBuySuccess" object:nil];
    
}


- (void)treasureSuccess {

    [self.treasureTableView beginRefreshing];
    
}

- (void)search {
    
    ZHSearchVC *searchVC = [[ZHSearchVC alloc] init];
    searchVC.type = ZHSearchVCTypeYYDB;
    [self.navigationController pushViewController:searchVC animated:YES];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    ZHGoodsDetailVC *vc = [[ZHGoodsDetailVC alloc] init];
    vc.detailType = ZHGoodsDetailTypeLookForTreasure;
    vc.treasure = self.treasures[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.treasures.count;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *zhTreasureCellId = @"zhTreasureCellId";
    ZHLookForTreasureCell *cell = [tableView dequeueReusableCellWithIdentifier:zhTreasureCellId];
    if (!cell) {
        
        cell = [[ZHLookForTreasureCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:zhTreasureCellId];
        
    }
    cell.treasure = self.treasures[indexPath.row];
    return cell;
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 10;

}

@end
