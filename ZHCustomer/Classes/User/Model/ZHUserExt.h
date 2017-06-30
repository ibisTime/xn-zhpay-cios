//
//  ZHUserExt.h
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/15.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@interface ZHUserExt : TLBaseModel

@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *photo;

@property (nonatomic,copy) NSString *province;
@property (nonatomic,copy) NSString *city;
@property (nonatomic,copy) NSString *area;



@end
