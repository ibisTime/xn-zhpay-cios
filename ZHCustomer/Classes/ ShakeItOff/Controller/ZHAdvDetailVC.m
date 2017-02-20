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
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    
    WKWebView *webV = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 95) configuration:config];
    [self.view addSubview:webV];
    webV.navigationDelegate = self;
    NSURL *url = [NSURL URLWithString:self.hzbModel.shareUrl];
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url];
    [webV loadRequest:req];
    
    
    UIButton *shareBtn = [UIButton zhBtnWithFrame:CGRectMake(0, webV.yy + 25, SCREEN_WIDTH - 40, 45) title:@"分享领奖"];
    [self.view addSubview:shareBtn];
    [self.view addSubview:shareBtn];
    shareBtn.centerX = SCREEN_WIDTH/2.0;
    [shareBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    

    
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {

    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [TLAlert alertWithHUDText:@"加载失败"];

}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {

    [MBProgressHUD hideHUDForView:self.view animated:YES];

}

- (void)share {

    [TLWXManager manager].wxShare = ^(BOOL isSuccess,int errorCode) {
        
        if (isSuccess) {
            
            [TLAlert alertWithHUDText:@"分享成功"];
            
            TLNetworking *http = [TLNetworking new];
            http.showView = self.view;
            http.code = @"808460";
            http.parameters[@"token"] = [ZHUser user].token;
            http.parameters[@"userId"] = [ZHUser user].userId;
            http.parameters[@"hzbHoldId"] = self.hzbModel.ID;
            http.parameters[@"deviceNo"] = [NSString stringWithFormat:@"%@",[FCUUID uuidForDevice]];
            //--//
            [http postWithSuccess:^(id responseObject) {
                
                NSDictionary *dict = responseObject[@"data"];
                NSString *type = dict[@"type"];
                NSNumber *quantity = dict[@"quantity"];
                
                //              1=红包币 2=钱包币 3购物币
                NSString *hintStr;
                
                if ([type isEqualToString:@"1"]) {
                    
                    hintStr = @"钱包币";
                    
                } else if([type isEqualToString:@"2" ]){
                    
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
            
            [TLAlert alertWithHUDText:@"分享失败,无法获取奖励"];
            
        }
        
    };
    
    //
    [TLWXManager wxShareWebPageWith:@"正汇分享" desc:@"我正在参加摇一摇活动" url:self.hzbModel.shareUrl];
    
}



@end
