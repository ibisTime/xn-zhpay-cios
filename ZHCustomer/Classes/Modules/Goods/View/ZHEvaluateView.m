//
//  ZHEvaluateView.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/28.
//  Copyright © 2016年  tianlei. All rights reserved.
//  评价的星星view

#import "ZHEvaluateView.h"
@interface ZHEvaluateView()

@property (nonatomic,strong) UIView *backgroundView;
@property (nonatomic,strong) UIView *forgroundView;

@property (nonatomic,assign) CGFloat fW;


@end

@implementation ZHEvaluateView

- (UIView *)backgroundView {

    if (!_backgroundView) {
        CGFloat h = self.height;
        _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        _backgroundView.centerY = self.height/2.0;
        
        for (NSInteger i = 0; i < 5; i ++) {
            CGFloat x = i*(h + 3);
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, h, h)];
            iv.centerY = _backgroundView.height/2.0;
            iv.image = [UIImage imageNamed:@"灰星"];
            [_backgroundView addSubview:iv];
        }
        
        
    }
    return _backgroundView;

}

- (UIView *)forgroundView {

    if (!_forgroundView) {

        CGFloat h = self.height;
        _forgroundView = [[UIView alloc] initWithFrame:self.bounds];
        _forgroundView.clipsToBounds = YES;
        _forgroundView.centerY = _backgroundView.centerY;

        for (NSInteger i = 0; i < 5; i ++) {
            CGFloat x = i*(h + 3);
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, h, h)];
            iv.image = [UIImage imageNamed:@"红星"];
            [_forgroundView addSubview:iv];
            iv.centerY = _forgroundView.height/2.0;

            if (i == 4) {
                
                self.fW = iv.xx;
            }
        }
        
    }
    return _forgroundView;

}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.backgroundView];
        [self addSubview:self.forgroundView];
    }
    return self;
}

- (void)setPercent:(CGFloat)percent {

    if (_percent == percent) {
        return;
    }
    _percent = percent;
    self.forgroundView.width = self.fW * percent;
//
}

@end
