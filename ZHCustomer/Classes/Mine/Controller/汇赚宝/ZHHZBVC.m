//
//  ZHHZBVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/8.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHHZBVC.h"
#import "ZHBuyHZBVC.h"
#import "ZHBusinessCardView.h"
#import "ZHHZBModel.h"

#import <Photos/Photos.h>
#import "SGAlertView.h"
#import "SGScanningQRCodeVC.h"
#import "MJRefresh.h"

@interface ZHHZBVC ()

@property (nonatomic,strong) ZHHZBModel *HZBModel;
@property (nonatomic,strong) ZHBuyHZBVC *buyVC;

@end

@implementation ZHHZBVC

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (ZHBuyHZBVC *)buyVC {

    if (!_buyVC) {
        
        _buyVC = [[ZHBuyHZBVC alloc] init];
        
    }
    return _buyVC;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的汇赚宝";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buySuccess) name:@"HZBBuySuccess" object:nil];
    
    //没有购买的进行购买
    [self buySuccess];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"激活" style:UIBarButtonItemStylePlain target:self action:@selector(scan)];
    


}


- (void)scan {
    
    NSString * mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus  authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (authorizationStatus == AVAuthorizationStatusRestricted|| authorizationStatus == AVAuthorizationStatusDenied) {
        
        [TLAlert alertWithTitle:nil Message:@"没有权限访问您的相机,请在设置中打开" confirmMsg:@"设置" CancleMsg:@"取消" cancle:^(UIAlertAction *action) {
            
            
        } confirm:^(UIAlertAction *action) {
            
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
            
        }];
        
        return;
        
    }

    SGScanningQRCodeVC *scanningQRCodeVC = [[SGScanningQRCodeVC alloc] init];
//    scanningQRCodeVC.title = @"扫码注册";
    scanningQRCodeVC.scannSuccess = ^(NSString *result){
        
        [self jh:result];
        
    };
    [self.navigationController pushViewController:scanningQRCodeVC animated:YES];
    
}


- (void)jh:(NSString *)result {

    NSData *data= [result dataUsingEncoding:NSUTF8StringEncoding];
    
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
            TLNetworking *http = [TLNetworking new];
            http.showView = self.view;
    
    if (!(dict[@"code"] && dict[@"userId"])) {
        
        [TLAlert alertWithHUDText:@"无效二维码"];
        return;
    }
            http.code = dict[@"code"];
            http.parameters[@"userId"] = dict[@"userId"];
    
//            http.code = @"808453";
//            http.parameters[@"userId"] = [ZHUser user].userId;
    
            http.parameters[@"token"] = [ZHUser user].token;
            [http postWithSuccess:^(id responseObject) {
    
                [TLAlert alertWithHUDText:@"激活成功"];
                [self buySuccess];
    
            } failure:^(NSError *error) {
                
            }];


}


- (void)buySuccess {

    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"808456";
    http.parameters[@"userId"] = [ZHUser user].userId;
    http.parameters[@"token"] = [ZHUser user].token;
    [http postWithSuccess:^(id responseObject) {
        
//        [self addChildViewController:self.buyVC];
//        [self.view addSubview:self.buyVC.view];
//
//        return ;
        
        NSDictionary *data = responseObject[@"data"];
        if (data.allKeys.count > 0) {
            
            self.HZBModel = [ZHHZBModel  tl_objectWithDictionary:data];
            [self.tl_placeholderView removeFromSuperview];
            [self setUpUI];
            
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"激活" style:UIBarButtonItemStylePlain target:self action:@selector(scan)];
            
            if ([self.HZBModel.status isEqualToString:@"2"] || [self.HZBModel.status isEqualToString:@"3"] ) {
                
                self.navigationItem.rightBarButtonItem = nil;

            }
            
            if (self.buyVC.view) {
                
                [self.buyVC.view removeFromSuperview];
                
            }
            
            if (self.buyVC) {
                [self.buyVC removeFromParentViewController];
            }
            
        } else { //还没有股份
            
            self.navigationItem.rightBarButtonItem = nil;
            
            [self addChildViewController:self.buyVC];
            [self.view addSubview:self.buyVC.view];

//            [self.view addSubview:[self tl_placholderViewWithTitle:@"您还没有购买汇赚宝" opTitle:@"前往购买汇赚宝"] ];
            
            //

            
        }
        
    } failure:^(NSError *error) {
        
    }];

}

//- (void)refresh {
//
//    
//
//}

//- (void)tl_placeholderOperation {
//    
//    ZHBuyHZBVC *buyVC = [[ZHBuyHZBVC alloc] init];
//    [self.navigationController pushViewController:buyVC animated:YES];
//    
//}

- (void)setUpUI {

    UIScrollView *bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    [self.view addSubview:bgScrollView];
//    bgScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    //
    ZHBusinessCardView *cardV = [[ZHBusinessCardView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90)];
    [bgScrollView addSubview:cardV];
    
    //
    TLTextField *addressTf = [self tfByframe:CGRectMake(0, cardV.yy + 1, SCREEN_WIDTH, 50) leftTitle:@"隶属辖区" titleWidth:98 placeholder:nil];
    [bgScrollView addSubview:addressTf];
    
    //
    TLTextField *numTf = [self tfByframe:CGRectMake(0, addressTf.yy + 1, SCREEN_WIDTH, 50) leftTitle:@"被摇次数" titleWidth:98 placeholder:nil];
    [bgScrollView addSubview:numTf];
    
    
    //
//    if ([ZHUser user].userExt.photo) {
//        
//        [cardV.headerImageV sd_setImageWithURL:[NSURL URLWithString: [ZHUser user].userExt.photo]placeholderImage:[UIImage imageNamed:@"user_placeholder"]];
//    } else {
//        
//        cardV.headerImageV.image = [UIImage imageNamed:@"user_placeholder"];
//    }
    
    cardV.headerImageV.image = [UIImage imageNamed:@"树"];

    cardV.titleTf.text = [ZHUser user].realName;
    cardV.subTitleTf.text =  [self.HZBModel getStatusName];
//
    addressTf.text = [[ZHUser user] detailAddress];
    
    numTf.text = [NSString stringWithFormat:@"%@ 次",self.HZBModel.totalRockNum];

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
