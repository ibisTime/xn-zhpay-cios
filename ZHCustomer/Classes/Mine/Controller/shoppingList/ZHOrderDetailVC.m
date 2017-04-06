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
#import "ZHCartManager.h"

@interface ZHOrderDetailVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UILabel *orderCodeLbl;
@property (nonatomic,strong) UILabel *orderTimeLbl;
@property (nonatomic,strong) UILabel *orderStatusLbl;
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
    
    tableV.backgroundColor = [UIColor zh_backgroundColor];
    tableV.rowHeight = [ZHOrderGoodsCell rowHeight];
    
    //header
    tableV.tableHeaderView = [self orderHeaderView];
    
    self.orderCodeLbl.text = [NSString stringWithFormat:@"订单号：%@",self.order.code];
    self.orderTimeLbl.text = [NSString stringWithFormat:@"下单时间：%@",[self.order.applyDatetime convertToDetailDate]];
    self.orderStatusLbl.text = [NSString stringWithFormat:@"订单状态：%@",[self.order getStatusName]];
   
    self.addressView.nameLbl.text = [@"收货人" add:self.order.receiver];
    self.addressView.mobileLbl.text = self.order.reMobile;
    self.addressView.addressLbl.text = [@"收货地址：" add:self.order.reAddress];
    
//    || [self.order.status isEqualToString:@"4"] //已经收货
    if ([self.order.status isEqualToString:@"3"]) {// 已发货
        
        //footer
        tableV.tableFooterView = [self footerView];
        self.expressCodeLbl.text = [@"快递单号：" add:self.order.logisticsCode];
        self.expressNameLbl.text = [@"快递公司：" add:self.order.logisticsCompany];
        
        //收货按钮
        tableV.height = tableV.height - 49;
        UIButton *shBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, tableV.yy, SCREEN_WIDTH, 49) title:@"收货" backgroundColor:[UIColor zh_themeColor]];
        [self.view addSubview:shBtn];
        [shBtn addTarget:self action:@selector(confirmReceive) forControlEvents:UIControlEventTouchUpInside];
        
    } else if([self.order.status isEqualToString:@"1"]) { //待支付，可取消
    
        tableV.height = tableV.height - 49;

        UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, tableV.yy, SCREEN_WIDTH/2.0, 49) title:@"取消订单" backgroundColor:[UIColor zh_themeColor]];
        [self.view addSubview:cancleBtn];
        [cancleBtn addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *shBtn = [[UIButton alloc] initWithFrame:CGRectMake(cancleBtn .xx + 1, tableV.yy, SCREEN_WIDTH/2.0 -  1, 49) title:@"支付" backgroundColor:[UIColor zh_themeColor]];
        [self.view addSubview:shBtn];
        [shBtn addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchUpInside];
    
    }

}

#pragma mark- 支付
- (void)pay {
    
    [ZHCartManager getPostage:^(NSNumber *postage) {
        
        ZHNewPayVC *newPayVC = [[ZHNewPayVC alloc] init];
        newPayVC.type = ZHPayViewCtrlTypeNewGoods;
        newPayVC.goodsCodeList = @[self.order.code];
        
        newPayVC.rmbAmount = self.order.amount1; //把人民币传过去
        
        newPayVC.postage = postage;
        newPayVC.amoutAttrAddPostage = [ZHCurrencyHelper totalPriceAttr2WithQBB:self.order.amount3 GWB:self.order.amount2 RMB:@([self.order.amount1 longValue] + [postage longLongValue])];
        newPayVC.amoutAttr = [ZHCurrencyHelper totalPriceAttr2WithQBB:self.order.amount3 GWB:self.order.amount2 RMB:self.order.amount1];
        
        newPayVC.paySucces = ^(){
            
            [self.navigationController popViewControllerAnimated:YES];
            
            if (self.paySuccess) {
                self.paySuccess();
            }
            
        };
        //
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:newPayVC];
        [self presentViewController:nav animated:YES completion:nil];
        
    } failure:^{
        
    }];
    //
 
    

    
    
