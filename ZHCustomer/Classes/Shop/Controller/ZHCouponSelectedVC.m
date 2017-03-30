//
//  ZHCouponSelectedVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/6.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHCouponSelectedVC.h"

@interface ZHCouponSelectedVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ZHCouponSelectedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TLTableView *tableV = [TLTableView groupTableViewWithframe:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 1) delegate:self dataSource:self];
    tableV.separatorStyle = UITableViewCellSeparatorStyleSingleLine;;
    [self.view addSubview:tableV];
    self.title = @"选择抵扣券";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.navigationController popViewControllerAnimated:YES];
    if (self.selected) {
        
        self.selected(self.coupons[indexPath.row]);
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.coupons.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
        cell.textLabel.textColor = [UIColor zh_themeColor];
    }
    
    ZHCoupon *coupon = self.coupons[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"满 %@减 %@",[coupon.storeTicket.key1 convertToSimpleRealMoney],[coupon.storeTicket.key2 convertToSimpleRealMoney]];
    return cell;

    
}
@end
