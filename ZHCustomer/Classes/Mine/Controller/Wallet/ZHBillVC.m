//
//  ZHBillVC.m
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/24.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHBillVC.h"
#import "TLPageDataHelper.h"
#import "ZHBillCell.h"
#import "ZHBillModel.h"

@interface ZHBillVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray <ZHBillModel *>*bills;
@property (nonatomic,strong) TLTableView *billTV;

@property (nonatomic,assign) BOOL isFirst;


@end

@implementation ZHBillVC

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    if (self.isFirst) {
        [self.billTV beginRefreshing];
        self.isFirst = NO;
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFirst = YES;
    self.title = @"账单";
    TLTableView *billTableView = [TLTableView tableViewWithframe:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)
                                                       delegate:self
                                                     dataSource:self];
    [self.view addSubview:billTableView];

    billTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    billTableView.rowHeight = 110;
//    billTableView.rowHeight = UITableViewAutomaticDimension;
    billTableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无记录"];
    self.billTV = billTableView;
    
    //--//
    __weak typeof(self) weakSelf = self;
    TLPageDataHelper *pageDataHelper = [[TLPageDataHelper alloc] init];
    pageDataHelper.code = @"802524";
    pageDataHelper.tableView = billTableView;
    pageDataHelper.parameters[@"token"] = [ZHUser user].token;
//    类型C=C端用户；B=B端用户；P=平台
    pageDataHelper.parameters[@"type"] = @"C";
    if (self.accountNumber) {
        
        pageDataHelper.parameters[@"accountNumber"] = self.accountNumber;

    }
    
    //0 刚生成待回调，1 已回调待对账，2 对账通过, 3 对账不通过待调账,4 已调账,9,无需对账
    //pageDataHelper.parameters[@"status"] = [ZHUser user].token;
    [pageDataHelper modelClass:[ZHBillModel class]];
    [billTableView addRefreshAction:^{
        
        [pageDataHelper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.bills = objs;
            [weakSelf.billTV reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    
    [billTableView addLoadMoreAction:^{
        
        [pageDataHelper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.bills = objs;
            [weakSelf.billTV reloadData_tl];
   
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.bills.count;

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return self.bills[indexPath.row].dHeightValue + 110;

}


//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    
//
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *billCellId = @"ZHBillCellID";
    ZHBillCell *cell = [tableView dequeueReusableCellWithIdentifier:billCellId];
    
    if (!cell) {
        cell = [[ZHBillCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:billCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.billModel = self.bills[indexPath.row];
    
    return cell;
    
}

@end
