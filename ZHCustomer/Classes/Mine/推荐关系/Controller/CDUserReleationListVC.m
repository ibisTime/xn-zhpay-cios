//
//  CDUserReleationVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/6/8.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CDUserReleationListVC.h"
#import "ZHReferralModel.h"
#import "ZHChatUserCell.h"
#import "TLHeader.h"
#import "ZHUser.h"
#import "UIColor+theme.h"

@interface CDUserReleationListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) TLTableView *releationTableView;

@property (nonatomic, strong) NSNumber *below_1_count;
@property (nonatomic, strong) NSNumber *below_2_count;
@property (nonatomic, strong) NSNumber *below_3_count;


@property (nonatomic, copy) NSArray <ZHReferralModel *>*users;

@property (nonatomic, assign) BOOL isFirst;

@end

@implementation CDUserReleationListVC

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    if (self.isFirst) {
        
        [self.releationTableView beginRefreshing];
        self.isFirst = NO;
    }

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.isFirst = YES;
    if (!self.level) {
        return;
    }
    
    //
    self.releationTableView = [TLTableView tableViewWithframe:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)
                                                     delegate:self
                                                   dataSource:self];
    [self.view addSubview:self.releationTableView];
    self.releationTableView.allowsSelection = NO;
    
    self.releationTableView.rowHeight = [ZHChatUserCell rowHeight];
    
    self.releationTableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"尚无用户"];
    
    //
    __weak typeof(self) weakSelf = self;
    // -1上级 -2上上级  1.下级 2. 下下级
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    helper.code = @"805205";
    helper.parameters[@"token"] = [ZHUser user].token;
    helper.parameters[@"refLevel"] = self.level;
    helper.parameters[@"userId"] = [ZHUser user].userId;
    helper.tableView = self.releationTableView;
    [helper modelClass:[ZHReferralModel class]];
    [self.releationTableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.users = objs;
            [weakSelf.releationTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    [self.releationTableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.users = objs;
            [weakSelf.releationTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.users.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZHChatUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZHChatUserCell"];
    if (!cell) {
        
        cell = [[ZHChatUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZHChatUserCell"];
        
    }
    
    //
    cell.level = self.level;
    cell.referral = self.users[indexPath.row];
    
    //
    return cell;
}



@end
