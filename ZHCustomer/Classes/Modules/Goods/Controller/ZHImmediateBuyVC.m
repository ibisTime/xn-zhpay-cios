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
#import "ZHNewPayVC.h"
#import "ZHCurrencyModel.h"
#import "TLHeader.h"
#import "ZHUser.h"
#import "UIColor+theme.h"


@interface ZHImmediateBuyVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIView *headeBGView;
@property (nonatomic,strong) UILabel * totalPriceLbl;

@property (nonatomic,strong) UITableView *tableV;

//@property (nonatomic,strong) UIImageView *arrowIV;
//@property (nonatomic, strong) TLTextField *postageTf;

@property (nonatomic,strong) UIButton *buyBtn;

@property (nonatomic,strong) TLTextField *enjoinTf;

@property (nonatomic,strong) NSMutableArray <ZHReceivingAddress *>*addressRoom;
@property (nonatomic,strong) ZHReceivingAddress *currentAddress;
@property (nonatomic,strong) ZHAddressChooseView *chooseView;

@property (nonatomic, strong) NSNumber *changeRate;
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
    self.title = @"订单确认";
    
    if (!self.goodsRoom) {
        
        NSLog(@"请传递购物模型");
        return;
    }
    
    
    //1.根据有无地址创建UI
    [self getAddress];
        
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeAddressInfo:) name:kEditCurrentChooseAddressSuccess object:nil];

    
}

//
- (void)changeAddressInfo:(NSNotification *)notification {

    ZHReceivingAddress *addr =  notification.userInfo[@"key"];
    self.currentAddress = addr;
    [self setHeaderAddress:addr];
    [self updatePostageAndTotalMoney];
    
}

