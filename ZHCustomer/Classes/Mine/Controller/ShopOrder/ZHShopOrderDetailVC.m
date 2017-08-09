//
//  ZHShopOrderDetailVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/18.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHShopOrderDetailVC.h"
#import "ZHShopOrderCell.h"
#import "TLHeader.h"
#import "UIColor+theme.h"

@interface ZHShopOrderDetailVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ZHShopOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
   self.title = @"买单详情";
    
    TLTableView *detailTV = [TLTableView groupTableViewWithframe:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) delegate:self dataSource:self];
    [self.view addSubview:detailTV];
    detailTV.tableHeaderView = [self headerView];
    detailTV.rowHeight = [ZHShopOrderCell rowHeight];
    
    
}

- (UIView *)headerView {

    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    headerV.backgroundColor = [UIColor whiteColor];
    //标题
    UILabel *titleLbl = [UILabel labelWithFrame:CGRectMake(15, 0, 150, 30)
                                   textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor clearColor]
                                           font:FONT(13)
                                      textColor:[UIColor zh_textColor]];
    [headerV addSubview:titleLbl];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, titleLbl.yy, SCREEN_WIDTH, 1)];
    line.backgroundColor = [UIColor zh_lineColor];
    [headerV addSubview:line];

    //订单号
    UILabel *orderNumLbl = [UILabel labelWithFrame:CGRectMake(15, line.yy + 10, SCREEN_WIDTH - 30, [FONT(13) lineHeight])
                                   textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor clearColor]
                                           font:FONT(13)
                                      textColor:[UIColor zh_textColor]];
    [headerV addSubview:orderNumLbl];
    
    //时间
    UILabel *timeLbl = [UILabel labelWithFrame:CGRectMake(15, orderNumLbl.yy + 10, SCREEN_WIDTH - 30, [FONT(13) lineHeight])
                                      textAligment:NSTextAlignmentLeft
                                   backgroundColor:[UIColor clearColor]
                                              font:FONT(13)
                                         textColor:[UIColor zh_textColor]];
    [headerV addSubview:timeLbl];
    
    //状态
    UILabel *statusLbl = [UILabel labelWithFrame:CGRectMake(15, timeLbl.yy + 10, SCREEN_WIDTH - 30, [FONT(13) lineHeight])
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor clearColor]
                                          font:FONT(13)
                                     textColor:[UIColor zh_textColor]];
    [headerV addSubview:statusLbl];
    
    headerV.height = statusLbl.yy  + 10;
    
    //
    titleLbl.text = @"订单信息";
    orderNumLbl.text = [NSString stringWithFormat:@"订单号：%@",self.shopOrder.code];
    timeLbl.text = [NSString stringWithFormat:@"下单时间：%@",[self.shopOrder.createDatetime convertToDetailDate]] ;
    
    statusLbl.text = [NSString stringWithFormat:@"订单状态：%@",[self.shopOrder getStatusName]];
    return headerV;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    ZHShopOrderDetailVC *vc = [[ZHShopOrderDetailVC alloc] init];
//    vc.shopOrder = self.shopOrders[indexPath.section];
//    [self.navigationController pushViewController:vc                            animated:YES];
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}


#pragma mark- dasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *zhShopOrderCellId = @"zhShopOrderCellId";
    ZHShopOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:zhShopOrderCellId];
    if (!cell) {
        
        cell = [[ZHShopOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:zhShopOrderCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    cell.shopOrderModel = self.shopOrder;
    
    return cell;
}

@end
