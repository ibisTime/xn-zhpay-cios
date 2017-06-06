//
//  CDParameterDisplayView.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/6/5.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CDParameterDisplayView.h"

@implementation CDParameterDisplayView


- (void)loadArr:(NSArray <NSString *>*)strArr {


    CGFloat horiaonMargin = 10;
    CGFloat verticalMargin = 10;
    
    __block CGFloat lastHeight = 0;
   
    //
    [strArr enumerateObjectsUsingBlock:^(NSString * _Nonnull strObj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGSize size = [strObj calculateStringSize:CGSizeMake(self.width, MAXFLOAT) font:FONT(12)];
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(horiaonMargin, verticalMargin + lastHeight, size.width, size.height)];
        lbl.numberOfLines = 0;
        [self addSubview:lbl];
        lbl.text = strObj;
        lbl.backgroundColor = [UIColor grayColor];
        lbl.textColor = [UIColor textColor];
        
        lastHeight = lbl.yy;
        
    }];
    
}



@end
