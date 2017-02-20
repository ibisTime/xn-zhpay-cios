//
//  ZHTreasureModel.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/11.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHTreasureModel.h"

@implementation ZHTreasureModel


- (NSArray<NSNumber *> *)imgHeights {
    
    if (!_imgHeights) {
        
        //未经转换的url
        NSArray *urls = [self.descriptionPic componentsSeparatedByString:@"||"];
        NSMutableArray *hs = [NSMutableArray arrayWithCapacity:urls.count];
        
        [urls enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            CGSize size = [obj imgSizeByImageName:obj];
            CGFloat scale = size.width*1.0/size.height;
            
            [hs addObject:@((SCREEN_WIDTH - 30)/scale + 10)];
            
        }];
        _imgHeights = hs;
    }
    return _imgHeights;
}

- (CGFloat)detailHeight {
    
    CGSize size  =  [self.descriptionText calculateStringSize:CGSizeMake(SCREEN_WIDTH - 30, 1000) font:FONT(13)];
    
    return size.height + 25;
}

- (CGFloat)getProgress {
    
    if (!(self.investNum && self.totalNum)) {
        
        return 0;
    }

   return [self.investNum floatValue]/[self.totalNum floatValue];
    
}

- (NSArray *)pics {
    
    if (!_pics) {
        
        NSArray *imgs = [self.descriptionPic componentsSeparatedByString:@"||"];
        NSMutableArray *newImgs = [NSMutableArray arrayWithCapacity:imgs.count];
        [imgs enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [newImgs addObject:[obj  convertImageUrl]];
            
        }];
        
        _pics = newImgs;
        
    }
    
    return _pics;
    
}

- (NSString *)getSurplusTime
{
    //开始时间
    NSDate *date02 = [self getDateByString:self.startDatetime];
    
    
    //已经过去的时间
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:date02];
    
    NSTimeInterval totalTime = [self.raiseDays integerValue]*24*60*60.0;

    NSTimeInterval surplusTime = totalTime - timeInterval;

    if (surplusTime <= 0) {
        
        return @"0";
        
    }
    //剩余时间
    
    //------//
    NSString *time = nil;
    if (surplusTime >= 24*60*60) {
        time = [NSString stringWithFormat:@"%.f天",surplusTime/(24*60*60)];
    } else {
        time = [NSString stringWithFormat:@"%.f小时",surplusTime/(60*60)];
    }
    
    //------//
    return time;
}


- (NSDate *)getDateByString:(NSString *)str
{
    NSString *dateStr = str;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MMM dd, yyyy hh:mm:ss aa";
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSDate *date01 = [formatter dateFromString:dateStr];
    return date01;
}

@end
