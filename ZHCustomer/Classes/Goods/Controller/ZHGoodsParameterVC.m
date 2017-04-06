//
//  ZHGoodsParameterVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/4/6.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHGoodsParameterVC.h"
#import "ZHParameterCell.h"

@interface ZHGoodsParameterVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ZHGoodsParameterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 60;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 10;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ZHParameterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZHParameterCellId"];
    if (!cell) {
        
        cell = [[ZHParameterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZHParameterCellId"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    cell.keyLbl.text = @"发觉你发只适合砸出只适合砸出你发觉只适合砸出你发觉只适合砸出你发觉只适合砸出你发觉只适合砸出你发觉只适合砸出你发觉只适合砸出你发觉你发节";
    cell.valueLbl.text = @"只适合砸出只适合砸出你发觉只适合砸出你发觉只适合砸出你发觉只适合砸出你发觉只适合砸出你发觉只适合砸出你发觉只适合砸出你发觉你发觉";

    return cell;

}


@end
