//
//  CDShopTypeChooseView.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/6/14.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHShopTypeModel.h"


@protocol CDShopTypeChoosDelegate <NSObject>

- (void)didChoose:(NSInteger)idx typeModel:(ZHShopTypeModel *)model;

@end

@interface CDShopTypeChooseView : UIView

+ (instancetype)chooseView;

@property (nonatomic, copy) NSArray<ZHShopTypeModel *> *typeModels;
@property (nonatomic, weak) id<CDShopTypeChoosDelegate> delegate;

@end
