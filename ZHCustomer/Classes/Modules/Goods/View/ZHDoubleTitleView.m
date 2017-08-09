//
//  ZHDoubleTiitleView.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/26.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHDoubleTitleView.h"
#import "TLHeader.h"
#import "ZHUser.h"
#import "UIColor+theme.h"

@interface ZHDoubleTitleView()



@end

@implementation ZHDoubleTitleView


- (instancetype)initWithFrameLayout:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
    
        self.topLbl = [UILabel labelWithFrame:CGRectMake(0, 0, self.width, [FONT(11) lineHeight])
                                 textAligment:NSTextAlignmentCenter
                              backgroundColor:[UIColor clearColor]
                                         font:FONT(11)
                                    textColor:[UIColor zh_textColor2]];
        [self addSubview:self.topLbl];
        
        self.bootomLbl = [UILabel labelWithFrame:CGRectMake(0, self.topLbl.yy + 4, self.width, [FONT(13) lineHeight])
                                    textAligment:NSTextAlignmentCenter
                                 backgroundColor:[UIColor clearColor]
                                            font:FONT(13)
                                       textColor:[UIColor zh_textColor]];
        [self addSubview:self.bootomLbl];
        
        self.height = self.bootomLbl.yy;
        
        
    }
    return self;



}

- (instancetype)initWithFrame:(CGRect)frame {

  
    if (self = [super initWithFrame:frame]) {
        
        self.topLbl = [UILabel labelWithFrame:CGRectMake(0, 0, self.width, [FONT(11) lineHeight])
                                 textAligment:NSTextAlignmentCenter
                              backgroundColor:[UIColor whiteColor]
                                         font:FONT(11)
                                    textColor:[UIColor zh_textColor2]];
        [self addSubview:self.topLbl];
        [self.topLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
        }];

        //
        self.bootomLbl = [UILabel labelWithFrame:CGRectMake(0, self.topLbl.yy + 4, self.width, [FONT(13) lineHeight])
                                    textAligment:NSTextAlignmentCenter
                                 backgroundColor:[UIColor whiteColor]
                                            font:FONT(13)
                                       textColor:[UIColor zh_textColor]];
        [self addSubview:self.bootomLbl];
        [self.bootomLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self.topLbl.mas_bottom).offset(4);
            
        }];
    }
    
    return self;

}


@end
