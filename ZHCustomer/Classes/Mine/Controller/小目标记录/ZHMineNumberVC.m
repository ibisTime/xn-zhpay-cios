//
//  ZHMineNumberVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHMineNumberVC.h"
#import "ZHDuoBaoCell.h"
#import "ZHDuoBaoDetailVC.h"
#import "ZHDBNumberModel.h"
#import "ZHNumberCell.h"
#import "MJRefresh.h"

@interface ZHMineNumberVC ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray <ZHDBNumberModel *>*numberRoom;

@property (nonatomic, assign) NSInteger start;


@end

@implementation ZHMineNumberVC

- (NSMutableArray<ZHDBNumberModel *> *)numberRoom {

    if (!_numberRoom) {
        
        _numberRoom = [[NSMutableArray alloc] init];
    }

    return _numberRoom;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.start = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    
    TLTableView *mineNumberTableView = [TLTableView tableViewWithframe:CGRectMake(0, 0, SCREEN_WIDTH, 140)
                                                              delegate:self
                                                            dataSource:self];
    //self.mineNumberTableView = mineNumberTableView;
    [self.view addSubview:mineNumberTableView];
    mineNumberTableView.rowHeight = 140;
    //
    if (self.isMineHistory) { //我的记录
       
        if ([self.historyModel.jewel.status isEqual:@0]) { //还未揭晓
            
            UIButton *shareBtn = [UIButton zhBtnWithFrame:CGRectMake(0, SCREEN_HEIGHT - 55 - 64, SCREEN_WIDTH - 45, 45) title:@"追加"];
            [self.view addSubview:shareBtn];
            [self.view addSubview:shareBtn];
            shareBtn.centerX = SCREEN_WIDTH/2.0;
            [shareBtn addTarget:self action:@selector(buy) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:shareBtn];
        }

    }

    //号码列表
    UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc] init];
    fl.itemSize = CGSizeMake(SCREEN_WIDTH/4.0, 30) ;
    fl.minimumLineSpacing = 0;
    fl.minimumInteritemSpacing = 0;
    
    UICollectionView *numberCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, mineNumberTableView.yy + 10, SCREEN_WIDTH, 260) collectionViewLayout:fl];
    [self.view addSubview:numberCollectionView];
    numberCollectionView.delegate = self;
    numberCollectionView.dataSource = self;
    numberCollectionView.backgroundColor = [UIColor zh_backgroundColor];
    
    [numberCollectionView registerClass:[ZHNumberCell class] forCellWithReuseIdentifier:@"collectionViewId"];
    
    __weak typeof(self) weakSelf = self;
    __weak UICollectionView *weakCollectioView = numberCollectionView;
    numberCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        TLNetworking *http = [TLNetworking new];

        http.code = @"808318";
        http.parameters[@"jewelCode"] = self.historyModel.jewel.code;
        http.parameters[@"start"] = @"1";
        http.parameters[@"limit"] = @"40";
        http.parameters[@"userId"] = self.isMineHistory ? [ZHUser user].userId : nil;
        //    http.parameters[@" "]
        [http postWithSuccess:^(id responseObject) {
            
            self.start = 2;
            self.numberRoom = [ZHDBNumberModel tl_objectArrayWithDictionaryArray:responseObject[@"data"][@"list"]];
            [weakCollectioView.mj_header endRefreshing];

            [weakCollectioView reloadData];

        } failure:^(NSError *error) {
            [weakCollectioView.mj_header endRefreshing];

            
        }];
        
    }];
    
    numberCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        
        TLNetworking *http = [TLNetworking new];
        http.code = @"808318";
        http.parameters[@"jewelCode"] = self.historyModel.jewel.code;
        http.parameters[@"start"] = [NSString stringWithFormat:@"%ld",self.start];
        http.parameters[@"limit"] = @"40";
        http.parameters[@"userId"] = self.isMineHistory ? [ZHUser user].userId : nil;
        [http postWithSuccess:^(id responseObject) {
            
            NSArray *arr = responseObject[@"data"][@"list"];
            if (arr.count > 0) {
                [weakCollectioView.mj_footer endRefreshing];

                NSArray *objs = [ZHDBNumberModel tl_objectArrayWithDictionaryArray:arr]
                ;
                [weakSelf.numberRoom addObjectsFromArray:objs];
                
                [weakCollectioView reloadData];
                
                self.start ++;
            } else {
                
                [weakCollectioView.mj_footer endRefreshingWithNoMoreData];
                
            
            }
            

        } failure:^(NSError *error) {
            
            [weakCollectioView.mj_footer endRefreshing];

        }];
        
    }];
    
 
    [weakCollectioView.mj_header beginRefreshing];
    
    
    //中奖号码
    if ([self.historyModel.jewel.status isEqual:@1]) {
        
        CGFloat y = numberCollectionView.yy + 10;
        UILabel *hintLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, y, SCREEN_WIDTH - 20, 20)];
        hintLbl.textColor = [UIColor zh_textColor];
        [self.view addSubview:hintLbl];
        hintLbl.text = @"中奖号码:";
        hintLbl.font = FONT(13);
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, hintLbl.yy, SCREEN_WIDTH - 20, 30)];
        [self.view addSubview:lbl];
        lbl.font = FONT(13);
        lbl.textColor = [UIColor zh_themeColor];
        lbl.text = self.historyModel.jewel.winNumber;
    }
}

#pragma mark- 追加
- (void)buy {

    //调到宝贝
    ZHDuoBaoDetailVC *detailVC = [[ZHDuoBaoDetailVC alloc] init];
    detailVC.dbModel = self.historyModel.jewel;
    [self.navigationController pushViewController:detailVC animated:YES];
    

}

#pragma mark- collectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

     return  self.numberRoom.count;
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    ZHNumberCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewId" forIndexPath:indexPath];
    cell.textLbl.text = self.numberRoom[indexPath.row].number;
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    
}

//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *zhDuoBaoCellId = @"ZHDuoBaoCell";
    ZHDuoBaoCell *cell = [tableView dequeueReusableCellWithIdentifier:zhDuoBaoCellId];
    if (!cell) {
        
        cell = [[ZHDuoBaoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:zhDuoBaoCellId];
        
    }
    cell.type = [NSString stringWithFormat:@"%ld",indexPath.row  + 1];
    cell.dbModel = self.historyModel.jewel;
    return cell;
    
    
}

@end
