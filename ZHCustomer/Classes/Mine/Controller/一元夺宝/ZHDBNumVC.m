//
//  ZHDBNumVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/13.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHDBNumVC.h"

@interface ZHDBNumVC ()

@end

@implementation ZHDBNumVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"夺宝号码";

    
    UIScrollView *sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    [self.view addSubview:sv];
    sv.backgroundColor = [UIColor whiteColor];
    
    sv.contentSize = CGSizeMake(SCREEN_WIDTH, 1);
    
    CGFloat w = SCREEN_WIDTH/4.0;
    CGFloat h  = [FONT(15) lineHeight] + 5;
      __block   UILabel *lastLbl;
    [self.treasureModel.jewelRecordNumberList enumerateObjectsUsingBlock:^(ZHTreasureRecordModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSInteger x = idx%4;
        NSInteger y = idx/4;
//        NSLog(@"%ld %ld",idx%4,idx/4);
        UILabel *lbl = [UILabel labelWithFrame:CGRectMake(x*w, 5 + y*h, w, h)
                                  textAligment:NSTextAlignmentCenter
                               backgroundColor:[UIColor clearColor]
                                          font:FONT(15)
                                     textColor:[UIColor zh_textColor]];
        [sv addSubview:lbl];
        lbl.text = self.treasureModel.jewelRecordNumberList[idx].number;
        lastLbl = lbl;
        
    }];
    
    
    sv.contentSize = CGSizeMake(SCREEN_WIDTH, lastLbl.yy + 10);
    

}

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
