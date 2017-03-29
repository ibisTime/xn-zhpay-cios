//
//  ZHImmediateBuyVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/27.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHImmediateBuyVC.h"
#import "ZHAddAddressVC.h"
#import "ZHReceivingAddress.h"
#import "ZHAddressChooseVC.h"
#import "ZHOrderGoodsCell.h"
#import "ZHCurrencyHelper.h"
#import "ZHAddressChooseView.h"
#import "ZHPayVC.h"
//#import "IQKeyboardManager.h"


@interface ZHImmediateBuyVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIView *headeBGView;
@property (nonatomic,strong) UILabel * totalPriceLbl;
//
//@property (nonatomic,strong) UILabel *nameLbl;
//@property (nonatomic,strong) UILabel *mobileLbl;
//@property (nonatomic,strong) UILabel *addressLbl;

@property (nonatomic,strong) UITableView *tableV;
@property (nonatomic,strong) UIImageView *arrowIV;
@property (nonatomic,strong) UIButton *buyBtn;
@property (nonatomic,strong) TLTextField *enjoinTf;

@property (nonatomic,strong) NSMutableArray <ZHReceivingAddress *>*addressRoom;
@property (nonatomic,strong) ZHReceivingAddress *currentAddress;
@property (nonatomic,strong) ZHAddressChooseView *chooseView;

@end

@implementation ZHImmediateBuyVC
- (ZHAddressChooseView *)chooseView {

    if (!_chooseView) {
        
        __weak typeof(self) weakself = self;
        //头部有个底 可以添加，有地址时的ui和无地址时的ui
        _chooseView = [[ZHAddressChooseView alloc] initWithFrame:self.headeBGView.bounds];
        _chooseView.chooseAddress = ^(){
        
            [weakself chooseAddress];
        };
    }
    return _chooseView;

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
//    self.title = @"";
    
//    [[IQKeyboardManager sharedManager].enabledToolbarClasses addObject:[self class]];
    
    //根据有无地址创建UI
    [self getAddress];
 
    if (self.type == ZHIMBuyTypeSingle) { //---单买
        
        NSNumber *price1 ;
        NSNumber *price2;
        NSNumber *price3;
        NSInteger num;
        if (self.goodsRoom) {
           
            ZHGoodsModel *goods = self.goodsRoom[0];

           price1 = goods.price1;
           price2 = goods.price2;
           price3 = goods.price3;
           num =  goods.count; //数量
        }
     

   self.totalPriceLbl.attributedText = [ZHCurrencyHelper calculatePriceWithQBB:price3
                                                                           GWB:price2
                                                                           RMB:price1
                                                                         count:num];
        
    } else if(self.type == ZHIMBuyTypeAll) {//购物车购买
     
        self.totalPriceLbl.attributedText = self.priceAttr;
        
    }  else if (self.type == ZHIMBuyTypeYYDBChooseAddress) { //一元夺宝地址选择
    
        
//       self.tableV.tableFooterView = nil;
       self.title = @"选择收货地址";
       [self.buyBtn setTitle:@"确认地址" forState:UIControlStateNormal];
        self.tableV.tableFooterView.alpha = 0.0;
    
        
    }
    

    
}


