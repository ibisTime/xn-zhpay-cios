//
//  ZHShopDetailVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/23.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHShopDetailVC.h"
#import "ZHShopInfoCell.h"
#import "ZHTextDetailCell.h"
#import "ZHImageCell.h"
#import "ZHPayVC.h"
#import "ZHUserLoginVC.h"
#import "ZHMapController.h"
#import "WXApi.h"
#import "ZHCurrencyModel.h"
#import "ZHShareView.h"
#import "AppConfig.h"


@interface ZHShopDetailVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) UILabel *shopNameLbl;
@property (nonatomic, strong) UILabel *advLbl;

@property (nonatomic,strong) ZHShop *shop;

@end


@implementation ZHShopDetailVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setPlaceholderViewTitle:@"加载失败" operationTitle:@"重新加载"];
    //查询优惠券
    [self tl_placeholderOperation];
    
}

- (void)tl_placeholderOperation {

    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"808218";
    http.parameters[@"code"] = self.shopCode;
    [http postWithSuccess:^(id responseObject) {
        
        self.shop = [ZHShop tl_objectWithDictionary:responseObject[@"data"]];
        [self setUpUI];
        
    } failure:^(NSError *error) {
        
    }];

}

- (void)setUpUI {

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"分享"] style:UIBarButtonItemStylePlain target:self action:@selector(share)];
    ///////
    
    UITableView *shopDetailTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    shopDetailTV.delegate = self;
    shopDetailTV.dataSource = self;
    shopDetailTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:shopDetailTV];
    
    UIImageView *coverImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*0.6)];
    shopDetailTV.tableHeaderView = coverImgView;
    coverImgView.clipsToBounds = YES;
    coverImgView.contentMode = UIViewContentModeScaleAspectFill;
    [coverImgView sd_setImageWithURL:[NSURL URLWithString:[self.shop.advPic convertImageUrl]] placeholderImage:nil];
    
    self.title = self.shop.name;



}


#pragma mark - tableview---delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            
        } else if (indexPath.row == 1) {//地图
            
            ZHMapController *mapCtrl = [[ZHMapController alloc] init];
            mapCtrl.shopName = self.shop.name;
            mapCtrl.point = CLLocationCoordinate2DMake([self.shop.latitude floatValue], [self.shop.longitude floatValue]);
            [self.navigationController pushViewController:mapCtrl animated:YES];
            
        } else {//电话
        
            [TLAlert alertWithTitle:@"提示" Message:@"确定要拨打该电话" confirmMsg:@"确定" CancleMsg:@"取消" cancle:^(UIAlertAction *action) {
                
            } confirm:^(UIAlertAction *action) {
                
                NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.shop.bookMobile];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                
            }];
            
        }
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


-(void)share {
    
    ZHShareView *shareView = [[ZHShareView alloc] init];
    shareView.wxShare = ^(BOOL isSuccess, int code){
        
        if (isSuccess) {
            
            [TLAlert alertWithHUDText:@"分享成功"];
            
        }
        
    };
    
    shareView.title = @"正汇钱包";
    shareView.content = self.shop.name;
    shareView.shareUrl = [NSString stringWithFormat:@"%@/share/store.html?code=%@",[AppConfig config].shareBaseUrl,self.shop.code];
    [shareView show];
    
    
}



#pragma mark - 买单
- (void)buy {
    
    if (![ZHUser user].isLogin) {
        
        ZHUserLoginVC *loginVC = [[ZHUserLoginVC alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self  presentViewController:nav animated:YES completion:nil];
        return;
    }
    
    //支付
    ZHPayVC *payVC = [[ZHPayVC alloc] init];
    payVC.shop = self.shop;
    if ([self.shop isGiftMerchant]) {
        
        payVC.shopPayType = ZHShopPayTypeGiftO2O;
        
    } else {
        
        payVC.shopPayType = ZHShopPayTypeDefaultO2O;

    }
    
    //
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:payVC];
    [self presentViewController:nav animated:YES completion:nil];
   
}


