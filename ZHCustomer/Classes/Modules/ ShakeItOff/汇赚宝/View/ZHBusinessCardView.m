//
//  ZHBusinessCardView.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/8.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHBusinessCardView.h"

@implementation ZHBusinessCardView

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {

        self.backgroundColor = [UIColor whiteColor];
        
        //--//
        UIImageView *headerImageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 60, 60)];
        headerImageV.layer.cornerRadius = 30;
        headerImageV.clipsToBounds = YES;
        [self addSubview:headerImageV];
        self.headerImageV = headerImageV;
        
        headerImageV.image = [UIImage imageNamed:@"user_placeholder"];
        //股东
        TLTextField *nameTf = [self tfByframe:CGRectMake(headerImageV.xx + 22, 23, SCREEN_WIDTH - self.yy - 23 , [[UIFont secondFont] lineHeight]) leftTitle:@"股东：" titleWidth:70 placeholder:nil];
        //    nameTf.text = @"藏啊按时";
        [self addSubview:nameTf];
        nameTf.text = [ZHUser user].nickname;
        self.titleTf = nameTf;
        
        //状态
        TLTextField *statusTf = [self tfByframe:CGRectMake(headerImageV.xx + 22, nameTf.yy + 10, SCREEN_WIDTH - self.yy - 23 , [[UIFont secondFont] lineHeight]) leftTitle:@"状态：" titleWidth:70 placeholder:nil];
        [self addSubview:statusTf];
        self.subTitleTf = statusTf;
        
    }
    
    return self;
}

- (TLTextField *)tfByframe:(CGRect)frame
                 leftTitle:(NSString *)leftTitle
                titleWidth:(CGFloat)titleW
               placeholder:(NSString *)placeholder {
    
    TLTextField *tf = [[TLTextField alloc] initWithframe:frame leftTitle:leftTitle titleWidth:titleW placeholder:placeholder];
    UILabel *lbl = (UILabel *)tf.leftView.subviews[0];
    lbl.textColor = [UIColor zh_textColor2];
    tf.textColor = [UIColor zh_textColor];
    
    tf.enabled = NO;
    return tf;
    
}

@end
