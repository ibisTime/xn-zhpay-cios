//
//  ZHBusinessCardView.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/8.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHBusinessCardView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic,strong) UIImageView *headerImageV;
@property (nonatomic,strong) TLTextField *titleTf;
@property (nonatomic,strong) TLTextField *subTitleTf;

@end
