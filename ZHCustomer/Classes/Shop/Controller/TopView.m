//
//  TopView.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/25.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TopView.h"

@implementation TopView

+ (instancetype)view {

    static TopView *view;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        view =  [[self alloc] initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, 64)];
        view.backgroundColor = [UIColor orangeColor];
        
        UILabel *lbl = [UILabel labelWithFrame:CGRectMake(15, 20, 70, 44) textAligment:NSTextAlignmentLeft backgroundColor:[UIColor whiteColor] font:[UIFont secondFont] textColor:[UIColor zh_textColor]];
        [view addSubview:lbl];
        lbl.text = @"杭州";
        
    });
    return view;
}


@end
