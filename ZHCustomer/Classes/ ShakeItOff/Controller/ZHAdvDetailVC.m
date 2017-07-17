//
//  ZHAdvDetailVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/9.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHAdvDetailVC.h"
#import "FCUUID.h"
#import "TLWXManager.h"
#import <WebKit/WebKit.h>
#import "SVProgressHUD.h"
#import "SGQRCodeTool.h"
#import "ZHShareView.h"
#import "AppConfig.h"
#import "ZHCurrencyModel.h"

@interface ZHAdvDetailVC ()<WKNavigationDelegate>

@property (nonatomic,strong) UIButton *awardBtn;
@property (nonatomic,strong) UILabel *infoLbl;

@end

@implementation ZHAdvDetailVC

- (void)remove:(UIButton *)btn {
    
    [btn removeFromSuperview];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (UIButton *)awardBtn {
    
    if (!_awardBtn) {
        
        _awardBtn = [[UIButton alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _awardBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        [_awardBtn addTarget:self action:@selector(remove:) forControlEvents:UIControlEventTouchUpInside];
        //
        CGFloat w = 200;
        CGFloat h = w*221/198.0;
        CGFloat topM = SCREEN_HEIGHT/2.0 - h;
        UIImageView *iconV = [[UIImageView alloc] initWithFrame:CGRectMake(0, topM, w,h)];
        iconV.image = [UIImage imageNamed:@"中奖"];
        iconV.centerX = SCREEN_WIDTH/2.0;
        [_awardBtn addSubview:iconV];
        
        UILabel *lbl1 = [UILabel labelWithFrame:CGRectMake(0, iconV.yy + 30, SCREEN_WIDTH, [FONT(18) lineHeight]) textAligment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor] font:FONT(18) textColor:[UIColor whiteColor]];
        [_awardBtn addSubview:lbl1];
        lbl1.numberOfLines = 0;
        self.infoLbl = lbl1;
        [lbl1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(iconV.mas_bottom).offset(30);
            make.left.equalTo(_awardBtn.mas_left);
            make.right.equalTo(_awardBtn.mas_right);
            
        }];
    }
    
    return _awardBtn;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
//   
//    UIWebView *webV = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 95)];
//    [self.view addSubview:webV];
//    webV.delegate = self;
    self.title = @"分享领奖";
    
//    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
//    
//    WKWebView *webV = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 95) configuration:config];
//    [self.view addSubview:webV];
//    webV.navigationDelegate = self;
//    NSURL *url = [NSURL URLWithString:self.hzbModel.shareUrl];
//    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url];
//    [webV loadRequest:req];
//    
//
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *qrImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 80, 190, 190)];
    qrImageView.centerX = self.view.centerX;
    
    [self.view addSubview:qrImageView];
    
    //
    UILabel *hintLbl = [UILabel labelWithFrame:CGRectMake(0, qrImageView.yy + 10, SCREEN_WIDTH, 20)
                                  textAligment:NSTextAlignmentCenter
                               backgroundColor:[UIColor whiteColor]
                                          font:FONT(13)
                                     textColor:[UIColor zh_textColor]];
    [self.view addSubview:hintLbl];
    hintLbl.text = @"扫码，和我一起玩正汇";
    
    
    //
    UIButton *shareBtn = [UIButton zhBtnWithFrame:CGRectMake(0, qrImageView.yy + 90, SCREEN_WIDTH - 40, 45) title:@"分享领奖"];
    [self.view addSubview:shareBtn];
    [self.view addSubview:shareBtn];
    shareBtn.centerX = SCREEN_WIDTH/2.0;
    [shareBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];

    
    //二维码
    NSString *qrStr = [NSString stringWithFormat:@"%@/user/register.html?userReferee=%@",[AppConfig config].shareBaseUrl,[[ZHUser user] mobile]];
    UIImage *image = [SGQRCodeTool SG_generateWithDefaultQRCodeData:qrStr imageViewWidth:SCREEN_WIDTH];
    
    qrImageView.image = image;
    
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {

    [TLProgressHUD showWithStatus:nil];
    
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [TLAlert alertWithError:@"加载失败"];

}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    
    [TLProgressHUD showWithStatus:nil];

//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {

    [TLProgressHUD dismiss];

//    [MBProgressHUD hideHUDForView:self.view animated:YES];

}

- (void)share {
    
    //
    ZHShareView *shareView = [[ZHShareView alloc] init];
    
    shareView.wxShare = ^(BOOL isSuccess,int errorCode) {
        
        if (isSuccess) {
            
            
            TLNetworking *http = [TLNetworking new];
            http.showView = self.view;
            http.code = @"615120";
            http.parameters[@"token"] = [ZHUser user].token;
            http.parameters[@"userId"] = [ZHUser user].userId;
            http.parameters[@"hzbCode"] = self.hzbModel.code;
            http.parameters[@"deviceNo"] = [NSString stringWithFormat:@"%@",[FCUUID uuidForDevice]];
            //--//
            [http postWithSuccess:^(id responseObject) {
                
                NSDictionary *dict = responseObject[@"data"];
                NSString *type = dict[@"yyCurrency"];
                NSString *quantity = [dict[@"yyAmount"] convertToRealMoney];
                
                //              1=红包币 2=钱包币 3购物币
                NSString *hintStr;
                
                if ([type isEqualToString:kQBB]) {
                    
                    hintStr = @"钱包币";
                    
                } else if([type isEqualToString:kGWB]){
                    
                    hintStr =@"购物币";
                    
                } else {
                    
                    hintStr = @"红包";
                    
                }
                
                //                [TLAlert alertWithHUDText:[NSString stringWithFormat:@"恭喜您获得 %@ 个%@",quantity,hintStr]];
                //
                NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"恭喜您获得 %@ 个%@",quantity,hintStr]];
                [attr addAttributes:@{
                                      NSForegroundColorAttributeName : [UIColor zh_themeColor]
                                      } range:NSMakeRange(6, [NSString stringWithFormat:@"%@",quantity].length)
                 ];
                
                [[UIApplication sharedApplication].keyWindow addSubview:self.awardBtn];
                
                self.infoLbl.attributedText = attr;
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self.awardBtn removeFromSuperview];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    
                });
                
                
            } failure:^(NSError *error) {
                
            }];
            
        } else {
            
//            [TLAlert alertWithHUDText:@"分享失败,无法获取奖励"];
            
        }
        
    };
    
    shareView.title = @"正汇钱包邀您玩转红包";
    shareView.content = @"小目标，发一发，摇一摇，聊一聊各种红包玩法";
    shareView.shareUrl = [NSString stringWithFormat:@"%@/user/register.html?userReferee=%@",[AppConfig config].shareBaseUrl,[[ZHUser user] mobile]];
    [shareView show];
    
}



@end
