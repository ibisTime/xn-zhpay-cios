//
//  ZHHZBListVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/9.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHHZBListVC.h"
#import "ZHHZBCell.h"
#import "ZHAdvDetailVC.h"

@interface ZHHZBListVC ()<UITableViewDelegate,UITableViewDataSource>


@end

@implementation ZHHZBListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    TLTableView *tableView = [TLTableView tableViewWithframe:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) delegate:self dataSource:self];
    tableView.rowHeight =  45;
    [self.view  addSubview:tableView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    headerView.backgroundColor = [UIColor zh_backgroundColor];
    UILabel *lbl = [UILabel labelWithFrame:headerView.bounds textAligment:NSTextAlignmentCenter backgroundColor:[UIColor zh_backgroundColor] font:FONT(13) textColor:[UIColor zh_themeColor]];
    [headerView addSubview:lbl];
    
    lbl.text = @"点击进入详情，分享成功后即可获得奖励";
    tableView.tableHeaderView = headerView;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.hzbRoom.count;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZHHZBModel *model = self.hzbRoom[indexPath.row];

    ZHAdvDetailVC *advDetailVC = [[ZHAdvDetailVC alloc] init];
    advDetailVC.hzbModel = model;
    
    [self.navigationController pushViewController:advDetailVC animated:YES];
    
    //
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static  NSString * zhHZBCellId = @"zhHZBCellId";
    ZHHZBCell *cell = [tableView dequeueReusableCellWithIdentifier:zhHZBCellId];
    if (!cell) {
        cell = [[ZHHZBCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:zhHZBCellId];
    }
    cell.hzb = self.hzbRoom[indexPath.row];
    return cell;

}


@end
