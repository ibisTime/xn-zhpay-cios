//
//  ZHDBRecordListVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/3.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHDBRecordListVC.h"
#import "ZHLookForTreasureCell.h"
//#import "ZHTreasureRecordModel.h"
#import "ZHMineTreasureModel.h"
#import "ZHMineTreasureCell.h"
#import "ZHDBRecordDetailVC.h"
#import "ZHImmediateBuyVC.h"
#import "ZHDBLastStepVC.h"

@interface ZHDBRecordListVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) TLTableView *shoppingListTableV;
@property (nonatomic,strong) NSMutableArray <ZHMineTreasureModel *>*mineTreasureRoom;
@property (nonatomic,assign) BOOL isFirst;

@end


@implementation ZHDBRecordListVC

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    if (self.isFirst) {
        [self.shoppingListTableV beginRefreshing];
        self.isFirst = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isFirst = YES;
    
    TLTableView *tableView = [TLTableView tableViewWithframe:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40) delegate:self dataSource:self];
    [self.view addSubview:tableView];
    tableView.rowHeight = 140;
    
    self.shoppingListTableV = tableView;
    tableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无记录"];
    
    //--//
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    
    if (self.isMineGetRecord) { //我的已获奖记录查询
        
        helper.code = @"808316";
        helper.parameters[@"userId"] = [ZHUser user].userId;

    } else {
        
    
        helper.code = @"808313";
        helper.parameters[@"userId"] = [ZHUser user].userId;
        if (self.status) {
            helper.parameters[@"jewelStatus"] = self.status;
        }
    
    }

    helper.tableView = self.shoppingListTableV;
    [helper modelClass:[ZHMineTreasureModel class]];
    
    //-----//
    __weak typeof(self) weakSelf = self;
    [self.shoppingListTableV addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.mineTreasureRoom = objs;
            [weakSelf.shoppingListTableV reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    [self.shoppingListTableV addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.mineTreasureRoom = objs;
            [weakSelf.shoppingListTableV reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    [self.shoppingListTableV endRefreshingWithNoMoreData_tl];

}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    
//    return 3;
//    
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (self.isMineGetRecord) { //我的中奖记录，条选择物流++++ 到添加物流界面
        
        ZHMineTreasureModel *mineTreasure = self.mineTreasureRoom[indexPath.row];
        ZHTreasureModel *treasure = mineTreasure.jewel;

        
        if (mineTreasure.reMobile && mineTreasure.reAddress) { //已经有收货地址
            ZHDBLastStepVC *lastStepVC = [[ZHDBLastStepVC alloc] init];
            
            lastStepVC.success = ^(){
            
                [self.shoppingListTableV beginRefreshing];
            
            };
            lastStepVC.mineTreasure=  mineTreasure;
            [self.navigationController pushViewController:lastStepVC animated:YES];
            
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            return;
        }
        
        //还没有选择收货地址
        ZHImmediateBuyVC *imBuyVC = [[ZHImmediateBuyVC alloc] init];
        imBuyVC.type = ZHIMBuyTypeYYDBChooseAddress;
        imBuyVC.yydbResCode = self.mineTreasureRoom[indexPath.row].code;
        imBuyVC.chooseYYDBSuccess = ^(){
        
            [self.shoppingListTableV beginRefreshing];
        
        };
        
        ZHGoodsModel *goods = [[ZHGoodsModel alloc] init];
        goods.name = treasure.name;
        goods.advPic = treasure.advPic;
        goods.advTitle = treasure.slogan;
        goods.count = [self.mineTreasureRoom[indexPath.row].times integerValue];
        goods.price1 = treasure.price1;
        goods.price2 = treasure.price2;
        goods.price3 = treasure.price3;

        imBuyVC.goodsRoom = @[goods];
        
        [self.navigationController pushViewController:imBuyVC animated:YES];

    } else {
    
        ZHDBRecordDetailVC *detailVC = [[ZHDBRecordDetailVC alloc] init];
        
        detailVC.mineTreasureModel = self.mineTreasureRoom[indexPath.row];
        [self.navigationController pushViewController:detailVC animated:YES];
    
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.mineTreasureRoom.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *zhMineTreasureCellId = @"zhMineTreasureCellId";
    ZHMineTreasureCell *cell = [tableView dequeueReusableCellWithIdentifier:zhMineTreasureCellId];
    
    if (!cell) {
        
        cell = [[ZHMineTreasureCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:zhMineTreasureCellId];
        
    }

    cell.isMineGet = self.isMineGetRecord;//必须先赋值
    cell.mineTreasure = self.mineTreasureRoom[indexPath.row];
    
    return cell;
}

@end
