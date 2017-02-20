//
//  ZHDBLastStepVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/14.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHDBLastStepVC.h"
#import "ZHAddressChooseView.h"


@interface ZHDBLastStepVC ()

@property (nonatomic,strong) UIImageView *coverImageV;


@end

@implementation ZHDBLastStepVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ZHAddressChooseView *addressDisplayView = [[ZHAddressChooseView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 89)];
    [self.view addSubview:addressDisplayView];
    addressDisplayView.type = ZHAddressChooseTypeDisplay;
    
    
    //宝贝信息
    UIView *infoScrollV = [[UIView alloc] initWithFrame:CGRectZero];
    infoScrollV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:infoScrollV];
    [infoScrollV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(addressDisplayView.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(@0);
        //make.height.mas_equalTo(@(SCREEN_HEIGHT - addressDisplayView.yy - 64));
    }];
    
    
    self.coverImageV = [[UIImageView alloc] initWithFrame:CGRectMake(15,15, 80, 65)];
    self.coverImageV.layer.masksToBounds  = YES;
    self.coverImageV.layer.cornerRadius = 2;
    self.coverImageV.layer.borderWidth = 0.5;
    self.coverImageV.layer.borderColor = [UIColor colorWithHexString:@"#dedede"].CGColor;
    self.coverImageV.contentMode = UIViewContentModeScaleAspectFill;
    [infoScrollV addSubview:self.coverImageV];
    
    UILabel *nameLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor whiteColor]
                                          font:FONT(15)
                                     textColor:[UIColor zh_textColor]];
    [infoScrollV addSubview:nameLbl];
    
    [nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coverImageV.mas_right).offset(15);
        make.top.equalTo(self.coverImageV.mas_top);
        make.width.mas_equalTo(@(SCREEN_WIDTH - self.coverImageV.xx - 20));
    }];
    //总需
    UILabel *totalNum = [UILabel labelWithFrame:CGRectZero
                                            textAligment:NSTextAlignmentLeft
                                         backgroundColor:[UIColor whiteColor]
                                                    font:FONT(13)
                                               textColor:[UIColor zh_textColor]];
    [infoScrollV addSubview:totalNum];
    [totalNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLbl.mas_left);
        make.top.equalTo(nameLbl.mas_bottom).offset(10);
        make.right.equalTo(nameLbl.mas_right);
    }];
    
    //幸运号码
    UILabel *numberLbl = [UILabel labelWithFrame:CGRectZero
                                   textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor whiteColor]
                                           font:FONT(13)
                                      textColor:[UIColor zh_textColor]];
    [infoScrollV addSubview:numberLbl];
    [numberLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLbl.mas_left);
        make.top.equalTo(totalNum.mas_bottom).offset(10);
        make.right.equalTo(nameLbl.mas_right);
    }];
    
    //本期参与
    UILabel *joninNumLbl = [UILabel labelWithFrame:CGRectZero
                                    textAligment:NSTextAlignmentLeft
                                 backgroundColor:[UIColor whiteColor]
                                            font:FONT(13)
                                       textColor:[UIColor zh_textColor]];
    [infoScrollV addSubview:joninNumLbl];
    [joninNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLbl.mas_left);
        make.top.equalTo(numberLbl.mas_bottom).offset(10);
        make.right.equalTo(nameLbl.mas_right);
        make.bottom.equalTo(joninNumLbl.mas_bottom);
    }];
    
    
    
    //
    
    //数据
    addressDisplayView.nameLbl.text = self.mineTreasure.receiver;
    addressDisplayView.mobileLbl.text = self.mineTreasure.reMobile;
    addressDisplayView.addressLbl.text = self.mineTreasure.reAddress;
    [self.coverImageV sd_setImageWithURL:[NSURL URLWithString:[self.mineTreasure.jewel.advPic convertThumbnailImageUrl]] placeholderImage:[UIImage imageNamed:GOODS_PLACEHOLDER_IMG]];
    
    //
    nameLbl.text = self.mineTreasure.jewel.name;
    totalNum.text = [NSString stringWithFormat:@"总需：%@",self.mineTreasure.jewel.totalNum];
    
    //幸运号码
    NSMutableAttributedString *numberAttrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"本期幸运号码：%@",self.mineTreasure.jewel.winNumber]];
    [numberAttrStr addAttribute:NSForegroundColorAttributeName value:[UIColor zh_themeColor] range:NSMakeRange(7, self.mineTreasure.jewel.winNumber.length)];
    
    numberLbl.attributedText = numberAttrStr;
    
    //本期参与
    joninNumLbl.text = [NSString stringWithFormat:@"本期参与：%@",self.mineTreasure.times];
    
    
    

    if ([self.mineTreasure.status isEqualToString:@"5"]) {
     
        UIButton *opBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64 - 45, SCREEN_WIDTH, 45)
                                                    title:@"确认签收"
                                          backgroundColor:[UIColor zh_themeColor]];
        [self.view addSubview:opBtn];
        [opBtn addTarget:self action:@selector(opAction) forControlEvents:UIControlEventTouchUpInside];
        
    }


}


- (void)opAction {


    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"808308";
    http.parameters[@"code"] = _mineTreasure.code;

    [http postWithSuccess:^(id responseObject) {
        
        
        UIAlertController *actionSheetCtrl = [UIAlertController alertControllerWithTitle:@"" message:@"请对该商品做出评价" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *hpAction = [UIAlertAction actionWithTitle:@"好评" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self commentWithType:@"A"];
        }];
        
        UIAlertAction *zpAction = [UIAlertAction actionWithTitle:@"中评" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self commentWithType:@"B"];
            
        }];
        
        
        UIAlertAction *cpAction = [UIAlertAction actionWithTitle:@"差评" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self commentWithType:@"C"];
            
        }];
        
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            [self.navigationController popViewControllerAnimated:YES];
            [self.navigationController popViewControllerAnimated:YES];
            
            if (self.success) {
                self.success();
            }
            
        }];
        
        [actionSheetCtrl addAction:hpAction];
        [actionSheetCtrl addAction:zpAction];
        [actionSheetCtrl addAction:cpAction];
        [actionSheetCtrl addAction:cancleAction];
        
        [self presentViewController:actionSheetCtrl animated:YES completion:nil];
        
        
    } failure:^(NSError *error) {
        
    }];


}


- (void)commentWithType:(NSString *)type {
    
        TLNetworking *http = [TLNetworking new];
        http.showView = self.view;
        http.code = @"808320";
        http.parameters[@"jewelCode"] = self.mineTreasure.jewelCode; //宝贝编号
        http.parameters[@"interacter"] = [ZHUser user].userId; //评价人
        http.parameters[@"orderCode"] = self.mineTreasure.code;

        http.parameters[@"evaluateType"] = type;

        [http postWithSuccess:^(id responseObject) {
            
            [TLAlert alertWithHUDText:@"评价成功"];
            [self.navigationController popViewControllerAnimated:YES];
            if (self.success) {
                self.success();
            }
            
        } failure:^(NSError *error) {
            
            
        }];
        
}

@end
