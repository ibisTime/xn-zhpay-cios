//
//  TLMsgPlayView.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/5/17.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLMsgPlayView.h"


@interface TLMsgPlayView()

@property (nonatomic, strong) UILabel *playLbl1;
@property (nonatomic, strong) UILabel *playLbl2;

@property (nonatomic, assign) NSTimeInterval playTimeLen;

@end

@implementation TLMsgPlayView



- (UILabel *)playLbl1 {

    if (!_playLbl1) {
        
         _playLbl1 = [UILabel labelWithFrame:CGRectZero textAligment:NSTextAlignmentCenter
                            backgroundColor:[UIColor orangeColor]
                                       font:FONT(12)
                                  textColor:[UIColor colorWithHexString:@"#222222"]];
    }
    
    return _playLbl1;
}

- (UILabel *)playLbl2 {
    
    if (!_playLbl2) {
        
        _playLbl2 = [UILabel labelWithFrame:CGRectZero textAligment:NSTextAlignmentCenter
                            backgroundColor:[UIColor orangeColor]
                                       font:FONT(12)
                                  textColor:[UIColor colorWithHexString:@"#222222"]];
    }
    
    return _playLbl2;
}


- (void)setPlayMsg:(NSString *)playMsg {

    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
    
    [self addSubview:self.playLbl1];
    [self addSubview:self.playLbl2];

    
    
    _playMsg = [playMsg copy];
    self.playLbl1.text = _playMsg;
    self.playLbl2.text = _playMsg;
    
    
    //计算运动距离
    CGSize size = [_playMsg calculateStringSize:CGSizeMake(MAXFLOAT, self.height)
                                           font:FONT(12)];
    CGFloat distance = self.width + size.width;
    
    //计算动画时间
    self.playTimeLen = distance/self.width + 3.5;
    
    //计算延迟时间
    
    //2个lbl之间的间距
    CGFloat lblsMargin = self.width/1.5;
    
    self.playLbl1.frame = CGRectMake(self.width, 0, size.width, self.height);
    self.playLbl2.frame = CGRectMake(self.width, 0, size.width, self.height);
    
    //
    [self play];
    [self play2];
    
    //
    NSTimer *timer = [NSTimer timerWithTimeInterval:self.playTimeLen target:self selector:@selector(play) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    dispatch_after(self.playTimeLen/2.0, dispatch_get_main_queue(), ^{
        
        NSTimer *timer2 = [NSTimer timerWithTimeInterval:self.playTimeLen target:self selector:@selector(play2) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer2 forMode:NSRunLoopCommonModes];
        
    });


   
 
}

- (void)play {

 
    
    [UIView animateWithDuration:self.playTimeLen delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.playLbl1.x = - self.playLbl1.width;

    } completion:^(BOOL finished) {
        
        self.playLbl1.x = self.width;

    }];
    

    
    

    
}

- (void)play2 {

    [UIView animateWithDuration:self.playTimeLen delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.playLbl2.x = - self.playLbl2.width;
        
    } completion:^(BOOL finished) {
        
        self.playLbl2.x = self.width;
        
    }];
    

}



//- (void)repeatAnimationWithTime:(CGFloat)time startX:(CGFloat)x {
//
//    [UIView animateWithDuration:time animations:^{
//        self.playLbl.x = startX;
//    } completion:^(BOOL finished) {
//        self.playLbl.x = self.width;
//    }];
//
//}

@end
