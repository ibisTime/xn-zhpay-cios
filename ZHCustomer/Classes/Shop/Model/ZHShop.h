//
//  ZHShop.h
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/19.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLBaseModal.h"
#import "ZHCoupon.h"

@interface ZHShop : TLBaseModal

//从本地读取店铺信息，有返回yes,并初始化用户信息 否则返回NO
- (BOOL)getInfo;



@property (nonatomic,copy)  NSString *code;

@property (nonatomic,copy) NSString *adPic; //封面图
@property (nonatomic,copy) NSString *type; //地址
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *province;
@property (nonatomic,copy) NSString *city;
@property (nonatomic,copy) NSString *area;
@property (nonatomic,copy) NSString *address;//详细地址

@property (nonatomic,copy) NSString *longitude;//经度
@property (nonatomic,copy) NSString *latitude;//纬度

@property (nonatomic,copy) NSString *bookMobile; //电话
@property (nonatomic,copy) NSString *slogan;//广告语
@property (nonatomic,copy) NSString *legalPersonName;

@property (nonatomic,copy) NSString *userReferee; //推荐人

@property (nonatomic,strong) NSNumber *rate1;//使用折扣券分成比例
@property (nonatomic,strong) NSNumber *rate2;

@property (nonatomic,copy) NSString *pic; //图片拼接字符串
@property (nonatomic,copy) NSString *descriptionShop;//店铺详述
@property (nonatomic,copy) NSString *owner;//拥有者
@property (nonatomic,copy) NSString *status;
@property (nonatomic,strong) NSArray <ZHCoupon *>*storeTickets;//商家折扣券
@property (nonatomic,copy) NSString *distance;
//
@property (nonatomic,copy) NSArray *detailPics;
@property (nonatomic,strong) NSArray <NSNumber *>* imgHeights;



//优惠信息
- (NSString *)discountDescription;

- (NSString *)distanceDescription;
//位置信息
//- (NSString *)distance;

//
- (CGFloat)detailHeight;


- (void)changShopInfoWithDict:(NSDictionary *)dict;

//图片URl
//- (NSArray <NSString *>*)detailPics;



- (NSString *)getCoverImgUrl;
- (NSString *)getStatusName;
- (NSString *)getTypeName;

- (void)loginOut;

+ (void)getShopInfoWithToken:(NSString *)token userId:(NSString *)userId  showInfoView:(UIView *)view success:(void(^)(NSDictionary *shopDict))success failure:(void(^)(NSError *error))failure;

@end

FOUNDATION_EXTERN  NSString *const kShopInfoChange;

