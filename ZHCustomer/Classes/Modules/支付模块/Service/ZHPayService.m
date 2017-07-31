//
//  ZHPayService.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/7/17.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHPayService.h"
#import "ZHCurrencyModel.h"

//#define PAY_TYPE_DEFAULT_PAY_CODE @"1"
//#define PAY_TYPE_WX_PAY_CODE @"2"
//#define PAY_TYPE_ALI_PAY_CODE @"3"

NSString *const kZHAliPayTypeCode = @"3";
NSString *const kZHWXTypeCode = @"2";
NSString *const kZHDefaultPayTypeCode = @"1";

NSString *const kZHGiftPayTypeCode = @"20";


@implementation ZHPayService

+ (instancetype)service {

    static ZHPayService *s;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        s = [[ZHPayService alloc] init];
        
    });
    
    return s;

}

+ (BOOL)checkRealNameAuthByResponseObject:(id)obj {

    if (![obj isKindOfClass:[NSDictionary class]]) {
        
        return NO;
    }

    NSString *errorBizCode =  obj[@"errorBizCode"];
    if ( errorBizCode && [errorBizCode isEqualToString:@"M000001"]) {
        
        return YES;
        
    }
    
    return NO;
    
}

+ (void)getFRBToGiftB:(void(^)(NSNumber *rate))success failure:(void(^)())failure {

    
    TLNetworking *convertHttp = [TLNetworking new];
    convertHttp.code = @"002051";
    convertHttp.parameters[@"fromCurrency"] = kFRB;
    convertHttp.parameters[@"toCurrency"] = kGiftB;
    
    //        convertHttp.parameters[@"fromCurrency"] =  kGiftB;
    //        convertHttp.parameters[@"toCurrency"] = kFRB;
    [convertHttp postWithSuccess:^(id responseObject) {
        
        [ZHPayService service].frbToGiftBRate = responseObject[@"data"][@"rate"];
        if (success) {
            success([ZHPayService service].frbToGiftBRate);
        } ;
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure();
        }
        
        
    }];


}



@end
