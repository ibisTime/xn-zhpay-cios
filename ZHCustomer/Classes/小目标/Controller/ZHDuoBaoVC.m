//
//  ZHDuoBaoVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/20.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHDuoBaoVC.h"
#import "ZHDuoBaoCell.h"
#import "ZHAwardAnnounceView.h"
#import "ZHDuoBaoDetailVC.h"
#import "ZHDBModel.h"
#import "ZHDBHistoryModel.h"
#import "AFHTTPSessionManager.h"

@interface ZHDuoBaoVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray <ZHDBModel *>*dbRooms;

@property (nonatomic, strong) TLTableView *dbTableView;
@property (nonatomic,assign) BOOL isFirst;

/** 历史模型 */
@property (nonatomic, strong) NSMutableArray <ZHDBHistoryModel *>*dbHistoryRooms;
@property (nonatomic, strong) NSMutableArray<ZHAwardAnnounceView *> *awardViewRooms;

@property (nonatomic,strong) UIView *tableHeaderView;
@end


@implementation ZHDuoBaoVC

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    if (self.isFirst) {
        [self.dbTableView beginRefreshing];
        self.isFirst = NO;
    }

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"小目标";
    self.isFirst = YES;
    
    TLTableView *tableView = [TLTableView tableViewWithframe:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49) delegate:self dataSource:self];
    [self.view addSubview:tableView];
    self.dbTableView = tableView;
    tableView.rowHeight = 145;
    tableView.backgroundColor = [UIColor zh_backgroundColor];
    tableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无商品"];
    
    //头部
    tableView.tableHeaderView = self.tableHeaderView;
    
    //
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    helper.code = @"808310";
    helper.limit = 3;
    helper.parameters[@"status"] = @"0";
    helper.tableView = tableView;
    [helper modelClass:[ZHDBModel class]];
    
    //
    __weak typeof(self) weakSelf = self;
    [tableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            self.dbRooms = objs;
            [weakSelf.dbTableView reloadData_tl];
            
            
        } failure:^(NSError *error) {
            
            
        }];
        
        //获得 记录
        [self getDBRecord];
        
    }];
    
//    //定时获取--购买记录
//    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(getDBRecord) userInfo:nil repeats:YES];
//    
//    TLNetworking *http = [TLNetworking new];
//    http.showView = self.view;
//    http.code = @"805191";
////    http.url = @"http://121.40.165.180:8903/std-certi/api";
//    http.parameters[@"userId"] = [ZHUser user].userId;
//    http.parameters[@"idKind"] = @"1";
//    http.parameters[@"idNo"] = @"412321199305120634";
//    http.parameters[@"realName"] = @"田磊";
//    [http postWithSuccess:^(id responseObject) {
//        
////        :8903/std-certi/zhima?bizNo=ZM42342545
//    NSString *urlStr = [NSString stringWithFormat:@"http://121.40.165.180:8903/std-certi/zhima?bizNo=%@",responseObject[@"data"][@"bizNo"]];
//        
//    NSString *alipayUrl = [NSString stringWithFormat:@"alipays://platformapi/startapp?appId=2016121204189723&url=%@",urlStr];
//        
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:alipayUrl] options:@{} completionHandler:nil];
//                [weakSelf.dbTableView endRefreshHeader];
//        
//    } failure:^(NSError *error) {
//        
//        
//    }];
    

}

- (void)getDBRecord {

    TLNetworking *http = [TLNetworking new];
    http.code = @"808315";
    http.parameters[@"start"] = @"1";
    http.parameters[@"limit"] = @"3";
    [http postWithSuccess:^(id responseObject) {
        
       self.dbHistoryRooms = [ZHDBHistoryModel tl_objectArrayWithDictionaryArray:responseObject[@"data"][@"list"]];
        
            [self.awardViewRooms makeObjectsPerformSelector:@selector(removeFromSuperview)];
       [self.dbHistoryRooms enumerateObjectsUsingBlock:^(ZHDBHistoryModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            //
            ZHAwardAnnounceView *announceView = self.awardViewRooms[idx];
            announceView.typeLbl.text = [obj getNowResultName];
            announceView.contentLbl.attributedText = [obj getNowResultContent];            
            [self.tableHeaderView addSubview:announceView];
            
            
        }];
        
    } failure:^(NSError *error) {
        
    }];

}

