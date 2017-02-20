//
//  ZHBuyShareVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/3.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHBuyShareVC.h"
#import "ZHMonthCardModel.h"
#import "ZHPayVC.h"

@interface ZHBuyShareVC ()

@property (nonatomic,strong) UIButton *lastMoneyBtn;
@property (nonatomic,strong) UIButton *lastTypeBtn;

//
@property (nonatomic,strong) UILabel *lastLbl;

//选中的价格Lbl
@property (nonatomic,strong) UILabel *selectedPriceLbl;


@property (nonatomic,strong) NSMutableArray <ZHMonthCardModel *>*mCards;
@end


@implementation ZHBuyShareVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购买福利月卡";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"玩法介绍" style:UIBarButtonItemStylePlain target:self action:@selector(goIntroduce)];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //查出信息
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"808401";
    http.parameters[@"start"] = @"1";
    http.parameters[@"limit"] = @"100";
    http.parameters[@"token"] = [ZHUser user].token;
    [http postWithSuccess:^(id responseObject) {
        
     self.mCards = [ZHMonthCardModel tl_objectArrayWithDictionaryArray:responseObject[@"data"][@"list"]];
        [self setUpUI];
        
    } failure:^(NSError *error) {
        
    }];
    

    
    
    
}

- (void)setUpUI {

    
    //类型Lbl
    UILabel *hintLbl1 = [UILabel labelWithFrame:CGRectMake(15, 20, SCREEN_WIDTH - 30, [FONT(14) lineHeight])
                                   textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor whiteColor]
                                           font:FONT(14)
                                      textColor:[UIColor zh_textColor]];
    [self.view addSubview:hintLbl1];
    hintLbl1.text = @"股份类型";
    
    // 股票类型--日月
    UIButton *dayBtn = [self btnWithFrame:CGRectMake(LEFT_MARGIN, hintLbl1.yy + 12, 90, 30) title:@"按月任务"];
    [self.view addSubview:dayBtn];
    self.lastTypeBtn = dayBtn;
    dayBtn.layer.borderColor = [UIColor zh_themeColor].CGColor;
    [dayBtn setTitleColor:[UIColor zh_themeColor] forState:UIControlStateNormal];
    dayBtn.tag = 100 + 1;
    [dayBtn addTarget:self action:@selector(chooseType:) forControlEvents:UIControlEventTouchUpInside];
    
    //
    //    UIButton *monBtn = [self btnWithFrame:CGRectMake(dayBtn.xx + 27 , hintLbl1.yy + 12, dayBtn.width, dayBtn.height) title:@"按月任务"];
    //    [self.view addSubview:monBtn];
    //    monBtn.tag = 100 + 2;
    //    [monBtn addTarget:self action:@selector(chooseType:) forControlEvents:UIControlEventTouchUpInside];
    
    //购买金额
    UILabel *hintLbl2 = [UILabel labelWithFrame:CGRectMake(15, dayBtn.yy + 35, SCREEN_WIDTH - 30, hintLbl1.height)
                                   textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor whiteColor]
                                           font:FONT(14)
                                      textColor:[UIColor zh_textColor]];
    [self.view addSubview:hintLbl2];
    hintLbl2.text = @"购买金额";
    
//    NSArray *tags = @[@"2千",@"1万",@"3万",@"5万"];
    
    //手机价格
//    NSMutableArray *prices = [NSMutableArray arrayWithCapacity:self.mCards.count];
    
    
    CGFloat  y = hintLbl2.yy + 12;
    CGFloat x = 0;
    
//    NSArray *tags = @[@"2000",@"10000",@"300000000000",@"5000",@"dfdsfdsfds",@"33333",@"33432423",@"23",@"323",@"323",@"234902349032809482903849023",@"32"];

    for (NSUInteger i = 0; i < self.mCards.count; i ++) {
        
//        [prices addObject:[self.mCards[i].price convertToRealMoney]];
        NSString *price = [self.mCards[i].price convertToSimpleRealMoney];
        CGFloat w =  [price calculateStringSize:CGSizeMake(MAXFLOAT, MAXFLOAT) font:FONT(14)].width + 20;
;
        if (i == 0) {
            x = LEFT_MARGIN;
        } else {
            
            x = _lastLbl.xx + LEFT_MARGIN;
            
            if ( x + w > SCREEN_WIDTH) {
                
                x = LEFT_MARGIN;
                y = _lastLbl.yy + 10;
            }
        }
        UILabel *lbl = [self lblWithFrame:CGRectMake(x, y, w, 30) title:price];
        lbl.tag = 1000 + i;
        [self.view addSubview:lbl];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choosePrice:)];
        [lbl addGestureRecognizer:tap];
        
        if (i == 0) {
            self.selectedPriceLbl = lbl;
            lbl.textColor = [UIColor zh_themeColor];
            lbl.layer.borderColor = [UIColor zh_themeColor].CGColor;
        }
        
        
        self.lastLbl = lbl;
        
    }
//    NSArray *tags = @[self.mCards[0].price ,self.mCards[1].name,self.mCards[2].name,self.mCards[3].name];

    //进行计算创建控件
    
    
    ///---------------///
