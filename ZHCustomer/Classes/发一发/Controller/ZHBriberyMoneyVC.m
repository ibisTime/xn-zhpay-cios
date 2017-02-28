//
//  ZHBriberyMoneyVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/20.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHBriberyMoneyVC.h"
#import "ZHHZBVC.h"
#import "ZHSendBriberyMoneyCell.h"
#import "ZHBriberyMoney.h"
#import "TLWXManager.h"
#import "ZHShareView.h"
#import "AppConfig.h"
#import "TLHTMLStrVC.h"

@interface ZHBriberyMoneyVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UIImageView *bgImageV;
@property (nonatomic, strong) TLTableView *briberyMoneyTableV;
@property (nonatomic,strong) NSMutableArray <ZHBriberyMoney *>*briberyMoneyRooms;
@property (nonatomic, assign) BOOL isFirst;

@property (nonatomic, assign) BOOL historyTap;

@end

@implementation ZHBriberyMoneyVC

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
//    if ([self.displayType isEqualToString:@"goFromHZB"] && self.isFirst) {
//        [self.briberyMoneyTableV beginRefreshing];
//    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发一发";
    self.isFirst = YES;
    self.historyTap = NO;
    
    if ((self.displayType == ZHBriberyMoneyVCTypeSecondUI) || (self.displayType == ZHBriberyMoneyVCTypeFirstUI)) {
        
        if (self.displayType == ZHBriberyMoneyVCTypeSecondUI) {
        
          self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"历史记录" style:UIBarButtonItemStylePlain target:self action:@selector(history)];
    
        } else {
            
          self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"玩法介绍" style:UIBarButtonItemStylePlain target:self action:@selector(introduce)];
        
        }

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
                [self.briberyMoneyTableV beginRefreshing];
                
            } else { //还没有股份
                
                [self.view addSubview:self.bgImageV];
                [self.bgImageV mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(self.view);
                }];
                
            }
            
        } failure:^(NSError *error) {
            
            
        }];
    
    } else if(self.displayType == ZHBriberyMoneyVCTypeHistory){
    
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"历史记录" style:UIBarButtonItemStylePlain target:self action:@selector(history)];
        
        //肯定有汇赚包
        self.title = @"历史记录";
        [self hasHZBUI];
        
        [self.briberyMoneyTableV beginRefreshing];
        
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buyHZBSuccess) name:@"HZBBuySuccess" object:nil];
    
    //用户登录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginSuccess) name:kUserLoginNotification object:nil];
    
    //用户退出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginOut) name:kUserLoginOutNotification object:nil];
    
}

- (void)userLoginOut {
    
    self.briberyMoneyRooms = nil;
    [self.briberyMoneyTableV beginRefreshing];
    
}

- (void)userLoginSuccess {
    
    [self.bgImageV removeFromSuperview];
    
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
            [self.briberyMoneyTableV beginRefreshing];
            
        } else { //还没有股份
            
            [self.view addSubview:self.bgImageV];
            [self.bgImageV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view);
            }];
            
        }
        
    } failure:^(NSError *error) {
        
        
    }];
    

    
    
}

#pragma mark- 汇赚宝 进入, 查看历史记录选项
- (void)history {

    if (self.historyTap) {
        return;
    }
    self.historyTap = YES;
    ZHBriberyMoneyVC *historyVC = [[ZHBriberyMoneyVC alloc] init];
    historyVC.displayType = ZHBriberyMoneyVCTypeHistory;
    [self.navigationController pushViewController:historyVC animated:YES];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(delay) userInfo:nil repeats:YES];
}

- (void)delay {


     self.historyTap = NO;
}

#pragma mark- 评论
- (void)introduce {

    TLHTMLStrVC *vc = [[TLHTMLStrVC alloc] init];
    vc.type = ZHHTMLTypeSendBrebireMoneyIntroduce;
    vc.title = @"玩法介绍";
    [self.navigationController pushViewController:vc animated:YES];

}


//购买会赚宝成功
- (void)buyHZBSuccess {

    [self.bgImageV removeFromSuperview];
    
    [self hasHZBUI];
    
    [self.briberyMoneyTableV beginRefreshing];
    
}


- (TLTableView *)briberyMoneyTableV {

    if (!_briberyMoneyTableV) {
      
        _briberyMoneyTableV = [TLTableView tableViewWithframe:[UIScreen mainScreen].bounds delegate:self dataSource:self];
        _briberyMoneyTableV.rowHeight = 113;
        _briberyMoneyTableV.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无红包"];
        
    }
    
    return _briberyMoneyTableV;

}

