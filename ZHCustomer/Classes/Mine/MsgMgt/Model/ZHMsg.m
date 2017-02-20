//
//  ZHMsg.m
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/24.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHMsg.h"

@implementation ZHMsg


- (CGFloat)contentHeight {

//    - 57 - 20 - 20
   CGSize size = [self.smsContent calculateStringSize:CGSizeMake(SCREEN_WIDTH - 77 - 20, MAXFLOAT) font:[UIFont fontWithName:@"PingFangSC-Regular" size:12]];
    
    return size.height + 10;
    
}


@end


