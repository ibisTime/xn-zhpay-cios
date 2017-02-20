//
//  TLBaseVC.m
//  WeRide
//
//  Created by  tianlei on 2016/11/25.
//  Copyright © 2016年 trek. All rights reserved.
//

#import "TLBaseVC.h"

@interface TLBaseVC ()

@end

@implementation TLBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    
}

- (UIView *)tl_placholderViewWithTitle:(NSString *)title opTitle:(NSString *)opTitle {
    
    if (!_tl_placeholderView) {
        
        UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
        view.backgroundColor = self.view.backgroundColor;
        UILabel *lbl = [UILabel labelWithFrame:CGRectMake(0, 100, view.width, 50) textAligment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor] font:FONT(18) textColor:[UIColor zh_textColor]];
        [view addSubview:lbl];
        lbl.text = title;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, lbl.yy + 10, 200, 40)];
        [self.view addSubview:btn];
        btn.titleLabel.font = FONT(15);
        [btn setTitleColor:[UIColor zh_themeColor] forState:UIControlStateNormal];
        btn.centerX = view.width/2.0;
        btn.layer.cornerRadius = 5;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [UIColor zh_themeColor].CGColor;
        [btn addTarget:self action:@selector(tl_placeholderOperation) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:opTitle forState:UIControlStateNormal];
        [view addSubview:btn];
        
        _tl_placeholderView = view;
    }
    return _tl_placeholderView;
    
}

#pragma mark- 站位操作
- (void)tl_placeholderOperation {

    if ([self isMemberOfClass:NSClassFromString(@"TLBaseVC")]) {
        
        NSLog(@"子类请重写该方法");
        
    }

}


//- (UIStatusBarStyle)preferredStatusBarStyle {
//    
//    return UIStatusBarStyleLightContent;
//    
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
