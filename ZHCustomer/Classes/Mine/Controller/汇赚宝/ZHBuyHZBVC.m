//
//  ZHBuyHZBVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/8.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHBuyHZBVC.h"
#import "ZHPayVC.h"
#import "ZHNewPayVC.h"

#import "ZHHZBModel.h"
#import "ZHRealNameAuthVC.h"
#import <WebKit/WebKit.h>
#import "ZHCurrencyModel.h"

@interface ZHBuyHZBVC ()<WKNavigationDelegate>

@property (nonatomic,strong) ZHHZBModel *HZBModel;
@property (nonatomic, strong) UIImageView *hzbImageView;
@property (nonatomic, strong) UILabel *priceLbl;


@end

@implementation ZHBuyHZBVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购买汇赚宝";
    
    //先查出
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"615105";
//    0 待上架 1 已上架 2 已下架
    http.parameters[@"status"] = @"1";
    http.parameters[@"start"] = @"1";
    http.parameters[@"limit"] = @"1";
    http.parameters[@"token"] = [ZHUser user].token;

    [http postWithSuccess:^(id responseObject) {
        
        NSArray *arr =  responseObject[@"data"][@"list"];
        if (arr.count <= 0) {
            [TLAlert alertWithMsg:@"暂无汇赚宝"];
            return ;
        }
        NSDictionary *dict = arr[0];
        self.HZBModel = [ZHHZBModel tl_objectWithDictionary:dict];
        [self setUpUI];
        
        //
        [self.hzbImageView sd_setImageWithURL:[NSURL URLWithString:[self.HZBModel.pic convertImageUrl]] placeholderImage:[UIImage imageNamed:@"hzb_tree"]];
        
        self.priceLbl.text = [NSString stringWithFormat:@"价格: %@ 元",[self.HZBModel.price convertToRealMoney]];
        
    } failure:^(NSError *error) {
        
        
    }];

}

- (void)read {

    //mask
    UIControl *maskCtrl = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [maskCtrl addTarget:self action:@selector(deleteMask:) forControlEvents:UIControlEventTouchUpInside];
    maskCtrl.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.65];
    [[UIApplication sharedApplication].keyWindow addSubview:maskCtrl];
    
    //title
    UILabel *titleLbl = [UILabel labelWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 30)
                                   textAligment:NSTextAlignmentCenter
                                backgroundColor:[UIColor clearColor]
                                           font:FONT(17)
                                      textColor:[UIColor whiteColor]];
    titleLbl.text = @"免责声明";
    [maskCtrl addSubview:titleLbl];
    
    //webView
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"807717";
    http.parameters[@"ckey"] = @"fyf_statement";
    
    [http postWithSuccess:^(id responseObject) {
        
        WKWebViewConfiguration *webConfig = [[WKWebViewConfiguration alloc] init];
        
        WKWebView *webV = [[WKWebView alloc] initWithFrame:CGRectMake(0, titleLbl.yy + 20, SCREEN_WIDTH, SCREEN_HEIGHT - titleLbl.yy - 85 - 20 - 35) configuration:webConfig];
        [maskCtrl addSubview:webV];
        webV.backgroundColor = [UIColor clearColor];
        webV.opaque = NO;
        webV.navigationDelegate = self;
        NSString *styleStr = @"<style type=\"text/css\"> *{color:white; font-size:30px;}</style>";
        NSString *htmlStr = responseObject[@"data"][@"note"];
        [webV loadHTMLString:[NSString stringWithFormat:@"%@%@",htmlStr,styleStr] baseURL:nil];
        
    } failure:^(NSError *error) {
        
    }];
    
    
    UIButton *readBtn = [UIButton zhBtnWithFrame:CGRectMake(20, SCREEN_HEIGHT - 85, SCREEN_WIDTH - 40, 45) title:@"我已阅读"];
    [readBtn addTarget:self action:@selector(readed:) forControlEvents:UIControlEventTouchUpInside];
    [maskCtrl addSubview:readBtn];
    
    


}


