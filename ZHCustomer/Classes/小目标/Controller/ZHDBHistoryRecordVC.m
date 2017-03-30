//
//  ZHDBHistoryRecordVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/22.
//  Copyright © 2017年  tianlei. All rights reserved.
//  ---- 往期揭晓的控制器

#import "ZHDBHistoryRecordVC.h"
#import "ZHDBHistoryModel.h"

#import "ZHDuoBaoCell.h"
#import "ZHMineNumberVC.h"

@interface ZHDBHistoryRecordVC ()

@property (nonatomic, strong) TLTableView *historyTableView;
@property (nonatomic, strong) NSMutableArray <ZHDBModel *>*dbHistoryRooms;
@property (nonatomic, assign) BOOL isFirst;


@end

@implementation ZHDBHistoryRecordVC
- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    if (self.isFirst) {
        
        [self.historyTableView beginRefreshing];
        self.isFirst = NO;
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"往期揭晓";
    self.isFirst = YES;
    
    
    TLTableView *tableView = [TLTableView tableViewWithframe:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) delegate:self dataSource:self];
    [self.view addSubview:tableView];
    tableView.rowHeight = 145;
    self.historyTableView = tableView;
    tableView.backgroundColor = [UIColor zh_backgroundColor];
    tableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无记录"];
    
    //
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    helper.code = @"615015";
    //0 募集中，1 已揭晓
    helper.parameters[@"status"] = @"1";
    helper.parameters[@"templateCode"] = self.dbModel.templateCode;
//    helper.parameters[@"jewelCode"] =  self.dbModel.code;
    
    
    helper.tableView = tableView;
    [helper modelClass:[ZHDBModel class]];
    
    //
    __weak typeof(self) weakSelf = self;
    [tableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            self.dbHistoryRooms = objs;
            [weakSelf.historyTableView reloadData_tl];
            
            
        } failure:^(NSError *error) {
            
            
        }];
        
        
    }];
    
    [tableView addLoadMoreAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            self.dbHistoryRooms = objs;
            [weakSelf.historyTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
}

#pragma mark- tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZHMineNumberVC *mineNumberVC = [[ZHMineNumberVC alloc] init];
    mineNumberVC.isMineHistory = NO;
    
    ZHDBHistoryModel *historyModel = [[ZHDBHistoryModel alloc] init];
    historyModel.jewel = self.dbHistoryRooms[indexPath.row];
    mineNumberVC.dbModel =  historyModel;
    
    [self.navigationController pushViewController:mineNumberVC animated:YES];
    
}


#pragma mark- dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dbHistoryRooms.count;
    
}

//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *zhDuoBaoCellId = @"ZHDuoBaoCell";
    ZHDuoBaoCell *cell = [tableView dequeueReusableCellWithIdentifier:zhDuoBaoCellId];
    if (!cell) {
        
        cell = [[ZHDuoBaoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:zhDuoBaoCellId];
        
    }
    
    cell.type = [NSString stringWithFormat:@"%ld",indexPath.row%3];
    cell.dbModel = self.dbHistoryRooms[indexPath.row];
    
    return cell;
    
    
}

@end
