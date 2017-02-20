//
//  ZHNavigationController.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/23.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHNavigationController.h"

@interface ZHNavigationController ()

@end

@implementation ZHNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.backIndicatorImage = [UIImage imageNamed:@"返回"];
    self.navigationBar.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"返回"];

    
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {

    if (self.viewControllers.count > 0) {
        
        viewController.hidesBottomBarWhenPushed = YES;
        
   

    }
    [super pushViewController:viewController animated:YES];

}

- (void)back {

    [self popViewControllerAnimated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
