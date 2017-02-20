//
//  TLTextField.h
//  WeRide
//
//  Created by  tianlei on 2016/12/7.
//  Copyright © 2016年 trek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLTextField : UITextField

- (instancetype)initWithframe:(CGRect)frame
                    leftTitle:(NSString *)leftTitle
                   titleWidth:(CGFloat)titleWidth
                  placeholder:(NSString *)placeholder;

//禁止复制粘贴等功能
@property (nonatomic,assign) BOOL isSecurity;


@end
