//
//  TLWXManager.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/9.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLWXManager.h"
#import "AppConfig.h"

@implementation TLWXManager

+ (instancetype)manager {

    static TLWXManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[TLWXManager alloc] init];
    });
    return manager;

}

- (void)registerApp {

    [WXApi registerApp:[AppConfig config].wxKey withDescription:nil];


}


-(void) onReq:(BaseReq*)req {
    
    
}

#pragma mark- 收到微信的回应
-(void) onResp:(BaseResp*)resp {
    
    if ([resp isKindOfClass:[PayResp class]]) { //支付
        
        if (self.wxPay) {

            self.wxPay(resp.errCode == 0,resp.errCode);
            
        }
        
    } else if([resp isKindOfClass:[SendMessageToWXResp class]]) { //分享回调
        
        if (self.wxShare) {
            
            self.wxShare(resp.errCode == 0,resp.errCode);
            
        }
        
    }
    
}


+ (void)wxShareWebPageWithScene:(int)scene title:(NSString *)title desc:(NSString *)desc url:(NSString *)url {

    if (![WXApi isWXAppInstalled]) {
        
        NSLog(@"您还没有安装微信");
        return;
    }
    
    // -- //
    WXWebpageObject *webObj = [WXWebpageObject object];
    webObj.webpageUrl = url;
    
    //
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = desc;
    message.mediaObject = webObj;
    
    //
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    [WXApi sendReq:req];


}

+ (void)wxShareWebPageWith:(NSString *)title desc:(NSString *)desc url:(NSString *)url {
    
    
    [self wxShareWebPageWithScene:WXSceneTimeline title:title desc:desc url:url];
    

}


@end
