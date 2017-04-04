//
//  ZHShopDetailVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/23.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHShopDetailVC.h"
#import "ZHShopInfoCell.h"
#import "ZHDiscountInfoCell.h"
#import "ZHTextDetailCell.h"
#import "ZHImageCell.h"
#import "ZHPayVC.h"
#import "ZHUserLoginVC.h"
#import "ZHMapController.h"
#import "WXApi.h"

#import "ZHCouponsMgtVC.h"
#import "ZHCouponsDetailVC.h"
#import "ZHMineCouponModel.h"
#import "ZHCurrencyModel.h"

@interface ZHShopDetailVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) UILabel *shopNameLbl;

@end

@implementation ZHShopDetailVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    self.shopNameLbl.text = self.shop.name;
    self.title = self.shop.name;
    
    
    //查询优惠券
    
    
}

#pragma mark - tableview---delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {//地图
            
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
        
    } else if(indexPath.section == 1) { //折扣券查询
    
        
        ZHCouponsDetailVC *couponsDetail = [[ZHCouponsDetailVC alloc] init];
        couponsDetail.coupon = self.shop.storeTickets[indexPath.row];
        [self.navigationController pushViewController:couponsDetail animated:YES];
    
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - 买单
- (void)buy {

    if (![ZHUser user].isLogin) {
        
        ZHUserLoginVC *loginVC = [[ZHUserLoginVC alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self  presentViewController:nav animated:YES completion:nil];
        return;
    }
    
    //先查询在该商家上是否有折扣券
    //查询折扣券
    //0=未使用；1=已使用；2=已过期
    //  isExist用户是否拥有此折扣券 ，1代表有了，0 没有
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"808265";
    http.parameters[@"userId"] = [ZHUser user].userId;
    http.parameters[@"status"] = @"0";
    http.parameters[@"start"] = @"1";
    http.parameters[@"limit"] = @"1000";
    http.parameters[@"storeCode"] = self.shop.code;
    http.parameters[@"token"] = [ZHUser user].token;
    [http postWithSuccess:^(id responseObject) {
        
        NSArray <ZHMineCouponModel *> *coupons = [ZHMineCouponModel tl_objectArrayWithDictionaryArray:responseObject[@"data"][@"list"]];
        
        
        TLNetworking *http = [TLNetworking new];
        //        http.showView = self.view;
        http.code = @"802503";
        http.parameters[@"token"] = [ZHUser user].token;
        http.parameters[@"userId"] = [ZHUser user].userId;
        
        [http postWithSuccess:^(id responseObject) {
            
            //传余额
            NSArray *accountArr = responseObject[@"data"];
         
            
            //支付
            ZHPayVC *payVC = [[ZHPayVC alloc] init];
            payVC.shop = self.shop;
            if (coupons && coupons.count > 0) {
                payVC.coupons = [coupons mutableCopy];
                
            }
            [accountArr enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if ([obj[@"currency"] isEqualToString:kFRB]) {
                    
                    payVC.balanceString = [NSString stringWithFormat:@"余额（分润%@）",[obj[@"amount"] convertToRealMoney]];
                    
                }
                
            }];
            
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:payVC];
            [self presentViewController:nav animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            
        }];
     
            
       
     
        
        
    } failure:^(NSError *error) {
        
        
    }];
    

}


-(void)onResp:(BaseResp*)resp{
 
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    if (section == 0) {
        return 55;
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
        return [ZHShopInfoCell rowHeight];
    } else if (indexPath.section == 1) {
        return [ZHDiscountInfoCell rowHeight];
    } else {
    
        if (indexPath.row == 0) {
            return [self.shop detailHeight];
        } else {
            return [self.shop.imgHeights[indexPath.row - 1] floatValue];
        }
        
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    if (section == 0) {
        
        return [self addressHeaderView];
        
    } else if(section == 1) {
        
        return [self discountHeaderView];
    } else {
        return [self detailHeaderView];
    }
    return nil;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 2;
        
    } else if(section == 1 ) {
    
        return self.shop.storeTickets.count;
    
    } else {
    
        return 1 + self.shop.detailPics.count;

    }

}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        
        static  NSString * reCellId = @"ZHShopInfoCellID";
        ZHShopInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:reCellId];
        if (!cell) {
            
          cell = [[ZHShopInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reCellId];
            
        }
        
        if (indexPath.row == 0) {
            
            cell.info = self.shop.address;
            cell.infoType = ShopInfoTypeLocation;
            
        } else {
            cell.info = self.shop.bookMobile;
            cell.infoType = ShopInfoTypeCall;
        }
        
        return cell;
        
    } else if(indexPath.section == 1) {
    
        static  NSString *discountCellId = @"ZHDiscountInfoCellID";
        ZHDiscountInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:discountCellId];
        if (!cell) {
            
            cell = [[ZHDiscountInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:discountCellId];
            
        }
    
        ZHCoupon *coupon = self.shop.storeTickets[indexPath.row];
        
       NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithAttributedString:[ZHCurrencyHelper QBBWithBouns:CGRectMake(0, -2, 15, 15)] ];
        [attr appendAttributedString:
         [[NSAttributedString alloc] initWithString: [NSString stringWithFormat:@" %@",[coupon.key2 convertToRealMoney]]]
                                      ];
         cell.mainLbl.attributedText = attr;
        
        cell.subLbl.text = [coupon discountInfoDescription01];
        
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


- (UILabel *)shopNameLbl {

    if (!_shopNameLbl) {
        
       _shopNameLbl = [UILabel labelWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 15 -80, 55) textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor clearColor]
                                          font:FONT(14)
                                     textColor:[UIColor zh_textColor]];
    }
    return _shopNameLbl;

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

- (UIView *)discountHeaderView {

   UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 42)];
    headView.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 15, 15)];
    [headView addSubview:imageView];
    imageView.image = [UIImage imageNamed:@"抵"];
    
    UILabel *lbl = [UILabel labelWithFrame:CGRectMake(imageView.xx + 5, 0, SCREEN_WIDTH - 35, 15) textAligment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor] font:[UIFont secondFont] textColor:[UIColor zh_textColor2]];
    lbl.text = @"抵扣券";
    lbl.centerY = 21;
    [headView addSubview:lbl];
    
    return headView;

}
- (UIView *)addressHeaderView {

    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55)];
    headView.backgroundColor = [UIColor whiteColor];
    headView.contentMode = UIViewContentModeScaleAspectFill;
 
    [headView addSubview:self.shopNameLbl];
    
    UIButton *btn = [UIButton zhBtnWithFrame:CGRectMake(0, 0, 65, 29) title:@"买单"];
    [headView addSubview:btn];
    btn.xx_size = SCREEN_WIDTH - 15;
    [btn addTarget:self action:@selector(buy) forControlEvents:UIControlEventTouchUpInside];
    btn.centerY = headView.height/2.0;
    
    return headView;
}


@end
