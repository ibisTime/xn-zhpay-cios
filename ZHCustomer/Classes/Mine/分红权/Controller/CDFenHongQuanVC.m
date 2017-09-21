//
//  CDFenHongQuanVC.m
//  ZHBusiness
//
//  Created by  tianlei on 2017/5/31.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CDFenHongQuanVC.h"
#import "CDFHQTopBottomView.h"
#import "ZHEarningModel.h"
#import "ZHCurrencyModel.h"
#import "CDProfitCell.h"
#import "ZHSingleProfitFlowVC.h"
//#import "UIHeader.h"
//#import "UserHeader.h"
#import "TLHeader.h"
#import "ZHUser.h"
#import "UIColor+theme.h"
#import "ZHRealNameAuthVC.h"
#import "ZHWithdrawalVC.h"


@interface CDFenHongQuanVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UILabel *hintLbl;
//
@property (nonatomic, strong) CDFHQTopBottomView *poolMoneyView;
@property (nonatomic, strong) CDFHQTopBottomView *willGetMoneyView;
@property (nonatomic, strong) CDFHQTopBottomView *profitCountView;
@property (nonatomic, strong) TLTableView *profitTableView;

@property (nonatomic, copy) NSArray<ZHEarningModel *> *earningModels;
//@property (nonatomic, strong) ZHCurrencyModel *fenRunModel;

@property (nonatomic, strong) UIButton *funRunBtn;
@property (nonatomic, strong) ZHCurrencyModel *fenRunCurrencyModel;

@end

@implementation CDFenHongQuanVC
{
    dispatch_group_t _group;
    
}


- (void)tl_placeholderOperation {
    
    [self getData];
    
}

- (void)getFenRun {
    
    //下部，钱包
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"802503";
    http.parameters[@"token"] = [ZHUser user].token;
    http.parameters[@"userId"] = [ZHUser user].userId;
    [http postWithSuccess:^(id responseObject) {
        
        //数据操作11
        NSArray <ZHCurrencyModel *>*currencyRoom = [ZHCurrencyModel tl_objectArrayWithDictionaryArray:responseObject[@"data"]];
        //把币种分开
        [currencyRoom enumerateObjectsUsingBlock:^(ZHCurrencyModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.currency isEqualToString:kFRB]) {
                
                self.fenRunCurrencyModel = obj;
                [self.funRunBtn setTitle:[NSString stringWithFormat:@"分润：%@",[obj.amount convertToRealMoney]] forState:UIControlStateNormal];
            }
        }];
        
    } failure:^(NSError *error) {
        
        //        [TLAlert alertWithHUDText:@"获取用户账户信息失败"];
        //        [weakSelf.mineTableView endRefreshHeader];
        
        
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //
    self.title = @"分红权详情";
    _group = dispatch_group_create();
    [self setPlaceholderViewTitle:@"加载失败" operationTitle:@"重新加载"];
    //先获取分润

    //
    UIView *topV = [[UIView alloc] initWithFrame:CGRectMake(0, 1, SCREEN_WIDTH, 110)];
    topV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topV];
    
    //分润 提现
    UIView *topBtnBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, topV.width, 40)];
    [topV addSubview:topBtnBGView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, topBtnBGView.yy, SCREEN_WIDTH, 1)];
    [topV addSubview:line];
    line.backgroundColor = [UIColor backgroundColor];
    
    //
    UIButton *fenRunBtn = [self topBtn];
    [topBtnBGView addSubview:fenRunBtn];
    [fenRunBtn setTitle:@"分润：--" forState:UIControlStateNormal];
    self.funRunBtn = fenRunBtn;
    
    //
    UIButton *withdrawBtn = [self topBtn];
    [topBtnBGView addSubview:withdrawBtn];
    [withdrawBtn setTitle:@"提现" forState:UIControlStateNormal];
    [withdrawBtn addTarget:self action:@selector(withdrawAction) forControlEvents:UIControlEventTouchUpInside];
    
    [fenRunBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topBtnBGView.mas_left).offset(15);
        make.top.bottom.equalTo(topBtnBGView);
    }];
    
    [withdrawBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(fenRunBtn);
        make.left.equalTo(fenRunBtn.mas_right).offset(15);
    }];
    
    //
    CGFloat w = SCREEN_WIDTH/3;
    CGFloat h = topV.height - topBtnBGView.height;
    self.poolMoneyView = [[CDFHQTopBottomView alloc] initWithFrame:CGRectMake(0, topBtnBGView.yy + 1, w, h)];
    [topV addSubview:self.poolMoneyView];
  
    self.willGetMoneyView = [[CDFHQTopBottomView alloc] initWithFrame:CGRectMake(w, self.poolMoneyView.y, w, h)];
    [topV addSubview:self.willGetMoneyView];
    
    self.profitCountView = [[CDFHQTopBottomView alloc] initWithFrame:CGRectMake(2*w, self.poolMoneyView.y, w, h)];
    [topV addSubview:self.profitCountView];
    
    //中部--友情提示
    UIView *hintV = [[UIView alloc] initWithFrame:CGRectMake(0, topV.yy + 10, SCREEN_WIDTH, 20)];
    [self.view addSubview:hintV];
    hintV.backgroundColor = [UIColor colorWithHexString:@"#f05567"];
    UIImageView *hintImageV = [[UIImageView alloc] init];
    [hintV addSubview:hintImageV];
    hintImageV.image = [UIImage imageNamed:@"分红权_提示"];
    
    [hintImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(hintV.mas_left).offset(15);
        make.centerY.equalTo(hintV.mas_centerY);
    }];
    
    UILabel *hintLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor clearColor]
                                          font:FONT(12)
                                     textColor:[UIColor whiteColor]];
    [hintV addSubview:hintLbl];
    self.hintLbl = hintLbl;
    [hintLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(hintImageV.mas_right).offset(5);
        make.centerY.equalTo(hintImageV.mas_centerY);
        make.right.lessThanOrEqualTo(hintV.mas_right).offset(-15);
    }];
    
    
    //底部
    TLTableView *tv = [TLTableView tableViewWithframe:CGRectMake(0, hintV.yy, SCREEN_WIDTH, SCREEN_HEIGHT - hintV.yy - 64) delegate:self dataSource:self];
    tv.rowHeight = 70;
    [self.view addSubview:tv];
    self.profitTableView = tv;
    tv.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无分红权"];
    //
    
    
    [self getData];
    [self getFenRun];
}

