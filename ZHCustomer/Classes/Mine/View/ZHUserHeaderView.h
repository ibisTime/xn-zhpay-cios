//
//  ZHUserHeaderView.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/20.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHUserHeaderView : UIImageView

@property (nonatomic, strong) UIImageView *avatarImageV;

@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *mobileLbl;
@property (nonatomic, strong) UILabel *hintLbl;
@property (nonatomic, strong) UIButton *goLiBaoBtn;


@property (nonatomic,copy) void(^changePhoto)();

@property (nonatomic,copy) void(^tapAction)();

@property (nonatomic,copy) void(^goLiBaoAction)();


@end