- (void)readed:(UIButton *)btn {
    
    [(UIControl *)btn.nextResponder removeFromSuperview];
    
    //进行实名认真之后才能提现
    NSLog(@"---==%@",[ZHUser user].realName);
    if (![ZHUser user].realName || ([ZHUser user].realName && [ZHUser user].realName.length == 0)) {
        
        [TLAlert alertWithTitle:nil Message:@"您还未进行实名认证\n前往进行实名认证" confirmMsg:@"前往" CancleMsg:@"取消" cancle:^(UIAlertAction *action) {
            
        } confirm:^(UIAlertAction *action) {
            
            ZHRealNameAuthVC *authVC = [[ZHRealNameAuthVC alloc] init];
            authVC.authSuccess = ^(){ //实名认证成功
                
            };
            [self.navigationController pushViewController:authVC animated:YES];
            
        }];
        
        return;
    }
    
    
    //获取账户信息
    TLNetworking *http = [TLNetworking new];
    //        http.showView = self.view;
    http.code = @"802503";
    http.parameters[@"token"] = [ZHUser user].token;
    http.parameters[@"userId"] = [ZHUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        //只能使用 --- 人民币 或者 ---分润----- 购买
        //    ZHPayVC *payVC = [[ZHPayVC alloc] init];
        //    payVC.type = ZHPayVCTypeHZB;
        
        NSArray <NSDictionary *>*accountArr = responseObject[@"data"];
        if (accountArr.count <=0 ) {
            return ;
            
        }
     
        
        
        ZHNewPayVC *payVC = [[ZHNewPayVC alloc] init];
        payVC.type = ZHPayViewCtrlTypeHZB;
        payVC.HZBModel = self.HZBModel;
        payVC.amoutAttr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",[self.HZBModel.price convertToRealMoney]]
                                                                 attributes:@{
                                                                              NSForegroundColorAttributeName : [UIColor zh_themeColor]                              }];
        
        //传价格
        payVC.rmbAmount = self.HZBModel.price;
        
        //传余额
        [accountArr enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj[@"currency"] isEqualToString:kFRB]) {
                
                payVC.balanceString = [NSString stringWithFormat:@"余额（分润%@）",[obj[@"amount"] convertToRealMoney]];
                
            }
            
        }];
        
        payVC.paySucces = ^(){
            
            //        [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HZBBuySuccess" object:nil];
            
        };
        
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:payVC];
        [self presentViewController:nav animated:YES completion:nil];
        
        
    } failure:^(NSError *error) {
        
        
        
    }];
    

}


- (void)deleteMask:(UIControl *)ctrl {
    
    [ctrl removeFromSuperview];
    
}

#pragma mark-
- (void)buy {
    
    [self read];
    
//    //进行实名认真之后才能提现
//    if (![ZHUser user].realName) {
//        [TLAlert alertWithTitle:nil Message:@"您还未进行实名认证\n前往进行实名认证" confirmMsg:@"前往" CancleMsg:@"取消" cancle:^(UIAlertAction *action) {
//            
//        } confirm:^(UIAlertAction *action) {
//            
//            ZHRealNameAuthVC *authVC = [[ZHRealNameAuthVC alloc] init];
//            authVC.authSuccess = ^(){ //实名认证成功
//                
//            };
//            [self.navigationController pushViewController:authVC animated:YES];
//            
//        }];
//        
//        return;
//    }
//
//    //只能使用 --- 人民币 或者 ---分润----- 购买
////    ZHPayVC *payVC = [[ZHPayVC alloc] init];
////    payVC.type = ZHPayVCTypeHZB;
//    
//    ZHNewPayVC *payVC = [[ZHNewPayVC alloc] init];
//    payVC.type = ZHPayViewCtrlTypeHZB;
//    payVC.HZBModel = self.HZBModel;
//    payVC.amoutAttr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",[self.HZBModel.price convertToRealMoney]]
//                        attributes:@{
//                               NSForegroundColorAttributeName : [UIColor zh_themeColor]                              }];
//    payVC.orderAmount = self.HZBModel.price;
//    payVC.paySucces = ^(){
//        
////        [self.navigationController popViewControllerAnimated:YES];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"HZBBuySuccess" object:nil];
//        
//    };
//    
//    
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:payVC];
//    [self presentViewController:nav animated:YES completion:nil];
    
}



#pragma mark- web代理
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [TLAlert alertWithHUDText:@"加载失败"];
    
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)setUpUI {

    
    UIImageView *treeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 65, 250, 250)];
    treeView.centerX = self.view.width/2.0;
    treeView.image = [UIImage imageNamed:@"hzb_tree"];
    [self.view addSubview:treeView];
    self.hzbImageView = treeView;
    
    //价格lbl
    UILabel *priceLbl = [UILabel labelWithFrame:CGRectZero
                                   textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor clearColor]
                                           font:FONT(13)
                                      textColor:[UIColor zh_textColor]];
    [treeView addSubview:priceLbl];
    self.priceLbl = priceLbl;
    
    [priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.view.mas_left).offset(20);
        make.top.equalTo(treeView.mas_bottom).offset(10);
        
        
    }];
    
    //
    UIButton *buyBtn = [UIButton zhBtnWithFrame:CGRectMake(20, treeView.yy + 30, SCREEN_WIDTH - 40, 45) title:@"购买"];
    [self.view addSubview:buyBtn];
    [buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(20);
        make.top.equalTo(priceLbl.mas_bottom).offset(10);
        make.width.mas_equalTo(SCREEN_WIDTH - 40);
        make.height.mas_equalTo(45);
        
    }];
    
    [buyBtn addTarget:self action:@selector(buy) forControlEvents:UIControlEventTouchUpInside];
}

@end
