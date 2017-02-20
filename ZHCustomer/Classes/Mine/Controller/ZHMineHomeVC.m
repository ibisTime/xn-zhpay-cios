//
//  ZHMineHomeVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/28.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHMineHomeVC.h"
#import "ZHUserAvatar.h"
#import "ZHAccountSecurityVC.h"
#import "ZHAddressChooseVC.h"
#import "ZHReceivingAddress.h"
#import "ZHBankCardListVC.h"
#import "ZHMsgVC.h"
#import "SGQRCodeTool.h"

@interface ZHMineHomeVC ()

@property (nonatomic,strong) ZHUserAvatar *userAvatar;

@end

@implementation ZHMineHomeVC

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人主页";
    
    UIScrollView *bgScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:bgScrollView];
    bgScrollView.backgroundColor = [UIColor whiteColor];
    
    
    //异步更新用户信息
    [[ZHUser user] updateUserInfo];
    
    //
//   UIImage *image = [SGQRCodeTool SG_generateWithLogoQRCodeData:[ZHUser user].mobile logoImageName:@"正汇ICON" logoScaleToSuperView:0.3];
    UIImage *image = [SGQRCodeTool SG_generateWithDefaultQRCodeData:[ZHUser user].mobile imageViewWidth:SCREEN_WIDTH];
//    UIImage *image = [SGQRCodeTool SG_generateWithColorQRCodeData:[ZHUser user].mobile backgroundColor:[UIColor zh_textColor].CIColor mainColor:[UIColor zh_themeColor].CIColor];
    
    ZHUserAvatar *userAvatar = [[ZHUserAvatar alloc] initWithFrame:CGRectMake(0, 26, SCREEN_WIDTH, 50)];
    [bgScrollView addSubview:userAvatar];
    self.userAvatar = userAvatar;
    

    
    UIButton *lastBtn = nil;
    NSArray *names = @[@"收货地址",@"银行卡",@"系统公告",@"账户安全"];
    for (NSInteger i = 0; i < names.count; i ++) {
        
        CGFloat w = (SCREEN_WIDTH - 30)/4.0;
        CGFloat x = 15 + i*w;
        UIButton *btn = [self funcBtnWithFrame:CGRectMake(x, userAvatar.yy + 32, w, 45) imgName:names[i] funcName:names[i]];
        
        [bgScrollView addSubview:btn];
        btn.tag = 1000 + i;
        [btn addTarget:self action:@selector(go:) forControlEvents:UIControlEventTouchUpInside];
        lastBtn = btn;
    }
    
    //二维码背景
    UIView *qrCodeBGView = [[UIView alloc] initWithFrame:CGRectMake(0, lastBtn.yy + 53, 200, 200)];
    [bgScrollView addSubview:qrCodeBGView];
    qrCodeBGView.centerX = bgScrollView.width/2.0;
    qrCodeBGView.layer.masksToBounds = YES;
    qrCodeBGView.layer.cornerRadius = 3;
    qrCodeBGView.layer.borderColor = [UIColor colorWithHexString:@"#dedede"].CGColor;
    qrCodeBGView.layer.borderWidth = 0.5;
    
    //
    CGFloat margin = 1;
    UIImageView *qrImageView = [[UIImageView alloc] initWithFrame:CGRectMake(margin, margin, qrCodeBGView.width - 2*margin, qrCodeBGView.height - 2*margin)];
    [qrCodeBGView addSubview:qrImageView];
    qrImageView.image = image;
    
    //
    UILabel *hintLbl = [UILabel labelWithFrame:CGRectMake(0, qrCodeBGView.yy + 32, SCREEN_WIDTH, [FONT(13) lineHeight])
                                  textAligment:NSTextAlignmentCenter
                               backgroundColor:[UIColor whiteColor]
                                          font:FONT(13)
                                     textColor:[UIColor zh_textColor2]];
    [bgScrollView addSubview:hintLbl];
    hintLbl.text = @"扫码计入，参与利润分成";
    
    
    bgScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, hintLbl.yy + 20);
    [self changeUserInfo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeUserInfo) name:kUserInfoChange object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeUserInfo) name:kUserLoginNotification object:nil];
}

- (void)changeUserInfo {

    self.userAvatar.nameLbl.text = [ZHUser user].nickname ? [ZHUser user].nickname : @"还未设置昵称" ;
    if ([ZHUser user].userExt.photo) {
        
        NSString *urlStr = [[ZHUser user].userExt.photo convertThumbnailImageUrl];
        [self.userAvatar.avatar sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"user_placeholder"]];
        
    } else {
        
        self.userAvatar.avatar.image = [UIImage imageNamed:@"user_placeholder"];
        
    }
    
}


- (void)go:(UIButton *)btn {

    NSInteger index = btn.tag - 1000;

    switch (index) {
        case 0: {
            
            //收货地址
            ZHAddressChooseVC *vc = [[ZHAddressChooseVC alloc] init];
            vc.isDisplay = YES;
            [self.navigationController pushViewController:vc animated:YES];
                       
        }
            
            break;
        case 1: {
            
            ZHBankCardListVC *vc = [[ZHBankCardListVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        
        }
            
            break;
        case 2: {
        
            ZHMsgVC *vc = [[ZHMsgVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];

        }
            break;
            
        case 3: {
        
            ZHAccountSecurityVC *vc = [[ZHAccountSecurityVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            

    }
    

}

- (UIButton *)funcBtnWithFrame:(CGRect)frame imgName:(NSString *)imgName funcName:(NSString *)name{

    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 25)];
    [btn addSubview:imageV];
    imageV.contentMode = UIViewContentModeScaleAspectFit;
    imageV.image = [UIImage imageNamed:imgName];
    
    UILabel *funcNameLbl = [UILabel labelWithFrame:CGRectMake(0, imageV.yy + 10, frame.size.width, [FONT(13) lineHeight]) textAligment:NSTextAlignmentCenter backgroundColor:[UIColor whiteColor] font:FONT(13) textColor:[UIColor zh_textColor]];
    [btn addSubview:funcNameLbl];
    funcNameLbl.text = name;
    
    btn.height = funcNameLbl.yy;
    return btn;

}

@end
