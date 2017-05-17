//
//  ZHHZBVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/8.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHHZBVC.h"
#import "ZHBuyHZBVC.h"
#import "ZHBusinessCardView.h"
#import "ZHHZBModel.h"
#import "ZHBriberyMoneyVC.h"

#import <Photos/Photos.h>
#import "SGAlertView.h"
#import "SGScanningQRCodeVC.h"
#import "MJRefresh.h"
#import "ZHBillVC.h"

#import "ZHHZBInfoCell.h"
#import "ZHCurrencyModel.h"

@interface ZHHZBVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,strong) ZHHZBModel *HZBModel;
@property (nonatomic,strong) ZHBuyHZBVC *buyVC;

@property (nonatomic, strong) NSMutableArray <NSDictionary <NSString*, NSString *> *>*hzbInfos;
@property (nonatomic, strong) TLTableView *hzbTableView;

@end


@implementation ZHHZBVC

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (ZHBuyHZBVC *)buyVC {

    if (!_buyVC) {
        
        _buyVC = [[ZHBuyHZBVC alloc] init];
        
    }
    return _buyVC;

}

- (NSMutableArray<NSDictionary<NSString *,NSString *> *> *)hzbInfos {

    if (!_hzbInfos) {
        
        _hzbInfos = [[NSMutableArray alloc] initWithCapacity:7];
    }
    return _hzbInfos;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的汇赚宝";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buySuccess) name:@"HZBBuySuccess" object:nil];
    
    //没有购买的进行购买
    [self buySuccess];
    

}


- (void)buySuccess {
    
//    [self setUpUI];
//    return;

    TLNetworking *http = [TLNetworking new];
    http.code = @"615118";
    http.parameters[@"userId"] = [ZHUser user].userId;
    http.parameters[@"token"] = [ZHUser user].token;
    [http postWithSuccess:^(id responseObject) {
    
        NSArray *data = responseObject[@"data"];
        if (data.count > 0) {
            
            self.HZBModel = [ZHHZBModel  tl_objectWithDictionary:data[0]];
            [self.tl_placeholderView removeFromSuperview];
            
            
            [self setUpUI];
            [self getOtherInfo];
            
//            [self.hzbInfos removeAllObjects];
//            NSDictionary *addressDict = @{@"隶属辖区" : [[ZHUser user] detailAddress]};
//            
//            NSDictionary *historyYYDict = @{@"历史被摇次数" : [ self.HZBModel.totalRockNum stringValue]};
//            NSDictionary *todayYYDict = @{@"今日被摇次数" : [self.HZBModel.periodRockNum stringValue]};
            
//            NSDictionary *HBYJDict = @{@"摇一摇红包业绩" : [(NSNumber *)allDict[@"yyTotalAmount"] convertToRealMoney]};
//            
//            
//            
//            NSDictionary *historyHBDict = @{@"历史定向红包" : [allDict[@"historyHbTimes"] stringValue]};
//            NSDictionary *todayHBDict = @{@"今日定向红包" : [allDict[@"todayHbTimes"] stringValue]};
//            //贡献值 -- 红包业绩
//            NSDictionary *GXZDict =  @{@"发一发红包业绩" : [(NSNumber *)allDict[@"ffTotalHbAmount"] convertToRealMoney]};
            
//            [self.hzbInfos addObjectsFromArray:@[addressDict,historyYYDict,todayYYDict]];
            
            
//            [self.hzbTableView reloadData];
            
            
            
            if (_buyVC && _buyVC.view) {
                
                [self.buyVC.view removeFromSuperview];
                [self.buyVC removeFromParentViewController];

            }
            
    
            
        } else { //还没有汇赚宝
            
            [self addChildViewController:self.buyVC];
            [self.view addSubview:self.buyVC.view];
        
        }
        
    } failure:^(NSError *error) {
        
        if (self.hzbTableView ) {
            [self.hzbTableView endRefreshHeader];
        }
        
    }];
    
    

    
//    data = {
//        ffTotalHbAmount = 0; 发一发红包业绩金额
    
    
//        historyYyTimes = 1;  历史摇摇次数
//        todayYyTimes = 0; 今日摇摇次数

//        historyHbTimes = 0;
//        todayHbTimes = 0;
    
//        yyTotalAmount = 450; 摇一摇总红包业绩
//    };

}


