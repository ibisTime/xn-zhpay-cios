//
//  ZHMineDBRecordVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHMineDBRecordVC.h"
#import "ZHDuoBaoCell.h"
#import "ZHMineNumberVC.h"

@interface ZHMineDBRecordVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ZHMineDBRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"小目标记录";
    
    TLTableView *mineNumberTableView = [TLTableView tableViewWithframe:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)
                                                              delegate:self
                                                            dataSource:self];
    //    self.mineNumberTableView = mineNumberTableView;
    
    [self.view addSubview:mineNumberTableView];
    mineNumberTableView.rowHeight = 140;
    
    mineNumberTableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无银行卡"];
    
    __weak typeof(self) weakSelf = self;
    TLPageDataHelper *pageDataHelper = [[TLPageDataHelper alloc] init];
    pageDataHelper.code = @"802015";
    pageDataHelper.tableView = mineNumberTableView;
    pageDataHelper.parameters[@"token"] = [ZHUser user].token;
    pageDataHelper.parameters[@"userId"] = [ZHUser user].userId;
//    [pageDataHelper modelClass:[ZHBankCard class]];
    [mineNumberTableView addRefreshAction:^{
        
        [pageDataHelper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
 
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    
    [mineNumberTableView addLoadMoreAction:^{
        
        [pageDataHelper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    ZHMineNumberVC *mineNumberVC = [[ZHMineNumberVC alloc] init];
    [self.navigationController pushViewController:mineNumberVC animated:YES];

}

//-----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
    
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
