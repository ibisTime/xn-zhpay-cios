//
//  ZHBriberyMoneyVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/20.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHBriberyMoneyVC.h"
#import "ZHBuyHZBVC.h"
#import "ZHSendBriberyMoneyCell.h"

@interface ZHBriberyMoneyVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UIImageView *bgImageV;
@property (nonatomic, strong) TLTableView *briberyMoneyTableV;
@property (nonatomic,strong) NSMutableArray *briberyMoneyRooms;

@end

@implementation ZHBriberyMoneyVC

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发一发";

    //判断是否购买了汇赚宝
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"808456";
    http.parameters[@"userId"] = [ZHUser user].userId;
    http.parameters[@"token"] = [ZHUser user].token;
    [http postWithSuccess:^(id responseObject) {
        
        
        
        NSDictionary *data = responseObject[@"data"];
        if (data.allKeys.count > 0) { //已经购买了汇转吧
//            [self.bgImageV removeFromSuperview];

            [self hasHZBUI];
     
        } else { //还没有股份
            
            [self.view addSubview:self.bgImageV];

        }
        
    } failure:^(NSError *error) {
        
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buyHZBSuccess) name:@"HZBBuySuccess" object:nil];
    
}


//购买会赚宝成功
- (void)buyHZBSuccess {

    [self.bgImageV removeFromSuperview];
    
    [self hasHZBUI];
    
    [self.briberyMoneyTableV beginRefreshing];
    
}


- (void)hasHZBUI {

    TLTableView *tableView = [TLTableView tableViewWithframe:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49) delegate:self dataSource:self];
    [self.view addSubview:tableView];
    tableView.rowHeight = 113;
    self.briberyMoneyTableV = tableView;
    tableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无商品"];
    
    //// 0 已提交 1.审批通过 2.审批不通过 3.已上架 4.已下架
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    helper.code = @"808020";
    helper.parameters[@"status"] = @"3";
    helper.tableView = self.briberyMoneyTableV;
//    [helper modelClass:[ZHGoodsModel class]];
    
    //
    __weak typeof(self) weakSelf = self;
    [self.briberyMoneyTableV addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.briberyMoneyRooms = objs;
            [weakSelf.briberyMoneyTableV reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    [self.briberyMoneyTableV addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.briberyMoneyRooms = objs;
            [weakSelf.briberyMoneyTableV reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];

}


- (void)goBuyHZB {

    ZHBuyHZBVC *vc = [[ZHBuyHZBVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark- TableView --- delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 5;
    
}

//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *zhGoodsCellId = @"ZHBriberyCell";
    ZHSendBriberyMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:zhGoodsCellId];
    if (!cell) {
        
        cell = [[ZHSendBriberyMoneyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:zhGoodsCellId];
        
    }
    return cell;
    
    
}


- (UIImageView *)bgImageV {

    if (!_bgImageV) {
        
        _bgImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49)];
        _bgImageV.contentMode = UIViewContentModeScaleAspectFill;
        _bgImageV.image = [UIImage imageNamed:@"发一发背景"];
        _bgImageV.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBuyHZB)];
        [_bgImageV addGestureRecognizer:tap];
        
        
    }
    
    return _bgImageV;

}

@end
