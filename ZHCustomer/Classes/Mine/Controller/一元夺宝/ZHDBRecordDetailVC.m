//
//  ZHDBRecordDetailVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/12.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHDBRecordDetailVC.h"
#import "ZHRecordListCell.h"
#import "ZHDBNumVC.h"

@interface ZHDBRecordDetailVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) TLTableView *mineRecordTableView;

@property (nonatomic,assign) BOOL isFrist;

@property (nonatomic,strong) NSMutableArray <ZHMineTreasureModel *>*recoderLists;

@end

@implementation ZHDBRecordDetailVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.isFrist) {
        [self.mineRecordTableView beginRefreshing];
        self.isFrist = NO;
    }
}

- (void)injected {
    
    [self.mineRecordTableView reloadData];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"夺宝详情";
    self.isFrist = YES;
    
    //名称
    CGSize size = [self.mineTreasureModel.jewel.name calculateStringSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT) font:FONT(15)];
    
    UILabel *nameLbl = [UILabel labelWithFrame:CGRectMake(15, 10, size.width, size.height)
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor clearColor]
                                          font:FONT(15)
                                     textColor:[UIColor zh_textColor]];
    [self.view addSubview:nameLbl];
    
    //揭晓时间
    UILabel *timeLbl = [UILabel labelWithFrame:CGRectMake(15, nameLbl.yy + 10, SCREEN_WIDTH - 30, [FONT(13) lineHeight])
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor clearColor]
                                          font:FONT(13)
                                     textColor:[UIColor zh_textColor]];
    [self.view addSubview:timeLbl];
    
    //幸运号码
    UILabel *resultLbl = [UILabel labelWithFrame:CGRectMake(15, timeLbl.yy + 10, SCREEN_WIDTH - 30, [FONT(13) lineHeight])
                                    textAligment:NSTextAlignmentLeft
                                 backgroundColor:[UIColor clearColor]
                                            font:FONT(13)
                                       textColor:[UIColor zh_textColor]];
    [self.view addSubview:resultLbl];
    
    
    //名称
    nameLbl.text = self.mineTreasureModel.jewel.name;
    
    //计算揭晓时间
    NSDate *startDate = [TLTool getDateByString:self.mineTreasureModel.jewel.startDatetime];
    //揭晓时间
     NSDate *date = [NSDate dateWithTimeInterval:[self.mineTreasureModel.jewel.raiseDays integerValue]*24*60*60.0 sinceDate:startDate];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
    NSString *dateStr = [formatter stringFromDate:date];
    timeLbl.text = [NSString stringWithFormat:@"揭晓时间: %@",dateStr];
    
    if ([self.mineTreasureModel.jewel.status isEqualToString:@"7"]) {
        
        NSString *res = self.mineTreasureModel.jewel.winNumber;
        NSMutableAttributedString *mutableStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"本期幸运号码: %@",res]];
        [mutableStr addAttribute:NSForegroundColorAttributeName value:[UIColor zh_themeColor] range:NSMakeRange(8, res.length)];
        resultLbl.attributedText = mutableStr;
        
    } else {
    
        resultLbl.text = @"本期幸运号码: 未揭晓";
        
    }
  
    //查询我的记录
    TLTableView *tableView = [TLTableView tableViewWithframe:CGRectMake(0, resultLbl.yy + 20, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - resultLbl.yy - 20) delegate:self dataSource:self];
    [self.view addSubview:tableView];
    tableView.rowHeight = 50;
    tableView.backgroundColor = [UIColor whiteColor];
    self.mineRecordTableView = tableView;

    //--//
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    helper.code = @"808315";
    helper.parameters[@"userId"] = [ZHUser user].userId;
    helper.parameters[@"jewelCode"] = self.mineTreasureModel.jewelCode;
    helper.parameters[@"status"] = @"payed";
    
    helper.tableView = self.mineRecordTableView;
    [helper modelClass:[ZHMineTreasureModel class]];
    
    //-----//
    __weak typeof(self) weakSelf = self;
    [self.mineRecordTableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.recoderLists = objs;
            [weakSelf.mineRecordTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    [self.mineRecordTableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.recoderLists = objs;
            [weakSelf.mineRecordTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    [self.mineRecordTableView endRefreshingWithNoMoreData_tl];

    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    ZHDBNumVC *vc = [[ZHDBNumVC alloc] init];
    vc.treasureModel = self.recoderLists[indexPath.row];
                                
    [self.navigationController pushViewController:vc animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];


}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    return [self headerView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 40;
}

- (UIView *)headerView {

    UIView *bgV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    bgV.backgroundColor = [UIColor whiteColor];
    UILabel *timeLbl = [UILabel labelWithFrame:CGRectZero
                              textAligment:NSTextAlignmentLeft
                           backgroundColor:[UIColor whiteColor]
                                          font:FONT(12)
                                     textColor:[UIColor zh_textColor2]];
    [bgV addSubview:timeLbl];
    [timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgV.mas_left).offset(15);
        make.top.equalTo(bgV.mas_top);
        make.bottom.equalTo(bgV.mas_bottom);
    }];
    timeLbl.text = @"夺宝时间";

    
    //
    UILabel *lookLbl = [UILabel labelWithFrame:CGRectZero
                              textAligment:NSTextAlignmentLeft
                           backgroundColor:[UIColor whiteColor]
                                      font:FONT(12)
                                 textColor:[UIColor zh_textColor2]];
    lookLbl.text = @"操作";
    [bgV addSubview:lookLbl];
    
    [lookLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(bgV.mas_top);
        make.bottom.equalTo(bgV.mas_bottom);
        make.right.equalTo(bgV.mas_right).offset(-15);
    }];
    
    //
    UILabel *countLbl = [UILabel labelWithFrame:CGRectZero textAligment:NSTextAlignmentRight backgroundColor:[UIColor whiteColor] font:FONT(12) textColor:[UIColor zh_textColor2]];
    [bgV addSubview:countLbl];
    [countLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgV.mas_top);
        make.bottom.equalTo(bgV.mas_bottom);
        make.right.equalTo(lookLbl.mas_left).offset(-50);
    }];
    countLbl.text = @"参与人次";
    
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor zh_lineColor];
    [bgV addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgV.mas_left);
        make.width.equalTo(bgV.mas_width);
        make.height.mas_equalTo(@(LINE_HEIGHT));
        make.bottom.equalTo(bgV.mas_bottom);
    }];
    
    return bgV;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.recoderLists.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *zhRecordListCellId = @"zhRecordListCellId";

    ZHRecordListCell *cell = [tableView dequeueReusableCellWithIdentifier:zhRecordListCellId];
    if (!cell) {
        cell = [[ZHRecordListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:zhRecordListCellId];
    }
    cell.record = self.recoderLists[indexPath.row];
    return cell;
}
@end
