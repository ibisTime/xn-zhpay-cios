//
//  ZHOrderDetailVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/31.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHOrderDetailVC.h"
#import "ZHOrderGoodsCell.h"
#import "ZHAddressChooseView.h"
#import "ZHPayVC.h"
#import "ZHNewPayVC.h"
#import "TLHeader.h"
#import "ZHUser.h"
#import "UIColor+theme.h"


@interface ZHOrderDetailVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *orderDetailTableView;
@property (nonatomic, strong) UIView *tableViewHeaderView;

@property (nonatomic,strong) UILabel *orderCodeLbl;
@property (nonatomic,strong) UILabel *orderTimeLbl;
@property (nonatomic,strong) UILabel *orderStatusLbl;
@property (nonatomic, strong) UILabel *postageLbl;
@property (nonatomic, strong) UILabel *orderTotalPrice; //订单总价

@property (nonatomic,strong) ZHAddressChooseView *addressView;

@property (nonatomic,strong) UILabel *expressNameLbl;
@property (nonatomic,strong) UILabel *expressCodeLbl;


@end


@implementation ZHOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    
    UITableView *tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableV.dataSource = self;
    tableV.delegate = self;
    [self.view addSubview:tableV];
    self.orderDetailTableView = tableV;
    //
    tableV.backgroundColor = [UIColor zh_backgroundColor];
    tableV.rowHeight = [ZHOrderGoodsCell rowHeight];
    
    //创建headerView
    [self orderHeaderView];
    
    //********headerView 数据
    self.orderCodeLbl.text = [NSString stringWithFormat:@"订单号：%@",self.order.code];
    self.orderTimeLbl.text = [NSString stringWithFormat:@"下单时间：%@",[self.order.applyDatetime convertToDetailDate]];
    self.orderStatusLbl.text = [NSString stringWithFormat:@"订单状态：%@",[self.order getStatusName]];
    
    self.postageLbl.text = [NSString stringWithFormat:@"订单运费：%@",[self.order.yunfei convertToRealMoney]];
    self.addressView.nameLbl.text = [@"收货人：" add:self.order.receiver];
    self.addressView.mobileLbl.text = self.order.reMobile;
    self.addressView.addressLbl.text = [@"收货地址：" add:self.order.reAddress];
    //********headerView 数据
    
    

    
    
    //底部数据
    if ([self.order.status isEqualToString:@"3"] || [self.order.status isEqualToString:@"4"]) {// 已发货
        
        //footer
        tableV.tableFooterView = [self footerView];
        self.expressCodeLbl.text = [@"快递单号：" add:self.order.logisticsCode];
        self.expressNameLbl.text = [@"快递公司：" add:self.order.logisticsCompany];
        self.orderTotalPrice.text = [NSString stringWithFormat:@"订单总额：%@",[self.order.payAmount1 convertToRealMoney]];
        if ([self.order.status isEqualToString:@"3"]) {
            
            //收货按钮
            tableV.height = tableV.height - 49;
            UIButton *shBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, tableV.yy, SCREEN_WIDTH, 49) title:@"收货" backgroundColor:[UIColor zh_themeColor]];
            [self.view addSubview:shBtn];
            [shBtn addTarget:self action:@selector(confirmReceive) forControlEvents:UIControlEventTouchUpInside];
        }
    
        
    } else if([self.order.status isEqualToString:@"1"]) { //待支付，可取消
    
        tableV.height = tableV.height - 49;

        UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, tableV.yy, SCREEN_WIDTH/2.0, 49) title:@"取消订单" backgroundColor:[UIColor zh_themeColor]];
        [self.view addSubview:cancleBtn];
        [cancleBtn addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *shBtn = [[UIButton alloc] initWithFrame:CGRectMake(cancleBtn .xx + 1, tableV.yy, SCREEN_WIDTH/2.0 -  1, 49)
                                                    title:@"去支付"
                                          backgroundColor:[UIColor zh_themeColor]];
        [self.view addSubview:shBtn];
        [shBtn addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchUpInside];
    
    }
    
    
    [self.tableViewHeaderView layoutIfNeeded];
    self.tableViewHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.addressView.yy);
    self.orderDetailTableView.tableHeaderView = self.tableViewHeaderView;

    
}


#pragma mark- 支付
- (void)pay {
    
    
    ZHNewPayVC *newPayVC = [[ZHNewPayVC alloc] init];
    newPayVC.type = [self.order.product isGift] ? ZHPayViewCtrlTypeBuyGift :ZHPayViewCtrlTypeNewGoods;
    newPayVC.goodsCodeList = @[self.order.code];
    
    NSNumber *totalPrice = @([self.order.amount1 longLongValue] + [self.order.yunfei longLongValue]);
    NSString *str =  [totalPrice convertToRealMoney];
    newPayVC.amoutAttr = str;
    newPayVC.totalPrice = totalPrice;
    
    
        //
    newPayVC.paySucces = ^(){
            
            [self.navigationController popViewControllerAnimated:YES];
            
            if (self.paySuccess) {
                self.paySuccess();
            }
            
     };
        //
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:newPayVC];
        [self presentViewController:nav animated:YES completion:nil];
    
}


