//
//  ZHHBConvertFRVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/3.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHHBConvertFRVC.h"

@interface ZHHBConvertFRVC ()

@property (nonatomic,strong) TLTextField *convertMoneytf;


@end

@implementation ZHHBConvertFRVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"转分润";
    
    UIImageView *bgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 115)];
    bgV.image = [UIImage imageNamed:@"转分润背景"];
    bgV.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:bgV];
    
    //hintLbl
    UILabel *hintLbl = [UILabel labelWithFrame:CGRectMake(LEFT_MARGIN, 20, SCREEN_WIDTH - 30, [FONT(13) lineHeight]) textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor clearColor]
                                          font:FONT(13)
                                     textColor:[UIColor whiteColor]];
    hintLbl.text = @"可转余额";
    [bgV addSubview:hintLbl];
    //
    UILabel *moneyLbl = [UILabel labelWithFrame:CGRectMake(LEFT_MARGIN, hintLbl.yy + 12, SCREEN_WIDTH - 30, [FONT(45) lineHeight]) textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor clearColor]
                                          font:FONT(45)
                                     textColor:[UIColor whiteColor]];
    [bgV addSubview:moneyLbl];
    
    //
    self.convertMoneytf = [[TLTextField alloc] initWithframe:CGRectMake(0, bgV.yy + 10, SCREEN_WIDTH, 50)
                                                   leftTitle:@"转换金额"
                                                  titleWidth:100
                                                 placeholder:@"请输入转入金额"];
    [self.view addSubview:self.convertMoneytf];
    self.convertMoneytf.keyboardType = UIKeyboardTypeDecimalPad;
    
    //btn
    
    UIButton *confirmBtn = [UIButton zhBtnWithFrame:CGRectMake(20, self.convertMoneytf.yy + 30, SCREEN_WIDTH - 40, 45) title:@"确定"];
    [self.view addSubview:confirmBtn];
    [confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    
    
    //总额赋值
    moneyLbl.text = [self.amount convertToRealMoney];

}

- (void)confirm {

    
       if (![self.convertMoneytf.text valid]) {
        
           [TLAlert alertWithHUDText:@"请输入转换金额"];
           return;
        
        }
    
//         CGFloat money = [self.convertMoneytf.text floatValue];
    
      if ([self.convertMoneytf.text greaterThan:self.amount]) {
        
//               scMoney > [self.amount longLongValue]/1000.0
          [TLAlert alertWithHUDText:@"转换金额不能超过总额"];
           return;
       }
    
        TLNetworking *http = [TLNetworking new];
 
        http.showView = self.view;
        http.code = @"802518";
        http.parameters[@"token"] = [ZHUser user].token;
        http.parameters[@"userId"] = [ZHUser user].userId;
        http.parameters[@"transAmount"] = [self.convertMoneytf.text convertToSysMoney];
//    [NSString stringWithFormat:@"%.f",[self.convertMoneytf.text floatValue]*1000];
    
//      50=红包兑分润 52=红包业绩兑分润 54=红包业绩兑贡献值
        switch (self.type) {
                
            case ZHCurrencyConvertHBToFR:
                http.parameters[@"bizType"] = @"50";
                break;
                
            case ZHCurrencyConvertHBYJToFR:
                http.parameters[@"bizType"] = @"52";
                break;
                
            case ZHCurrencyConvertHBYJToGXJL:
                http.parameters[@"bizType"] = @"54";
                break;
        }

        [http postWithSuccess:^(id responseObject) {
            
            [TLAlert alertWithHUDText:@"提交成功\n我们会对这笔交易进行审核"];
            [self.navigationController popViewControllerAnimated:YES];
            if (self.success) {
                self.success();
            }
            
        } failure:^(NSError *error) {
            
        }];



}

@end
