//
//  ZHMineWalletVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/3.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHMineWalletVC.h"
#import "ZHWalletCell.h"
#import "ZHHBConvertFRVC.h"
#import "ZHCurrencyModel.h"
#import "ZHWithdrawalVC.h"
#import "ZHRealNameAuthVC.h"
#import "ZHBillVC.h"

@interface ZHMineWalletVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UILabel *balanceLbl;
@property (nonatomic,strong) UIButton *maskBtn;

@property (nonatomic,strong) NSMutableArray <ZHCurrencyModel *>*currencyRoom;
@property (nonatomic,strong) NSMutableDictionary <NSString *,ZHCurrencyModel *>*currencyDict;

@property (nonatomic,strong) TLTableView *walletTableView;

@end

@implementation ZHMineWalletVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的钱包";
    
    self.currencyDict = [NSMutableDictionary dictionary];
  
    [self howInit];
    
}

- (void)howInit {

    //
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;

    if (self.walletTableView) {
        http.showView = nil;
    }
    http.code = @"802503";
    http.parameters[@"token"] = [ZHUser user].token;
    http.parameters[@"userId"] = [ZHUser user].userId;
    [http postWithSuccess:^(id responseObject) {
        
        self.currencyRoom = [ZHCurrencyModel tl_objectArrayWithDictionaryArray:responseObject[@"data"]];
        
        if (self.walletTableView) {
            [self.walletTableView reloadData];
            [self.walletTableView endRefreshHeader];
        } else {
            
            [self setUpUI];
            
        }
        
        
        //把币种分开
        [self.currencyRoom  enumerateObjectsUsingBlock:^(ZHCurrencyModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            self.currencyDict[obj.currency] = obj;
            
        }];
        
        //计算总额
        long long YE = [self.currencyDict[kFRB].amount longLongValue];
        long long GX = [self.currencyDict[kGXB].amount longLongValue];
        long long amount = YE + GX;
//        self.balanceLbl.text = [@(amount) convertToRealMoney];
        
        //        self.balanceLbl.text = @"2000.00";
        
    } failure:^(NSError *error) {
        
        [TLAlert alertWithHUDText:@"获取用户账户信息失败"];
        
    }];
    
    //获得总额
    TLNetworking *http2 = [TLNetworking new];
    http2.showView = self.view;
    http2.code = @"808801";
    http2.parameters[@"userId"] = [ZHUser user].userId;
    http2.parameters[@"token"] = [ZHUser user].token;
    [http2 postWithSuccess:^(id responseObject) {
        
     self.balanceLbl.text =  [responseObject[@"data"] convertToRealMoney];
        
    } failure:^(NSError *error) {
        
    }];


}

- (void)setUpUI{

    if (self.walletTableView) {
        
        return;
    }
    
    //
    TLTableView *walletTableView = [[TLTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    [self.view addSubview:walletTableView];
    self.walletTableView = walletTableView;
    walletTableView.backgroundColor = [UIColor zh_backgroundColor];
    walletTableView.rowHeight = 50;
    walletTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //header
    walletTableView.delegate = self;
    walletTableView.dataSource = self;
    walletTableView.tableHeaderView = [self headerView];
    
    [walletTableView addRefreshAction:^{
       
        [self howInit];
       
    }];
    
    
}

- (UILabel *)balanceLbl {

    if (!_balanceLbl) {
      
        _balanceLbl = [UILabel labelWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [FONT(30) lineHeight])
                                 textAligment:NSTextAlignmentCenter
                              backgroundColor:[UIColor clearColor]
                                         font:FONT(30)
                                    textColor:[UIColor whiteColor]];
    
    }
    
    return _balanceLbl;
}


- (UIImageView *)headerView {
    //
    UIImageView *bgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
    bgV.image = [UIImage imageNamed:@"我的钱包背景"];
    bgV.userInteractionEnabled = YES;
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookAllBill)];
    
    bgV.contentMode = UIViewContentModeScaleAspectFill;
    UILabel *lbl = [UILabel labelWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, [FONT(12) lineHeight])
                      textAligment:NSTextAlignmentCenter
                   backgroundColor:[UIColor clearColor]
                              font:FONT(12)
                         textColor:[UIColor whiteColor]];
    lbl.text = @"可用余额(元)";
    [bgV addSubview:lbl];
    
    //
//    self.balanceLbl = [UILabel labelWithFrame:CGRectMake(0, lbl.yy + 12, SCREEN_WIDTH, [FONT(30) lineHeight])
//                                 textAligment:NSTextAlignmentCenter
//                              backgroundColor:[UIColor clearColor]
//                                         font:FONT(30)
//                                    textColor:[UIColor whiteColor]];
    self.balanceLbl.y = lbl.yy + 12;
    [bgV addSubview:self.balanceLbl];
    
    
    //底部提示
    UILabel *bootomHintlbl = [UILabel labelWithFrame:CGRectMake(0, self.balanceLbl.yy + 6, SCREEN_WIDTH, [FONT(11) lineHeight])
                                        textAligment:NSTextAlignmentCenter
                                     backgroundColor:[UIColor clearColor]
                                                font:FONT(11)
                                           textColor:[UIColor colorWithHexString:@"#99ffff"]];
    bootomHintlbl.text = @"(分润+贡献奖励)";
    [bgV addSubview:bootomHintlbl];
    
    return bgV;

}

