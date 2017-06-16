//
//  CDChooseTimeIntervalView.m
//  ZHBusiness
//
//  Created by  tianlei on 2017/6/14.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CDChooseTimeIntervalView.h"
#import "TLDatePicker.h"

@interface CDChooseTimeIntervalView()

@property (nonatomic,assign) BOOL isBegin;
@property (nonatomic,assign) BOOL isEnd;
@property (nonatomic, strong) TLDatePicker *datePicker;


@end

@implementation CDChooseTimeIntervalView


- (BOOL)valid {

    if (![self.beginTimeTf.text valid]) {
        
        [TLAlert alertWithInfo:@"请选择开始时间"];
        return NO;
    }
    if (![self.beginTimeTf.text valid]) {
        
        [TLAlert alertWithInfo:@"请选择结束"];
        return NO;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd";
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    NSDate *date1 =  [formatter dateFromString:self.beginTimeTf.text];
    NSDate *date2 =  [formatter dateFromString:self.endTimeTf.text];
    
    //判断结束日期不能大于起始日期
    if ([date1 timeIntervalSince1970] > [date2 timeIntervalSince1970]) {
        
        [TLAlert alertWithInfo:@"开始时间应该早于结束时间"];
        return NO;
        
    }
    
    
    return YES;

}

+ (instancetype)chooseView {

    CDChooseTimeIntervalView *view = [[CDChooseTimeIntervalView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 91)];
    view.backgroundColor = [UIColor backgroundColor];
    
    return view;
}



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UILabel *lbl = [UILabel labelWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 30)
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor clearColor]
                                          font:FONT(13)
                                     textColor:[UIColor themeColor]];
        [self addSubview:lbl];
        lbl.text = @"支持7天内账单查询";
        
        [self addSubview:self.beginTimeTf];
        self.beginTimeTf.y = lbl.yy;
        
        self.endTimeTf.y = self.beginTimeTf.yy + 1;
        [self addSubview:self.endTimeTf];
        self.height = self.endTimeTf.yy + 1;
        
        self.datePicker = [[TLDatePicker alloc] init];
        
        //
        __weak typeof(self) weakSelf = self;
        self.datePicker.confirmAction = ^(NSDate *date) {
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"YYYY-MM-dd";
            if (weakSelf.isBegin) {
                
                weakSelf.beginTimeTf.text = [dateFormatter stringFromDate:date];
                
            } else {
                
                weakSelf.endTimeTf.text = [dateFormatter stringFromDate:date];
                
                //
            }
            weakSelf.isBegin = NO;
            weakSelf.isEnd = NO;
            
        };
        
        //
        //
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        
        NSDateComponents *minComponents = [[NSDateComponents alloc] init];
        [minComponents setDay:-7];
        
        //
        NSDateComponents *maxComponents = [[NSDateComponents alloc] init];
        [maxComponents setDay:-1];
        
        //最大时间
        self.datePicker.datePicker.maximumDate = [calendar dateByAddingComponents:maxComponents toDate:[NSDate date] options:0];
        
        self.datePicker.datePicker.minimumDate =  [calendar dateByAddingComponents:minComponents toDate:[NSDate date] options:0];
        
        //
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd";
        self.beginTimeTf.text = [formatter stringFromDate:self.datePicker.datePicker.minimumDate];
        self.endTimeTf.text = [formatter stringFromDate:self.datePicker.datePicker.maximumDate];
    }
    return self;
}


#pragma mark- 开始结束时间
- (void)chooseBeginTime {
    
//    [self.view endEditing:YES];
    self.isBegin =  YES;
    [self.datePicker show];
}


- (void)chooseEndTime {
    
    self.isEnd = YES;
    [self.datePicker show];
    
}


- (TLTextField *)beginTimeTf {
    
    if (!_beginTimeTf) {
        
        _beginTimeTf = [[TLTextField alloc] initWithframe:CGRectMake(0, 0, SCREEN_WIDTH,45) leftTitle:@"开始时间" titleWidth:100 placeholder:@"请点击选择开始时间"];
//        _beginTimeTf.leftLbl.textColor = [UIColor textColor];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:_beginTimeTf.bounds];
        [_beginTimeTf addSubview:btn];
        [btn addTarget:self action:@selector(chooseBeginTime) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _beginTimeTf;
}

- (TLTextField *)endTimeTf {
    
    if (!_endTimeTf) {
        
        _endTimeTf = [[TLTextField alloc] initWithframe:CGRectMake(0, 0, SCREEN_WIDTH, self.beginTimeTf.height) leftTitle:@"结束时间" titleWidth:100 placeholder:@"请点击选择结束时间"];
//        _endTimeTf.leftLbl.textColor = [UIColor textColor];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:_endTimeTf.bounds];
        [_endTimeTf addSubview:btn];
        [btn addTarget:self action:@selector(chooseEndTime) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _endTimeTf;
}


@end
