//
//  ZHUserAvatar.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/28.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHUserAvatar.h"

@implementation ZHUserAvatar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        UIImageView *avatar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 65, 65)];
        [self addSubview:avatar];
        avatar.centerX = self.width/2.0;
        self.avatar = avatar;
        avatar.layer.masksToBounds = YES;
        avatar.layer.cornerRadius = 65/2.0;
        avatar.layer.borderColor = [UIColor whiteColor].CGColor;
        avatar.layer.borderWidth = 1.5;
        
        //
        UILabel *nameLbl = [UILabel labelWithFrame:CGRectMake(0, avatar.yy + 10, SCREEN_WIDTH, [[UIFont secondFont] lineHeight])
                                      textAligment:NSTextAlignmentCenter
                                   backgroundColor:[UIColor clearColor]
                                              font:[UIFont secondFont]
                                         textColor:[UIColor zh_textColor]];
        [self addSubview:nameLbl];
        self.nameLbl = nameLbl;
        self.height = nameLbl.yy;
        
    }
    return self;
}


@end
