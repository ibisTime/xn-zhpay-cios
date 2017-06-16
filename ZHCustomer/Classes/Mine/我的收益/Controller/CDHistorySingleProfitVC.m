//
//  ZHSingleProfitDetailVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/4/3.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CDHistorySingleProfitVC.h"
#import "CDChooseTimeIntervalView.h"

#import "ZHEarningModel.h"
#import "TLPageDataHelper.h"
#import "ZHEarningFlowCell.h"
//#import "CDProfitCell.h"


@interface CDHistorySingleProfitVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) TLTableView *flowTableView;
@property (nonatomic, strong) NSMutableArray<ZHEarningFlowModel *> *flowModels;

@property (nonatomic, assign) BOOL isFirst;

@property (nonatomic, strong) CDChooseTimeIntervalView *chooseView;
@end

@implementation CDHistorySingleProfitVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
//    [self.flowTableView beginRefreshing];
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    [self beginSearch];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.earnModel) {
        
        NSLog(@"模型传进来");
        return;
    }
    self.title = @"历史详情";
    
    //
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"开始查询" style:0 target:self action:@selector(beginSearch)];
    
    self.chooseView = [CDChooseTimeIntervalView chooseView];
    [self.view addSubview:self.chooseView];
    self.chooseView.y = 0;
    //
    
    TLTableView *tableView = [TLTableView tableViewWithframe:CGRectMake(0, self.chooseView.yy, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - self.chooseView.yy) delegate:self dataSource:self];
    [self.view addSubview:tableView];
    tableView.estimatedRowHeight = 50;

//    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(UIEdgeInsetsZero);
//    }];
    
    self.flowTableView = tableView;
    tableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无记录"];
    
  
    
    
}


- (void)beginSearch {

    if (![self.chooseView valid]) {
        
        return;
    }
    
#pragma mark- 店铺列表
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    helper.code = @"808428";
    helper.parameters[@"fundCode"] = self.earnModel.fundCode;
    helper.parameters[@"stockCode"] = self.earnModel.code;
    helper.parameters[@"toUser"] = [ZHUser user].userId;
    helper.parameters[@"dateStart"] = self.chooseView.beginTimeTf.text;
    helper.parameters[@"dateEnd"] = self.chooseView.endTimeTf.text;

    //
    helper.tableView = self.flowTableView;
    [helper modelClass:[ZHEarningFlowModel class]];
    
    __weak typeof(self) weakSelf = self;
    [self.flowTableView addRefreshAction:^{
        
        //店铺数据
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.flowModels = objs;
            [weakSelf.flowTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    
    [self.flowTableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.flowModels = objs;
            [weakSelf.flowTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];

    
    [self.flowTableView beginRefreshing];

}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    ZHSingleProfitFlowVC *singleProfitVC = [[ZHSingleProfitFlowVC alloc] init];
//    [self.navigationController pushViewController:singleProfitVC animated:YES];
//
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    return   40 ;
//    
//}

//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return self.flowModels.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    ZHEarningFlowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZHEarningFlowCellID"];
    
    if (!cell) {
        
        cell = [[ZHEarningFlowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZHEarningFlowCellID"];
        
    }
    cell.flowModel = self.flowModels[indexPath.row];
    return cell;
    
}




@end
