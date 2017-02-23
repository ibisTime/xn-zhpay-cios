//
//  ZHMineNumberVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHMineNumberVC.h"
#import "ZHDuoBaoCell.h"
#import "ZHDuoBaoDetailVC.h"

@interface ZHMineNumberVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ZHMineNumberVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    TLTableView *mineNumberTableView = [TLTableView tableViewWithframe:CGRectMake(0, 0, SCREEN_WIDTH, 140)
                                                              delegate:self
                                                            dataSource:self];
    //self.mineNumberTableView = mineNumberTableView;
    [self.view addSubview:mineNumberTableView];
    mineNumberTableView.rowHeight = 140;
    //
    if (self.isMineHistory) { //我的记录
       
        if ([self.historyModel.jewel.status isEqual:@0]) { //还未揭晓
            
            UIButton *shareBtn = [UIButton zhBtnWithFrame:CGRectMake(0, SCREEN_HEIGHT - 55 - 64, SCREEN_WIDTH - 45, 45) title:@"追加"];
            [self.view addSubview:shareBtn];
            [self.view addSubview:shareBtn];
            shareBtn.centerX = SCREEN_WIDTH/2.0;
            [shareBtn addTarget:self action:@selector(buy) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:shareBtn];
        }

        
    }
    
    //查询号码列表
    UIScrollView *numListTableView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, mineNumberTableView.yy + 10, SCREEN_WIDTH - 20, 100)];
    [self.view addSubview:numListTableView];
    
    
    //查询中奖号码列表
    if ([self.historyModel.jewel.status isEqual:@1]) {
       
        CGFloat y = numListTableView.yy;
        UILabel *hintLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, y, SCREEN_WIDTH - 20, 20)];
        hintLbl.textColor = [UIColor zh_textColor];
        [self.view addSubview:hintLbl];
        hintLbl.text = @"中奖号码:";
        hintLbl.font = FONT(13);

        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, hintLbl.yy, SCREEN_WIDTH - 20, 30)];
        [self.view addSubview:lbl];
        lbl.font = FONT(13);
        lbl.textColor = [UIColor zh_themeColor];
        lbl.text = self.historyModel.jewel.winUser;
    }

 

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
    
    
}

#pragma mark- 追加
- (void)buy {

    //调到宝贝
    ZHDuoBaoDetailVC *detailVC = [[ZHDuoBaoDetailVC alloc] init];
    detailVC.dbModel = self.historyModel.jewel;
    [self.navigationController pushViewController:detailVC animated:YES];
    

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
    cell.dbModel = self.historyModel.jewel;
    return cell;
    
    
}

@end