//    CGFloat btnW = 60;
//    CGFloat middleMargin = (SCREEN_WIDTH - 2*LEFT_MARGIN - 4*btnW)/3.0;
//    CGFloat  btnY = hintLbl2.yy + 12;
//    for (NSInteger i = 0; i < tags.count; i ++ ) {
//        
//        CGFloat x = LEFT_MARGIN + i*(btnW + middleMargin);
//        UIButton *btn = [self btnWithFrame:CGRectMake(x, btnY, btnW, 30) title:tags[i]];
//        btn.tag = 200 + i;
//        [btn addTarget:self action:@selector(chooseMoney:) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:btn];
//        if (i == 0) {
//            
//            _lastMoneyBtn = btn;
//            btn.layer.borderColor = [UIColor zh_themeColor].CGColor;
//            [btn setTitleColor:[UIColor zh_themeColor] forState:UIControlStateNormal];
//            
//        }
//    }
    
    //btn
    UIButton *confirmBtn = [UIButton zhBtnWithFrame:CGRectMake(15, _lastLbl.yy + 55, SCREEN_WIDTH - LEFT_MARGIN *2, 45) title:@"确定"];
    [self.view addSubview:confirmBtn];
    [confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];

}

#pragma mark-- 确认购买
- (void)confirm {

    if (_lastTypeBtn.tag == 101) {//日
        
    } else {
    
    
    }
    
    if (self.selectedPriceLbl.tag == 1000) { //2千
       
        
    }
    

    ZHPayVC *payVC = [[ZHPayVC alloc] init];
    payVC.type = ZHPayVCTypeMonthCard;
    payVC.paySucces = ^(){
    
//        [self.navigationController popViewControllerAnimated:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"monthCardBuySuccess" object:nil];
    };
    payVC.monthCardModel = self.mCards[self.selectedPriceLbl.tag - 1000];
    
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:payVC];
//    [self.navigationController pushViewController:payVC animated:YES];
    [self presentViewController:nav animated:YES completion:nil];

}

#pragma mark- 选择金额
- (void)choosePrice:(UITapGestureRecognizer *)tap {
    
    UILabel *lbl = (UILabel *)tap.view;

    if ([self.selectedPriceLbl isEqual:lbl]) {
        return;
    }

    self.selectedPriceLbl.textColor = [UIColor zh_textColor2];
    self.selectedPriceLbl.layer.borderColor = [UIColor zh_textColor2].CGColor;
    
    
    lbl.textColor = [UIColor zh_themeColor];
    lbl.layer.borderColor = [UIColor zh_themeColor].CGColor;
    
    //
    self.selectedPriceLbl = lbl;

}

#pragma mark- 选择类型
- (void)chooseType:(UIButton *)btn {

//    btn.layer.borderColor = [UIColor zh_themeColor].CGColor;
//    [btn setTitleColor:[UIColor zh_themeColor] forState:UIControlStateNormal];
//    
//    _lastTypeBtn.layer.borderColor = [UIColor zh_textColor2].CGColor;
//    [_lastTypeBtn setTitleColor:[UIColor zh_textColor2] forState:UIControlStateNormal];
//    
//    _lastTypeBtn = btn;

}

//#pragma mark- 选择金额
//- (void)chooseMoney:(UIButton *)btn {
//
//    btn.layer.borderColor = [UIColor zh_themeColor].CGColor;
//    [btn setTitleColor:[UIColor zh_themeColor] forState:UIControlStateNormal];
//    
//    _lastMoneyBtn.layer.borderColor = [UIColor zh_textColor2].CGColor;
//    [_lastMoneyBtn setTitleColor:[UIColor zh_textColor2] forState:UIControlStateNormal];
//
//    _lastMoneyBtn = btn;
//}


- (UILabel *)lblWithFrame:(CGRect)frame title:(NSString *)title {

    UILabel *lbl = [UILabel labelWithFrame:frame
                              textAligment:NSTextAlignmentCenter
                           backgroundColor:[UIColor clearColor]
                                      font:FONT(14)
                                 textColor:[UIColor zh_textColor2]];
    
    lbl.layer.cornerRadius = 3;
    lbl.layer.masksToBounds = YES;
    lbl.layer.borderColor = [UIColor zh_textColor2].CGColor;
    lbl.layer.borderWidth = 1;
    lbl.text = title;
    lbl.userInteractionEnabled = YES;
    //
    return lbl;

}

- (UIButton *)btnWithFrame:(CGRect)frame title:(NSString *)title {

    UIButton *btn = [[UIButton alloc] initWithFrame:frame title:title backgroundColor:[UIColor whiteColor]];
    
    btn.layer.cornerRadius = 3;
    btn.layer.masksToBounds = YES;
    btn.layer.borderColor = [UIColor zh_textColor2].CGColor;
    btn.layer.borderWidth = 1;
    btn.titleLabel.font = FONT(14);
    [btn setTitleColor:[UIColor zh_textColor2] forState:UIControlStateNormal];
    //
    return btn;

}

- (void)goIntroduce {

    [TLAlert alertWithHUDText:@"查看玩法"];

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
