//
//  ZHShareView.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/25.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHShareView.h"
#import "SGQRCodeTool.h"
#import "TLWXManager.h"
#import "TLHeader.h"
#import "UIColor+theme.h"

@interface ZHShareView ()

@property (nonatomic, strong) UIImageView *qrImageView;

@end

@implementation ZHShareView


- (UIImageView *)qrImageView {

    if (!_qrImageView) {
        
        //添加二维码
        UIImageView *qrImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 69, 200, 200)];
        _qrImageView = qrImageView;
        qrImageView.layer.cornerRadius = 5;
        qrImageView.clipsToBounds = YES;
        qrImageView.center = [UIApplication sharedApplication].keyWindow.center;
        qrImageView.centerY = qrImageView.centerY - 40;
//        [maskCtrl addSubview:qrImageView];
        
        
    }
    return _qrImageView;

}
- (instancetype)init {

    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        
        
        
        UIControl *maskCtrl = self;
        
//        [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [maskCtrl addTarget:self action:@selector(cancleShare:) forControlEvents:UIControlEventTouchUpInside];
        maskCtrl.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.65];
        //    [UIColor colorWithWhite:0.2 alpha:0.5];
        
        
        
      
        
        
        
        //分享界面
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 139 - 54, SCREEN_WIDTH, 139 + 54)];
        bgView.backgroundColor = [UIColor colorWithHexString:@"#dcdbdb"];
        
        [maskCtrl addSubview:bgView];
        
        //
        UILabel *hintLbl = [UILabel labelWithFrame:CGRectZero
                                      textAligment:NSTextAlignmentLeft
                                   backgroundColor:[UIColor clearColor]
                                              font:FONT(14)
                                         textColor:[UIColor zh_textColor]];
        [bgView addSubview:hintLbl];
        hintLbl.text = @"分享到";
        [hintLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView.mas_left).offset(15);
            make.top.equalTo(bgView.mas_top).offset(16);
        }];
        
        //分享给好友
        CGFloat w = 50;
        UIButton *shareFriendBtn = [[UIButton alloc] init];
        [shareFriendBtn setImage:[UIImage imageNamed:@"朋友圈"] forState:UIControlStateNormal];
        [bgView addSubview:shareFriendBtn];
        [shareFriendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(hintLbl.mas_bottom).offset(23);
            make.left.equalTo(bgView.mas_left).offset(15);
            make.width.mas_equalTo(w);
            make.height.mas_equalTo(w);
            
        }];
        
        //微信
        UIButton *shareWXZoneBtn = [[UIButton alloc] init];
        [shareWXZoneBtn setImage:[UIImage imageNamed:@"微信"] forState:UIControlStateNormal];
        [bgView addSubview:shareWXZoneBtn];
        [shareWXZoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(hintLbl.mas_bottom).offset(23);
            make.left.equalTo(shareFriendBtn.mas_right).offset(15);
            make.width.mas_equalTo(w);
            make.height.mas_equalTo(w);
            
        }];
        
        //
        UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 139, SCREEN_WIDTH, 54)];
        [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        
        [bgView addSubview:cancleBtn];
        cancleBtn.backgroundColor = [UIColor whiteColor];
        [cancleBtn setTitleColor:[UIColor zh_textColor] forState:UIControlStateNormal];
        [cancleBtn addTarget:self action:@selector(cancleShare:) forControlEvents:UIControlEventTouchUpInside];
        
        shareFriendBtn.tag = 100;
        shareWXZoneBtn.tag = 101;
        [shareFriendBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        [shareWXZoneBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return self;

}

- (void)setQrContentStr:(NSString *)qrContentStr {

    _qrContentStr = qrContentStr;
    
    [self.qrImageView removeFromSuperview];
    
    self.qrImageView.image = [SGQRCodeTool SG_generateWithDefaultQRCodeData:_qrContentStr imageViewWidth:SCREEN_WIDTH];
    
    [self addSubview:self.qrImageView];

}

- (void)show {
    
    if (![TLWXManager judgeAndHintInstalllWX]) {
        
        return;
    }

    [[UIApplication sharedApplication].keyWindow addSubview:self];


}





- (void)share:(UIButton *)btn {
    
    [TLWXManager manager].wxShare = ^(BOOL isSuccess,int errorCode){
        
        if (self.wxShare) {
            self.wxShare(isSuccess,errorCode);
        }
        
        if (isSuccess) {
            
            [(UIControl *)[[btn nextResponder] nextResponder] removeFromSuperview];
            
        } else {
            
            [TLAlert alertWithHUDText:@"分享失败"];
           
        }
        
    };
    
    
    [TLWXManager wxShareWebPageWithScene:btn.tag == 100 ? WXSceneTimeline : WXSceneSession title:self.title desc:self.content url:self.shareUrl];
    
}

- (void)cancleShare:(UIControl *)ctrl {
    
    //
    if ([ctrl isMemberOfClass:[UIButton class]]) {
        
        [(UIControl *)[[ctrl nextResponder] nextResponder] removeFromSuperview];
        
    } else {
        
        [ctrl removeFromSuperview];
        
    }
    
}

@end
