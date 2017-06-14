//
//  CDChooseTimeIntervalView.h
//  ZHBusiness
//
//  Created by  tianlei on 2017/6/14.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol ChooseTimeIntervalDelegate <NSObject>
//
//- (void)
//
//@end

@interface CDChooseTimeIntervalView : UIView

+ (instancetype)chooseView;

- (BOOL)valid;

//开始日期
@property (nonatomic,strong) TLTextField *beginTimeTf;

//结束日期
@property (nonatomic,strong) TLTextField *endTimeTf;

@end
