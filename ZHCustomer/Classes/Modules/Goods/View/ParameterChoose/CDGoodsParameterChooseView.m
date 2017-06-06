//
//  CDGoodsParameterChooseView.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/6/5.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CDGoodsParameterChooseView.h"
#import "CDSingleParamView.h"
#import "CDGoodsParameterModel.h"
#import "ZHStepView.h"

#define NORMAL_COLOR [[UIColor blackColor] colorWithAlphaComponent:0.65]


@interface CDGoodsParameterChooseView()

@property (nonatomic, strong) UIView *validBgView;
//@property (nonatomic, strong) UITableView *validTableView;

@property (nonatomic, strong) UIScrollView *validScrollView;

//图片
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *countLbl;
@property (nonatomic, strong) UILabel *priceLbl;


@property (nonatomic, copy) NSArray <CDGoodsParameterModel *>*paramerModels;

@property (nonatomic, strong) CDSingleParamView *lastParamView;
@property (nonatomic, strong) ZHStepView *stepView;

@end

@implementation CDGoodsParameterChooseView

+ (instancetype)chooseView {
    
    CDGoodsParameterChooseView *chooseView = [[CDGoodsParameterChooseView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    return chooseView;
}


- (void)show {

    CGFloat orgY = self.validBgView.y;
    self.validBgView.y = SCREEN_HEIGHT + 30;
    self.backgroundColor = [UIColor clearColor];
    //
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.validBgView.y = orgY;
        
    } completion:^(BOOL finished) {
        self.backgroundColor = NORMAL_COLOR;
    }];
    
}


- (void)remove:(UIControl*)maskCtrl {

    [self dismiss];
}

- (void)dismiss {

    [UIView animateWithDuration:0.3 animations:^{
        
        self.validBgView.y = SCREEN_HEIGHT + 30;;
        
    } completion:^(BOOL finished) {
        
        self.backgroundColor = NORMAL_COLOR;
        [self removeFromSuperview];

    }];

}


- (void)setCoverImageUrl:(NSString *)coverImageUrl {

    _coverImageUrl = [coverImageUrl copy];
    
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:self.coverImageUrl]];

}

- (void)loadArr:(NSArray <CDGoodsParameterModel *>*)strArr {

    self.paramerModels = strArr;
    //1.计算cell
    
    
    
    //
    self.priceLbl.text = [NSString stringWithFormat:@"价格%@",@"222"];
    
    //
    if (!(self.paramerModels && self.paramerModels.count)) {
        
        return;
    }
    
    [self loadData];

}



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = NORMAL_COLOR;
        [self addTarget:self action:@selector(remove:) forControlEvents:UIControlEventTouchUpInside];
        //中部规格选择
        
        CGFloat topMargin = 200;
        
   
        self.validBgView = [[UIView alloc] initWithFrame:CGRectMake(0, topMargin, self.width, self.height - topMargin)];
        [self addSubview:self.validBgView];
        self.validBgView.backgroundColor = [UIColor whiteColor];
        
        //商品图片
        self.coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, -15, 100, 100)];
        self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.coverImageView.layer.cornerRadius = 8;
        self.coverImageView.layer.masksToBounds = YES;
        self.coverImageView.backgroundColor = [UIColor whiteColor];
        [self.validBgView addSubview:self.coverImageView];
        self.coverImageView.layer.borderColor = [UIColor lineColor].CGColor;
        self.coverImageView.layer.borderWidth = 1.5;

        
        //数量
        self.countLbl = [UILabel labelWithFrame:CGRectZero
                                   textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor whiteColor]
                                           font:FONT(14)
                                      textColor:[UIColor textColor]];
        [self.validBgView addSubview:self.countLbl];
        
        //价格
        self.priceLbl = [UILabel labelWithFrame:CGRectZero
                                   textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor whiteColor]
                                           font:FONT(14)
                                      textColor:[UIColor themeColor]];
        [self.validBgView addSubview:self.priceLbl];
        self.priceLbl.numberOfLines = 0;
        
        
        [self.countLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.coverImageView.mas_right).offset(15);
            make.top.equalTo(self.validBgView.mas_top).offset(20);
            
        }];
        
        [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.countLbl.mas_left);
            make.top.equalTo(self.countLbl.mas_bottom).offset(10);
            make.right.lessThanOrEqualTo(self.validBgView.mas_right).offset(-15);
            
        }];
        
        //取消按钮
        UIButton *btn = [[UIButton alloc] init];
        [self.validBgView addSubview:btn];
