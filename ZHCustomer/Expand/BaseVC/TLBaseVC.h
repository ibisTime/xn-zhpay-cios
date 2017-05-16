//
//  TLBaseVC.h
//  WeRide
//
//  Created by  tianlei on 2016/11/25.
//  Copyright © 2016年 trek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLBaseVC : UIViewController

@property (nonatomic,strong) UIView *tl_placeholderView;


- (void)tl_placeholderOperation;


- (void)removePlaceholderView; //移除
- (void)addPlaeholderView; // 添加
//更新placeholderView
- (void)setPlacholderViewTitle:(NSString *)title  operationTitle:(NSString *)optitle;

@end
