//
//  ZHBankCardListVC.m
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/15.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHBankCardListVC.h"
#import "ZHBankCardAddVC.h"
#import "ZHBankCardCell.h"
#import "TLPageDataHelper.h"
#import "ZHBankCard.h"

@interface ZHBankCardListVC()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) TLTableView *bankCardTV;
@property (nonatomic,strong) NSMutableArray *banks;
@property (nonatomic,assign) BOOL isFirst;

@end

@implementation ZHBankCardListVC

- (instancetype)init {

    if (self = [super init]) {
        self.isFirst = YES;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.isFirst) {
        [self.bankCardTV beginRefreshing];
        self.isFirst = NO;
    }

}


- (void)viewDidLoad {

    [super viewDidLoad];
    self.title = @"我的银行卡";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(add)];
    
    TLTableView *bankCardTV = [TLTableView tableViewWithframe:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)
                                                       delegate:self
                                                     dataSource:self];
    self.bankCardTV = bankCardTV;
    bankCardTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:bankCardTV];
    bankCardTV.rowHeight = 140;
    
    bankCardTV.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无银行卡"];
    
    __weak typeof(self) weakSelf = self;
    TLPageDataHelper *pageDataHelper = [[TLPageDataHelper alloc] init];
    pageDataHelper.code = @"802015";
    pageDataHelper.tableView = bankCardTV;
    pageDataHelper.parameters[@"token"] = [ZHUser user].token;
    pageDataHelper.parameters[@"userId"] = [ZHUser user].userId;
    [pageDataHelper modelClass:[ZHBankCard class]];
    [bankCardTV addRefreshAction:^{
        
        [pageDataHelper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.banks = objs;
            [weakSelf.bankCardTV reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    
    [bankCardTV addLoadMoreAction:^{
        
        [pageDataHelper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.banks = objs;
            [weakSelf.bankCardTV reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
}

- (void)add {

    ZHBankCardAddVC *VC= [[ZHBankCardAddVC alloc] init];
    VC.addSuccess = ^(ZHBankCard *card){
    
        [self.bankCardTV beginRefreshing];
        
    };
    [self.navigationController pushViewController:VC animated:YES];

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.banks.count;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    
    ZHBankCardAddVC *displayAddVC = [[ZHBankCardAddVC alloc] init];
    displayAddVC.bankCard = self.banks[indexPath.row];
    displayAddVC.addSuccess = ^(ZHBankCard *card){
        
        [self.bankCardTV beginRefreshing];
        
    };
    
    [self.navigationController pushViewController:displayAddVC animated:YES];

}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *bankCardCellId = @"bankCardCellId";
    ZHBankCardCell *cell = [tableView dequeueReusableCellWithIdentifier:bankCardCellId];
    if (!cell) {
        cell = [[ZHBankCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bankCardCellId];
    }
    cell.bankCard = self.banks[indexPath.row];
    return cell;

}


@end
