//
//  ZHTreasureInfoView.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/27.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHTreasureInfoView.h"


@interface ZHTreasureInfoView()



@end

@implementation ZHTreasureInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
        UILabel *hintLbl = [UILabel labelWithFrame:CGRectZero
                                      textAligment:NSTextAlignmentLeft
                                   backgroundColor:[UIColor whiteColor]
                                              font:FONT(11)
                                         textColor:[UIColor zh_textColor2]];
        [self addSubview:hintLbl];
        hintLbl.text = @"购买进度:";
        
        [hintLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.mas_left).offset(13);
            make.top.equalTo(self.mas_top);
            
        }];
        
        //
        self.progress = [[ZHProgressView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.progress];
        [self.progress mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(hintLbl.mas_right).offset(3);
            make.centerY.equalTo(hintLbl);
            make.width.mas_equalTo(@190);
            make.height.mas_equalTo(@10);
        }];
        
        //
        self.peopleView = [[ZHDoubleTitleView alloc] initWithFrame:CGRectZero];
        self.peopleView.topLbl.text = @"参与人数";
        [self addSubview:self.peopleView];
        
//        self.priceView = [[ZHDoubleTitleView alloc] initWithFrame:CGRectZero];
//        self.priceView.topLbl.text = @"单价（元）";
//        self.priceView.bootomLbl.textColor = [UIColor zh_themeColor];
//        [self addSubview:self.priceView];
        
        self.dayView = [[ZHDoubleTitleView alloc] initWithFrame:CGRectZero];
        self.dayView.topLbl.text = @"剩余天数";
        [self addSubview:self.dayView];
        
        
        [self.peopleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.top.equalTo(hintLbl.mas_bottom).offset(16);
            make.right.equalTo(self.dayView.mas_left);
            make.width.equalTo(self.dayView.mas_width);
            make.bottom.equalTo(self.mas_bottom);
            
        }];
        
//        [self.priceView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.peopleView.mas_right);
//            make.top.equalTo(self.peopleView);
//            make.right.equalTo(self.dayView.mas_left);
//            make.width.equalTo(self.peopleView.mas_width);
//            make.width.equalTo(self.dayView.mas_width);
//        }];
        
        [self.dayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.peopleView.mas_right);
            make.top.equalTo(self.peopleView.mas_top);
            make.right.equalTo(self.mas_right);
             make.width.equalTo(self.peopleView.mas_width);
        }];
        
        //两条线
        UIView *line1 = [[UIView alloc] init];
        [self addSubview:line1];
        line1.backgroundColor = [UIColor zh_lineColor];
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.peopleView.mas_right);
            make.width.mas_equalTo(@1);
            make.top.equalTo(self.peopleView.mas_top).offset(4);
            make.bottom.equalTo(self.peopleView.mas_bottom).offset(-4);
        }];
        
//        UIView *line2 = [[UIView alloc] init];
//        [self addSubview:line2];
//        line2.backgroundColor = [UIColor zh_lineColor];
//        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.priceView.mas_right);
//            make.width.mas_equalTo(@1);
//            make.top.equalTo(self.peopleView.mas_top).offset(4);
//            make.bottom.equalTo(self.peopleView.mas_bottom).offset(-4);
//        }];
        
        
    }
    return self;
}

@end
