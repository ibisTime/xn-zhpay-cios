//
//  ZHAccountSetBaseVC.m
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/12.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHAccountSetBaseVC.h"

@interface ZHAccountSetBaseVC ()

@end

@implementation ZHAccountSetBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bgSV = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _bgSV.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.bgSV.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 64 + 1);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.bgSV addGestureRecognizer:tap];
    [self.view addSubview:_bgSV];
    
    
//    [self.navigationController.navigationBar setTitleTextAttributes:@{
//                                     NSForegroundColorAttributeName : [UIColor whiteColor]
//                                     }];
}

- (void)tap {
    
    [self.view endEditing:YES];
    
}



@end