#pragma mark- 立即购买行为
- (void)buyAction {
    
    if (self.type == ZHIMBuyTypeAll) { //购物车购买方式
        
        if (!self.currentAddress) {
            
            [TLAlert alertWithHUDText:@"请选择收货地址"];
            return;
        }
        
        NSMutableArray *codes = [NSMutableArray arrayWithCapacity:self.cartGoodsRoom.count];
        
        [self.cartGoodsRoom enumerateObjectsUsingBlock:^(ZHCartGoodsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [codes addObject:obj.code];
        }];
        
        TLNetworking *http = [TLNetworking new];
        http.showView = self.view;
        http.code = @"808051";
        http.parameters[@"receiver"] = self.currentAddress.addressee;
        http.parameters[@"reMobile"] = self.currentAddress.mobile;
        http.parameters[@"reAddress"] = self.currentAddress.totalAddress;
        http.parameters[@"applyUser"] = [ZHUser user].userId;
        http.parameters[@"token"] = [ZHUser user].token;
        if ([self.enjoinTf.text valid]) {
            
          http.parameters[@"applyNote"] = self.enjoinTf.text;
            
        }
        
       http.parameters[@"cartCodeList"] = codes ;
       [http postWithSuccess:^(id responseObject) {
           
//           NSString *ddCode = responseObject[@"data"];
//           [TLAlert alertWithHUDText:@"购买成功"];
//           [self.navigationController popToRootViewControllerAnimated:YES];
           
           if (self.placeAnOrderSuccess) {
               
               self.placeAnOrderSuccess();
               
           }
           
           //商品购买
           ZHPayVC *payVC = [[ZHPayVC alloc] init];
           //订单编号
           payVC.codeList = responseObject[@"data"][@"codeList"];
           
           //传人民币过去
           __block  long long totalRmb = 0;
           [self.cartGoodsRoom enumerateObjectsUsingBlock:^(ZHCartGoodsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
               
               totalRmb += [obj.price1 longLongValue]*[obj.quantity integerValue];
               
           }];
//           NSNumber *rmb = self.cartGoodsRoom[0].price1;
           
//           payVC.orderAmount = @([rmb longLongValue]*[self.cartGoodsRoom[0].quantity integerValue]); //把人民币传过去
           payVC.orderAmount = @(totalRmb);
           //
           payVC.amoutAttr = self.totalPriceLbl.attributedText;
           payVC.paySucces = ^(){
               
               [TLAlert alertWithHUDText:@"支付成功"];
               [self.navigationController popToRootViewControllerAnimated:YES];
               
           };
           //购物车支付 和 普通商品 购买方式相同
           payVC.type = ZHPayVCTypeGoods;
           
           UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:payVC];
           [self presentViewController:nav animated:YES completion:nil];

       } failure:^(NSError *error) {
           
           
           
       }];
        
        
        
       return;
    }
    
    
    ///------////
    if (self.type == ZHIMBuyTypeSingle && self.goodsRoom) { //普通商品购买
        
        if (!self.currentAddress) {
            
            [TLAlert alertWithHUDText:@"请选择收货地址"];
            return;
        }
        
        //单个购买
        ZHGoodsModel *goods = self.goodsRoom[0];
        TLNetworking *http = [TLNetworking new];
        http.showView = self.view;
        http.code = @"808050";
        http.parameters[@"productCode"] = goods.code;
        http.parameters[@"quantity"] = [NSString stringWithFormat:@"%ld",goods.count];
        //根据收货地址
        http.parameters[@"receiver"] = self.currentAddress.addressee;
        http.parameters[@"reMobile"] = self.currentAddress.mobile;
        http.parameters[@"reAddress"] = self.currentAddress.totalAddress;
        http.parameters[@"applyUser"] = [ZHUser user].userId;
        http.parameters[@"token"] = [ZHUser user].token;
        if ([self.enjoinTf.text valid]) {
            
            http.parameters[@"applyNote"] = self.enjoinTf.text;
        }
        [http postWithSuccess:^(id responseObject) {
            
            //订单编号
            NSString *orderCode = responseObject[@"data"];
            
            //商品购买
            ZHPayVC *payVC = [[ZHPayVC alloc] init];
            payVC.orderCode = orderCode;
            NSNumber *rmb = self.goodsRoom[0].price1;
            payVC.orderAmount = @([rmb longLongValue]*self.goodsRoom[0].count); //把人民币传过去
            payVC.amoutAttr = self.totalPriceLbl.attributedText;

            payVC.paySucces = ^(){
                

                
                [TLAlert alertWithHUDText:@"支付成功"];
                [self.navigationController popViewControllerAnimated:YES];
                
            };
            payVC.type = ZHPayVCTypeGoods;
            
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:payVC];
            [self presentViewController:nav animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            
        }];

        return;
    }
    
//     if (self.type == ZHIMBuyTypeYYDB && self.treasureRoom) { //一元夺宝购买
//        //商品购买
//        ZHPayVC *payVC = [[ZHPayVC alloc] init];
////        payVC.orderCode = orderCode;
//        payVC.type = ZHPayVCTypeYYDB;
//        NSNumber *rmb = self.treasureRoom[0].price1;
//        payVC.orderAmount = @([rmb longLongValue]*self.treasureRoom[0].count); //把人民币传过去
//        payVC.treasureModel = self.treasureRoom[0];
//        payVC.amoutAttr = self.totalPriceLbl.attributedText;
//
//        payVC.paySucces = ^(){
//            
//            //夺宝
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"dbBuySuccess" object:nil];
//            
//            [TLAlert alertWithHUDText:@"参与夺宝成功"];
//            [self.navigationController popViewControllerAnimated:YES];
//            
//        };
//        
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:payVC];
//        [self presentViewController:nav animated:YES completion:nil];
//        
//         return;
//         
//    }
    
    
    if (self.type == ZHIMBuyTypeYYDBChooseAddress) { //地址选择
        
        if (!self.currentAddress) {
            
            [TLAlert alertWithHUDText:@"请选择收货地址"];
            return;
        }
        
        TLNetworking *http = [TLNetworking new];
        http.showView = self.view;
        http.code = @"808307";
        http.parameters[@"code"] = self.yydbResCode;
        http.parameters[@"receiver"] = self.currentAddress.addressee;
        http.parameters[@"reMobile"] = self.currentAddress.mobile;
        http.parameters[@"reAddress"] = self.currentAddress.totalAddress;

        [http postWithSuccess:^(id responseObject) {
            
            [TLAlert alertWithHUDText:@"添加收货地址成功"];
            [self.navigationController popViewControllerAnimated:YES];
            if (self.chooseYYDBSuccess) {
                self.chooseYYDBSuccess();
            }
            
        } failure:^(NSError *error) {
            
            
        }];

        return;
    }
    
    
}

