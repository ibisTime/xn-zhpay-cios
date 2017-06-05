//
//  CDGoodsParameterChooseView.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/6/5.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CDGoodsParameterChooseView.h"

@interface CDGoodsParameterChooseView()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UIView *validBgView;
@end

@implementation CDGoodsParameterChooseView

+ (instancetype)chooseView {
    
    CDGoodsParameterChooseView *chooseView = [[CDGoodsParameterChooseView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    return chooseView;
    
}

- (void)show {

    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
}

- (void)remove:(UIControl*)maskCtrl {

    [maskCtrl removeFromSuperview];

}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.65];
        [self addTarget:self action:@selector(remove:) forControlEvents:UIControlEventTouchUpInside];
        //中部规格选择
        
        self.validBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, self.width, self.height - 100)];
        [self addSubview:self.validBgView];
        
        //
        UITableView *parameterTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.validBgView addSubview:parameterTableView];
        parameterTableView.delegate = self;
        parameterTableView.dataSource = self;

        
        [parameterTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.validBgView.mas_top).offset(30);
            make.left.equalTo(self.validBgView.mas_left);
            make.right.equalTo(self.validBgView.mas_right);
            make.bottom.equalTo(self.validBgView.mas_bottom).offset(-45);
        }];
        //
        
        
        //底部按钮
        UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45) title:@"确定" backgroundColor:[UIColor zh_themeColor]];
        [confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
        confirmBtn.titleLabel.font = FONT(18);
        [self.validBgView addSubview:confirmBtn];
        //
        [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.validBgView.mas_bottom);
            make.left.right.equalTo(self.validBgView);
            make.height.mas_offset(45);
        }];
        
    }
    return self;
}

//
- (void)confirm {


}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {


    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellId"];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCellId"];
        
    }
    
    return cell;

}
@end
