//
//  CDShopPaySuccessVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/6/10.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CDShopPaySuccessVC.h"
#import "TLHeader.h"
#import "UIColor+theme.h"

@interface CDShopPaySuccessVC ()

@end

@implementation CDShopPaySuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:0 target:self action:@selector(back)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //
    UIImageView *iconV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"正汇ICON"]];
    iconV.layer.cornerRadius = 5;
    iconV.layer.masksToBounds = YES;
    [self.view addSubview:iconV];
    
    
    UILabel *hintLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentCenter
                               backgroundColor:[UIColor whiteColor]
                                          font:[UIFont fontWithName:@"Impact" size:18]
                                     textColor:[UIColor themeColor]];
    [self.view addSubview:hintLbl];
    hintLbl.text = @"支付成功";
    
    //
    UILabel *moneyLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentCenter
                               backgroundColor:[UIColor whiteColor]
                                           font: [UIFont fontWithName:@"Impact" size:30]

                                     textColor:[UIColor themeColor]];
    [self.view addSubview:moneyLbl];
    moneyLbl.text = [NSString stringWithFormat:@"%@元",self.payMoney];
    
    //
    UILabel *timeLbl = [UILabel labelWithFrame:CGRectZero
                                   textAligment:NSTextAlignmentCenter
                                backgroundColor:[UIColor whiteColor]
                                           font: FONT(15)
                         
                                      textColor:[UIColor textColor]];
    [self.view addSubview:timeLbl];
    timeLbl.text = [NSString stringWithFormat:@"%@元",self.payMoney];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
    timeLbl.text = [NSString stringWithFormat:@"支付时间：%@",[formatter stringFromDate:[NSDate date]]];

    //商家名称
    UILabel *shopNameLbl = [UILabel labelWithFrame:CGRectZero
                            
                                   textAligment:NSTextAlignmentCenter
                                backgroundColor:[UIColor whiteColor]
                                           font: FONT(15)
                            
                                      textColor:[UIColor textColor]];
    [self.view addSubview:shopNameLbl];
    shopNameLbl.text = [NSString stringWithFormat:@"商家名称：%@",self.shopName];
    shopNameLbl.numberOfLines = 0;
    
    [iconV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(60);
        make.width.height.mas_equalTo(70);
    }];
    
    //
    [hintLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(iconV.mas_bottom).offset(30);
        
    }];
    
    [moneyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(hintLbl.mas_bottom).offset(30);
        
    }];
    
    
    
    [shopNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(moneyLbl.mas_bottom).offset(20);
        
    }];
    
    [timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(shopNameLbl.mas_bottom).offset(20);
        
    }];
    
    
}

- (void)back {

    [self.navigationController dismissViewControllerAnimated:YES completion:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
