//
//  TLTimeButton.m
//  实验22
//
//  Created by 田磊 on 16/3/17.
//  Copyright © 2016年 田磊. All rights reserved.
//

#import "TLTimeButton.h"

@implementation TLTimeButton
{

    NSInteger _time;
    NSInteger _totalTime;
    NSTimer *_timer;
}

- (instancetype)initWithFrame:(CGRect)frame totalTime:(NSInteger)total
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _time = total;
        _totalTime = total;
        [self setTitle:@"获取验证码" forState:UIControlStateNormal];
        
        [self setTitleColor:[UIColor colorWithRed:0.427 green:0.749 blue:0.929 alpha:1.000] forState:UIControlStateNormal];
        
//        CGFloat r = 170.0/255.0;
       //[self setTitleColor:[UIColor colorWithRed:r green:r blue:r alpha:1.000] forState:UIControlStateDisabled];
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        self.titleLabel.font = [UIFont secondFont];
        self.enabled = YES;

    }
    return self;
}

- (void)forbid
{

    self.enabled = NO;
}

- (void)available
{

    self.enabled = YES;

}



- (void)begin{

    self.enabled = NO;
    
    [self setTitle:[NSString stringWithFormat:@"重新发送(%ld)",_totalTime] forState:UIControlStateDisabled];
    _timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
}

- (void)timeAction
{
    _time --;

    NSString *str = [NSString stringWithFormat:@"重新发送(%ld)",_time];
    [self setTitle:str forState:UIControlStateDisabled];

    if (_time == 0) {
        
        [_timer invalidate];
        _timer = nil;
        _time = _totalTime;
        self.enabled = YES;
    }
    
}
@end
