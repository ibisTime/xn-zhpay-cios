//
//  ZHCouponsDetailVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/6.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHCouponsDetailVC.h"
#import "ZHUserLoginVC.h"

//#import "ZHCouponsCell.h"

#import "ZHShop.h"

@interface ZHCouponsDetailVC ()

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *soldOutImageView;

@property (nonatomic,strong) UILabel *infoLbl;
@property (nonatomic,strong) UILabel *titleLbl;
@property (nonatomic,strong) UILabel *timeLbl;

@property (nonatomic,strong) UILabel *price1Lbl;
@property (nonatomic,strong) UILabel *price2Lbl;


@end

@implementation ZHCouponsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH - 30, 120)];
    [self.view addSubview:self.backgroundImageView];
    
    self.soldOutImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, 60, 60)];
    self.soldOutImageView.xx_size = self.backgroundImageView.width - 10;
    [self.backgroundImageView addSubview:self.soldOutImageView];
    
//    self.infoLbl = [UILabel labelWithFrame:CGRectZero textAligment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor] font:FONT(18) textColor:[UIColor zh_textColor]];
//    [self.view addSubview:self.infoLbl];
//    self.infoLbl.numberOfLines = 2;
//    [self.infoLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left).offset(35);
//        make.top.equalTo(self.view.mas_top).offset(48);
//    }];
    
    self.price1Lbl = [UILabel labelWithFrame:CGRectZero
                                textAligment:NSTextAlignmentLeft
                             backgroundColor:[UIColor clearColor]
                                        font:FONT(18)
                                   textColor:[UIColor zh_textColor]];
    [self.backgroundImageView addSubview:self.price1Lbl];
    [self.price1Lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.backgroundImageView.mas_left).offset(20);
        make.bottom.equalTo(self.backgroundImageView.mas_centerY).offset(-2);
    }];
    
    //
    self.price2Lbl = [UILabel labelWithFrame:CGRectZero
                                textAligment:NSTextAlignmentLeft
                             backgroundColor:[UIColor clearColor]
                                        font:FONT(18)
                                   textColor:[UIColor zh_textColor]];
    [self.backgroundImageView addSubview:self.price2Lbl];
    [self.price2Lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.backgroundImageView.mas_left).offset(20);
        make.top.equalTo(self.backgroundImageView.mas_centerY).offset(2);
    }];
    
    //
    self.titleLbl = [UILabel labelWithFrame:CGRectMake(SCREEN_WIDTH/2.0, 48, SCREEN_WIDTH/2.0 - 15, [FONT(12) lineHeight]) textAligment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor] font:FONT(12) textColor:[UIColor zh_textColor2]];
    [self.view addSubview:self.titleLbl];
    self.titleLbl.height = [FONT(12) lineHeight];
    self.titleLbl.text = @"抵扣券";
    //
    
    self.timeLbl = [UILabel labelWithFrame:CGRectZero textAligment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor] font:FONT(12) textColor:[UIColor zh_textColor2]];
    [self.view addSubview:self.timeLbl];
    [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLbl.mas_left);
        make.top.equalTo(self.titleLbl.mas_bottom).offset(12);
    }];
    

    //尾部详情
    UIView *footerBGView = [[UIView alloc] initWithFrame:CGRectMake(0, self.backgroundImageView.yy + 15, SCREEN_WIDTH, SCREEN_HEIGHT - 64 -130)];
    footerBGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footerBGView];
    
    UILabel *hintLbl = [UILabel labelWithFrame:CGRectMake(LEFT_MARGIN, 0, 200, 35) textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor whiteColor]
                                          font:FONT(13)
                                     textColor:[UIColor zh_textColor2]];
    hintLbl.text = @"详情";
    [footerBGView addSubview:hintLbl];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, hintLbl.yy, SCREEN_WIDTH, LINE_HEIGHT)];
    line.backgroundColor = [UIColor zh_lineColor];
    [footerBGView addSubview:line];
    
    UILabel *descLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor whiteColor]
                                          font:FONT(12)
                                     textColor:[UIColor zh_textColor]];
    [footerBGView addSubview:descLbl];
    descLbl.numberOfLines = 0;
    [descLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footerBGView.mas_left).offset(15);
        make.right.equalTo(footerBGView.mas_right).offset(-15);
        make.top.equalTo(line.mas_bottom).offset(10);
    }];
    

    if (self.coupon) {
        
        NSString *  price1Str = [_coupon.key1 convertToSimpleRealMoney];
        NSString *  price2Str = [_coupon.key2 convertToSimpleRealMoney];
        
        
        //
        NSMutableAttributedString *attr1Str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"满 %@",price1Str]];
        [attr1Str addAttributes:@{
                                  NSForegroundColorAttributeName : [UIColor zh_themeColor]
                                  } range:NSMakeRange(2, price1Str.length)];
        //--//
        NSMutableAttributedString *attr2Str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"减 %@",price2Str]];
        [attr2Str addAttributes:@{
                                  NSForegroundColorAttributeName : [UIColor zh_themeColor]
                                  } range:NSMakeRange(2, price2Str.length)];
        
        //价格字符串
        self.price1Lbl.attributedText = attr1Str;
        self.price2Lbl.attributedText = attr2Str;
        
        self.titleLbl.text = [NSString  stringWithFormat:@"起始日期%@",[_coupon.validateStart converDate]];
         self.timeLbl.text = [NSString  stringWithFormat:@"有效期至%@",[_coupon.validateEnd converDate]];
        
        //底部购买按钮
        UIButton *buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 49 -64, SCREEN_WIDTH, 49) title:@"购买" backgroundColor:[UIColor zh_themeColor]];
        [self.view addSubview:buyBtn];
        [buyBtn addTarget:self action:@selector(buy) forControlEvents:UIControlEventTouchUpInside];
        
        self.backgroundImageView.image = [UIImage imageNamed:@"抵扣券ing"];
        descLbl.text = self.coupon.desc;
        
    } else {
    
        NSString *  price1Str = [self.mineCoupon.storeTicket.key1 convertToSimpleRealMoney];
        NSString *  price2Str = [self.mineCoupon.storeTicket.key2 convertToSimpleRealMoney];
        
        
        //
        NSMutableAttributedString *attr1Str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"满 %@",price1Str]];
        [attr1Str addAttributes:@{
                                  NSForegroundColorAttributeName : [UIColor zh_themeColor]
                                  } range:NSMakeRange(2, price1Str.length)];
        //--//
        NSMutableAttributedString *attr2Str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"减 %@",price2Str]];
        [attr2Str addAttributes:@{
                                  NSForegroundColorAttributeName : [UIColor zh_themeColor]
                                  } range:NSMakeRange(2, price2Str.length)];
        
        //价格字符串
        self.price1Lbl.attributedText = attr1Str;
        self.price2Lbl.attributedText = attr2Str;
        
        self.titleLbl.text = [NSString  stringWithFormat:@"起始日期%@",[self.mineCoupon.storeTicket.validateStart converDate]];
        self.timeLbl.text = [NSString  stringWithFormat:@"有效期至%@",[self.mineCoupon.storeTicket.validateEnd converDate]];
    
        if ([self.mineCoupon.status isEqualToString:@"0"]) { //未使用
            
            self.soldOutImageView.image = [UIImage new];
            self.backgroundImageView.image = [UIImage imageNamed:@"抵扣券ing"];
            
        } else if([self.mineCoupon.status isEqualToString:@"1"]){ //已经使用
            
            self.soldOutImageView.image = [UIImage imageNamed:@"已使用"];
            self.backgroundImageView.image = [UIImage imageNamed:@"抵扣券ed"];
            
        } else { //2   ---- 已过期
            
            self.soldOutImageView.image = [UIImage new];
            self.backgroundImageView.image = [UIImage imageNamed:@"抵扣券ed"];
            
        }
        
        //详情
        descLbl.text = [NSString stringWithFormat:@"%@\n%@\n%@",self.mineCoupon.store.name,self.mineCoupon.store.bookMobile,self.mineCoupon.storeTicket.desc];
    
    }
    
}

