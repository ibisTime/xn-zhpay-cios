//
//  CDFenHongQuanVC.m
//  ZHBusiness
//
//  Created by  tianlei on 2017/5/31.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHBuTieDetailVC.h"

#import "CDFHQTopBottomView.h"
#import "ZHEarningModel.h"
#import "ZHCurrencyModel.h"
#import "CDProfitCell.h"
#import "ZHSingleProfitFlowVC.h"
//#import "UIHeader.h"
//#import "UserHeader.h"
#import "TLHeader.h"
#import "ZHUser.h"



@interface ZHBuTieDetailVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UILabel *hintLbl;
//
@property (nonatomic, strong) CDFHQTopBottomView *poolMoneyView;
@property (nonatomic, strong) CDFHQTopBottomView *willGetMoneyView;
@property (nonatomic, strong) CDFHQTopBottomView *profitCountView;
@property (nonatomic, strong) TLTableView *profitTableView;

@property (nonatomic, copy) NSArray<ZHEarningModel *> *earningModels;
@property (nonatomic, assign) BOOL isFirst;


@end

@implementation ZHBuTieDetailVC
{
    dispatch_group_t _group;
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (self.isFirst) {
        
        [self.profitTableView beginRefreshing];
        self.isFirst = NO;
    }
    
    
}

- (void)tl_placeholderOperation {
    
    [self getData];
    
}

