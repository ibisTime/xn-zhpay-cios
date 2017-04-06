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

@property (nonatomic, strong) TLTableView *paramTableView;

@end

@implementation ZHGoodsParameterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.paramTableView = [TLTableView tableViewWithframe:CGRectZero delegate:self dataSource:self];
    [self.view addSubview:self.paramTableView];
    self.paramTableView.delegate = self;
    self.paramTableView.dataSource = self;
    self.paramTableView.estimatedRowHeight = 60;
    self.paramTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.paramTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    
//    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
//    
//    __weak typeof(self) weakSelf = self;
//    [self.paramTableView addRefreshAction:^{
//        
//        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
//            
//            weakSelf.goods = objs;
//            [weakSelf.paramTableView reloadData_tl];
//            
//        } failure:^(NSError *error) {
//            
//            
//        }];
//        
//    }];
//    
//    //---//
//    [self.paramTableView addLoadMoreAction:^{
//        
//        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
//            
//            weakSelf.goods = objs;
//            [weakSelf.goodsTableView reloadData_tl];
//            
//        } failure:^(NSError *error) {
//            
//            
//        }];
//        
//    }];
    
    
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