#pragma mark- 立即购买行为
- (void)buyAction {
    
    if ( self.goodsRoom) { //普通商品购买
        
        if (!self.currentAddress) {
            
            [TLAlert alertWithHUDText:@"请选择收货地址"];
            return;
        }
        
        if (! self.goodsRoom[0].currentParameterModel) {
            
            [TLAlert alertWithHUDText:@"请传递规格"];
            return;
        }
        
        //单个购买
        ZHGoodsModel *goods = self.goodsRoom[0];
        TLNetworking *http = [TLNetworking new];
        http.showView = self.view;
        http.code = @"808050";
        http.parameters[@"productSpecsCode"] = self.goodsRoom[0].currentParameterModel.code;
        
        http.parameters[@"quantity"] = [NSString stringWithFormat:@"%ld",goods.currentCount];
        http.parameters[@"receiver"] = self.currentAddress.addressee;
        http.parameters[@"reAddress"] = self.currentAddress.totalAddress;
        http.parameters[@"reMobile"] = self.currentAddress.mobile;

        http.parameters[@"applyUser"] = [ZHUser user].userId;
        http.parameters[@"companyCode"] = @"CD-CZH000001";
        http.parameters[@"systemCode"] = @"CD-CZH000001";
        
        //根据收货地址
        http.parameters[@"token"] = [ZHUser user].token;
        if ([self.enjoinTf.text valid]) {
            
            http.parameters[@"applyNote"] = self.enjoinTf.text;
        }
        
        [http postWithSuccess:^(id responseObject) {
            
            //订单编号
            NSString *orderCode = responseObject[@"data"][@"code"];
            
            //商品购买
            ZHNewPayVC *payVC = [[ZHNewPayVC alloc] init];
            payVC.goodsCodeList = @[orderCode];
            payVC.isFRBAndGXZ = [self.goodsRoom[0].payCurrency isEqualToString:@"2"];
            
            
            //加上邮费的价格
            payVC.amoutAttr = self.totalPriceLbl.attributedText;

            payVC.paySucces = ^(){
                    
               [self.navigationController popViewControllerAnimated:YES];
                    
            };
            payVC.type = [goods isGift] ? ZHPayViewCtrlTypeBuyGift : ZHPayViewCtrlTypeNewGoods;
                
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:payVC];
            [self presentViewController:nav animated:YES completion:nil];
            
          
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
    //http.parameters[@"isDefault"] = @"0"; //是否为默认收货地址
    [http postWithSuccess:^(id responseObject) {
        
        self.tableV = [TLTableView groupTableViewWithframe:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49) delegate:self dataSource:self];
        [self.view addSubview:self.tableV];
        self.tableV.tableFooterView = [self footerView];
//
        self.buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 120, self.tableV.yy, 120, 49) title:@"确认购买" backgroundColor:[UIColor zh_themeColor]];
        [self.view addSubview:self.buyBtn];
        [self.buyBtn addTarget:self action:@selector(buyAction) forControlEvents:UIControlEventTouchUpInside];
        
        //
        UILabel *hintLbl = [UILabel labelWithFrame:CGRectMake(0, self.buyBtn.y, 90, self.buyBtn.height)
                                        textAligment:NSTextAlignmentRight
                                     backgroundColor:[UIColor whiteColor]
                                                font:FONT(16)
                                           textColor:[UIColor textColor]];
        [self.view addSubview:hintLbl];
        hintLbl.text = @"实际支付：";
        
        
        self.totalPriceLbl = [UILabel labelWithFrame:CGRectMake(hintLbl.xx, self.buyBtn.y, SCREEN_WIDTH - 120 - hintLbl.xx, self.buyBtn.height)
                                    textAligment:NSTextAlignmentLeft
                                 backgroundColor:[UIColor whiteColor]
                                            font:FONT(16)
                                       textColor:[UIColor zh_themeColor]];
        [self.view addSubview:self.totalPriceLbl];
        
        
        NSArray *adderssRoom = responseObject[@"data"];
        if (adderssRoom.count > 0 ) {
            //有收获地址
            
            self.addressRoom = [ZHReceivingAddress tl_objectArrayWithDictionaryArray:adderssRoom];
            //给一个默认地址
            self.currentAddress = self.addressRoom[0];
            self.currentAddress.isSelected = YES;
            [self setHeaderAddress:self.currentAddress];

            
        } else { //没有收货地址，展示没有的UI
            
            self.addressRoom = [NSMutableArray array];
            [self setNOAddressUI];
            
        }
        
//      初始化数据
        [self updatePostageAndTotalMoney];
        
    } failure:^(NSError *error) {
        
        
    }];

}


- (void)setHeaderAddress:(ZHReceivingAddress *)address {

    [self setHaveAddressUI];
    self.chooseView.nameLbl.text = [NSString stringWithFormat:@"收货人：%@",address.addressee];
    self.chooseView.mobileLbl.text = [NSString stringWithFormat:@"%@",address.mobile];
    self.chooseView.addressLbl.text = [NSString stringWithFormat:@"收货地址：%@%@%@%@",address.province,address.city, address.district, address.detailAddress];
}

#pragma mark- 前往选择收货地址，已有地址
- (void)chooseAddress {

    ZHAddressChooseVC *chooseVC = [[ZHAddressChooseVC alloc] init];
    chooseVC.selectedAddrCode = self.currentAddress.code;
    chooseVC.chooseAddress = ^(ZHReceivingAddress *addr){
    
        self.currentAddress = addr;
        [self setHeaderAddress:addr];
        [self updatePostageAndTotalMoney];

    
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
        
        [self updatePostageAndTotalMoney];
    };
    
    [self.navigationController pushViewController:address animated:YES];

}