- (void)buy {

    
    if (![ZHUser user].isLogin) {
        
        ZHUserLoginVC *loginVC = [[ZHUserLoginVC alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self  presentViewController:nav animated:YES completion:nil];
        return;
    }
    
    [TLAlert alertWithTitle:nil Message:[NSString stringWithFormat:@"您是否确定花 %@ 钱包币购买此折扣券",[self.coupon.key2 convertToSimpleRealMoney]] confirmMsg:@"确定" CancleMsg:@"取消" cancle:^(UIAlertAction *action) {
        
    } confirm:^(UIAlertAction *action) {
        
        TLNetworking *http = [TLNetworking new];
        http.showView = self.view;
        http.code = @"808260";
        http.parameters[@"code"] = self.coupon.code;
        http.parameters[@"userId"] = [ZHUser user].userId;
        http.parameters[@"token"] = [ZHUser user].token;
        [http postWithSuccess:^(id responseObject) {
            
            [TLAlert alertWithHUDText:@"购买成功"];
            [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(NSError *error) {
            
        }];
        
        
    }];

}


//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    
//    return 1;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    static NSString * couponsCellId = @"couponsCellId";
//    ZHCouponsCell *cell = [tableView dequeueReusableCellWithIdentifier:couponsCellId];
//    
//    if (!cell) {
//        cell = [[ZHCouponsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:couponsCellId];
//    }
//    cell.coupon = self.coupon;
//    return cell;
//}


@end