#pragma mark- 提现
- (void)withdrawAction {
    
    __weak typeof(self) weakself = self;
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
    withdrawalVC.accountNum = weakself.fenRunCurrencyModel.accountNumber;
    withdrawalVC.success = ^(){
        
    };
    [weakself.navigationController pushViewController:withdrawalVC animated:YES];
    
    
}

- (UIButton *)topBtn {
    
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitleColor:[UIColor shopThemeColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor whiteColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    return btn;
}

- (void)getData {

    [TLProgressHUD showWithStatus:nil];
    __block NSInteger successCount = 0;
    __block NSInteger reqCount = 0;

    
    //我的分红权查询
    reqCount ++;
    dispatch_group_enter(_group);
    TLNetworking *http = [TLNetworking new];
    http.code = @"808417";
    http.parameters[@"userId"] = [ZHUser user].userId;
    http.parameters[@"token"] = [ZHUser user].token;
    [http postWithSuccess:^(id responseObject) {
        
        dispatch_group_leave(_group);
        successCount ++;
        //创建UI
        NSArray *arr = [ZHEarningModel tl_objectArrayWithDictionaryArray:responseObject[@"data"]];
        self.earningModels = arr;
        [self.profitTableView reloadData_tl];
        
        //

    } failure:^(NSError *error) {
        
        dispatch_group_leave(_group);
        
    }];
    //
    
    





    //
    reqCount ++;
    dispatch_group_enter(_group);
    TLNetworking *myFHQHttp = [TLNetworking new];
    myFHQHttp.code = @"808419";
    myFHQHttp.parameters[@"userId"] = [ZHUser user].userId;
    [myFHQHttp postWithSuccess:^(id responseObject) {
        
        successCount ++;
        dispatch_group_leave(_group);
        
        NSNumber *stockCount = responseObject[@"data"][@"stockCount"];//个数
        NSNumber *backProfitAmount =  responseObject[@"data"][@"backProfitAmount"];//已领取
        NSNumber *unbackProfitAmount =  responseObject[@"data"][@"unbackProfitAmount"];//未领取
        self.willGetMoneyView.topLbl.text = [unbackProfitAmount convertToRealMoney];
        self.willGetMoneyView.bottomLbl.text = @"待领取的收益(元)";
        
        
            self.poolMoneyView.topLbl.text = [backProfitAmount convertToRealMoney];
            self.poolMoneyView.bottomLbl.text = @"已领取收益(元)";
            
     
   

        self.profitCountView.topLbl.text = [NSString stringWithFormat:@"%@",stockCount];
        self.profitCountView.bottomLbl.text = @"分红权(个)";
//        backProfitAmount = 49000;
//        stockCount = 1;
//        todayProfitAmount = 4000;
//        todayStockCount = 1;
//        unbackProfitAmount = 446000;
        
    } failure:^(NSError *error) {
        
        dispatch_group_leave(_group);

        
    }];

    //我的下一个分红权查询
    reqCount ++;
    dispatch_group_enter(_group);
    TLNetworking *nextHttp = [TLNetworking new];
    nextHttp.code = @"808418";
    nextHttp.parameters[@"userId"] = [ZHUser user].userId;
    [nextHttp postWithSuccess:^(id responseObject) {
        
        NSDictionary *dict = responseObject[@"data"];
        if (dict.allKeys <= 0) {
            return ;
        }
        
        NSNumber *costAmount =  responseObject[@"data"][@"costAmount"];
        CGFloat needMoney =  500 - [costAmount longLongValue]/1000.0;
        self.hintLbl.text = [NSString stringWithFormat:@"友情提示：消费还差%.2f元，就可再获得一个分红权",needMoney];

        //
        successCount ++;
        dispatch_group_leave(_group);
        
    } failure:^(NSError *error) {
        
        dispatch_group_leave(_group);
        
    }];
    
    dispatch_group_notify(_group, dispatch_get_main_queue(), ^{
        
        [TLProgressHUD dismiss];
        
        if (successCount == reqCount) {
            //所有请求成功
            [self removePlaceholderView];
            
            //
            
            TLNetworking *visiableHttp = [TLNetworking new];
            visiableHttp.code = @"808917";
            visiableHttp.parameters[@"key"] = @"POOL_VISUAL";
            visiableHttp.parameters[@"token"] = [ZHUser user].token;
            [visiableHttp postWithSuccess:^(id responseObject) {
                
                id cValue = responseObject[@"data"][@"cvalue"];
                if ([cValue isEqualToString:@"0"]) {
                    
                    return ;
                }

                //资金池查询
                TLNetworking *poolhttp = [TLNetworking new];
                poolhttp.code = @"802503";
                poolhttp.parameters[@"userId"] = @"USER_POOL_ZHPAY";
                poolhttp.parameters[@"accountNumber"] = @"A2017100000000000001";
                poolhttp.parameters[@"token"] = [ZHUser user].token;
                
                [poolhttp postWithSuccess:^(id responseObject) {
                    
                    NSArray *arr = responseObject[@"data"];
                    if (arr.count > 0) {
                        
                        ZHCurrencyModel *currencyModel = [ZHCurrencyModel tl_objectWithDictionary:arr[0]];
                        
                        self.poolMoneyView.topLbl.text = [currencyModel.amount convertToRealMoney];
                        self.poolMoneyView.bottomLbl.text = @"消费者池中金额(元)";
                    }
                    
                } failure:^(NSError *error) {
                    
                    
                }];
                
            } failure:^(NSError *error) {
                
            }];

    
            
        } else {
            //所有请求失败
            [self addPlaceholderView];
            
        }
        
    });

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    ZHSingleProfitFlowVC *vc = [[ZHSingleProfitFlowVC alloc] init];
    vc.type = ZHSingleProfitFlowVCTypeFenHongQuan;
    vc.earnModel = self.earningModels[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.earningModels.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    CDProfitCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CDProfitCell"];
    if (!cell) {
        
        cell = [[CDProfitCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CDProfitCell"];
        
    }
    cell.isSimpleUI = NO;
    cell.earningModel = self.earningModels[indexPath.row];
    return cell;
    
}

@end
