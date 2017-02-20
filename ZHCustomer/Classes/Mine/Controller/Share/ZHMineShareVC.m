//
//  ZHMineShareVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/3.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHMineShareVC.h"
#import "ZHBuyShareVC.h"
#import "ZHMonthCardModel.h"

@interface ZHMineShareVC ()

@property (nonatomic,strong) ZHMonthCardModel *mothCard;

@property (nonatomic,strong) TLTextField *rewardtf;
@property (nonatomic,strong) TLTextField *nextRewardTf;

@property (nonatomic,strong) ZHBuyShareVC *buyShareVC;
@end

@implementation ZHMineShareVC

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (ZHBuyShareVC *)buyShareVC {

    if (!_buyShareVC) {
        
        _buyShareVC = [[ZHBuyShareVC alloc] init];
    }
    
    return _buyShareVC;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的福利月卡";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"玩法介绍" style:UIBarButtonItemStylePlain target:self action:@selector(goIntroduce)];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buySuccess) name:@"monthCardBuySuccess" object:nil];
    
    //先查询是否有，福利月卡
    [self buySuccess];

}

//已经结算的数据

//backNum = 10;
//backWelfare1 = 200000;
//backWelfare2 = 20000;
//id = 5;
//status = 2;
//stockCode = ST00000001;
//systemCode = "CD-CZH000001";
//userId = U2017042813592079863;


//还未结算的数据
//backNum = 2;
//backWelfare1 = 2000000;
//backWelfare2 = 200000;
//id = 1;

//nextBack = "May 28, 2017 12:00:00 AM";

//status = 1;
//stockCode = ST00000002;
//systemCode = "CD-CZH000001";
//userId = U2017011704242588411;

- (void)buySuccess {


    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"808406";
    http.parameters[@"userId"] = [ZHUser user].userId;
    http.parameters[@"token"] = [ZHUser user].token;
    [http postWithSuccess:^(id responseObject) {
        
        NSDictionary *dict = responseObject[@"data"];
        if (dict.allKeys.count > 0) {
            
            if (self.buyShareVC.view) {
                
                [self.buyShareVC.view removeFromSuperview];
            }
            
            if (self.buyShareVC) {
                
                [self.buyShareVC removeFromParentViewController];
                
            }

            self.mothCard = [ZHMonthCardModel tl_objectWithDictionary:dict];
            [self setUpUI];
            //
            
        } else {
            
            [self addChildViewController:self.buyShareVC];
            [self.view addSubview:self.buyShareVC.view];
            
        }
        
    } failure:^(NSError *error) {
        
        
    }];


}

//- (UIView *)placholderView {
//
//    if (!_placeholderView) {
//        
//        UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
//        
//        UILabel *lbl = [UILabel labelWithFrame:CGRectMake(0, 100, view.width, 50) textAligment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor] font:FONT(18) textColor:[UIColor zh_textColor]];
//        [view addSubview:lbl];
//        lbl.text = @"您还未购买月卡";
//        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, lbl.yy + 10, 200, 40)];
//        [self.view addSubview:btn];
//        btn.titleLabel.font = FONT(15);
//        [btn setTitleColor:[UIColor zh_themeColor] forState:UIControlStateNormal];
//        btn.centerX = view.width/2.0;
//        btn.layer.cornerRadius = 5;
//        btn.layer.borderWidth = 1;
//        btn.layer.borderColor = [UIColor zh_themeColor].CGColor;
//        [btn addTarget:self action:@selector(buy) forControlEvents:UIControlEventTouchUpInside];
//        [btn setTitle:@"->前往购买" forState:UIControlStateNormal];
//        [view addSubview:btn];
//
//        _placeholderView = view;
//    }
//    return _placeholderView;
//
//}


- (void)buy {

    
    ZHBuyShareVC *buyVC = [[ZHBuyShareVC alloc] init];
    [self.navigationController pushViewController:buyVC animated:YES];

}