- (void)setUpUI {
    
    
    //
    UIView *topV = [[UIView alloc] initWithFrame:CGRectMake(0, 1, SCREEN_WIDTH, 70)];
    topV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topV];
    
    //
    CGFloat w = SCREEN_WIDTH/3;
    CGFloat h = topV.height;
    self.poolMoneyView = [[CDFHQTopBottomView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    [topV addSubview:self.poolMoneyView];
    
    self.willGetMoneyView = [[CDFHQTopBottomView alloc] initWithFrame:CGRectMake(w, 0, w, h)];
    [topV addSubview:self.willGetMoneyView];
    
    self.profitCountView = [[CDFHQTopBottomView alloc] initWithFrame:CGRectMake(2*w, 0, w, h)];
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
    tv.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无补贴"];
    
    //补贴分页查
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    helper.code = @"808455";
    helper.parameters[@"userId"] = [ZHUser user].userId;
    helper.tableView = self.profitTableView;
    [helper modelClass:[ZHEarningModel class]];
    
    //
    __weak typeof(self) weakSelf = self;
    [self.profitTableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            
            weakSelf.earningModels = objs;
            [weakSelf.profitTableView reloadData_tl];
            
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    [self.profitTableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.earningModels = objs;
            [weakSelf.profitTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isFirst = YES;
    
    //
    self.title = @"补贴详情";
    _group = dispatch_group_create();
    [self setPlaceholderViewTitle:@"加载失败" operationTitle:@"重新加载"];
    [self setUpUI];
    
    //
    [self getData];
    
}


- (void)getData {
    
    [TLProgressHUD showWithStatus:nil];
    __block NSInteger successCount = 0;
    __block NSInteger reqCount = 0;

    //
    reqCount ++;
    dispatch_group_enter(_group);
    TLNetworking *myFHQHttp = [TLNetworking new];
    myFHQHttp.code = @"808459";
    myFHQHttp.parameters[@"userId"] = [ZHUser user].userId;
    [myFHQHttp postWithSuccess:^(id responseObject) {
        
        successCount ++;
        dispatch_group_leave(_group);
        
        NSNumber *stockCount = responseObject[@"data"][@"stockCount"];//个数
        NSNumber *backProfitAmount =  responseObject[@"data"][@"backProfitAmount"];//已领取
        NSNumber *unbackProfitAmount =  responseObject[@"data"][@"unbackProfitAmount"];//未领取
        
        NSNumber *poolAmount =  responseObject[@"data"][@"poolAmount"];//未领取

        self.willGetMoneyView.topLbl.text = [unbackProfitAmount convertToRealMoney];
        self.willGetMoneyView.bottomLbl.text = @"待领取的补贴(元)";

        self.profitCountView.topLbl.text = [NSString stringWithFormat:@"%@",stockCount];
        self.profitCountView.bottomLbl.text = @"补贴名额(个)";
        
        //池金额
        self.poolMoneyView.topLbl.text = [poolAmount convertToRealMoney];
        self.poolMoneyView.bottomLbl.text = @"消费者补贴总额(元)";
        
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
    nextHttp.code = @"808458";
    nextHttp.parameters[@"userId"] = [ZHUser user].userId;
    [nextHttp postWithSuccess:^(id responseObject) {
        
        NSDictionary *dict = responseObject[@"data"];
        if (dict.allKeys <= 0) {
            return ;
        }
        
        NSNumber *costAmount =  responseObject[@"data"][@"costAmount"];
        CGFloat needMoney =  500 - [costAmount longLongValue]/1000.0;
        self.hintLbl.text = [NSString stringWithFormat:@"友情提示：消费还差%.2f元，就可再获得一个补贴名额",needMoney];
        
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
            //资金池查询
            TLNetworking *poolhttp = [TLNetworking new];
            poolhttp.code = @"802503";
            poolhttp.parameters[@"userId"] = @"BT_USER_POOL_ZHPAY";
            poolhttp.parameters[@"accountNumber"] = @"A2017100000000000004";
            poolhttp.parameters[@"token"] = [ZHUser user].token;
            
            [poolhttp postWithSuccess:^(id responseObject) {
                
                NSArray *arr = responseObject[@"data"];
                if (arr.count > 0) {
                    
                    ZHCurrencyModel *currencyModel = [ZHCurrencyModel tl_objectWithDictionary:arr[0]];
                    
                    self.poolMoneyView.topLbl.text = [currencyModel.amount convertToRealMoney];
                    self.poolMoneyView.bottomLbl.text = @"消费者补贴总额(元)";
                }
                
            } failure:^(NSError *error) {
                
                
            }];
//            TLNetworking *visiableHttp = [TLNetworking new];
//            visiableHttp.code = @"808917";
//            visiableHttp.parameters[@"key"] = @"POOL_VISUAL";
//            visiableHttp.parameters[@"token"] = [ZHUser user].token;
//            [visiableHttp postWithSuccess:^(id responseObject) {
//
//                id cValue = responseObject[@"data"][@"cvalue"];
//                if ([cValue isEqualToString:@"0"]) {
//
//                    return ;
//                }
//
//                //资金池查询
//                TLNetworking *poolhttp = [TLNetworking new];
//                poolhttp.code = @"802503";
//                poolhttp.parameters[@"userId"] = @"USER_POOL_ZHPAY";
//                poolhttp.parameters[@"accountNumber"] = @"A2017100000000000001";
//                poolhttp.parameters[@"token"] = [ZHUser user].token;
//
//                [poolhttp postWithSuccess:^(id responseObject) {
//
//                    NSArray *arr = responseObject[@"data"];
//                    if (arr.count > 0) {
//
//                        ZHCurrencyModel *currencyModel = [ZHCurrencyModel tl_objectWithDictionary:arr[0]];
//
//                        self.poolMoneyView.topLbl.text = [currencyModel.amount convertToRealMoney];
//                        self.poolMoneyView.bottomLbl.text = @"消费者补贴总额(元)";
//                    }
//
//                } failure:^(NSError *error) {
//
//
//                }];
//
//            } failure:^(NSError *error) {
//
//            }];
            
            
            
        } else {
            //所有请求失败
            [self addPlaceholderView];
            
        }
        
    });
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZHSingleProfitFlowVC *vc = [[ZHSingleProfitFlowVC alloc] init];
    vc.type = ZHSingleProfitFlowVCTypeBuTie;
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

