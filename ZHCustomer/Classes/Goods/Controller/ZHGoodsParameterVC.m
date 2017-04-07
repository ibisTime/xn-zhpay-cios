//
//  ZHGoodsParameterVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/4/6.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHGoodsParameterVC.h"
#import "ZHParameterCell.h"
#import "ZHGoodsKeyValue.h"

@interface ZHGoodsParameterVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) TLTableView *paramTableView;
@property (nonatomic, copy) NSArray <ZHGoodsKeyValue *>*keyValueArray;

@end

@implementation ZHGoodsParameterVC

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [self.paramTableView beginRefreshing];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.paramTableView = [TLTableView tableViewWithframe:CGRectZero delegate:self dataSource:self];
    [self.view addSubview:self.paramTableView];
    self.paramTableView.delegate = self;
    self.paramTableView.dataSource = self;
    self.paramTableView.estimatedRowHeight = 60;
    self.paramTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
     self.paramTableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无产品参数"];

    [self.paramTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    
    __weak typeof(self) weakSelf = self;
    [self.paramTableView addRefreshAction:^{
        
        //查看产品参数
        TLNetworking *http = [TLNetworking new];
        http.code = @"808037";
        http.parameters[@"productCode"] = weakSelf.productCode;
        [http postWithSuccess:^(id responseObject) {
            
            weakSelf.keyValueArray = [ZHGoodsKeyValue tl_objectArrayWithDictionaryArray:responseObject[@"data"]];
            [weakSelf.paramTableView reloadData_tl];
            
            [weakSelf.paramTableView endRefreshHeader];
            
        } failure:^(NSError *error) {
            
            [weakSelf.paramTableView reloadData_tl];
            [weakSelf.paramTableView endRefreshHeader];
            
        }];
        
        
    }];
    
    
}


//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.keyValueArray.count;

}

//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ZHParameterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZHParameterCellId"];
    if (!cell) {
        
        cell = [[ZHParameterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZHParameterCellId"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    cell.keyLbl.text = self.keyValueArray[indexPath.row].dkey;
    cell.valueLbl.text = self.keyValueArray[indexPath.row].dvalue;

    return cell;

}


@end
