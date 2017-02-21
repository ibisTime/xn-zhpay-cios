//
//  ZHMineNumberVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHMineNumberVC.h"
#import "ZHDuoBaoCell.h"

@interface ZHMineNumberVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ZHMineNumberVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的号码";
    self.view.backgroundColor = [UIColor whiteColor];
    
    TLTableView *mineNumberTableView = [TLTableView tableViewWithframe:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 65)
                                                              delegate:self
                                                            dataSource:self];
    //self.mineNumberTableView = mineNumberTableView;
    [self.view addSubview:mineNumberTableView];
    mineNumberTableView.rowHeight = 140;
    
    
    //
    UIButton *shareBtn = [UIButton zhBtnWithFrame:CGRectMake(0, mineNumberTableView.yy + 10, SCREEN_WIDTH - 40, 45) title:@"追加"];
    [self.view addSubview:shareBtn];
    [self.view addSubview:shareBtn];
    shareBtn.centerX = SCREEN_WIDTH/2.0;
    [shareBtn addTarget:self action:@selector(buy) forControlEvents:UIControlEventTouchUpInside];

    __weak typeof(self) weakSelf = self;
    TLPageDataHelper *pageDataHelper = [[TLPageDataHelper alloc] init];
    pageDataHelper.code = @"802015";
    pageDataHelper.tableView = mineNumberTableView;
    pageDataHelper.parameters[@"token"] = [ZHUser user].token;
    pageDataHelper.parameters[@"userId"] = [ZHUser user].userId;
    
    //[pageDataHelper modelClass:[ZHBankCard class]];
    [mineNumberTableView addRefreshAction:^{
        
        [pageDataHelper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
        } failure:^(NSError *error) {
            
        }];
        
    }];
    
    //
    [mineNumberTableView addLoadMoreAction:^{
        
        [pageDataHelper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
        } failure:^(NSError *error) {
          
        }];
        
    }];
    
    
}

#pragma mark- 追加
- (void)buy {

    
    

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    
}

//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *zhDuoBaoCellId = @"ZHDuoBaoCell";
    ZHDuoBaoCell *cell = [tableView dequeueReusableCellWithIdentifier:zhDuoBaoCellId];
    if (!cell) {
        
        cell = [[ZHDuoBaoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:zhDuoBaoCellId];
        
    }
    cell.type = [NSString stringWithFormat:@"%ld",indexPath.row  + 1];
    return cell;
    
    
}

@end