- (void)getAddress {

    //查询是否有收货地址
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"805165";
    http.parameters[@"userId"] = [ZHUser user].userId;
    http.parameters[@"token"] = [ZHUser user].token;
    //    http.parameters[@"isDefault"] = @"0"; //是否为默认收货地址
    [http postWithSuccess:^(id responseObject) {
        
        self.buyBtn.y = self.tableV.yy;

        //添加
        [self.view addSubview:self.tableV];
        //购买按钮
        [self.view addSubview:self.buyBtn];
        //
    

        NSArray *adderssRoom = responseObject[@"data"];
        if (adderssRoom.count > 0 ) { //有收获地址
            
            self.addressRoom = [ZHReceivingAddress tl_objectArrayWithDictionaryArray:adderssRoom];
            //给一个默认地址
            self.currentAddress = self.addressRoom[0];
            self.currentAddress.isSelected = YES;
            
            [self setHeaderAddress:self.currentAddress];

            
        } else { //没有收货地址，展示没有的UI
            
            self.addressRoom = [NSMutableArray array];
            [self setNOAddressUI];
            
        }
        
    } failure:^(NSError *error) {
        
        
    }];

}



- (void)setHeaderAddress:(ZHReceivingAddress *)address {

    [self setHaveAddressUI];

    self.chooseView.nameLbl.text = [NSString stringWithFormat:@"收货人：%@",address.addressee];
    self.chooseView.mobileLbl.text = [NSString stringWithFormat:@"%@",address.mobile];
    self.chooseView.addressLbl.text = [NSString stringWithFormat:@"收货地址：%@%@%@%@",address.province,address.city, address.district, address.detailAddress];
}

#pragma mark- 前往地址
- (void)chooseAddress {

    ZHAddressChooseVC *chooseVC = [[ZHAddressChooseVC alloc] init];
//    chooseVC.addressRoom = self.addressRoom;
    chooseVC.selectedAddrCode = self.currentAddress.code;
    
    chooseVC.chooseAddress = ^(ZHReceivingAddress *addr){
    
        self.currentAddress = addr;
        [self setHeaderAddress:addr];
    
    };
    [self.navigationController pushViewController:chooseVC animated:YES];

    
}

#pragma mark- 原来无地址，现在添加地址
- (void)addAddress {

    ZHAddAddressVC *address = [[ZHAddAddressVC alloc] init];
    address.addAddress = ^(ZHReceivingAddress *address){
    
        //原来无地址, 现在又地址
        self.currentAddress = address;
        [self setHeaderAddress:address];
        [self.addressRoom addObject:address];
        
    };
    [self.navigationController pushViewController:address animated:YES];

}

- (UITableView *)tableV{
    
    if (!_tableV) {
        
        //无收货地址
        TLTableView *tableView = [TLTableView groupTableViewWithframe:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49) delegate:self dataSource:self];
        tableView.tableHeaderView = self.headeBGView;
        tableView.tableFooterView = [self footerView];
        _tableV = tableView;
    }
    return _tableV;
    
}

