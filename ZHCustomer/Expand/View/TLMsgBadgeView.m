//
//  TLMsgBadgeView.m
//  WeRide
//
//  Created by  tianlei on 2016/12/4.
//  Copyright © 2016年 trek. All rights reserved.
//

#import "TLMsgBadgeView.h"

@implementation TLMsgBadgeView
{
    BOOL _isSettedFrame;
    CGFloat _orgX;
    CGFloat _orgW;
    CGFloat _orgH;
}



- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        
        self.layer.backgroundColor = [UIColor zh_themeColor].CGColor;
        
        _orgX = frame.origin.x;
        _orgH = frame.size.height;
        _orgW = frame.size.width;
        _isRightResize = YES;
        self.padding = 10;
        self.layer.cornerRadius = frame.size.height / 2.0;
        self.font = [UIFont systemFontOfSize:10];
        self.textAlignment = NSTextAlignmentCenter;
        self.textColor = [UIColor whiteColor];
        
        self.hidden = YES;
        
    }
    return self;
}


- (void)setMsgCount:(NSInteger)msgCount
{

    
    if(msgCount < 0){
        NSLog(@"消息数量要大于 0");
        return;
    };
    
    if(msgCount == 0){
    
        self.hidden = YES;
        return;
    }
    self.hidden = NO;
    
    _msgCount = msgCount;
    
    NSString *countString = [NSString stringWithFormat:@"%ld",msgCount];
    
    if(msgCount >= 10){ ////////
       
        if(msgCount >= 100){
          countString = @"99+";
        }
        
   CGRect rect = [countString boundingRectWithSize:CGSizeMake(0, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{
                                                                                                                                        NSFontAttributeName:  [UIFont systemFontOfSize:10]
                                                                                                                                        } context:nil];
        CGFloat paddingTwo = self.padding;
        
        //增加或者减少的距离
        CGFloat dValue = rect.size.width + paddingTwo - _orgW;
        
        if(dValue){
            
            CGRect frame = CGRectMake(_orgX, self.frame.origin.y, _orgW, _orgH);
            
            //当视图变宽时，是起点不变，还是终点不变
            
            //1.终点不变
            if (_isRightResize) {
                
            } else {
                //2.起点不变
                frame.origin.x = _orgX - dValue;
            }
      
            
            frame.size.width = _orgW + dValue;
            self.frame = frame;
        
        }
        
        
    } else { //小于10的  消息
        
        
        CGRect frame = CGRectMake(_orgX, self.frame.origin.y, _orgW, _orgH);
        frame.size.width = _orgH;
        self.frame = frame;
        
    }
    
    self.text = countString;


}



@end
