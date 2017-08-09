//
//  ZHBillVC.m
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/24.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "CDBillHistoryVC.h"
#import "TLPageDataHelper.h"
#import "ZHBillCell.h"
#import "ZHBillModel.h"
#import "TLHeader.h"
#import "UIColor+theme.h"
#import "TLDatePicker.h"

@interface CDBillHistoryVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray <ZHBillModel *>*bills;
@property (nonatomic,strong) TLTableView *billTV;
@property (nonatomic,assign) BOOL isFirst;


//开始日期
@property (nonatomic,strong) TLTextField *beginTimeTf;

//结束日期
@property (nonatomic,strong) TLTextField *endTimeTf;

@property (nonatomic,assign) BOOL isBegin;
@property (nonatomic,assign) BOOL isEnd;
@property (nonatomic, strong) TLDatePicker *datePicker;
@property (nonatomic, strong) TLPageDataHelper *pageDataHelper;

@end

@implementation CDBillHistoryVC

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
//    if (self.isFirst) {
//        [self.billTV beginRefreshing];
//        self.isFirst = NO;
//    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"历史账单";
    self.isEnd = NO;
    self.isBegin = NO;
    
    
    if (!self.accountNumber) {
        NSLog(@"请传入账户编号");
        return;
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"开始查询" style:0 target:self action:@selector(beginSearch)];
    
    //
    UILabel *lbl = [UILabel labelWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 30)
                              textAligment:NSTextAlignmentLeft
                           backgroundColor:[UIColor clearColor]
                                      font:FONT(13)
                                 textColor:[UIColor themeColor]];
    [self.view addSubview:lbl];
    lbl.text = @"支持7天内账单查询";
    
    
    [self.view addSubview:self.beginTimeTf];
    self.beginTimeTf.y = lbl.yy;
    
    [self.view addSubview:self.endTimeTf];
    self.endTimeTf.y = self.beginTimeTf.yy + 1;
    
    __weak typeof(self) weakSelf = self;
    self.datePiker.confirmAction = ^(NSDate *date) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"YYYY-MM-dd";
        if (weakSelf.isBegin) {
            
            weakSelf.beginTimeTf.text = [dateFormatter stringFromDate:date];
            
        } else {
            
            weakSelf.endTimeTf.text = [dateFormatter stringFromDate:date];
            
            //
        }
        weakSelf.isBegin = NO;
        weakSelf.isEnd = NO;
        
    };
    
    //
    
    //
    TLTableView *billTableView = [TLTableView tableViewWithframe:CGRectMake(0, self.endTimeTf.yy + 10, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - self.endTimeTf.yy - 10)
                                                        delegate:self
                                                      dataSource:self];
    [self.view addSubview:billTableView];
    self.isFirst = YES;
    
    billTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    billTableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无记录"];
    self.billTV = billTableView;
    
    
    
    //
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *minComponents = [[NSDateComponents alloc] init];
    [minComponents setDay:-7];
    
    //
    NSDateComponents *maxComponents = [[NSDateComponents alloc] init];
    [maxComponents setDay:-1];
    
    //最大时间
    self.datePicker.datePicker.maximumDate = [calendar dateByAddingComponents:maxComponents toDate:[NSDate date] options:0];
    
    self.datePicker.datePicker.minimumDate =  [calendar dateByAddingComponents:minComponents toDate:[NSDate date] options:0];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    self.beginTimeTf.text = [formatter stringFromDate:self.datePicker.datePicker.minimumDate];
    self.endTimeTf.text = [formatter stringFromDate:self.datePicker.datePicker.maximumDate];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self beginSearch];

    });
    
    //
//    UIButton *confirmBtn =  [UIButton zhBtnWithFrame:CGRectMake(20, self.endTimeTf.yy + 20, SCREEN_WIDTH - 40, 40) title:@"查询"];
//    [self.view addSubview:confirmBtn];
//    [confirmBtn addTarget:self action:@selector(look) forControlEvents:UIControlEventTouchUpInside];
//    [confirmBtn setBackgroundColor:[UIColor billThemeColor] forState:UIControlStateNormal];
    

    
    
}


