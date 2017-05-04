//
//  ZHShopTypeView.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/23.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHShopTypeView.h"

@implementation ZHShopTypeView

- (instancetype)initWithFrame:(CGRect)frame funcImage:(NSString *)imgName funcName:(NSString *)funcName {

    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        UIView *bgView = self;
        bgView.backgroundColor = [UIColor whiteColor];
        
        UIButton *funcBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 14, 45, 45)];
        [bgView addSubview:funcBtn];
        funcBtn.centerX = bgView.width/2.0;
        [funcBtn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
        [funcBtn addTarget:self action:@selector(selectedAction) forControlEvents:UIControlEventTouchUpInside];
        
        self.funcBtn = funcBtn;
        
        CGFloat h = [[UIFont thirdFont] lineHeight];
        UILabel *nameLbl = [UILabel labelWithFrame:CGRectMake(0, funcBtn.yy + 7, bgView.width, h) textAligment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor] font:[UIFont thirdFont] textColor:[UIColor zh_textColor]];
        nameLbl.centerX = funcBtn.centerX;
        nameLbl.text = funcName;
        [bgView addSubview:nameLbl];
        
    }
    
    return self;

}

//--//
- (void)selectedAction {

    if (self.selected) {
        self.selected(self.index);
    }

}

//-//

@end