#pragma mark- 取消订单
- (void)cancle { //取消订单
    
    [TLAlert alertWithTitle:@"" Message:@"确定取消订单？" confirmMsg:@"确定取消" CancleMsg:@"不取消" cancle:^(UIAlertAction *action) {
        
        
    } confirm:^(UIAlertAction *action) {
        
        TLNetworking *http = [TLNetworking new];
        http.showView = self.view;
        http.code = @"808053";
        http.parameters[@"code"] = self.order.code;
        http.parameters[@"userId"] = [ZHUser user].userId;
        http.parameters[@"remark"] = @"取消订单收货";
        http.parameters[@"token"] = [ZHUser user].token;
        [http postWithSuccess:^(id responseObject) {
            
            [TLAlert alertWithHUDText:@"取消订单成功"];
            if (self.cancleSuccess) {
                self.cancleSuccess();
            }
            [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    


}

- (void)confirmReceive {

    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"808057";
    http.parameters[@"code"] = self.order.code;
    http.parameters[@"updater"] = [ZHUser user].userId;
    http.parameters[@"remark"] = @"确认收货";
    http.parameters[@"token"] = [ZHUser user].token;

    [http postWithSuccess:^(id responseObject) {
        
//        [TLAlert alertWithHUDText:@"确认收货成功"];

        [self goCommentWithCode:nil];
    } failure:^(NSError *error) {
        
        
    }];

}

- (void)goCommentWithCode:(NSString *)code {

    UIAlertController *actionSheetCtrl = [UIAlertController alertControllerWithTitle:@"" message:@"请对该商品做出评价" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *hpAction = [UIAlertAction actionWithTitle:@"好评" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self commentWithType:@"A" code:code];
    }];
    
//    UIAlertAction *zpAction = [UIAlertAction actionWithTitle:@"中评" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//        [self commentWithType:@"B" code:code];
//
//        
//    }];
//    
//    UIAlertAction *cpAction = [UIAlertAction actionWithTitle:@"差评" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//        [self commentWithType:@"C" code:code];
//        
//    }];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
        if (self.confirmReceiveSuccess) {
            
            self.confirmReceiveSuccess();
            
        }
        
    }];
    
    [actionSheetCtrl addAction:hpAction];
//    [actionSheetCtrl addAction:zpAction];
//    [actionSheetCtrl addAction:cpAction];
    [actionSheetCtrl addAction:cancleAction];
    
    [self presentViewController:actionSheetCtrl animated:YES completion:nil];


}

- (void)commentWithType:(NSString *)type code:(NSString *)code {
    
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"808240";
    http.parameters[@"storeCode"] = self.order.product.code;
    
    http.parameters[@"userId"] = [ZHUser user].userId;
    http.parameters[@"type"] = @"3";
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithHUDText:@"评价成功"];
        [self.navigationController popViewControllerAnimated:YES];
        
        if (self.confirmReceiveSuccess) {
            
            self.confirmReceiveSuccess();
            
        }
        
    } failure:^(NSError *error) {
        
        
    }];

    
    
    ///////////`````````````````````````````//////////////////////
    //进行评论
//    TLNetworking *http = [TLNetworking new];
//    http.showView = self.view;
//    http.code = @"808320";
//    http.parameters[@"jewelCode"] = code ? : self.order.productOrderList[0].productCode; //宝贝编号
//    http.parameters[@"orderCode"] = self.order.code;
//    http.parameters[@"interacter"] = [ZHUser user].userId; //评价人
//    http.parameters[@"evaluateType"] = type;
//    [http postWithSuccess:^(id responseObject) {
//        
//        [TLAlert alertWithHUDText:@"评价成功"];
//        [self.navigationController popViewControllerAnimated:YES];
//        
//        if (self.confirmReceiveSuccess) {
//            
//            self.confirmReceiveSuccess();
//            
//        }
//        
//    } failure:^(NSError *error) {
//        
//    }];

    
    

}

- (UIView *)footerView {

   UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
    footerView.backgroundColor = [UIColor whiteColor];
    
    self.expressNameLbl = [UILabel labelWithFrame:CGRectMake(LEFT_MARGIN, 16, SCREEN_WIDTH - 30, [FONT(13) lineHeight])
                                     textAligment:NSTextAlignmentLeft
                                  backgroundColor:[UIColor whiteColor]
                                             font:FONT(13)
                                        textColor:[UIColor zh_textColor]];
    [footerView addSubview:self.expressNameLbl];
    
    self.expressCodeLbl = [UILabel labelWithFrame:CGRectMake(LEFT_MARGIN,  self.expressNameLbl.yy + 16, SCREEN_WIDTH - 30, self.expressNameLbl.height)
                                     textAligment:NSTextAlignmentLeft
                                  backgroundColor:[UIColor whiteColor]
                                             font:FONT(13)
                                        textColor:[UIColor zh_textColor]];
    [footerView addSubview:self.expressCodeLbl];
    
    return footerView;
    

}

