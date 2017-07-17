//
//  NBRealNameService.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/7/17.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "NBRealNameService.h"

@implementation NBRealNameService



- (void)rzWithRealName:(NSString *)realName idNo:(NSString *)idNo {

    BOOL installedAliPay = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipays://"]];
    if (!installedAliPay) {
        //未安装支付宝，提示安装
      
        return;
    }
    if (!idNo || !realName) {
        
        NSLog(@"都不能为空");
        return;
    }
    
    //
    TLNetworking *http = [TLNetworking new];
    http.code = @"805191";
    //    http.url = @"http://121.40.165.180:8903/std-certi/api";
    http.parameters[@"userId"] = [ZHUser user].userId;
    http.parameters[@"idKind"] = @"1";
    http.parameters[@"idNo"] = idNo;
    http.parameters[@"realName"] = realName;
    [http postWithSuccess:^(id responseObject) {
        
        
        if ([responseObject[@"data"][@"isSuccess"] isEqual:@1]) {
            //服务器有认证记录,已成功
            

            
            return ;
        }
        
        //带卡进行认证
        [ZHUser user].tempBizNo = responseObject[@"data"][@"bizNo"];
        NSString *urlStr = [NSString stringWithFormat:@"http://121.40.165.180:8903/std-certi/zhima?bizNo=%@",responseObject[@"data"][@"bizNo"]];
        
        NSString *alipayUrl = [NSString stringWithFormat:@"alipayqr://platformapi/startapp?saId=10000007&qrcode=%@",urlStr];
        
        //打开进行
        //此方法到  -- ios10 -- 但是ios10还可以使用
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:alipayUrl]];
        
        
        
    } failure:^(NSError *error) {
        
        
    }];

}

@end
