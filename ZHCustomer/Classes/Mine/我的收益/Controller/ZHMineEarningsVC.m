//
//  ZHMineEarningsVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/3/22.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHMineEarningsVC.h"
#import "ZHProfitDetailVC.h"

@interface ZHMineEarningsVC ()

//基金
@property (nonatomic, strong) UILabel *amountLbl;

//分红权
@property (nonatomic, strong) UILabel *profitCountLbl;

//收益
@property (nonatomic, strong) UILabel *todayEarningsLbl;

//鼓励
@property (nonatomic, strong) UILabel *motivationLbl;

@end

@implementation ZHMineEarningsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收益";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_earnings_bg"]];
    [self.view  addSubview:bgImageView];
    bgImageView.frame = CGRectMake(0, - 64, SCREEN_WIDTH, 258);
    
    //
    UILabel *hintLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentCenter
                               backgroundColor:[UIColor clearColor]
                                          font:FONT(14)
                                     textColor:[UIColor whiteColor]];
    [bgImageView addSubview:hintLbl];
    hintLbl.text = @"理财基金(元)";
    
    //
    self.amountLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentCenter
                               backgroundColor:[UIColor clearColor]
                                          font:FONT(35)
                                     textColor:[UIColor whiteColor]];
    [bgImageView addSubview:self.amountLbl];
    [self.amountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(bgImageView);
        make.bottom.equalTo(bgImageView.mas_bottom).offset(-100);
    }];
    
    [hintLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(bgImageView);
        make.bottom.equalTo( self.amountLbl.mas_top).offset(-28);
        
    }];
    
    
    
    // 和 今日收益
    UIView *headerFooterView = [[UIView alloc] init];
    [bgImageView addSubview:headerFooterView];
    headerFooterView.userInteractionEnabled = YES;
    bgImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookDetail)];
    [headerFooterView addGestureRecognizer:tap];
    
    headerFooterView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.08];
    [headerFooterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(bgImageView);
        make.height.mas_equalTo(60);
    }];
    
    //
    UILabel *profitHintLbl = [UILabel labelWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, [FONT(14) lineHeight])
                                  textAligment:NSTextAlignmentCenter
                               backgroundColor:[UIColor clearColor]
                                          font:FONT(14)
                                     textColor:[UIColor whiteColor]];
    [headerFooterView addSubview:profitHintLbl];
    profitHintLbl.text = @"分红权（个）";
    
    //分红个数
    self.profitCountLbl = [UILabel labelWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, [FONT(14) lineHeight])
                                  textAligment:NSTextAlignmentCenter
                               backgroundColor:[UIColor clearColor]
                                          font:FONT(16)
                                     textColor:[UIColor whiteColor]];
    [headerFooterView addSubview:self.profitCountLbl];
    
    
    UILabel *todayEarningsHintLbl = [UILabel labelWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, [FONT(14) lineHeight])
                                  textAligment:NSTextAlignmentCenter
                               backgroundColor:[UIColor clearColor]
                                          font:FONT(14)
                                     textColor:[UIColor whiteColor]];
    [headerFooterView addSubview:todayEarningsHintLbl];
    todayEarningsHintLbl.text = @"今日收益（元）";
    
    self.todayEarningsLbl = [UILabel labelWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, [FONT(14) lineHeight])
                                  textAligment:NSTextAlignmentCenter
                               backgroundColor:[UIColor clearColor]
                                          font:FONT(16)
                                     textColor:[UIColor whiteColor]];
    [headerFooterView addSubview:self.todayEarningsLbl];
    
    //约束
    [profitHintLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(headerFooterView.mas_left);
        make.top.equalTo(headerFooterView.mas_top).offset(10);
        make.width.equalTo(headerFooterView.mas_width).multipliedBy(0.5);
        
    }];
    [todayEarningsHintLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(headerFooterView.mas_top).offset(10);
        make.left.equalTo(profitHintLbl.mas_right);
        make.right.equalTo(headerFooterView.mas_right);
        
    }];
    
    //
    [self.profitCountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(profitHintLbl);
        make.top.equalTo(profitHintLbl.mas_bottom).offset(8);
        
    }];
    
    [self.todayEarningsLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(todayEarningsHintLbl);
        make.top.equalTo(self.profitCountLbl.mas_top);
        
    }];
    
    //arrow
    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_eqraings_more"]];
    [headerFooterView addSubview:arrowImageView];
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerFooterView.mas_centerY);
        make.right.equalTo(headerFooterView.mas_right).offset(-15);
    }];
    
    //火箭
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"火箭"]];
    [self.view addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(bgImageView.mas_bottom).offset(40);
    }];
    
    //
    
    self.motivationLbl = [UILabel labelWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, [FONT(14) lineHeight])
                                       textAligment:NSTextAlignmentCenter
                                    backgroundColor:[UIColor clearColor]
                                               font:FONT(16)
                                          textColor:[UIColor zh_textColor]];
    [self.view addSubview:self.motivationLbl];
    self.motivationLbl.numberOfLines = 0;
    
    //约束
    [self.motivationLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.view);
        make.top.equalTo(iconImageView.mas_bottom).offset(20);
        
    }];

    self.motivationLbl.text = @"冲一冲\n再500元消费额\n您将新获得一个分红权";
    self.amountLbl.text = @"100.22";
    self.profitCountLbl.text = @"332";
    self.todayEarningsLbl.text = @"33.32";
    
}

- (void)lookDetail {

    ZHProfitDetailVC *vc = [ZHProfitDetailVC new];
    [self.navigationController pushViewController:vc animated:YES];

}



@end
