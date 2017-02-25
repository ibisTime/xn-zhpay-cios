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
#import "ZHCurrencyConvertView.h"
#import "ZHRealNameAuthVC.h"
#import "ZHWithdrawalVC.h"
#import "ZHHBConvertFRVC.h"


@interface ZHBillVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray <ZHBillModel *>*bills;
@property (nonatomic,strong) TLTableView *billTV;

@property (nonatomic,assign) BOOL isFirst;

@property (nonatomic,copy)  void(^rightAciton)();

@end



@implementation ZHBillVC

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    if (self.isFirst) {
        [self.billTV beginRefreshing];
        self.isFirst = NO;
    }

}

//
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFirst = YES;
    
//    if (!self.currencyModel || !(self.currency && self.bizType)) {
//        [TLAlert alertWithHUDText:@"无模型数据"];
//        return;
//    }
    
    self.title = @"账单";
    TLTableView *billTableView = [TLTableView tableViewWithframe:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)
                                                       delegate:self
                                                     dataSource:self];
    [self.view addSubview:billTableView];

    billTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    billTableView.rowHeight = 110;
//    billTableView.rowHeight = UITableViewAutomaticDimension;
    billTableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无记录" topMargin:100];
    self.billTV = billTableView;
    
    //--//
    __weak typeof(self) weakSelf = self;
    TLPageDataHelper *pageDataHelper = [[TLPageDataHelper alloc] init];
    pageDataHelper.code = @"802524";
    pageDataHelper.tableView = billTableView;
    pageDataHelper.parameters[@"token"] = [ZHUser user].token;
//    类型C=C端用户；B=B端用户；P=平台
    pageDataHelper.parameters[@"userId"] = [ZHUser user].userId;
    pageDataHelper.parameters[@"type"] = @"C";
    
        
    pageDataHelper.parameters[@"accountNumber"] = self.currencyModel.accountNumber ? : nil;


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
    
    
    if (self.currency && self.bizType) {
        
        pageDataHelper.parameters[@"bizType"] = self.bizType;
        pageDataHelper.parameters[@"currency"] = self.currency;
        return;
        
    }
    
    ZHCurrencyConvertView *currencyConvertView = [[ZHCurrencyConvertView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    billTableView.tableHeaderView = currencyConvertView;
    
    [currencyConvertView.leftBtn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    
    [currencyConvertView.rightBtn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    
    currencyConvertView.typeLbl.text = [self.currencyModel getTypeName];
    currencyConvertView.moneyLbl.text = [self.currencyModel.amount convertToRealMoney];
    
    BOOL hiddenLeft = NO;
    BOOL hiddenRight = NO;
    NSString *leftTitle = @"";
    NSString *rightTitle = @"";
    
    
    

    __weak typeof(self) weakself = self;
    //头部
    if ([self.currencyModel.currency isEqualToString:kFRB]) { //只可以提现
        
        hiddenLeft = YES;
        rightTitle = @"提现";
        
        [self howWithDraw];
        
    } else if ([self.currencyModel.currency isEqualToString:kGXB] ||
               [self.currencyModel.currency isEqualToString:kQBB] ||
               [self.currencyModel.currency isEqualToString:kGWB]) {//消费
    
        hiddenLeft = YES;
        rightTitle = @"消费";
        hiddenRight = YES;
        self.rightAciton = ^(){
            [TLAlert alertWithHUDText:@"去消费"];
        };
    
    } else if ([self.currencyModel.currency isEqualToString:kHBB]) {//红包币转分润
    
        hiddenLeft = YES;
        rightTitle = @"转分润";
        
        self.rightAciton = ^(){
            
            ZHHBConvertFRVC *vc = [[ZHHBConvertFRVC alloc] init];
            vc.title = @"转分润";
            vc.type = ZHCurrencyConvertHBToFR;
            vc.amount = weakself.currencyModel.amount;
            
            vc.success = ^(){
                
                [weakSelf.billTV beginRefreshing];

            };
            
            [weakself.navigationController pushViewController:vc animated:YES];
            
        };
        
     
        
    } else if ([self.currencyModel.currency isEqualToString:kHBYJ]) {//转贡献，或者分润
    
        hiddenLeft = NO;
        leftTitle = @"转贡献";
        rightTitle = @"转分润";
        
        self.rightAciton = ^(){
        
            ZHHBConvertFRVC *vc = [[ZHHBConvertFRVC alloc] init];
            vc.success = ^(){
                
                [weakSelf.billTV beginRefreshing];

            };
            vc.title = @"转分润";
            vc.type = ZHCurrencyConvertHBYJToFR;
            
            vc.amount = weakself.currencyModel.amount;
            [weakself.navigationController pushViewController:vc animated:YES];
        
        
        };
        
    }
    
    currencyConvertView.leftBtn.hidden = hiddenLeft;
    currencyConvertView.rightBtn.hidden = hiddenRight;
    [currencyConvertView.leftBtn setTitle:leftTitle forState:UIControlStateNormal];
    [currencyConvertView.rightBtn setTitle:rightTitle forState:UIControlStateNormal];


    
}

- (void)howWithDraw {

    __weak typeof(self) weakself = self;

    self.rightAciton = ^(){
        
        //进行实名认真之后才能提现
        if (![ZHUser user].realName) {
            [TLAlert alertWithTitle:nil Message:@"您还未进行实名认证\n前往进行实名认证" confirmMsg:@"前往" CancleMsg:@"取消" cancle:^(UIAlertAction *action) {
                
            } confirm:^(UIAlertAction *action) {
                
                ZHRealNameAuthVC *authVC = [[ZHRealNameAuthVC alloc] init];
                authVC.authSuccess = ^(){ //实名认证成功
                    
                };
                [weakself.navigationController pushViewController:authVC animated:YES];
                
            }];
            
            return;
        }
        
        ZHWithdrawalVC *withdrawalVC = [[ZHWithdrawalVC alloc] init];
        withdrawalVC.balance = weakself.currencyModel.amount;
        withdrawalVC.accountNum = weakself.currencyModel.accountNumber;
        withdrawalVC.success = ^(){
            
            
        };
        [weakself.navigationController pushViewController:withdrawalVC animated:YES];
        
    };

}

- (void)leftAction {
    //只可能 红包业绩转贡献
    ZHHBConvertFRVC *vc = [[ZHHBConvertFRVC alloc] init];
    vc.success = ^(){
        
        [self.billTV beginRefreshing];
        
    };
    
    vc.title = @"转贡献奖励";
    vc.type = ZHCurrencyConvertHBYJToGXJL;
        

//    vc.title = @"转分润";
//    vc.type = ZHCurrencyConvertHBYJToFR;
//    
    vc.amount = self.currencyModel.amount;
    [self.navigationController pushViewController:vc animated:YES];

 
    
}

- (void)rightAction {

    if (self.rightAciton) {
        self.rightAciton();
    }
    
//    if ([self.currencyModel.type isEqualToString:kFRB]) { //只可以提现
//        
//
//        
//    } else if ([self.currencyModel.type isEqualToString:kGXB] || [self.currencyModel.type isEqualToString:kQBB] || [self.currencyModel.type isEqualToString:kGWB]) {//消费
//        
//    
//    } else if ([self.currencyModel.type isEqualToString:kHBB]) {//红包币转分润
//        
//   
//        
//    } else if ([self.currencyModel.type isEqualToString:kHBYJ]) {//转贡献，或者分润
//        
//        hiddenLeft = NO;
//        leftTitle = @"转贡献";
//        rightTitle = @"转分润";
//        
//    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.bills.count;

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return self.bills[indexPath.row].dHeightValue + 110;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 10;
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