- (UIButton *)buyBtn {
    
    if (!_buyBtn) {
        
        _buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49) title:@"立即购买" backgroundColor:[UIColor zh_themeColor]];
        [_buyBtn addTarget:self action:@selector(buyAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _buyBtn;
    
}

- (UILabel *)totalPriceLbl {
    
    if (!_totalPriceLbl) {
        _totalPriceLbl = [UILabel labelWithFrame:CGRectZero
                                    textAligment:NSTextAlignmentRight
                                 backgroundColor:[UIColor whiteColor]
                                            font:FONT(18)
                                       textColor:[UIColor zh_themeColor]];
    }
    
    return _totalPriceLbl;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    
    
    if (self.type == ZHIMBuyTypeAll) {
        
        return self.cartGoodsRoom.count;

    } else {
    
        return 1;

    
    }

}


#pragma dataspurce
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *zhOrderGoodsCell = @"ZHOrderGoodsCellId";
    ZHOrderGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:zhOrderGoodsCell];
    if (!cell) {
        
        cell = [[ZHOrderGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:zhOrderGoodsCell];
    }
    
   if(self.type == ZHIMBuyTypeAll) {
    
        cell.cartGoods = self.cartGoodsRoom[indexPath.row];
   } else {
   
//       if (self.type == ZHIMBuyTypeSingle || self.type == ZHIMBuyTypeSingle) {
       
       cell.goods = self.goodsRoom[indexPath.row];

    
           
//       }
       
   }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 96;
}

- (UIView *)footerView {

    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90)];
    footerView.backgroundColor = [UIColor whiteColor];
    TLTextField *tf = [[TLTextField alloc] initWithframe:CGRectMake(0, 0, SCREEN_WIDTH, 45) leftTitle:@"买家嘱咐：" titleWidth:100 placeholder:@"对本次交易的说明"];
    [footerView addSubview:tf];
    self.enjoinTf = tf;
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, tf.yy + 1, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = [UIColor zh_lineColor];
    [footerView addSubview:line];

    //
    [footerView addSubview:self.totalPriceLbl];
    [self.totalPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(footerView.mas_right).offset(-15);
        make.top.equalTo(line.mas_bottom);
        make.bottom.equalTo(footerView.mas_bottom);
        
    }];
    
    
    UILabel *hintLbl = [[UILabel alloc] initWithFrame:CGRectZero
                                             textAligment:NSTextAlignmentRight
                                          backgroundColor:[UIColor whiteColor]
                                                     font:FONT(14)
                                                textColor:[UIColor zh_textColor]];
    [footerView addSubview:hintLbl];
    hintLbl.text = @"应付金额：";
        
    [hintLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.totalPriceLbl.mas_left).offset(-9);
            make.top.equalTo(self.totalPriceLbl.mas_top);
            make.bottom.equalTo(footerView.mas_bottom);
    }];

    return footerView;
    
}

//#pragma mark- 有收获地址时的头部UI
- (void)setHaveAddressUI {

    if (self.headeBGView.subviews.count > 0) {
        
        [self.headeBGView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    }
    [self.headeBGView addSubview:self.chooseView];
    
}

//
- (UIView *)headeBGView {

    if (!_headeBGView) {
        
        _headeBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.5, SCREEN_WIDTH, 89)];
        _headeBGView.backgroundColor = [UIColor whiteColor];
    }
    return _headeBGView;

}

#pragma mark- 设置没有收货地址的UI
- (void)setNOAddressUI {
    
//  [self.headeBGView.subviews performSelector:@selector(removeFromSuperview)];
    
    UIView *addressView = self.headeBGView;
    [self.view addSubview:addressView];
//    addressView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *noAddressImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 9, 35, 35)];
    [addressView addSubview:noAddressImageV];
    
    //-==-//
    noAddressImageV.centerX = SCREEN_WIDTH/2.0;
    noAddressImageV.image = [UIImage imageNamed:@"添加收获地址"];
    
    //btn
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0 + 25, noAddressImageV.yy + 9, 58, 21)];
    [addressView addSubview:addBtn];
    addBtn.layer.masksToBounds = YES;
    addBtn.layer.cornerRadius = 3;
    addBtn.layer.borderWidth = 1;
    addBtn.titleLabel.font = FONT(11);
    addBtn.layer.borderColor = [UIColor zh_themeColor].CGColor;
    [addBtn setTitle:@"+ 添加" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor zh_themeColor] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addAddress) forControlEvents:UIControlEventTouchUpInside];
    //
    UILabel *hintLbl = [UILabel labelWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2.0 + 3, addBtn.height) textAligment:NSTextAlignmentRight
                               backgroundColor:[UIColor whiteColor]
                                          font:FONT(13)
                                     textColor:[UIColor zh_textColor]];
    [addressView addSubview:hintLbl];
    hintLbl.text = @"还没有收货地址";
    hintLbl.centerY = addBtn.centerY;
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _headeBGView.width, 2)];
    [_headeBGView addSubview:line];
    line.y = _headeBGView.height - 2;
    line.image = [UIImage imageNamed:@"address_line"];

}

@end
