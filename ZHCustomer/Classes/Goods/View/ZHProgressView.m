//
//  ZHProgressView.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/26.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHProgressView.h"

@interface ZHProgressView()


@property (nonatomic,strong) UIView *forgroundView;
@property (nonatomic,strong) UILabel *progressLbl;
@property (nonatomic,assign) CGFloat w;

@end

@implementation ZHProgressView

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        UIView *backgroundV = [self viewWithColor:[UIColor colorWithHexString:@"#e1e1e1"]];
        [self addSubview:backgroundV];
        
        self.clipsToBounds = NO;
         self.w = 150;
        if (SCREEN_WIDTH == 320) {
           self.w = 120;
        }
        backgroundV.frame = CGRectMake(0, 0, _w, 10);
        backgroundV.layer.backgroundColor = [UIColor colorWithHexString:@"#e1e1e1"].CGColor;

//        [backgroundV mas_makeConstraints:^(MASConstraintMaker *make) {
//            
//            make.edges.equalTo(self);
//        }];
        
        UIView *forgroundView = [self viewWithColor:[UIColor zh_themeColor]];
        [self addSubview:forgroundView];
        self.forgroundView = forgroundView;
        forgroundView.frame = CGRectMake(0, 0, _w, 10);
        forgroundView.layer.backgroundColor = [UIColor zh_themeColor].CGColor;

        self.progressLbl = [UILabel labelWithFrame:CGRectMake(forgroundView.xx + 10, 0, 30, 10)
                                      textAligment:NSTextAlignmentLeft
                                   backgroundColor:[UIColor whiteColor] font:FONT(11) textColor:[UIColor zh_themeColor]];
        [self addSubview:self.progressLbl];
    }
    return self;

}

- (void)setProgress:(CGFloat)progress {

//    if (_progress == progress) {
//        return;
//    }
    _progress = progress;
    
    self.forgroundView.width = progress*self.w;
    
    self.progressLbl.text = [NSString stringWithFormat:@"%.f%%",progress*100];
    
}


- (UIView *)viewWithColor:(UIColor *)color {

    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = color;
    backgroundView.layer.masksToBounds = YES;
    backgroundView.layer.cornerRadius = 5;
    
    return backgroundView;

}

@end
