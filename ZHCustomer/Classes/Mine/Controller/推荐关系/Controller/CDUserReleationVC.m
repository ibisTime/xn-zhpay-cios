//
//  CDUserReleationVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/6/8.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CDUserReleationVC.h"
#import "CDUserReleationListVC.h"
#import "ZHChatUserCell.h"

@interface CDUserReleationVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) TLTableView *releationTableView;

@property (nonatomic, strong) NSNumber *below_1_count;
@property (nonatomic, strong) NSNumber *below_2_count;
@property (nonatomic, strong) NSNumber *below_3_count;

@end

@implementation CDUserReleationVC

- (void)viewDidLoad {

    [super viewDidLoad];
    self.title = @"推荐关系";
    

    [self setPlaceholderViewTitle:@"加载失败" operationTitle:@"重新加载"];
    [self tl_placeholderOperation];
    
}

- (void)setUpUI {

    //
    self.releationTableView = [TLTableView tableViewWithframe:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)
                                                     delegate:self
                                                   dataSource:self];
    [self.view addSubview:self.releationTableView];
    self.releationTableView.delegate = self;
    self.releationTableView.dataSource = self;
    self.releationTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}


- (void)tl_placeholderOperation {

    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"805800";
    http.parameters[@"token"] = [ZHUser user].token;
    http.parameters[@"userId"] = [ZHUser user].userId;
    [http postWithSuccess:^(id responseObject) {
        
        [self removePlaceholderView];
        self.below_1_count =  responseObject[@"data"][@"oneRefCount"];
        self.below_2_count =  responseObject[@"data"][@"twoRefCount"];
        self.below_3_count =  responseObject[@"data"][@"threeRefCount"];
        
        [self setUpUI];
    } failure:^(NSError *error) {
        
        [self addPlaceholderView];

    }];


}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    

    CDUserReleationListVC *vc = [[CDUserReleationListVC alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
    //
    vc.level = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    switch (indexPath.row) {
        case 0: {
        
            vc.title = @"下一级";
            
        } break;
            
        case 1: {
            
            vc.title = @"下二级";

        } break;
            
        case 2: {
            
            vc.title = @"下三级";

        } break;

    }
    
    //
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {


    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 3;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (indexPath.section == 0) {
//        
//        ZHChatUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZHChatUserCell"];
//        if (!cell) {
//            
//            cell = [[ZHChatUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZHChatUserCell"];
//            
//        }
//        
//        ZHReferralModel *model = [ZHReferralModel new];
////        model.createDatetime = [ZHUser user].;
//        model.userRefereeName = [ZHUser user].userRefereeName;
//        model.userExt = [ZHUser user].userExt;
//        
//        //
//        cell.level = @"0";
//        cell.referral = model;
//        
//        //
//        return cell;
//        
//    }

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellId"];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCellId"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor lineColor];
        [cell addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.mas_left);
            make.width.equalTo(cell.mas_width);
            make.height.mas_equalTo(LINE_HEIGHT);
            make.bottom.equalTo(cell.mas_bottom);
        }];
        
        cell.textLabel.textColor = [UIColor textColor];
        cell.textLabel.font = FONT(14);
        
    }
    
    NSString *levelStr = nil;
    switch (indexPath.row) {
        case 0: {
            
         levelStr =  [NSString stringWithFormat:@"%@(%@)",@"下一级",self.below_1_count];
        
        } break;
            
        case 1: {
            
         levelStr =  [NSString stringWithFormat:@"%@(%@)",@"下二级",self.below_2_count];
        } break;
            
        case 2: {
            
 levelStr =  [NSString stringWithFormat:@"%@(%@)",@"下三级",self.below_3_count];
        } break;
            
    }
    
    //
    cell.textLabel.text = levelStr;
    return cell;
}



@end