- (void)setUpUI {

    //数据
    NSArray *titles = @[@"隶属辖区",@"总股本",@"类型",@"已得奖励",@"下次奖励"];
    
    
    NSString *address = [[ZHUser user] detailAddress];
    NSMutableArray *contents =[NSMutableArray arrayWithArray:@[address,
                                                               [NSString stringWithFormat:@"%@",self.mothCard.stock.capital],
                                                               @"月卡",
                                                               [NSString stringWithFormat:@"%@贡献奖励 + %@购物币",[self.mothCard.backWelfare1 convertToRealMoney],[self.mothCard.backWelfare2 convertToRealMoney]]
                                                               ]];
    
    if ([self.mothCard.status isEqualToString:@"1"]) {
        
        [contents addObject:[self.mothCard.nextBack converDate]];
        
    }
    
    //
    
    UIScrollView *bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    [self.view addSubview:bgScrollView];
    bgScrollView.backgroundColor = [UIColor zh_backgroundColor];
    
    //头部
    UIView *headerV = [self headerView];
    [bgScrollView addSubview:headerV];
    
    

    
    UIView *lastV;
    for (NSInteger i = 0; i < contents.count; i++) {
        
        TLTextField *tf = [self tfByframe:CGRectMake(0,headerV.yy+ 1 + i*51, SCREEN_WIDTH, 50) leftTitle:titles[i] titleWidth:98 placeholder:nil];
        tf.text = contents[i];
        [bgScrollView addSubview:tf];
        if (i == titles.count - 1) {
            lastV = tf;
        }
        
        if ([titles[i] isEqualToString:@"已得奖励"]) {
            
            self.rewardtf = tf;
            
        } else if ([titles[i] isEqualToString:@"下次奖励"]) {
        
            self.nextRewardTf = tf;
            
        }
        
    }
    
    UIButton *btn = [UIButton zhBtnWithFrame:CGRectMake(LEFT_MARGIN, lastV.yy + 30, SCREEN_WIDTH - LEFT_MARGIN * 2, 45) title:@"签到领奖"];
    [bgScrollView addSubview:btn];
    [btn addTarget:self action:@selector(getEarnings) forControlEvents:UIControlEventTouchUpInside];
    
    if ([self.mothCard.status isEqualToString:@"2"]) { //已经清算
        btn.hidden = YES;
    }

}

- (void)getEarnings {

   //领取奖励
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"808404";
    http.parameters[@"userId"] = [ZHUser user].userId;
    http.parameters[@"token"] = [ZHUser user].token;
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithHUDText:@"领取奖励成功" duration:1.5 complection:^{
            
            TLNetworking *http = [TLNetworking new];
            http.showView = self.view;
            http.code = @"808406";
            http.parameters[@"userId"] = [ZHUser user].userId;
            http.parameters[@"token"] = [ZHUser user].token;
            [http postWithSuccess:^(id responseObject) {
                
                self.mothCard = [ZHMonthCardModel tl_objectWithDictionary:responseObject[@"data"]];
                
                self.rewardtf.text = [NSString stringWithFormat:@"%@贡献奖励 + %@购物币",[self.mothCard.backWelfare1 convertToRealMoney],[self.mothCard.backWelfare2 convertToRealMoney]];
                self.nextRewardTf.text = [self.mothCard.nextBack converDate];
                
                
            } failure:nil];
            
            
        } ];
        
    } failure:^(NSError *error) {
        
    }];


}

- (void)goIntroduce {
    
    [TLAlert alertWithHUDText:@"查看玩法"];
    
}

- (UIView *)headerView {

    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90)];
    headerV.backgroundColor = [UIColor whiteColor];
    UIImageView *headerImageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 60, 60)];
    headerImageV.layer.cornerRadius = 30;
    headerImageV.clipsToBounds = YES;
    [headerV addSubview:headerImageV];
    
    if ([ZHUser user].userExt.photo) {
     
           [headerImageV sd_setImageWithURL:[NSURL URLWithString: [[ZHUser user].userExt.photo convertThumbnailImageUrl]] placeholderImage:[UIImage imageNamed:@"user_placeholder"]];
    } else {
    
        headerImageV.image = [UIImage imageNamed:@"user_placeholder"];
    }
 

    //股东
    TLTextField *nameTf = [self tfByframe:CGRectMake(headerImageV.xx + 22, 23, SCREEN_WIDTH - headerV.yy - 23 , [[UIFont secondFont] lineHeight]) leftTitle:@"股东：" titleWidth:70 placeholder:nil];
//    nameTf.text = @"藏啊按时";
    [headerV addSubview:nameTf];
    nameTf.text = [ZHUser user].nickname;
    
    //状态
    TLTextField *statusTf = [self tfByframe:CGRectMake(headerImageV.xx + 22, nameTf.yy + 10, SCREEN_WIDTH - headerV.yy - 23 , [[UIFont secondFont] lineHeight]) leftTitle:@"状态：" titleWidth:70 placeholder:nil];
    statusTf.text = [self.mothCard getStatusName];
    [headerV addSubview:statusTf];
    
    
    return headerV;

}



- (TLTextField *)tfByframe:(CGRect)frame
                 leftTitle:(NSString *)leftTitle
                titleWidth:(CGFloat)titleW
               placeholder:(NSString *)placeholder {

    TLTextField *tf = [[TLTextField alloc] initWithframe:frame leftTitle:leftTitle titleWidth:titleW placeholder:placeholder];
    UILabel *lbl = (UILabel *)tf.leftView.subviews[0];
    lbl.textColor = [UIColor zh_textColor2];
    tf.textColor = [UIColor zh_textColor];
    
    tf.enabled = NO;
    return tf;

}



@end