//        btn.backgroundColor = [UIColor orangeColor];
        [btn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:@"parameter_cancle"] forState:UIControlStateNormal];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.validBgView.mas_right).offset(0);
            make.top.equalTo(self.validBgView.mas_top).offset(0);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(40);

        }];
        
        
        //规格数量的 table
        self.validScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        [self.validBgView addSubview:self.validScrollView];

        [self.validScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.coverImageView.mas_bottom).offset(15);
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


    if (self.delegate && [self.delegate respondsToSelector:@selector(finishChooseWithType:chooseView:parameter:count:)]) {
        
        [self.delegate finishChooseWithType:GoodsParameterChooseConfirm
                                 chooseView:self
                                  parameter:self.lastParamView.parameterModel count:self.stepView.count];
        
    }
    
}

- (void)loadData {

    UIView *bgView = [[UIView alloc] init];
    [self.validScrollView addSubview:bgView];

    //
    UILabel *parameterHintLbl = [UILabel labelWithFrame:CGRectMake(15, 0, 70, 30) textAligment:NSTextAlignmentLeft
                                        backgroundColor:[UIColor whiteColor]
                                                   font:FONT(15)
                                              textColor:[UIColor textColor]];
    
    [bgView addSubview:parameterHintLbl];
    parameterHintLbl.text = @"规格";
    
    //
    __block UIView *lastV = nil;
    
    [self.paramerModels enumerateObjectsUsingBlock:^(CDGoodsParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CDSingleParamView *v = [[CDSingleParamView alloc] initWithFrame:CGRectZero];
        [bgView addSubview:v];
        v.parameterModel = obj;
        v.contentLbl.text = [obj getDetailText];
        [v addTarget:self action:@selector(chooseOne:) forControlEvents:UIControlEventTouchUpInside];
        
        //
        if (idx == 0) {
            
            [v selected];
            self.lastParamView = v;
            self.countLbl.text = [obj getCountDesc];
            self.priceLbl.text = [obj getPrice];
            
            [v mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(bgView.mas_left).offset(15);
                make.right.equalTo(bgView.mas_right).offset(-15);
                make.top.equalTo(bgView.mas_top).offset(parameterHintLbl.height);
                make.bottom.equalTo(v.contentLbl.mas_bottom).offset(10);
                
            }];
            
        }  else {
            
            [v unSelected];
            [v mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(bgView.mas_left).offset(15);
                make.right.equalTo(bgView.mas_right).offset(-15);
                make.top.equalTo(lastV.mas_bottom).offset(10);
                make.bottom.equalTo(v.contentLbl.mas_bottom).offset(10);
                
            }];
            
        }
        
        lastV = v;
        
    }];
    
    

    
//    //加线
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor lineColor];
    [bgView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset(15);
        make.right.equalTo(bgView.mas_right);
        make.top.equalTo(lastV.mas_bottom).offset(10);
        make.height.mas_equalTo(LINE_HEIGHT);
        
    }];
    
    //----数量选择
            UILabel *countLbl = [UILabel labelWithFrame:CGRectZero
                                           textAligment:NSTextAlignmentLeft
                                        backgroundColor:[UIColor whiteColor]
                                                   font:FONT(15)
                                              textColor:[UIColor textColor]];
    
            [bgView addSubview:countLbl];
            countLbl.text = @"购买数量";
            [countLbl mas_makeConstraints:^(MASConstraintMaker *make) {
    
                make.top.equalTo(line.mas_bottom);
                make.left.equalTo(bgView.mas_left).offset(15);
                make.width.equalTo(@70);
                make.height.equalTo(@50);
    
            }];
    
    
            ZHStepView *stepV = [[ZHStepView alloc] initWithFrame:CGRectZero type:ZHStepViewTypeDefault];
            self.stepView = stepV;
            self.stepView.hintLbl.hidden = YES;
            self.stepView.isDefault = YES;
            [bgView addSubview:self.stepView];
    
            [stepV mas_makeConstraints:^(MASConstraintMaker *make) {
    
                make.right.equalTo(bgView.mas_right).offset(25);
                make.centerY.equalTo(countLbl.mas_centerY);
                make.width.mas_equalTo(@250);
                make.height.mas_equalTo(@25);
    
            }];
    

            //加线
            UIView *bottomLine = [[UIView alloc] init];
            bottomLine.backgroundColor = [UIColor lineColor];
            [bgView addSubview:bottomLine];
    
            [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(bgView.mas_left).offset(15);
                make.right.equalTo(bgView.mas_right);
                make.top.equalTo(countLbl.mas_bottom);
                make.height.mas_equalTo(LINE_HEIGHT);
            }];
 
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.validScrollView);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.bottom.equalTo(bottomLine.mas_bottom);
    }];



}

#pragma mark- 选择了一规格
- (void)chooseOne:(CDSingleParamView *)btn {

    if ([self.lastParamView isEqual:btn]) {
        
        return;
    }
    
    [btn selected];
    [self.lastParamView unSelected];
    
    self.priceLbl.text = [btn.parameterModel getPrice];
    self.countLbl.text = [btn.parameterModel getCountDesc];
    self.lastParamView = btn;

}





@end
