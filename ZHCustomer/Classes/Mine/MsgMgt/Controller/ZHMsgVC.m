//
//  ZHMsgVC.m
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/22.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHMsgVC.h"
#import "ZHMsgCell.h"
#import "TLPageDataHelper.h"
#import "ZHMsg.h"

@interface ZHMsgVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray <ZHMsg *> *msgs;
@property (nonatomic,strong) TLTableView *msgTV;
@property (nonatomic,assign) BOOL isFirst;


@end


@implementation ZHMsgVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"系统消息";
    
    self.isFirst = YES;
    
    TLTableView *msgTableView = [TLTableView tableViewWithframe:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)
                                                       delegate:self
                                                     dataSource:self];
    msgTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.view addSubview:msgTableView];
    self.msgTV = msgTableView;
    
    msgTableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无消息"];
    
    __weak typeof(self) weakSelf = self;
    TLPageDataHelper *pageDataHelper = [[TLPageDataHelper alloc] init];
    pageDataHelper.code = @"804040";
    pageDataHelper.tableView = msgTableView;
    pageDataHelper.parameters[@"token"] = [ZHUser user].token ? : nil;
    
    pageDataHelper.parameters[@"channelType"] = @"4";
    pageDataHelper.parameters[@"pushType"] = @"41";
    pageDataHelper.parameters[@"toKind"] = @"1";
    pageDataHelper.parameters[@"fromSystemCode"] = @"CD-CZH000001";

//    1 立即发 2 定时发
    pageDataHelper.parameters[@"smsType"] = @"1";
    
    //0 未读 1 已读 2未读被删 3 已读被删
//    pageDataHelper.parameters[@"status"] = @"0";
//    pageDataHelper.parameters[@"dateStart"] = @""; //开始时间
    [pageDataHelper modelClass:[ZHMsg class]];
    
    [msgTableView addRefreshAction:^{
        
        [pageDataHelper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            self.msgs = objs;
            [weakSelf.msgTV reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    
    [msgTableView addLoadMoreAction:^{
        
        [pageDataHelper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            self.msgs = objs;
            [weakSelf.msgTV reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];

        
    }];
    

}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    if (self.isFirst) {
        
        self.isFirst = NO;

        [self.msgTV beginRefreshing];

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return self.msgs[indexPath.row].contentHeight + 20 + 15 + 73;

    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.msgs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *msgCellId = @"msgCellId";
    ZHMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:msgCellId];
    
    if (!cell) {
        cell = [[ZHMsgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:msgCellId];
    }
    
    cell.msg = self.msgs[indexPath.row];
    return cell;

}

@end
