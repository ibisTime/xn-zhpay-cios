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
#import "TLHeader.h"
#import "ZHUser.h"
#import "UIColor+theme.h"
#import "RecommendMerchantVC.h"

@interface CDUserReleationVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) TLTableView *releationTableView;

@property (nonatomic, strong) NSNumber *below_1_count;
@property (nonatomic, strong) NSNumber *below_2_count;
@property (nonatomic, strong) NSNumber *below_3_count;
@property (nonatomic, strong) NSNumber *recomMerchantCount;

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

    
    dispatch_group_t group = dispatch_group_create();
    
    
    NSInteger reqCount = 0;
    __block NSInteger successCount = 0;
    
    reqCount ++;
    dispatch_group_enter(group);
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"805800";
    http.parameters[@"token"] = [ZHUser user].token;
    http.parameters[@"userId"] = [ZHUser user].userId;
    [http postWithSuccess:^(id responseObject) {
        
        successCount ++;
        dispatch_group_leave(group);
        self.below_1_count =  responseObject[@"data"][@"oneRefCount"];
        self.below_2_count =  responseObject[@"data"][@"twoRefCount"];
        self.below_3_count =  responseObject[@"data"][@"threeRefCount"];
        
    } failure:^(NSError *error) {
        
        dispatch_group_leave(group);


    }];


    reqCount ++;
    dispatch_group_enter(group);
    TLNetworking *getMerchantCountHttp = [TLNetworking new];
    getMerchantCountHttp.code = @"808220";
    getMerchantCountHttp.showView = self.view;
    getMerchantCountHttp.parameters[@"userReferee"] = [ZHUser user].userId;
    [getMerchantCountHttp postWithSuccess:^(id responseObject) {
        
        successCount ++;
        dispatch_group_leave(group);
        self.recomMerchantCount = responseObject[@"data"][@"totalCount"];
        
    } failure:^(NSError *error) {
        
        dispatch_group_leave(group);

        
    }];
    
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
       
        if (reqCount == successCount) {
            [self removePlaceholderView];

            [self setUpUI];
            
        } else {
        
            [self addPlaceholderView];

        }
        
    });

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0) {
    
        return;
    }
    

  
    //
    switch (indexPath.row) {
        case 0: {
        
            CDUserReleationListVC *vc = [[CDUserReleationListVC alloc] init];
            vc.level = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
            vc.title = @"下一级";
            [self.navigationController pushViewController:vc animated:YES];
            
        } break;
            
        case 1: {
            
            CDUserReleationListVC *vc = [[CDUserReleationListVC alloc] init];
            vc.level = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
            vc.title = @"下二级";
            [self.navigationController pushViewController:vc animated:YES];
            
        } break;
            
        case 2: {
          
            RecommendMerchantVC *vc = [RecommendMerchantVC new];
            [self.navigationController pushViewController:vc animated:YES];
            
            

        } break;

    }
    
    //
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return indexPath.section == 0 ? [ZHChatUserCell rowHeight] : 40;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {


    return 2;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return section == 0 ? 5 : 10;

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return section == 0 ? 1 : 3;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0) {
        
        ZHChatUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZHChatUserCell"];
        if (!cell) {
            
            cell = [[ZHChatUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZHChatUserCell"];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        //
        cell.level = @"0";
        ZHReferralModel *model = [ZHReferralModel new];
        model.userExt = [ZHUser user].userExt;
        model.nickname = [ZHUser user].nickname;
        model.userRefereeName = [ZHUser user].userRefereeName;
        model.createDatetime = [ZHUser user].createDatetime;
        cell.referral = model;
        
        //
        return cell;
    }


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
            
        levelStr =  [NSString stringWithFormat:@"%@(%@)",@"推荐商家",self.recomMerchantCount];
            
        } break;
            
    }
    
    //
    cell.textLabel.text = levelStr;
    return cell;
}



@end