#pragma mark- 查看所有的账单
- (void)lookAllBill {

    ZHBillVC *billVC = [[ZHBillVC alloc] init];
    [self.navigationController pushViewController:billVC animated:YES];
    
}


- (void)howWithdrawal {
    
    
    //进行实名认真之后才能提现
    if (![ZHUser user].realName) {
        [TLAlert alertWithTitle:nil Message:@"您还未进行实名认证\n前往进行实名认证" confirmMsg:@"前往" CancleMsg:@"取消" cancle:^(UIAlertAction *action) {
            
        } confirm:^(UIAlertAction *action) {
            
            ZHRealNameAuthVC *authVC = [[ZHRealNameAuthVC alloc] init];
            authVC.authSuccess = ^(){ //实名认证成功
                
            };
            [self.navigationController pushViewController:authVC animated:YES];
            
        }];
        
        return;
    }
    
    
    __block ZHCurrencyModel *model;
    [self.currencyRoom enumerateObjectsUsingBlock:^(ZHCurrencyModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.currency isEqualToString:kFRB]) {
            model = obj;
        }
    }];
    if (model) {
        
        ZHWithdrawalVC *withdrawalVC = [[ZHWithdrawalVC alloc] init];
        withdrawalVC.balance = model.amount;
        withdrawalVC.accountNum = model.accountNumber;
        withdrawalVC.success = ^(){
        
            [self.walletTableView beginRefreshing];
            
        };
        [self.navigationController pushViewController:withdrawalVC animated:YES];
        
    } else {
        
        [TLAlert alertWithMsg:@"账户出现问题"];
        
    }
    
    return;

    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"802116";
    http.parameters[@"userId"] = [ZHUser user].userId;
    http.parameters[@"token"] = [ZHUser user].token;
    [http postWithSuccess:^(id responseObject) {
        
        NSArray *arr = responseObject[@"data"];
        if (arr.count <= 0) {//无银行卡
            
            [TLAlert alertWithTitle:nil Message:@"您还没有银行卡\n前往添加银行卡" confirmMsg:@"取消" CancleMsg:@"前往" cancle:nil confirm:^(UIAlertAction *action) {
                
                
                
            }];
            
        } else { //有银行卡
            
            
            __block ZHCurrencyModel *model;
            [self.currencyRoom enumerateObjectsUsingBlock:^(ZHCurrencyModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.currency isEqualToString:kFRB]) {
                    model = obj;
                }
            }];
            if (model) {
                
                ZHWithdrawalVC *withdrawalVC = [[ZHWithdrawalVC alloc] init];
                withdrawalVC.balance = model.frozenAmount;
                withdrawalVC.accountNum = model.accountNumber;
                [self.navigationController pushViewController:withdrawalVC animated:YES];
                
            } else {
                
                [TLAlert alertWithMsg:@"账户出现问题"];
                
            }
        
        
        }
        //查询银行卡
 
        
    } failure:^(NSError *error) {
        
    }];
    


}
#pragma mark-- delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {//提现 商户端完成
        
        //先检测是否有银行卡，没有调转到添加银行卡,内部检测吧
        //分润提现
        [self howWithdrawal];
        
    } else if(indexPath.section == 2) { //红包 转分润
    
        ZHHBConvertFRVC *vc = [[ZHHBConvertFRVC alloc] init];
        vc.title = @"转分润";
        vc.type = ZHCurrencyConvertHBToFR;
        vc.amount = self.currencyDict[kHBB].amount;
        vc.success = ^(){
            [self.walletTableView beginRefreshing];
        };
        [self.navigationController pushViewController:vc animated:YES];
    
    } else if(indexPath.section == 3) { //转贡献奖励
        
      UITableViewCell *currentCell = [tableView cellForRowAtIndexPath:indexPath];
      CGRect rect = [currentCell convertRect:currentCell.bounds toView:nil];
        
      UIView *chooseTypeView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 130, rect.origin.y + rect.size.height - 10 - tableView.contentOffset.y, 115,80)];
        
        chooseTypeView.layer.cornerRadius = 3;
        chooseTypeView.layer.masksToBounds = YES;
        chooseTypeView.clipsToBounds = YES;
        chooseTypeView.layer.borderColor = [UIColor zh_lineColor].CGColor;
        chooseTypeView.layer.borderWidth = 1;
        chooseTypeView.backgroundColor = [UIColor whiteColor];
        
        //专贡献
        UIButton *gxjlBtn = [self coverBtnWithFrame:CGRectMake(0, 0, chooseTypeView.width, chooseTypeView.height/2.0) tag:1 title:@"转贡献奖励"];
        [chooseTypeView addSubview:gxjlBtn];
        
        //转分润
        UIButton *frBtn = [self coverBtnWithFrame:CGRectMake(0, gxjlBtn.yy, chooseTypeView.width, gxjlBtn.height) tag:2 title:@"转分润"];
        [chooseTypeView addSubview:frBtn];
        
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, gxjlBtn.yy, chooseTypeView.width, 1)];
        line.backgroundColor = [UIColor zh_lineColor];
        [chooseTypeView addSubview:line];
        
        
        UIWindow *keyWin = [UIApplication sharedApplication].keyWindow;
        UIButton *btn = [[UIButton alloc] initWithFrame:keyWin.bounds];
        btn.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.2];
        [keyWin addSubview:btn];
        self.maskBtn = btn;
        [btn addTarget:self action:@selector(cancle:) forControlEvents:UIControlEventTouchUpInside];
        [btn addSubview:chooseTypeView];
        
    }
    

}



