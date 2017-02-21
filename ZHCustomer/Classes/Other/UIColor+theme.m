//
//  UIColor+theme.m
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/12.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "UIColor+theme.h"

@implementation UIColor (theme)

+ (UIColor *)zh_themeColor {

    return [UIColor colorWithHexString:@"#fe4332"];

}

+ (UIColor *)zh_textColor {

    return [UIColor colorWithHexString:@"#484848"];
}


+ (UIColor *)zh_textColor2 {
    
    return [UIColor colorWithHexString:@"#999999"];
}

+ (UIColor *)zh_lineColor {
    
    return [UIColor colorWithHexString:@"#eeeeee"];
}

+ (UIColor *)zh_backgroundColor {

    return [UIColor colorWithHexString:@"#f0f0f0"];
}

@end