#pragma mark- 购买B
- (void)buyGiftBAction {

    //支付
    ZHPayVC *payVC = [[ZHPayVC alloc] init];
    payVC.shop = self.shop;
    payVC.shopPayType = ZHShopPayTypeBuyGiftB;
        
    //
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:payVC];
    [self presentViewController:nav animated:YES completion:nil];


}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    if (section == 0) {
        
        return [self.shop isGiftMerchant] ? 100 : 45;
        
    } else {
        
        return 42;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    if (section == 0 || section == 1) {
        return 10;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            return self.shop.sloganHeight;
        }
        
        return [ZHShopInfoCell rowHeight];
        
    } else {
    
        if (indexPath.row == 0) {
            return [self.shop detailHeight];
        } else {
            return [self.shop.imgHeights[indexPath.row - 1] floatValue];
        }
        
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    if (section == 0) { //地址的headerView  有店铺名称和买单
        
        return [self addressHeaderView];
        
    } else {
        
        return [self detailHeaderView];
        
    }
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 3;
        
    } else {
    
        return 1 + self.shop.detailPics.count;

    }
    

}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
                    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellId"];
                    if (!cell) {
            
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCellId"];
            
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    if (!self.advLbl) {
            
                        self.advLbl = [UILabel labelWithFrame:CGRectZero
                                  
                                                            textAligment:NSTextAlignmentLeft
                                                         backgroundColor:[UIColor whiteColor]
                                                                    font:FONT(12)
                                                               textColor:[UIColor zh_textColor]];
                        [cell addSubview:self.advLbl];
                        self.advLbl.numberOfLines = 0;
                        
                        [self.advLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.right.equalTo(cell.mas_right).offset(-15);
                            make.left.equalTo(cell.mas_left).offset(15);

                            
                            make.top.equalTo(cell.mas_top).offset(5);
                            make.bottom.equalTo(cell.mas_bottom).offset(-10);
                        }];
                        
                        
                        
                    }
                    self.advLbl.text = self.shop.slogan;
                    return cell;
            
        }
        
        
        static  NSString * reCellId = @"ZHShopInfoCellID";
        ZHShopInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:reCellId];
        if (!cell) {
            
          cell = [[ZHShopInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reCellId];
            
        }
        
        if (indexPath.row == 1) {
            
            cell.info = self.shop.address;
            cell.infoType = ShopInfoTypeLocation;
            
        } else {
            cell.info = self.shop.bookMobile;
            cell.infoType = ShopInfoTypeCall;
        }
        
        return cell;
        
    } else {
        
        if (indexPath.row == 0) {
        
        static  NSString *detailCellId = @"ZHTextDetailCell";
        ZHTextDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:detailCellId];
        if (!cell) {
            
            cell = [[ZHTextDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailCellId];
            
        }
        cell.detailLbl.text = self.shop.descriptionShop;
        return cell;
            
        } else {
            
            static  NSString *imgCellId = @"imgCellId";
            ZHImageCell *cell = [tableView dequeueReusableCellWithIdentifier:imgCellId];
            if (!cell) {
                
                cell = [[ZHImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:imgCellId];
                
            }
            cell.url = self.shop.detailPics[indexPath.row - 1];
            return cell;

        }
        
    }
    

}




- (UIView *)detailHeaderView {

    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 42)];
    headView.backgroundColor = [UIColor whiteColor];
    
    UILabel *lbl = [UILabel labelWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 35, 42) textAligment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor] font:FONT(13) textColor:[UIColor zh_textColor]];
    lbl.text = @"图文详情";
    [headView addSubview:lbl];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 41.5, SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = [UIColor zh_lineColor];
    [headView addSubview:lineView];
    
    return headView;
}



- (UIView *)addressHeaderView {

    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
    headView.backgroundColor = [UIColor whiteColor];
    headView.contentMode = UIViewContentModeScaleAspectFill;
 
    
    self.shopNameLbl = [UILabel labelWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 15 -80, 55)
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor clearColor]
                                          font:FONT(14)
                                     textColor:[UIColor zh_textColor]];
    [headView addSubview:self.shopNameLbl];
    self.shopNameLbl.text = self.shop.name;

    UIButton *btn = [UIButton zhBtnWithFrame:CGRectMake(0, 10, 100, 29) title:@"买单"];
    [headView addSubview:btn];
    [btn addTarget:self action:@selector(buy) forControlEvents:UIControlEventTouchUpInside];
    
    //
    UIButton *giftBtn = [UIButton zhBtnWithFrame:CGRectMake(0, btn.yy + 10, 100, 29) title:@"购买礼品券"];
    [headView addSubview:giftBtn];
    [giftBtn addTarget:self action:@selector(buyGiftBAction) forControlEvents:UIControlEventTouchUpInside];
    giftBtn.xx_size = SCREEN_WIDTH - 15;
    giftBtn.hidden = YES;
    
    //
    if ([self.shop isGiftMerchant]) {
        
        btn.frame = CGRectMake(0, 55, 100, 29);
        btn.xx_size = SCREEN_WIDTH - 15;
        
        giftBtn.hidden = NO;
        giftBtn.frame = CGRectMake(15, btn.y, 100, 29);


        
    } else {
    
        giftBtn.hidden = YES;
        btn.frame = CGRectMake(0, 10, 65, 29);
        btn.xx_size = SCREEN_WIDTH - 15;


    
    }
    
    
    return headView;
    
}


@end