//    TLNetworking *http = [TLNetworking new];
//    http.showView = self.view;
//    http.code = @"808052";
//    http.parameters[@"code"] = self.order.code;
//    http.parameters[@"token"] = [ZHUser user].token;
//    [http postWithSuccess:^(id responseObject) {
        //商品购买
        
//        ZHPayVC *payVC = [[ZHPayVC alloc] init];
////        payVC.orderCode = self.order.code;
//        payVC.orderAmount = self.order.amount1; //把人民币传过去
//    payVC.amoutAttr = [ZHCurrencyHelper totalPriceAttr2WithQBB:self.order.amount3 GWB:self.order.amount2 RMB:self.order.amount1];
//    
//        payVC.paySucces = ^(){
//            
//            [TLAlert alertWithHUDText:@"支付成功"];
//            [self.navigationController popViewControllerAnimated:YES];
//            
//            if (self.paySuccess) {
//                self.paySuccess();
//            }
//            
//        };
////        payVC.type = ZHPayVCTypeGoods;
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:payVC];
//        [self presentViewController:nav animated:YES completion:nil];
//        
//        
//    } failure:^(NSError *error) {
//        
//    }];
}


#pragma mark- 取消订单
- (void)cancle { //取消订单
    
    [TLAlert alertWithTitle:@"" Message:@"确定取消订单？" confirmMsg:@"取消" CancleMsg:@"不取消" cancle:^(UIAlertAction *action) {
        
        
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
    
    UIAlertAction *zpAction = [UIAlertAction actionWithTitle:@"中评" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self commentWithType:@"B" code:code];

        
    }];
    
    UIAlertAction *cpAction = [UIAlertAction actionWithTitle:@"差评" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self commentWithType:@"C" code:code];
        
    }];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
        if (self.confirmReceiveSuccess) {
            
            self.confirmReceiveSuccess();
            
        }
        
    }];
    
    [actionSheetCtrl addAction:hpAction];
    [actionSheetCtrl addAction:zpAction];
    [actionSheetCtrl addAction:cpAction];
    [actionSheetCtrl addAction:cancleAction];
    
    [self presentViewController:actionSheetCtrl animated:YES completion:nil];


}

- (void)commentWithType:(NSString *)type code:(NSString *)code {
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"808320";
    http.parameters[@"jewelCode"] = code ? : self.order.productOrderList[0].productCode; //宝贝编号
    http.parameters[@"orderCode"] = self.order.code;
    http.parameters[@"interacter"] = [ZHUser user].userId; //评价人
    http.parameters[@"evaluateType"] = type;
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithHUDText:@"评价成功"];
        [self.navigationController popViewControllerAnimated:YES];
        
        if (self.confirmReceiveSuccess) {
            
            self.confirmReceiveSuccess();
            
        }
        
    } failure:^(NSError *error) {
        
    }];

//    [TLAlert alertWithTitle:nil Message:@"请对该商品做出评价" confirmMsg:@"好评" CancleMsg:@"拒绝" cancle:^(UIAlertAction *action) {
//        
//        [self.navigationController popViewControllerAnimated:YES];
//        
//        if (self.confirmReceiveSuccess) {
//            
//            self.confirmReceiveSuccess();
//            
//        }
//        
//    } confirm:^(UIAlertAction *action) {
//        
//
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
- (UIView *)orderHeaderView {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 195)];
    headerView.backgroundColor = [UIColor whiteColor];
    
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
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, self.orderStatusLbl.yy + 16, SCREEN_WIDTH, 10)];
    [headerView addSubview:lineV];
    lineV.backgroundColor = [UIColor zh_backgroundColor];
    
    //
    self.addressView = [[ZHAddressChooseView alloc] initWithFrame:CGRectMake(0, lineV.yy, SCREEN_WIDTH, 89)];
    self.addressView.type = ZHAddressChooseTypeDisplay;
    [headerView addSubview:self.addressView];
    //
    
    headerView.height = self.addressView.yy;
    return headerView;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.order.productOrderList.count;

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
    
    cell.orderGoods = self.order.productOrderList[indexPath.row];
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
