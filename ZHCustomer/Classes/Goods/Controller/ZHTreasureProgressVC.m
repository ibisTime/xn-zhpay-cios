//
//  ZHTreasureProgressVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/27.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHTreasureProgressVC.h"
#import "ZHBuyerCell.h"
#import "ZHTreasureRecord.h"


@interface ZHTreasureProgressVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIView *progressView;
@property (nonatomic,strong) UILabel *totalLbl;
@property (nonatomic,strong) UILabel *alreadlyLbl;
@property (nonatomic,strong) TLTableView *progressTableView;

@property (nonatomic,strong) NSMutableArray <ZHTreasureRecord *>*buyerItems;
@property (nonatomic,assign) BOOL isFirst;

//@property (nonatomic,strong) ZHTreasureRecord <ZHTreasureRecord *> *records;

@end

@implementation ZHTreasureProgressVC

//
- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    if (self.isFirst) {
        
        self.isFirst = NO;
        [self.progressTableView beginRefreshing];

    }
    
}

//
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"购买进度";
    
    self.isFirst = YES;

    TLTableView *tableView = [TLTableView tableViewWithframe:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) delegate:self dataSource:self];
    [self.view addSubview:tableView];
    self.progressTableView = tableView;

    tableView.tableHeaderView = self.progressView;
    tableView.rowHeight = [ZHBuyerCell rowHeight];

    //
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    helper.code = @"808315";
    helper.parameters[@"jewelCode"] = self.treasureModel.code;
    helper.parameters[@"status"] = @"payed";

    
    helper.tableView = self.progressTableView;
    [helper modelClass:[ZHTreasureRecord class]];
    
    //
    __weak typeof(self) weakSelf = self;
    [self.progressTableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.buyerItems = objs;
            [weakSelf.progressTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    [self.progressTableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.buyerItems = objs;
            [weakSelf.progressTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    [self.progressTableView endRefreshingWithNoMoreData_tl];
    
    
    
    NSAttributedString *totalAttrStr = [ZHCurrencyHelper calculatePriceWithQBB:self.treasureModel.price3 GWB:self.treasureModel.price2 RMB:self.treasureModel.price1 count:[self.treasureModel.totalNum integerValue]];
    
    NSAttributedString *investAttrStr = [ZHCurrencyHelper calculatePriceWithQBB:self.treasureModel.price3 GWB:self.treasureModel.price2 RMB:self.treasureModel.price1 count:[self.treasureModel.investNum integerValue]];
    
    self.totalLbl.attributedText = totalAttrStr;
    self.alreadlyLbl.attributedText = investAttrStr;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.buyerItems.count;
//    return 3;
    
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *zhBuyerCellId = @"ZHBuyerCell";
    ZHBuyerCell *cell = [tableView dequeueReusableCellWithIdentifier:zhBuyerCellId];
    if (!cell) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell = [[ZHBuyerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:zhBuyerCellId];
        
    }
//    cell.goods = self.buyerItems[indexPath.row];
    cell.treasureRecord = self.buyerItems[indexPath.row];
    return cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
    
}



- (UIView *)progressView {
    
    if (!_progressView) {
        
        _progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        _progressView.backgroundColor = [UIColor whiteColor];
        
        UILabel *lbl1 = [UILabel labelWithFrame:CGRectZero
                                   textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor whiteColor]
                                           font:[UIFont thirdFont]
                                      textColor:[UIColor zh_textColor2]];
        lbl1.text = @"总额";
        [_progressView addSubview:lbl1];
        [lbl1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_progressView.mas_left).offset(15);
            make.top.equalTo(_progressView.mas_top);
            make.height.mas_equalTo(@50);
        }];
        
        //
        
        //
        self.totalLbl = [UILabel labelWithFrame:CGRectZero
                                   textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor whiteColor]
                                           font:[UIFont secondFont]
                                      textColor:[UIColor zh_themeColor]];
        [_progressView addSubview:self.totalLbl];
        
        [_totalLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbl1.mas_right).offset(6);
            make.top.equalTo(_progressView.mas_top);
            make.height.mas_equalTo(@50);
        }];
        
        //
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor zh_lineColor];
        [_progressView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_progressView.mas_left);
            make.height.mas_equalTo(@(5));
            make.width.mas_equalTo(@(SCREEN_WIDTH));
            make.top.equalTo(_totalLbl.mas_bottom);
        }];
        
//        //------------------------------
//        //已购
        
        UILabel *lbl2 = [UILabel labelWithFrame:CGRectZero
                                   textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor whiteColor]
                                           font:[UIFont thirdFont]
                                      textColor:[UIColor zh_textColor2]];
        lbl2.text = @"已购";
        [_progressView addSubview:lbl2];
        [lbl2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_progressView.mas_left).offset(15);
            make.top.equalTo(_totalLbl.mas_bottom).offset(5);
            make.height.mas_equalTo(@50);
        }];
        
        self.alreadlyLbl = [UILabel labelWithFrame:CGRectZero
                                      textAligment:NSTextAlignmentLeft
                                   backgroundColor:[UIColor whiteColor]
                                              font:[UIFont secondFont]
                                         textColor:[UIColor zh_themeColor]];
        [_progressView addSubview:self.alreadlyLbl];
        
        [_alreadlyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(_progressView.mas_right).offset(-15);
            make.top.equalTo(lbl2.mas_top);
            make.height.mas_equalTo(@50);
            make.left.equalTo(lbl2.mas_right).offset(6);
        }];
        //
        

        
        
        
    }
    
    return _progressView;
}

@end