- (void)getOtherInfo {

    //获取统计信息
    TLNetworking *httpGetInfo = [TLNetworking new];
    httpGetInfo.code = @"615119";
    httpGetInfo.parameters[@"userId"] = [ZHUser user].userId;
    httpGetInfo.parameters[@"token"] = [ZHUser user].token;
    [httpGetInfo postWithSuccess:^(id responseObject) {
        
        
       
        
        if (self.hzbTableView ) {
            [self.hzbTableView endRefreshHeader];
        }
        
        // 拼接地址数据
        [self.hzbInfos removeAllObjects];
        
        NSDictionary *allDict = responseObject[@"data"];
//        ffTotalHbAmount = 0;
//        historyHbTimes = 0;
//        historyYyTimes = 0;
//        todayHbTimes = 0;
//        todayYyTimes = 0;
        
//        yyTotalAmount = 0;
        
//        NSArray *titles = @[@"隶属辖区",@"历史被摇次数",@"今日被摇次数",@"红包业绩",@"历史定向红包",@"今日定向红包",@"贡献值"];
//        NSArray *keys = @[];
        
        NSDictionary *addressDict = @{@"隶属辖区" : [[ZHUser user] detailAddress]};
        
        NSDictionary *historyYYDict = @{@"历史被摇次数" : [allDict[@"historyYyTimes"] stringValue]};
        NSDictionary *todayYYDict = @{@"今日被摇次数" : [allDict[@"todayYyTimes"]stringValue]};
        NSDictionary *HBYJDict = @{@"摇一摇红包业绩" : [(NSNumber *)allDict[@"yyTotalAmount"] convertToRealMoney]};
        
 
        
        NSDictionary *historyHBDict = @{@"历史定向红包" : [allDict[@"historyHbTimes"] stringValue]};
        NSDictionary *todayHBDict = @{@"今日定向红包" : [allDict[@"todayHbTimes"] stringValue]};
        
        //贡献值 -- 红包业绩
        NSDictionary *GXZDict =  @{@"发一发红包业绩" : [(NSNumber *)allDict[@"ffTotalHbAmount"] convertToRealMoney]};
        
        [self.hzbInfos addObjectsFromArray:@[addressDict,historyYYDict,todayYYDict,HBYJDict,historyHBDict,todayHBDict,GXZDict]];
        
    
        [self.hzbTableView reloadData];
        
        
    } failure:^(NSError *error) {
        
        if (self.hzbTableView ) {
            [self.hzbTableView endRefreshHeader];
        }
        
    }];

}


