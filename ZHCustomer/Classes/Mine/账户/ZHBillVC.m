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
#import "ZHCurrencyToOtherPeopleVC.h"
#import "CDBillHistoryVC.h"
#import  "ZHCMacro.h"
#import "TLHeader.h"
#import "UIColor+theme.h"
#import "ZHUser.h"


@interface ZHBillVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray <ZHBillModel *>*bills;
@property (nonatomic,strong) TLTableView *billTV;

@property (nonatomic,assign) BOOL isFirst;

@property (nonatomic,copy)  void(^rightActionBlock)();
@property (nonatomic,copy)  void(^leftAcitonBlock)();

@property (nonatomic, strong) ZHCurrencyConvertView *currencyConvertView;

@end



@implementation ZHBillVC

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    if (self.isFirst) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.billTV beginRefreshing];
            self.isFirst = NO;
            
        });
     
    }

}

- (void)zhuanZhangAction {

    ZHCurrencyToOtherPeopleVC *vc = [[ZHCurrencyToOtherPeopleVC alloc] init];
    vc.accountNumber = self.currencyModel.accountNumber;
    [vc setSuccess:^(NSNumber *frbSysMoney){
        
        //修改
        self.currencyModel.amount = frbSysMoney;
        self.currencyConvertView.moneyLbl.text = [self.currencyModel.amount convertToRealMoney];
        
    }];
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFirst = YES;
    
    if (!self.currencyModel) {
        
        [TLAlert alertWithInfo:@"请传入币种模型"];
        
        return;
        
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"历史账单" style:0 target:self action:@selector(lookHistoryBill)];
    

    
    TLTableView *billTableView = [TLTableView tableViewWithframe:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)
                                                       delegate:self
                                                     dataSource:self];
    [self.view addSubview:billTableView];

    billTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    billTableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无记录" topMargin:100];
    self.billTV = billTableView;
    
    //--//
    __weak typeof(self) weakSelf = self;
    TLPageDataHelper *pageDataHelper = [[TLPageDataHelper alloc] init];
    pageDataHelper.code = @"802524";
    pageDataHelper.tableView = billTableView;
    pageDataHelper.limit = 10;
    pageDataHelper.parameters[@"token"] = [ZHUser user].token;
//    类型C=C端用户；B=B端用户；P=平台
    pageDataHelper.parameters[@"userId"] = [ZHUser user].userId;
    pageDataHelper.parameters[@"type"] = TERMINAL_TYPE;
    pageDataHelper.parameters[@"accountNumber"] = self.currencyModel.accountNumber ? : nil;
    

    
    //1=待对账，3=已对账且账已平，4=帐不平待调账审批 5=已对账且账不平 6=无需对账
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

    ZHCurrencyConvertView *currencyConvertView = [[ZHCurrencyConvertView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    billTableView.tableHeaderView = currencyConvertView;
    self.currencyConvertView = currencyConvertView;
    currencyConvertView.typeLbl.text = [self.currencyModel getTypeName];
    currencyConvertView.moneyLbl.text = [self.currencyModel.amount convertToRealMoney];

    
    __weak typeof(self) weakself = self;
    
    
    if ([self.currencyModel.currency isEqualToString:kFRB]) {
        //分润 可提现，不可转账
        currencyConvertView.leftBtn.hidden = YES;
        [currencyConvertView.rightBtn setTitle:@"提现" forState:UIControlStateNormal];
       [currencyConvertView.rightBtn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
        
        self.rightActionBlock = ^(){
            
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
            withdrawalVC.accountNum = weakself.currencyModel.accountNumber;
            withdrawalVC.success = ^(){
                
            };
            [weakself.navigationController pushViewController:withdrawalVC animated:YES];
            
        };
       
        
    } else if ([self.currencyModel.currency isEqualToString:kBTB]) {
        //补贴币 ,可转账,可提现
        
        //分润 可提现，不可转账
        [currencyConvertView.leftBtn setTitle:@"转账" forState:UIControlStateNormal];
        [currencyConvertView.leftBtn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
        
        //
        [currencyConvertView.rightBtn setTitle:@"提现" forState:UIControlStateNormal];
        [currencyConvertView.rightBtn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
        
        //
        [self setLeftAcitonBlock:^{
            
            [weakSelf zhuanZhangAction];
        }];
        
        //
        self.rightActionBlock = ^(){
            
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
            withdrawalVC.accountNum = weakself.currencyModel.accountNumber;
            withdrawalVC.success = ^(){
                
            };
            [weakself.navigationController pushViewController:withdrawalVC animated:YES];
        };
        
    } else {
        
        //其它按钮隐藏
        currencyConvertView.leftBtn.hidden = YES;
        currencyConvertView.rightBtn.hidden = YES;
  
    }
    
    //头部
//    if ([self.currencyModel.currency isEqualToString:kFRB]) { //只可以提现
//        
//        hiddenLeft = YES;
//        rightTitle = @"提现";
        
//#pragma mark- 转贡献值
//        UIButton *zhuanZhangeBtn = [UIButton zhBtnWithFrame:CGRectZero title:@"转账"];
//        [currencyConvertView addSubview:zhuanZhangeBtn];
//        [zhuanZhangeBtn addTarget:self action:@selector(zhuanZhangAction) forControlEvents:UIControlEventTouchUpInside];
//        [zhuanZhangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.centerY.equalTo(currencyConvertView.mas_centerY);
//            make.width.equalTo(currencyConvertView.rightBtn.mas_width);
//            make.height.equalTo(currencyConvertView.rightBtn.mas_height);
//            make.right.equalTo(currencyConvertView.rightBtn.mas_left).offset(-20);
//
//        }];

        
//    }
    
//    currencyConvertView.rightBtn.hidden = hiddenRight;
//    [currencyConvertView.rightBtn setTitle:rightTitle forState:UIControlStateNormal];
    
//    if ([self.currencyModel.currency isEqualToString:kHBB] || [self.currencyModel.currency isEqualToString:kHBYJ]) {
//
//        TLNetworking *masOpTimesHttp = [TLNetworking new];
//        masOpTimesHttp.showView = self.view;
//        masOpTimesHttp.code = @"802027";
//        masOpTimesHttp.parameters[@"key"] = @"EXCTIMES";
//        [masOpTimesHttp postWithSuccess:^(id responseObject) {
//
//            currencyConvertView.topHintLbl.text =[NSString stringWithFormat:@"每人每月最多转换%@次",responseObject[@"data"][@"cvalue"]];
//
//        } failure:^(NSError *error) {
//
//
//        }];
//
//    }
    
}


- (void)lookHistoryBill {
    
    CDBillHistoryVC *vc = [[CDBillHistoryVC alloc] init];
    vc.accountNumber = self.currencyModel.accountNumber;
    [self.navigationController pushViewController:vc animated:YES];

}

//


- (void)leftAction {

    if (self.leftAcitonBlock) {
        self.leftAcitonBlock();
    }
}

- (void)rightAction {

    if (self.rightActionBlock) {
        self.rightActionBlock();
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
