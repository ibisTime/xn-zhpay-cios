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

@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, strong) NSMutableArray <NSValue *> *rectArr;

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

- (void)loadArr:(NSArray <NSString *>*)strArr {

    
    //1.计算cell
    
    CGFloat horiaonMargin = 10;
    CGFloat verticalMargin = 10;
    
    __block CGFloat lastHeight = 0;
    
    self.rectArr = [[NSMutableArray alloc] initWithCapacity:strArr.count];
    
    //
    [strArr enumerateObjectsUsingBlock:^(NSString * _Nonnull strObj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGFloat w = self.validBgView.width - 2*horiaonMargin;
        
        //
        CGSize size = [strObj calculateStringSize:CGSizeMake(w, MAXFLOAT) font:FONT(12)];
        CGRect frame = CGRectMake(horiaonMargin, verticalMargin + lastHeight, w, size.height);
        [self.rectArr addObject:[NSValue valueWithCGRect:frame]];
        
        //
//        UILabel *lbl = [[UILabel alloc] initWithFrame:frame];
//        lbl.numberOfLines = 0;
//        [self addSubview:lbl];
//        lbl.text = strObj;
//        lbl.backgroundColor = [UIColor grayColor];
//        lbl.textColor = [UIColor textColor];
//        lastHeight = lbl.yy;
        
    }];
    
    
    self.cellHeight = lastHeight;
    

}



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.65];
        [self addTarget:self action:@selector(remove:) forControlEvents:UIControlEventTouchUpInside];
        //中部规格选择
        
        CGFloat topMargin = 200;
        self.validBgView = [[UIView alloc] initWithFrame:CGRectMake(0, topMargin, self.width, self.height - topMargin)];
        [self addSubview:self.validBgView];
        self.validBgView.backgroundColor = [UIColor orangeColor];
        
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
        
        //底部按钮
        UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45) title:@"确定"
                                               backgroundColor:[UIColor themeColor]];
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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return self.cellHeight;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {


    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellId"];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCellId"];
        
    }
    
    [self.rectArr enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
//        [cell addSubview:];
        
    }];
    
    return cell;

}
@end
