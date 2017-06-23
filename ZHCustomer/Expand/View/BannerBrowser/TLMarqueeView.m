//
//  TLMarqueeView.m
//  paoMaDeng
//
//  Created by  tianlei on 2017/6/22.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLMarqueeView.h"
#import "UIView+Frame.h"

#define MARGIN 50

@interface TLMarqueeView()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *firstLbl;
@property (nonatomic, strong) UILabel *secondLbl;

@property (nonatomic, strong) NSMutableArray <NSString *>*playMsgs;

@property (nonatomic, copy) NSString *currentPlaysMsg;
@property (nonatomic, assign) BOOL isFirst;

@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, assign) NSTimeInterval playDuration;


@end

@implementation TLMarqueeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.firstLbl];
        [self.contentView addSubview:self.secondLbl];
        self.isFirst = YES;
        self.playDuration = 3;
        self.clipsToBounds = YES;
  
    }
    return self;
}

- (void)setFont:(UIFont *)font {

    _font = font;
    self.firstLbl.font = font;
    self.secondLbl.font = font;

}

- (void)setTextColor:(UIColor *)textColor {

    _textColor = textColor;
    self.firstLbl.textColor = textColor;
    self.secondLbl.textColor = textColor;

}

- (void)begin {

    
//    NSString *msg = @"原文标题：乔布斯为何要开发iPhone？原因是听了微软高管吹牛乔布斯 北京时间6月22日消息，如果不是乔布斯讨厌微软的一位高管，苹果也许不会开发出iPhone或者iPad。[详细]";
    
    if (!self.msg) {
        return;
    }
    self.currentPlaysMsg = self.msg;
    
    NSString *msg = self.msg;
    [self reloadSizeWith:msg];



}

- (void)reloadSizeWith:(NSString *)msg {

    self.firstLbl.text = msg;
    self.secondLbl.text = msg;
    
    //
    CGSize size = [self.firstLbl sizeThatFits:CGSizeMake(MAXFLOAT, self.frame.size.height)];
    
    //
    CGFloat selfWidth = self.frame.size.width;
    CGFloat selfHeight = self.frame.size.height;
    
    
    if (size.width > selfWidth) {
        
        self.secondLbl.hidden = NO;
        
        self.contentView.frame = CGRectMake(0, 0, MARGIN + 2*size.width, selfHeight);
        self.firstLbl.frame = CGRectMake(0, 0, size.width, selfHeight);
        self.secondLbl.frame = CGRectMake(self.firstLbl.xx + MARGIN, 0, size.width, selfHeight);
        
        //速度不变
        CGFloat v = 60.0;
        
        //
        self.playDuration = size.width/v;
        [self beginAnimation];
        self.isPlaying = YES;
        
    } else {
        //不需要播放
        self.contentView.frame = CGRectMake(0, 0, size.width, selfHeight);
        self.firstLbl.frame = CGRectMake(0, 0, size.width, selfHeight);
        //移除动画
        [self.contentView.layer removeAllAnimations];
        self.secondLbl.hidden = YES;
        self.isPlaying = NO;

    }
    

}

- (void)setMsg:(NSString *)msg {

    _msg = [msg copy];
    
    if (self.isFirst) {
        
        self.isFirst = NO;
        
    } else {
        
        if (!self.isPlaying) {
            
            [self reloadSizeWith:_msg];
            
        }
    
    }
    

}


#pragma mark- 动画控制
- (void)beginAnimation {


    [UIView animateWithDuration:self.playDuration delay:1 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.contentView.x = - self.firstLbl.width - 50;
        
        
    } completion:^(BOOL finished) {
        
        self.contentView.x = 0;
        
        //判断有误最新消息，有的话更换消息
        [self.contentView.layer removeAllAnimations];
        if ([self.currentPlaysMsg isEqualToString:self.msg]) {
            
            [self beginAnimation];

        } else {
        
            self.currentPlaysMsg = self.msg;
            [self reloadSizeWith:self.currentPlaysMsg];
        }
        
    }];

}

- (void)addPlayMsg:(NSString *)msg {

    [self.playMsgs addObject:msg];

}


- (NSMutableArray<NSString *> *)playMsgs {

    if (!_playMsgs) {
      
        _playMsgs = [[NSMutableArray alloc] init];
        
    }
    
    return _playMsgs;

}


- (UIView *)contentView {

    if (!_contentView) {
        
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        _contentView.backgroundColor = [UIColor clearColor];

    }
    return _contentView;
}

- (UILabel *)firstLbl {

    if (!_firstLbl) {
        
        _firstLbl = [self lbl];
    }
    
    return _firstLbl;
}


- (UILabel *)secondLbl {
    
    if (!_secondLbl) {
        
        _secondLbl = [self lbl];
    }
    
    return _secondLbl;
}

- (UILabel *)lbl {

    UILabel *lbl = [[UILabel alloc] init];
    
    lbl.textColor = [UIColor blackColor];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.font = [UIFont systemFontOfSize:15];
    return lbl;

}


@end