- (void)hasHZBUI {

    [self.view addSubview:self.briberyMoneyTableV];
    [self.briberyMoneyTableV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);

    }];
    

    //// 0=待转发 1=待领取 2=已领取   3=已失效
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    helper.code = @"808475";
    helper.parameters[@"owner"] = [ZHUser user].userId;
    
    if (self.displayType == ZHBriberyMoneyVCTypeHistory) {
        
        //历史记录
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
       
        NSDateComponents *comps = nil;
        comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
        NSDateComponents *adcomps = [[NSDateComponents alloc] init];
        [adcomps setDay:-1];
        NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:[NSDate date] options:0];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        NSString *dateStr = [dateFormatter stringFromDate:newdate];
        
        helper.parameters[@"createDatetimeEnd"] = dateStr;
        
        
    } else {
    
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        NSString *dateStr = [dateFormatter stringFromDate:[NSDate new]];
        helper.parameters[@"createDatetimeStart"] = dateStr;
        helper.parameters[@"createDatetimeEnd"] = dateStr;

    }
    
    
    helper.tableView = self.briberyMoneyTableV;
    [helper modelClass:[ZHBriberyMoney class]];
    
    //
    __weak typeof(self) weakSelf = self;
    [self.briberyMoneyTableV addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.briberyMoneyRooms = objs;
            [weakSelf.briberyMoneyTableV reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
        
    }];
    
    
    //
    [self.briberyMoneyTableV addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.briberyMoneyRooms = objs;
            [weakSelf.briberyMoneyTableV reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    

}


- (void)goBuyHZB {

    ZHHZBVC *vc = [[ZHHZBVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark- TableView --- delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.displayType == ZHBriberyMoneyVCTypeHistory) {
        return;
    }
    
    ZHBriberyMoney *breiberyMoney = self.briberyMoneyRooms[indexPath.row];
    //已领取不能分享
    if (breiberyMoney.status == ZHBriberyMoneyStatusReceiverd) {
        [TLAlert alertWithHUDText:@"该红包已被领取,不能进行分享"];
        return;
    }
    
    
//    [TLWXManager manager].wxShare = ^(BOOL isSuccess,int errorCode){
//    
//        if (isSuccess) {
//            
//            //用户发送成功之后---选择留在微信。无法获取，回调事件
//            TLNetworking *http = [TLNetworking new];
//            http.code = @"808470";
//            http.parameters[@"code"] = self.briberyMoneyRooms[indexPath.row].code;
//            [http postWithSuccess:^(id responseObject) {
//              
//                [self.briberyMoneyTableV beginRefreshing];
//                
//            } failure:^(NSError *error) {
//                
//                
//            }];
//
//        }
//        
//    };
    
    //
    ZHShareView *shareView = [[ZHShareView alloc] init];
    shareView.wxShare = ^(BOOL isSuccess,int errorCode){
        
        if (isSuccess) {
            
            //用户发送成功之后---选择留在微信。无法获取，回调事件
            TLNetworking *http = [TLNetworking new];
            http.code = @"808470";
            http.parameters[@"code"] = self.briberyMoneyRooms[indexPath.row].code;
            http.parameters[@"userId"] = [ZHUser user].userId;
            [http postWithSuccess:^(id responseObject) {
                
                [self.briberyMoneyTableV beginRefreshing];
                
            } failure:^(NSError *error) {
                
                
            }];
            
        }
        
    };

    shareView.title = @"正汇钱包邀您领红包";
    shareView.content = @"千万红包免费领，快来快来快快来";
    shareView.shareUrl = [NSString stringWithFormat:@"%@/share/share-receive.html?code=%@&userReferee=%@",[AppConfig config].shareBaseUrl,breiberyMoney.code,[ZHUser user].mobile];
//    shareView.qrContentStr = [ZHUser user].mobile;
    
    [shareView show];
    
    return;
//    [TLWXManager wxShareWebPageWithScene:WXSceneSession title:@"我在喊你领红包! 速度速度!" desc:@"正汇钱包,领取红包" url:@"http://www.weibo.com"];
//    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.briberyMoneyRooms.count;
    
}

//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *zhGoodsCellId = @"ZHBriberyCell";
    ZHSendBriberyMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:zhGoodsCellId];
    if (!cell) {
        
        cell = [[ZHSendBriberyMoneyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:zhGoodsCellId];
        
    }
    
    cell.briberMoney = self.briberyMoneyRooms[indexPath.row];
    
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