#pragma mark- tableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    ZHDuoBaoDetailVC *detailVC = [[ZHDuoBaoDetailVC alloc] init];
    detailVC.dbModel = self.dbRooms[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];

}


#pragma mark- dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dbRooms.count;

}

//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *zhDuoBaoCellId = @"ZHDuoBaoCell";
    ZHDuoBaoCell *cell = [tableView dequeueReusableCellWithIdentifier:zhDuoBaoCellId];
    if (!cell) {
        
        cell = [[ZHDuoBaoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:zhDuoBaoCellId];
        
    }
    cell.type = [NSString stringWithFormat:@"%ld",indexPath.row  + 1];
    cell.dbModel = self.dbRooms[indexPath.row];
    
    return cell;
    
    
}

- (UIView *)tableHeaderView {

    if (!_tableHeaderView) {
        
        UIView *headerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 84)];
        headerBgView.backgroundColor = [UIColor whiteColor];
        _tableHeaderView = headerBgView;
        
        UIImageView *hintImageView = [[UIImageView alloc] initWithFrame:CGRectMake(17, 17, 46, 50)];
        hintImageView.image = [UIImage imageNamed:@"分秒实况"];
        [headerBgView addSubview:hintImageView];
        
        //线
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor zh_lineColor];
        [headerBgView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(hintImageView.mas_right).offset(17);
            make.width.mas_equalTo(@1);
            make.height.mas_equalTo(@(50));
            make.centerY.equalTo(headerBgView.mas_centerY);
        }];
        
        //
        self.awardViewRooms = [[NSMutableArray alloc] initWithCapacity:3];
        for (NSInteger i = 0; i < 3 ; i++) {
            
            CGFloat x = hintImageView.xx + 18 + 10;
            CGFloat y = 13.5 + i*(15 + 6);
            
            ZHAwardAnnounceView *awardV = [[ZHAwardAnnounceView alloc] initWithFrame:CGRectMake(x, y, SCREEN_WIDTH - line.xx, 15)];
            //        [headerBgView addSubview:awardV];
            [self.awardViewRooms addObject:awardV];
            
        }

    }
    
    return _tableHeaderView;


}

//- (UIView *)tableViewHeaderView {
//    
//    UIView *headerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 84)];
//    headerBgView.backgroundColor = [UIColor whiteColor];
//    
//    UIImageView *hintImageView = [[UIImageView alloc] initWithFrame:CGRectMake(17, 17, 46, 50)];
//    hintImageView.image = [UIImage imageNamed:@"分秒实况"];
//    [headerBgView addSubview:hintImageView];
//    
//    //线
//    UIView *line = [[UIView alloc] init];
//    line.backgroundColor = [UIColor zh_lineColor];
//    [headerBgView addSubview:line];
//    [line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(hintImageView.mas_right).offset(17);
//        make.width.mas_equalTo(@1);
//        make.height.mas_equalTo(@(50));
//        make.centerY.equalTo(headerBgView.mas_centerY);
//    }];
//    
//    //
//    self.awardViewRooms = [[NSMutableArray alloc] initWithCapacity:3];
//    for (NSInteger i = 0; i < 3 ; i++) {
//        
//        CGFloat x = hintImageView.xx + 18 + 10;
//        CGFloat y = 13.5 + i*(15 + 6);
//        
//        ZHAwardAnnounceView *awardV = [[ZHAwardAnnounceView alloc] initWithFrame:CGRectMake(x, y, SCREEN_WIDTH - line.xx, 15)];
////        [headerBgView addSubview:awardV];
//        [self.awardViewRooms addObject:awardV];
//        
//    }
//    
//    return headerBgView;
//    
//}


@end
