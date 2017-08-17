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



@interface CDFenHongQuanVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UILabel *hintLbl;
//
@property (nonatomic, strong) CDFHQTopBottomView *poolMoneyView;
@property (nonatomic, strong) CDFHQTopBottomView *willGetMoneyView;
@property (nonatomic, strong) CDFHQTopBottomView *profitCountView;
@property (nonatomic, strong) TLTableView *profitTableView;

@property (nonatomic, copy) NSArray<ZHEarningModel *> *earningModels;

@end

@implementation CDFenHongQuanVC
{
    dispatch_group_t _group;
    
}





- (void)viewDidLoad {
    [super viewDidLoad];
    
  
    //
    self.title = @"分红权详情";
    _group = dispatch_group_create();
    [self setPlaceholderViewTitle:@"加载失败" operationTitle:@"重新加载"];

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
    tv.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无分红权"];
    //
    
    
    [self getData];
    
}


- (void)getData {

    [TLProgressHUD showWithStatus:nil];
    __block NSInteger successCount = 0;
    
//    dispatch_group_enter(_group);
//    //资金池查询
//    TLNetworking *poolhttp = [TLNetworking new];
//    poolhttp.code = @"802503";
//    poolhttp.parameters[@"userId"] = @"USER_POOL_ZHPAY";
//    poolhttp.parameters[@"accountNumber"] = @"A2017100000000000001";
//    poolhttp.parameters[@"token"] = [ZHUser user].token;
//    
//    [poolhttp postWithSuccess:^(id responseObject) {
//        
//        NSArray *arr = responseObject[@"data"];
//        if (arr.count > 0) {
//            
//          ZHCurrencyModel *currencyModel = [ZHCurrencyModel tl_objectWithDictionary:arr[0]];
//            
//         self.poolMoneyView.topLbl.text = [currencyModel.amount convertToRealMoney];
//         self.poolMoneyView.bottomLbl.text = @"商家补贴额度(元)";
//            
//        }
//        
//        successCount ++;
//        dispatch_group_leave(_group);
//        
//    } failure:^(NSError *error) {
//        
//        dispatch_group_leave(_group);
//        
//    }];
    
    
    //我的分红权查询
    dispatch_group_enter(_group);
    
    TLNetworking *http = [TLNetworking new];
    http.code = @"808417";
    http.parameters[@"userId"] = [ZHUser user].userId;
    http.parameters[@"token"] = [ZHUser user].token;
    [http postWithSuccess:^(id responseObject) {
        
        //创建UI
        NSArray *arr = [ZHEarningModel tl_objectArrayWithDictionaryArray:responseObject[@"data"]];
        self.earningModels = arr;
        
        [self.profitTableView reloadData_tl];
        //分红权个数
        self.profitCountView.topLbl.text = [NSString stringWithFormat:@"%ld",arr.count];
        self.profitCountView.bottomLbl.text = @"分红权(个)";
        
        //计算待领取的收益
        __block long long totalWillGetSysMoney = 0;
        __block long long haveGetSysMoney = 0;
        
        [self.earningModels enumerateObjectsUsingBlock:^(ZHEarningModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            totalWillGetSysMoney += ([obj.profitAmount longLongValue] - [obj.backAmount longLongValue]);
            haveGetSysMoney += [obj.backAmount longLongValue];
            
            //
        }];
        self.willGetMoneyView.topLbl.text = [@(totalWillGetSysMoney) convertToRealMoney];
        self.willGetMoneyView.bottomLbl.text = @"待领取的收益(元)";
        
        self.poolMoneyView.topLbl.text = [@(haveGetSysMoney) convertToRealMoney];
        self.poolMoneyView.bottomLbl.text = @"已领取收益(元)";
        
        //
        dispatch_group_leave(_group);
        successCount ++;
    } failure:^(NSError *error) {
        
        dispatch_group_leave(_group);
        
    }];
    
    
//    //今日分红权个数及收益统计
//    dispatch_group_enter(_group);
//    TLNetworking *todayProfitHttp = [TLNetworking new];
//    todayProfitHttp.code = @"808419";
//    todayProfitHttp.parameters[@"userId"] = [ZHUser user].userId;
//    todayProfitHttp.parameters[@"token"] = [ZHUser user].token;
//    [todayProfitHttp postWithSuccess:^(id responseObject) {
//        
//        //        responseObject[@"data"][@"stockCount"]
//       [responseObject[@"data"][@"todayProfitAmount"] convertToRealMoney];
//        
//        //    stockCount: 今日分红权个数,
//        //    todayProfitAmount: 今日分红权收益
//        successCount ++;
//        dispatch_group_leave(_group);
//        
//    } failure:^(NSError *error) {
//        
//        dispatch_group_leave(_group);
//        
//    }];
    
    
    //我的下一个分红权查询
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
        
        if (successCount == 2) {
            //所有请求成功
            [self removePlaceholderView];
            
        } else {
            //所有请求失败
            [self addPlaceholderView];
            
        }
        
    });

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    ZHSingleProfitFlowVC *vc = [[ZHSingleProfitFlowVC alloc] init];
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