#pragma mark- 查询账单
- (void)beginSearch {
    
    if (![self.beginTimeTf.text valid]) {
        [TLAlert alertWithError:@"请选择开始时间"];
        return;
    }
    
    if (![self.endTimeTf.text valid]) {
        [TLAlert alertWithError:@"请选择结束时间"];
        return;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd";
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    NSDate *date1 =  [formatter dateFromString:self.beginTimeTf.text];
    NSDate *date2 =  [formatter dateFromString:self.endTimeTf.text];
    
    //判断结束日期不能大于起始日期
    if ([date1 timeIntervalSince1970] > [date2 timeIntervalSince1970]) {
        
        [TLAlert alertWithInfo:@"开始时间应该早于结束时间"];
        return;
        
    }
    
    __weak typeof(self) weakSelf = self;
    //    __weak typeof(self) weakSelf = self;
    TLPageDataHelper *pageDataHelper = [[TLPageDataHelper alloc] init];
    self.pageDataHelper = pageDataHelper;
    pageDataHelper.code = @"802531";
    pageDataHelper.tableView = self.billTV;
    pageDataHelper.limit = 10;
//    pageDataHelper.parameters[@"token"] = [ZHUser user].token;
//    pageDataHelper.parameters[@"type"] = TERMINAL_TYPE;
//    pageDataHelper.isAutoDeliverCompanyCode = NO;
    pageDataHelper.parameters[@"accountNumber"] = self.accountNumber ? : @"";
    
    pageDataHelper.parameters[@"dateStart"] = self.beginTimeTf.text;
    pageDataHelper.parameters[@"dateEnd"] = self.endTimeTf.text;
    
    //
    if ( self.bizType) {
        
        pageDataHelper.parameters[@"bizType"] = self.bizType;
    }
    
    //0 刚生成待回调，1 已回调待对账，2 对账通过, 3 对账不通过待调账,4 已调账,9,无需对账
    //pageDataHelper.parameters[@"status"] = [ZHUser user].token;
    [pageDataHelper modelClass:[ZHBillModel class]];
    [self.billTV addRefreshAction:^{
        
        [pageDataHelper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.bills = objs;
            [weakSelf.billTV reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    
    [self.billTV addLoadMoreAction:^{
        
        [pageDataHelper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.bills = objs;
            [weakSelf.billTV reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];

    
   [self.billTV beginRefreshing];

//    //
//    self.pageDataHelper.parameters[@"startDateTime"] = self.beginTimeTf.text;
//    self.pageDataHelper.parameters[@"endDateTime"] = self.endTimeTf.text;

}




#pragma mark- 开始结束时间
- (void)chooseBeginTime {
    
    [self.view endEditing:YES];
    self.isBegin =  YES;
    [self.datePiker show];
}

- (void)chooseEndTime {
    
    [self.view endEditing:YES];
    self.isEnd = YES;
    [self.datePiker show];
    
}

- (TLDatePicker *)datePiker {
    
    if (!_datePicker) {
        
        _datePicker = [[TLDatePicker alloc] init];
        
    }
    return _datePicker;
    
}

- (TLTextField *)beginTimeTf {
    
    if (!_beginTimeTf) {
        
        _beginTimeTf = [[TLTextField alloc] initWithframe:CGRectMake(0, 0, SCREEN_WIDTH,45) leftTitle:@"开始时间" titleWidth:100 placeholder:@"请点击选择起始时间"];
//        _beginTimeTf.leftLbl.textColor = [UIColor textColor];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:_beginTimeTf.bounds];
        [_beginTimeTf addSubview:btn];
        [btn addTarget:self action:@selector(chooseBeginTime) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _beginTimeTf;
}

- (TLTextField *)endTimeTf {
    
    if (!_endTimeTf) {
        
        _endTimeTf = [[TLTextField alloc] initWithframe:CGRectMake(0, 0, SCREEN_WIDTH, self.beginTimeTf.height) leftTitle:@"结束时间" titleWidth:100 placeholder:@"请点击选择结束时间"];
//        _endTimeTf.leftLbl.textColor = [UIColor textColor];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:_endTimeTf.bounds];
        [_endTimeTf addSubview:btn];
        [btn addTarget:self action:@selector(chooseEndTime) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _endTimeTf;
}


//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    CDOneBillDetailVC *detailVC = [CDOneBillDetailVC new];
//    detailVC.billModel = self.bills[indexPath.row];
//    [self.navigationController pushViewController:detailVC animated:YES];
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.bills.count;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.bills[indexPath.row].dHeightValue + 110;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        static NSString *billCellId = @"ZHBillCellID";
        ZHBillCell *cell = [tableView dequeueReusableCellWithIdentifier:billCellId];
    
        if (!cell) {
            cell = [[ZHBillCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:billCellId];
        }
        cell.billModel = self.bills[indexPath.row];
    
        return cell;
    
//    static NSString *billCellId = @"CDBillCellID";
//    CDBillCell *cell = [tableView dequeueReusableCellWithIdentifier:billCellId];
//    
//    if (!cell) {
//        cell = [[CDBillCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:billCellId];
//    }
//    cell.billModel = self.bills[indexPath.row];
//    
//    return cell;
    
}

@end
