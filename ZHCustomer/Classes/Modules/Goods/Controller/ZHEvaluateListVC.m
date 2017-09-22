//
//  ZHEvaluateListVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/27.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHEvaluateListVC.h"
#import "ZHEvaluateCell.h"
#import "ZHEvaluateView.h"
#import "ZHEvaluateModel.h"
#import "UIColor+theme.h"

@interface ZHEvaluateListVC ()<UITableViewDelegate,UITableViewDataSource>

//酱油
@property (nonatomic,strong) UIView *progressView;
//大哥
@property (nonatomic,strong) UILabel *alreadlyLbl;
@property (nonatomic,strong) ZHEvaluateView *evaluateView;
@property (nonatomic,strong) TLTableView *evaluateTableView;

@property (nonatomic,strong) NSMutableArray <ZHEvaluateModel *>*buyerItems;
@property (nonatomic,assign) BOOL isFirst;
@property (nonatomic,assign) NSInteger start;

@end



@implementation ZHEvaluateListVC

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    if (!self.isFirst) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.evaluateTableView beginRefreshing];
            self.isFirst = YES;

        });

    }
    
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"购买进度";
    self.isFirst = NO;
    
//
    TLTableView *tableView = [TLTableView tableViewWithframe:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - [DeviceUtil top64] - 49) delegate:self dataSource:self];
    [self.view addSubview:tableView];
    self.evaluateTableView = tableView;
    tableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无评价" topMargin:50];
    
    tableView.tableHeaderView = self.progressView;
    tableView.rowHeight = [ZHEvaluateCell rowHeight];
    //
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    helper.code = @"808029";
    helper.parameters[@"productCode"] = self.goodsCode; //大类
    helper.parameters[@"type"] = @"3";
    helper.tableView = self.evaluateTableView;
    [helper modelClass:[ZHEvaluateModel class]];
    
    //
    __weak typeof(self) weakSelf = self;
    [self.evaluateTableView addRefreshAction:^{
        
        
//        TLNetworking *http = [TLNetworking new];
//        http.code = @"808325";
//        http.parameters[@"jewelCode"] = weakSelf.goodsCode;
//        
//        http.parameters[@"start"] = @"1";
//        http.parameters[@"limit"] = @"30";
//        [http postWithSuccess:^(id responseObject) {
//            
//            [weakSelf.evaluateTableView resetNoMoreData_tl];
//
//            weakSelf.start = 2;
//
//            weakSelf.evaluateView.percent = [responseObject[@"data"][@"goodRate"] floatValue];
//            weakSelf.alreadlyLbl.text = [NSString stringWithFormat:@"购买人次(%@)",responseObject[@"data"][@"buyNums"]];
//            NSArray *arr =  responseObject[@"data"][@"page"][@"list"];
//            
//            weakSelf.buyerItems = [ZHEvaluateModel mj_objectArrayWithKeyValuesArray:arr];
//            
//            [weakSelf.evaluateTableView reloadData_tl];
//            [weakSelf.evaluateTableView endRefreshHeader];
//            
//            
//            
//            
//        } failure:^(NSError *error) {
//            
//            
//        }];

        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.buyerItems = objs;
            [weakSelf.evaluateTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    [self.evaluateTableView addLoadMoreAction:^{
        
//        TLNetworking *http = [TLNetworking new];
//        http.code = @"808325";
//        http.parameters[@"jewelCode"] = weakSelf.goodsCode;
//        
//        http.parameters[@"start"] = [NSString stringWithFormat:@"%ld",weakSelf.start];
//        http.parameters[@"limit"] = @"30";
//        [http postWithSuccess:^(id responseObject) {
//            
//            weakSelf.start ++;
//            
//            NSArray *arr = responseObject[@"data"][@"page"][@"list"];
//            if (arr.count <= 0) {
//                
//                [weakSelf.evaluateTableView endRefreshingWithNoMoreData_tl];
//
//                
//            } else {
//            
//                [weakSelf.buyerItems addObjectsFromArray: [ZHEvaluateModel mj_objectArrayWithKeyValuesArray:arr]];
//               
//                [weakSelf.evaluateTableView reloadData_tl];
//                [weakSelf.evaluateTableView endRefreshHeader];
//            }
//                        
//        } failure:^(NSError *error) {
//            
//            
//        }];
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.buyerItems = objs;
            [weakSelf.evaluateTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    [self.evaluateTableView endRefreshingWithNoMoreData_tl];
    
    self.alreadlyLbl.text = [NSString stringWithFormat:@"购买人数(%@)",self.peopleNum];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //    return self.buyerItems.count;
    return self.buyerItems.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *zhEvaluateCellId = @"ZHEvaluateCellID";
    ZHEvaluateCell *cell = [tableView dequeueReusableCellWithIdentifier:zhEvaluateCellId];
    if (!cell) {
        
        cell = [[ZHEvaluateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:zhEvaluateCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    cell.evaluateModel = self.buyerItems[indexPath.row];
    
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
    
}


- (UIView *)progressView {
    
    if (!_progressView) {
        
        _progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        _progressView.backgroundColor = [UIColor whiteColor];
        
        UILabel *lbl1 = [UILabel labelWithFrame:CGRectMake(15, 0, 50, _progressView.height)
                                   textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor whiteColor]
                                           font:[UIFont secondFont]
                                      textColor:[UIColor zh_textColor]];
        lbl1.text = @"好评率";
        [_progressView addSubview:lbl1];
        lbl1.centerY = _progressView.height/2.0;
        
        ZHEvaluateView *evaluateView = [[ZHEvaluateView alloc] initWithFrame:CGRectMake(lbl1.xx + 7, 0, 97, 17)];
        [_progressView addSubview:evaluateView];
        evaluateView.centerY = _progressView.height/2.0;
        self.evaluateView = evaluateView;
        //
        self.alreadlyLbl = [UILabel labelWithFrame:CGRectMake(evaluateView.xx, 0, SCREEN_WIDTH - evaluateView.xx - 15, _progressView.height)
                                   textAligment:NSTextAlignmentRight
                                backgroundColor:[UIColor whiteColor]
                                           font:FONT(14)
                                      textColor:[UIColor zh_textColor2]];
        [_progressView addSubview:self.alreadlyLbl];
        
    }
    
    return _progressView;
    
}

@end
