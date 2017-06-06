//
//  CDSingleParamView.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/6/6.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CDGoodsParameterModel;

#define SINGLE_CONTENT_MARGIN 15
#define SINGLE_CONTENT_FONT [UIFont systemFontOfSize:14]

@interface CDSingleParamView : UIButton

@property (nonatomic, strong) UILabel *contentLbl;

- (void)unSelected;
- (void)selected;

@property (nonatomic, strong) CDGoodsParameterModel *parameterModel;

@end