- (void)covert:(UIButton *)btn {

    ZHHBConvertFRVC *vc = [[ZHHBConvertFRVC alloc] init];
    vc.success = ^(){
        [self.walletTableView beginRefreshing];
    };
    if (btn.tag == 1) {//转贡献奖励
        
        vc.title = @"转贡献奖励";
        vc.type = ZHCurrencyConvertHBYJToGXJL;
        
    } else { //转分润
    
        vc.title = @"转分润";
        vc.type = ZHCurrencyConvertHBYJToFR;
    
    }
    
    vc.amount = self.currencyDict[kHBYJ].amount;
    
    [self.navigationController pushViewController:vc animated:YES];
    [self.maskBtn removeFromSuperview];
    
}


- (UIButton *)coverBtnWithFrame:(CGRect)frame tag:(NSUInteger)tag title:(NSString *)title {
    
    //专贡献
    UIButton *gxjlBtn = [[UIButton alloc] initWithFrame:frame];
    [gxjlBtn addTarget:self action:@selector(covert:) forControlEvents:UIControlEventTouchUpInside];
    gxjlBtn.tag = tag;
    [gxjlBtn setTitleColor:[UIColor zh_themeColor] forState:UIControlStateNormal];
    [gxjlBtn setTitle:title forState:UIControlStateNormal];
    gxjlBtn.titleLabel.font = [UIFont secondFont];
    return gxjlBtn;
}
- (void)cancle:(UIButton *)btn {

    [btn removeFromSuperview];

}

#pragma mark-- datasource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 10;

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 1) {
        return 3;
    }
    return 1;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *zhWalletCellId = @"zhWalletCellId";
    ZHWalletCell *cell = [tableView dequeueReusableCellWithIdentifier:zhWalletCellId];
    
    if (!cell) {
        
        cell = [[ZHWalletCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:zhWalletCellId];
    }
    
    switch (indexPath.section) {
        case 0: {
            
            cell.typeLbl.text = @"分润";
            cell.moneyLbl.text = [self.currencyDict[kFRB].amount convertToRealMoney];
            cell.currencyModel = self.currencyDict[kFRB];
            cell.accessoryLbl.text = @"提现";
            cell.type = @"1";
        
        }  break;
            
        case 1: {
            
            NSString *typeText;
            NSString *moneyText;
            
            if (indexPath.row == 0) {
                
                typeText = @"贡献奖励";
                moneyText = [self.currencyDict[kGXB].amount convertToRealMoney];
                cell.currencyModel = self.currencyDict[kGXB];

                
            } else if (indexPath.row == 1) {
                
                typeText = @"钱包币";
                cell.currencyModel = self.currencyDict[kQBB];
                moneyText = [self.currencyDict[kQBB].amount convertToRealMoney];
                
            } else {
                
                typeText = @"购物币";
                moneyText = [self.currencyDict[kGWB].amount convertToRealMoney];
                cell.currencyModel = self.currencyDict[kGWB];


                
            }
            cell.typeLbl.text = typeText;
            cell.moneyLbl.text = moneyText;
            cell.type = @"0";
            cell.accessoryLbl.text = @"";
        
        
        } break;
            
        case 2: {
            
            cell.typeLbl.text = @"红包";
            cell.moneyLbl.text = [self.currencyDict[kHBB].amount convertToRealMoney];
            cell.currencyModel = self.currencyDict[kHBB];
            cell.type = @"1";
            cell.accessoryLbl.text = @"转分润";
            
        } break;
            
        case 3: {
            
            cell.typeLbl.text = @"红包业绩";
            cell.moneyLbl.text = [self.currencyDict[kHBYJ].amount convertToRealMoney];
            cell.currencyModel = self.currencyDict[kHBYJ];
            cell.accessoryLbl.text = @"转贡献奖励";
            cell.type = @"2";
            
        } break;
            
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    
    UITableViewHeaderFooterView *hfv = (UITableViewHeaderFooterView *)view;
    hfv.contentView.backgroundColor = [UIColor zh_backgroundColor];
    
}


@end
