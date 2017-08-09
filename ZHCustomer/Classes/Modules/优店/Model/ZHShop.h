//
//  ZHShop.h
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/19.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"
#import <UIKit/UIKit.h>

@interface ZHShop : TLBaseModel

//TOCHECK("0", "待审核"), UNPASS("91", "审核不通过"),
//PASS("1", "审核通过待上架"),
//ON_OPEN( "2", "已上架，开店"),
//ON_CLOSE("3", "已上架，关店"),
//OFF("4", "已下架");

//从本地读取店铺信息，有返回yes,并初始化用户信息 否则返回NO
//- (BOOL)getInfo;


@property (nonatomic,copy)  NSString *code;
@property (nonatomic,copy) NSString *advPic; //封面图
@property (nonatomic,copy) NSString *type; //地址
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *province;
@property (nonatomic,copy) NSString *city;
@property (nonatomic,copy) NSString *area;

@property (nonatomic, copy) NSString *level;

@property (nonatomic,copy) NSString *address;//详细地址

@property (nonatomic,copy) NSString *longitude;//经度
@property (nonatomic,copy) NSString *latitude;//纬度

@property (nonatomic,copy) NSString *bookMobile; //电话
@property (nonatomic,copy) NSString *slogan;//广告语

@property (nonatomic, assign, readonly) CGFloat sloganHeight;

@property (nonatomic,copy) NSString *legalPersonName;

@property (nonatomic,copy) NSString *userReferee; //推荐人

@property (nonatomic,strong) NSNumber *rate1;//使用折扣券分成比例
@property (nonatomic,strong) NSNumber *rate2;

@property (nonatomic,copy) NSString *pic; //图片拼接字符串
@property (nonatomic,copy) NSString *descriptionShop;//店铺详述
@property (nonatomic,copy) NSString *owner;//拥有者
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *distance;
//

/**
 1 = 分润    ；2 = 余额 = 分润 + 贡献值
 */
@property (nonatomic, copy) NSString *payCurrency;

@property (nonatomic,copy) NSArray *detailPics;
@property (nonatomic,strong) NSArray <NSNumber *>* imgHeights;


- (NSString *)distanceDescription;

//
- (CGFloat)detailHeight;


/**
 是否为礼品商
 @return yes 是； no 不是
 */
- (BOOL)isGiftMerchant;



/**
 获取店铺类型名称 普通 或者礼品商
 */
- (NSString *)getShopTypeName;



- (NSString *)getCoverImgUrl;
- (NSString *)getStatusName;


+ (void)getShopInfoWithToken:(NSString *)token userId:(NSString *)userId  showInfoView:(UIView *)view success:(void(^)(NSDictionary *shopDict))success failure:(void(^)(NSError *error))failure;

@end

FOUNDATION_EXTERN  NSString *const kShopInfoChange;

FOUNDATION_EXTERN  NSString *const kShopOpenStatus;