//
- ( void )orderHeaderView {
    
    self.tableViewHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableViewHeaderView.backgroundColor = [UIColor whiteColor];
    UIView *headerView = self.tableViewHeaderView;
    
    //
    self.orderCodeLbl = [UILabel labelWithFrame:CGRectMake(LEFT_MARGIN, 16, SCREEN_WIDTH - 30, [FONT(13) lineHeight])
                                   textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor whiteColor]
                                           font:FONT(13)
                                      textColor:[UIColor zh_textColor]];
    [headerView addSubview:self.orderCodeLbl];
    
    //
    self.orderTimeLbl = [UILabel labelWithFrame:CGRectMake(LEFT_MARGIN, self.orderCodeLbl.yy + 5, SCREEN_WIDTH - 30, self.orderCodeLbl.height)
                                   textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor whiteColor]
                                           font:FONT(13)
                                      textColor:[UIColor zh_textColor]];
    [headerView addSubview:self.orderTimeLbl];
    
    //
    self.orderStatusLbl = [UILabel labelWithFrame:CGRectMake(LEFT_MARGIN, self.orderTimeLbl.yy + 5, SCREEN_WIDTH - 30,self.orderCodeLbl.height)
                                   textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor whiteColor]
                                           font:FONT(13)
                                      textColor:[UIColor zh_textColor]];
    [headerView addSubview:self.orderStatusLbl];
    
    //
    self.postageLbl = [UILabel labelWithFrame:CGRectMake(LEFT_MARGIN, self.orderStatusLbl.yy + 5, SCREEN_WIDTH - 30,self.orderCodeLbl.height)
                                 textAligment:NSTextAlignmentLeft
                              backgroundColor:[UIColor whiteColor]
                                         font:FONT(13)
                                    textColor:[UIColor zh_textColor]];
    [headerView addSubview:self.postageLbl];
    self.postageLbl.numberOfLines = 0;
    
    //订单总价
    self.orderTotalPrice = [UILabel labelWithFrame:CGRectMake(LEFT_MARGIN, self.orderStatusLbl.yy + 5, SCREEN_WIDTH - 30,self.orderCodeLbl.height)
                                      textAligment:NSTextAlignmentLeft
                                   backgroundColor:[UIColor whiteColor]
                                              font:FONT(13)
                                         textColor:[UIColor zh_textColor]];
    [headerView addSubview:self.orderTotalPrice];
    self.orderTotalPrice.numberOfLines = 0;
    
    //
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, self.postageLbl.yy + 16, SCREEN_WIDTH, 10)];
    [headerView addSubview:lineV];
    lineV.backgroundColor = [UIColor zh_backgroundColor];
    
    //收货信息
    self.addressView = [[ZHAddressChooseView alloc] initWithFrame:CGRectMake(0, lineV.yy, SCREEN_WIDTH, 89)];
    self.addressView.type = ZHAddressChooseTypeDisplay;
    [headerView addSubview:self.addressView];
    
    //添加约束
    [self.postageLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.orderStatusLbl.mas_bottom).offset(5);
        make.left.equalTo(headerView.mas_left).offset(LEFT_MARGIN);
        make.right.lessThanOrEqualTo(headerView.mas_right).offset(-LEFT_MARGIN);
        
    }];
    
    [self.orderTotalPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.postageLbl.mas_bottom).offset(5);
        make.left.equalTo(headerView.mas_left).offset(LEFT_MARGIN);
        make.right.lessThanOrEqualTo(headerView.mas_right).offset(-LEFT_MARGIN);
        
    }];
    
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.orderTotalPrice.mas_bottom).offset(12);
        make.left.right.equalTo(headerView);
        make.height.mas_equalTo(10);
        
    }];
    
    [self.addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(headerView);
        make.top.equalTo(lineV.mas_bottom);
        make.height.equalTo(@89);
    }];
    

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

//    return self.order.productOrderList.count;
    return 1;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *zhOrderGoodsCellId = @"ZHOrderGoodsCell";
    ZHOrderGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:zhOrderGoodsCellId];
    if (!cell) {
        
        cell = [[ZHOrderGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:zhOrderGoodsCellId];
        __weak typeof(self) weakself = self;
        cell.comment = ^(NSString *code){
        
            [weakself goCommentWithCode:code];

        };
        
    }
    
    cell.order = self.order;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}


- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *hfV = (UITableViewHeaderFooterView *)view;
    hfV.contentView.backgroundColor = [UIColor zh_backgroundColor];
    
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {

    UITableViewHeaderFooterView *hfV = (UITableViewHeaderFooterView *)view;
    hfV.contentView.backgroundColor = [UIColor zh_backgroundColor];
    
}

@end
