//
//  ZHSingleProfitDetailVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/4/3.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHSingleProfitFlowVC.h"
#import "ZHEarningModel.h"
#import "TLPageDataHelper.h"
#import "ZHEarningFlowCell.h"
#import "CDProfitCell.h"
#import "CDHistorySingleProfitVC.h"
#import "TLHeader.h"
#import "ZHUser.h"


@interface ZHSingleProfitFlowVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) TLTableView *flowTableView;
@property (nonatomic, strong) NSMutableArray<ZHEarningFlowModel *> *flowModels;

@property (nonatomic, assign) BOOL isFirst;

@end

@implementation ZHSingleProfitFlowVC

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    if (self.isFirst) {
        
        self.isFirst = NO;
        [self.flowTableView beginRefreshing];

    }
}

- (void)lookHistory {

    CDHistorySingleProfitVC *vc = [CDHistorySingleProfitVC new];
    vc.earnModel = self.earnModel;
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFirst = YES;
    
    if (!self.earnModel) {
        
        NSLog(@"模型传进来");
        return;
    }
    
    //
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"历史详情" style:0 target:self action:@selector(lookHistory)];
    
    TLTableView *tableView = [TLTableView tableViewWithframe:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) delegate:self dataSource:self];
    [self.view addSubview:tableView];
//    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(UIEdgeInsetsZero);
//    }];
    
    self.flowTableView = tableView;
    tableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无记录"];
    
#pragma mark- 店铺列表
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    switch (self.type) {
        case ZHSingleProfitFlowVCTypeFenHongQuan :  {
            
            helper.code = @"808425";
            self.title = @"分红权收益详情";

        } break;
            
        case ZHSingleProfitFlowVCTypeBuTie : {
            //
            helper.code = @"808465";
            self.title = @"补贴收益详情";

        } break;
            
    }
    
    helper.parameters[@"fundCode"] = self.earnModel.fundCode;
    helper.parameters[@"stockCode"] = self.earnModel.code;
    helper.parameters[@"toUser"] = [ZHUser user].userId;
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
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

   return  indexPath.section != 0 ? 40 :  [CDProfitCell rowHeight];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;

}


//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    }
    
    return self.flowModels.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        CDProfitCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CDProfitCell"];
        if (!cell) {
            
            cell = [[CDProfitCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CDProfitCell"];
            
        }
        cell.isSimpleUI = YES;
        cell.earningModel = self.earnModel;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    
    
    ZHEarningFlowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZHEarningFlowCellID"];
    if (!cell) {
        
        cell = [[ZHEarningFlowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZHEarningFlowCellID"];
        
    }
    cell.flowModel = self.flowModels[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}




@end
