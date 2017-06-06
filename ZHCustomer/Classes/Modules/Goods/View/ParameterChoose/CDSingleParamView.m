//
//  CDSingleParamView.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/6/6.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CDSingleParamView.h"



//
@implementation CDSingleParamView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor grayColor];
        
//        //
        self.contentLbl = [UILabel labelWithFrame:CGRectZero
                                     textAligment:NSTextAlignmentLeft
                                  backgroundColor:[UIColor clearColor]
                                             font:SINGLE_CONTENT_FONT
                                        textColor:[UIColor textColor]];
        [self addSubview:self.contentLbl];
        self.contentLbl.numberOfLines = 0;
        
        //
        [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.mas_left).offset(10);
            make.top.equalTo(self.mas_top).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);

        }];
        
        
        //
        
    }
    return self;
}

//- (void)layoutSubviews {
//
//    [super layoutSubviews];
//    //
//    if (self.contentLbl) {
//       
//         self.contentLbl.frame = CGRectMake(SINGLE_CONTENT_MARGIN, SINGLE_CONTENT_MARGIN, self., <#CGFloat height#>)
//    }
//   
//}

@end
