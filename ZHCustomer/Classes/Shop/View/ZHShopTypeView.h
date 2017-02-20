//
//  ZHShopTypeView.h
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/23.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHShopTypeView : UIView

- (instancetype)initWithFrame:(CGRect)frame funcImage:(NSString *)imgName funcName:(NSString *)funcName;
@property (nonatomic,copy)  void(^selected)(NSInteger index);
@property (nonatomic,assign) NSInteger index;

@end