#pragma mark- 根据地址变更进行邮费变更和总价格变更
- (void)updatePostageAndTotalMoney {
    
    //查询邮费
    ZHGoodsModel *goods = self.goodsRoom[0];

    __block NSNumber *postage;
    
    if (self.currentAddress) {
        
        if (self.goodsRoom[0].isGift) {
            
            TLNetworking *convertHttp = [TLNetworking new];
            convertHttp.code = @"002051";
            convertHttp.parameters[@"fromCurrency"] = kFRB;
            convertHttp.parameters[@"toCurrency"] = kGiftB;
            [convertHttp postWithSuccess:^(id responseObject) {
                
                self.changeRate = responseObject[@"data"][@"rate"];
                TLNetworking *http = [TLNetworking new];
                http.showView = self.view;
                http.code = @"808088";
                http.parameters[@"startPoint"] = goods.currentParameterModel.province;
                http.parameters[@"endPoint"] = self.currentAddress.province;
                
                [http postWithSuccess:^(id responseObject) {
                    
                    postage = responseObject[@"data"][@"price"];
                    long long newPostage = [postage longLongValue]*[self.changeRate floatValue];
                    
//                    self.postageTf.text = [@(newPostage) convertToRealMoney];
                    
                    //
                    long long totalPrice = newPostage + [goods.currentParameterPriceRMB longLongValue]*goods.currentCount;
                    
                    //
                    NSString *totalPriceStr = [NSString stringWithFormat:@"%@ %@",[goods priceUnit], [@(totalPrice) convertToRealMoney]];
                    
                    //
                    self.totalPriceLbl.text = [NSString stringWithFormat:@"￥%@ + 邮费%@", [@([goods.currentParameterPriceRMB longLongValue]*goods.currentCount) convertToRealMoney],[@(newPostage) convertToRealMoney]];
 
                } failure:^(NSError *error) {
                    
                }];

            } failure:^(NSError *error) {
                
                
            }];
            
            
        } else {
            
            //普通商家邮费无需转换
            TLNetworking *http = [TLNetworking new];
            http.showView = self.view;
            http.code = @"808088";
            http.parameters[@"startPoint"] = goods.currentParameterModel.province;
            http.parameters[@"endPoint"] = self.currentAddress.province;
            [http postWithSuccess:^(id responseObject) {
            
                postage = responseObject[@"data"][@"price"];
                
                long long totalPrice = [postage longLongValue] + [goods.currentParameterPriceRMB longLongValue]*goods.currentCount;
                
                NSString *totalPriceStr = [NSString stringWithFormat:@"%@ %@",[goods priceUnit], [@(totalPrice) convertToRealMoney]];
                self.totalPriceLbl.text = [NSString stringWithFormat:@"%@ + 邮费%@", [@([goods.currentParameterPriceRMB longLongValue]*goods.currentCount) convertToRealMoney],[postage convertToRealMoney]];
                
            } failure:^(NSError *error) {
                
                
            }];
        
        }
 
        return;
    }
    
    
    //无地址
    postage = @0;
    long long totalPrice = [postage longLongValue] + [goods.currentParameterPriceRMB longLongValue]*goods.currentCount;
//    NSString *totalPriceStr = [NSString stringWithFormat:@"￥%@", [@(totalPrice) convertToRealMoney]];
    self.totalPriceLbl.text = [NSString stringWithFormat:@"%@", [@([goods.currentParameterPriceRMB longLongValue]*goods.currentCount) convertToRealMoney]];

}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;

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
    
    
   
    cell.goods = self.goodsRoom[indexPath.row];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 96;
}

- (UIView *)footerView {

    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
    footerView.backgroundColor = [UIColor backgroundColor];
    
    [footerView addSubview:self.headeBGView];

    
    //买家嘱咐
    self.enjoinTf = [[TLTextField alloc] initWithframe:CGRectMake(0, self.headeBGView.yy + 10, SCREEN_WIDTH, 45) leftTitle:@"买家嘱咐：" titleWidth:100 placeholder:@"对本次交易的说明"];
    [footerView addSubview:self.enjoinTf];
    
//    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, self.enjoinTf.yy, SCREEN_WIDTH, 0.5)];
//    line2.backgroundColor = [UIColor zh_lineColor];
//    [footerView addSubview:line2];
    
    footerView.height = self.enjoinTf.yy + 30;
    
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
    
    UIView *addressView = self.headeBGView;
//    [self.view addSubview:addressView];
    
    UIImageView *noAddressImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 9, 35, 35)];
    [addressView addSubview:noAddressImageV];
    
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