- (void)setUpUI {
    
    //防止刷新重复创建
    if (self.hzbTableView) {
        return;
    }
    
    self.hzbTableView = [TLTableView tableViewWithframe:CGRectMake(0, 0, SCREEN_WIDTH , SCREEN_HEIGHT - 64 - 65) delegate:self dataSource:self];
    [self.view addSubview:self.hzbTableView];
    self.hzbTableView.rowHeight = 50;
    
    __weak typeof(self) weakSelf = self;
    [self.hzbTableView addRefreshAction:^{
        
        [weakSelf buySuccess];
        
        
    }];
    
    //--//
    //
    ZHBusinessCardView *cardV = [[ZHBusinessCardView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90)];
    
    //汇赚宝数据赋值
    self.hzbTableView.tableHeaderView = cardV;
    cardV.headerImageV.image = [UIImage imageNamed:@"树"];
    cardV.titleTf.text = [ZHUser user].realName;
    cardV.subTitleTf.text =  [self.HZBModel getStatusName];
    

    
    NSString *title;
    if ([self.HZBModel isAbandon]) {
        
        title = @"查看历史";

        
    } else {
    
        title = @"发定向红包";


    }
    
    //发红包Btn
    UIButton *sendBtn = [UIButton zhBtnWithFrame:CGRectMake(20,self.hzbTableView.yy , SCREEN_WIDTH - 40, 45) title:title];
    [self.view addSubview:sendBtn];
    [sendBtn addTarget:self action:@selector(sendBriberyMoney) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)sendBriberyMoney {

    ZHBriberyMoneyVC *vc = [[ZHBriberyMoneyVC alloc] init];
    
    if ([self.HZBModel isAbandon]) {
        
        vc.displayType = ZHBriberyMoneyVCTypeHistory;

    } else {
    
        vc.displayType = ZHBriberyMoneyVCTypeSecondUI;

    }
    
    [self.navigationController pushViewController:vc animated:YES];

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (!(indexPath.row == 3 || indexPath.row == 6)) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        return;
    }
    
    //获取账户
    
    //下部，钱包
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"802503";
    http.parameters[@"token"] = [ZHUser user].token;
    http.parameters[@"userId"] = [ZHUser user].userId;
    [http postWithSuccess:^(id responseObject) {
        
      NSArray <ZHCurrencyModel *> *currencyRoom =  [ZHCurrencyModel tl_objectArrayWithDictionaryArray:responseObject[@"data"]];
        
        ZHBillVC *billVC = [[ZHBillVC alloc] init];
        billVC.currency = kHBYJ;
        
        [currencyRoom enumerateObjectsUsingBlock:^(ZHCurrencyModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.currency isEqualToString:kHBYJ]) {
                
                billVC.currencyModel = obj;
 
                
            }
        }];
        
        
    
        
        if (indexPath.row == 3) { //摇摇
            
            billVC.bizType = @"53";
            
        }
        
        if (indexPath.row == 6) {
            
            billVC.bizType = @"60";
            
            
        }
        
        [self.navigationController pushViewController:billVC animated:YES];
        
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        
    } failure:^(NSError *error) {
        
    }];
    



}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.hzbInfos.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ZHHZBInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hzbCell"];
    if (!cell) {
        
        cell = [[ZHHZBInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hzbCell"];
    }
    cell.titleLbl.text = self.hzbInfos[indexPath.row].allKeys[0];
    cell.contentLbl.text = self.hzbInfos[indexPath.row].allValues[0];
    
    cell.arrowImageView.hidden = ( indexPath.row == 3 || indexPath.row == 6 )? NO : YES;
    return cell;

}




#pragma mark- 以下代码暂时无用
//- (void)scan {
//    
//    NSString * mediaType = AVMediaTypeVideo;
//    AVAuthorizationStatus  authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
//    if (authorizationStatus == AVAuthorizationStatusRestricted|| authorizationStatus == AVAuthorizationStatusDenied) {
//        
//        [TLAlert alertWithTitle:nil Message:@"没有权限访问您的相机,请在设置中打开" confirmMsg:@"设置" CancleMsg:@"取消" cancle:^(UIAlertAction *action) {
//            
//            
//        } confirm:^(UIAlertAction *action) {
//            
//            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//            if ([[UIApplication sharedApplication] canOpenURL:url]) {
//                [[UIApplication sharedApplication] openURL:url];
//            }
//            
//        }];
//        
//        return;
//        
//    }
//    
//    SGScanningQRCodeVC *scanningQRCodeVC = [[SGScanningQRCodeVC alloc] init];
//    //    scanningQRCodeVC.title = @"扫码注册";
//    scanningQRCodeVC.scannSuccess = ^(NSString *result){
//        
//        [self jh:result];
//        
//    };
//    [self.navigationController pushViewController:scanningQRCodeVC animated:YES];
//    
//}
//
//
//- (void)jh:(NSString *)result {
//    
//    NSData *data= [result dataUsingEncoding:NSUTF8StringEncoding];
//    
//    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//    
//    TLNetworking *http = [TLNetworking new];
//    http.showView = self.view;
//    
//    if (!(dict[@"code"] && dict[@"userId"])) {
//        
//        [TLAlert alertWithHUDText:@"无效二维码"];
//        return;
//    }
//    http.code = dict[@"code"];
//    http.parameters[@"userId"] = dict[@"userId"];
//    
//    
//    http.parameters[@"token"] = [ZHUser user].token;
//    [http postWithSuccess:^(id responseObject) {
//        
//        [TLAlert alertWithHUDText:@"激活成功"];
//        [self buySuccess];
//        
//    } failure:^(NSError *error) {
//        
//    }];
//    
//    
//}


@end
