//
//  NSAttributedString+add.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/26.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "NSAttributedString+add.h"

@implementation NSAttributedString (add)

+ (NSAttributedString *)coverImg:(UIImage *)img bounds:(CGRect)bounds {

    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = img;
    textAttachment.bounds = bounds;
    return [NSAttributedString attributedStringWithAttachment:textAttachment];

}
@end
