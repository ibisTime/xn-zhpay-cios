//
//  ZHBuyHZBVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/8.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHBuyHZBVC.h"
#import "ZHPayVC.h"
#import "ZHHZBModel.h"
#import "ZHRealNameAuthVC.h"

@interface ZHBuyHZBVC ()

@property (nonatomic,strong) ZHHZBModel *HZBModel;


@end

@implementation ZHBuyHZBVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购买汇赚宝";
    
    //先查出
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"808451";
    http.parameters[@"token"] = [ZHUser user].token;

    [http postWithSuccess:^(id responseObject) {
        
        NSDictionary *dict = responseObject[@"data"][0];
        self.HZBModel = [ZHHZBModel tl_objectWithDictionary:dict];
        [self setUpUI];
    } failure:^(NSError *error) {
        
        
    }];

    
    

 
}

#pragma mark-
- (void)buy {
    
    //进行实名认真之后才能提现
    if (![ZHUser user].realName) {
        [TLAlert alertWithTitle:nil Message:@"您还未进行实名认证\n前往进行实名认证" confirmMsg:@"前往" CancleMsg:@"取消" cancle:^(UIAlertAction *action) {
            
        } confirm:^(UIAlertAction *action) {
            
            ZHRealNameAuthVC *authVC = [[ZHRealNameAuthVC alloc] init];
            authVC.authSuccess = ^(){ //实名认证成功
                
            };
            [self.navigationController pushViewController:authVC animated:YES];
            
        }];
        
        return;
    }

    //只能使用 --- 人民币 或者 ---分润----- 购买
    ZHPayVC *payVC = [[ZHPayVC alloc] init];
    payVC.type = ZHPayVCTypeHZB;
    payVC.paySucces = ^(){
        
//        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HZBBuySuccess" object:nil];
        
    };
    payVC.HZBModel = self.HZBModel;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:payVC];
    [self presentViewController:nav animated:YES completion:nil];
    
}


- (void)setUpUI {

    
    UIImageView *treeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 65, 250, 250)];
    treeView.centerX = self.view.width/2.0;
    treeView.image = [UIImage imageNamed:@"hzb_tree"];
    [self.view addSubview:treeView];
    
    UIButton *buyBtn = [UIButton zhBtnWithFrame:CGRectMake(20, treeView.yy + 30, SCREEN_WIDTH - 40, 45) title:@"购买"];
    [self.view addSubview:buyBtn];
    [buyBtn addTarget:self action:@selector(buy) forControlEvents:UIControlEventTouchUpInside];
}

@end
