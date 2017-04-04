//
//  ZHSingleProfitDetailVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/4/3.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHSingleProfitFlowVC.h"
#import "ZHEarningModel.h"

@interface ZHSingleProfitFlowVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) TLTableView *flowTableView;

@end

@implementation ZHSingleProfitFlowVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.earnModel) {
        
        NSLog(@"模型传进来");
        return;
    }
    self.title = @"分红权收益详情";
    
    TLTableView *tableView = [TLTableView tableViewWithframe:CGRectZero delegate:self dataSource:self];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    tableView.estimatedRowHeight = 150;
    self.flowTableView = tableView;
    
    
#pragma mark- 店铺列表
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    helper.code = @"808425";
    helper.parameters[@"fundCode"] = self.earnModel.fundCode;
    helper.parameters[@"stockCode"] = self.earnModel.code;
    helper.parameters[@"toUser"] = [ZHUser user].userId;

    
      __weak typeof(self) weakSelf = self;
        [self.flowTableView addRefreshAction:^{
    
            //店铺数据
            [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
    
                [weakSelf.flowTableView reloadData_tl];
    
            } failure:^(NSError *error) {
    
    
            }];
    
        }];
    
    
        [self.flowTableView addLoadMoreAction:^{
    
            [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
    
                [weakSelf.flowTableView reloadData_tl];
    
            } failure:^(NSError *error) {
    
    
            }];
    
        }];
    
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    ZHSingleProfitFlowVC *singleProfitVC = [[ZHSingleProfitFlowVC alloc] init];
    [self.navigationController pushViewController:singleProfitVC animated:YES];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellId"];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCellId"];
        
    }
    
    return cell;
    
}




@end
