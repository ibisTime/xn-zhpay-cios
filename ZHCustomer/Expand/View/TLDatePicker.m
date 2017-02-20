//
//  TLDatePickerView.m
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/20.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLDatePicker.h"

@implementation TLDatePicker
{

    UIControl *_bgCtrl;
}
- (instancetype)init {

    if (self = [super init]) {
        


    }
    return self;
}

- (UIDatePicker *)datePicker {

    if (!_datePicker) {
        
        UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 200, SCREEN_WIDTH,200)];
        datePicker.backgroundColor = [UIColor whiteColor];
        datePicker.datePickerMode = UIDatePickerModeDate;
        datePicker.minimumDate = [NSDate date];
        _datePicker = datePicker;
    }

    return _datePicker;
}

- (void)show {

   UIControl *bgCtrl = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
   _bgCtrl = bgCtrl;
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 240, SCREEN_WIDTH, 240)];
    [bgCtrl addSubview:bgView];
    
    //取消btn
    UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 60, 40) title:@"取消" backgroundColor:[UIColor whiteColor]];
    [cancleBtn addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
    [cancleBtn setTitleColor:[UIColor zh_themeColor] forState:UIControlStateNormal];
    bgView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:cancleBtn];
    
    //确定btn
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 70, 0, 60, 40) title:@"确定" backgroundColor:[UIColor whiteColor]];
    [confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:confirmBtn];
    [confirmBtn setTitleColor:[UIColor zh_themeColor] forState:UIControlStateNormal];

   
    
    [bgCtrl addSubview:self.datePicker];
    [bgCtrl addTarget:self action:@selector(remove:) forControlEvents:UIControlEventTouchUpInside];
    
    bgCtrl.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [[UIApplication sharedApplication].keyWindow addSubview:bgCtrl];
    
}

- (void)confirm {

    if (self.confirmAction) {
        self.confirmAction(self.datePicker.date);
    }
    [_bgCtrl removeFromSuperview];


}

- (void)cancle {

    [_bgCtrl removeFromSuperview];

}


- (void)remove:(UIControl *)ctrl {
    
    [ctrl removeFromSuperview];
}

@end
