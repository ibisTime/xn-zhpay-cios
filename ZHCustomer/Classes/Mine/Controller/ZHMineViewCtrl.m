//
//  ZHMineViewCtrl.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/20.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHMineViewCtrl.h"
#import "ZHSettingGroup.h"
#import "ZHSettingUpCell.h"
#import "ZHAccountSecurityVC.h"
#import "ZHHZBVC.h"
#import "ZHWalletView.h"
#import "ZHCurrencyModel.h"
#import "ZHUserHeaderView.h"
#import "TLImagePicker.h"
#import "TLUploadManager.h"
#import "QNUploadManager.h"
#import "ZHBillVC.h"

@interface ZHMineViewCtrl ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSArray <ZHSettingGroup *>*groups;
@property (nonatomic,strong) NSMutableArray <ZHWalletView *>*walletViews;
@property (nonatomic,strong) TLTableView *mineTableView;
@property (nonatomic,strong) ZHUserHeaderView *headerView;

@property (nonatomic,strong) TLImagePicker *imagePicker;


@property (nonatomic,strong) NSMutableArray <ZHCurrencyModel *>*currencyRoom; //币种
@property (nonatomic,strong) NSMutableDictionary <NSString *,ZHCurrencyModel *>*currencyDict;

@end

@implementation ZHMineViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    
    TLTableView *tableV = [TLTableView groupTableViewWithframe:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49 - 64) delegate:self dataSource:self];
    [self.view addSubview:tableV];
    self.mineTableView = tableV;
    
    tableV.backgroundColor = [UIColor zh_backgroundColor];
    tableV.delegate = self;
    tableV.dataSource = self;
    tableV.rowHeight = 45;
    tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    self.groups = @[[self group01],[self group02]];
    
    //头部信息
    [self setUptableViewHeader];
    
    //刷新信息
    [tableV addRefreshAction:^{
        
        TLNetworking *http = [TLNetworking new];
        http.showView = self.view;
        http.code = @"802503";
        http.parameters[@"token"] = [ZHUser user].token;
        http.parameters[@"userId"] = [ZHUser user].userId;
        [http postWithSuccess:^(id responseObject) {
            
            [self.mineTableView endRefreshHeader];

            self.currencyRoom = [ZHCurrencyModel tl_objectArrayWithDictionaryArray:responseObject[@"data"]];
            
            //把币种分开
            [self.currencyRoom  enumerateObjectsUsingBlock:^(ZHCurrencyModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                self.currencyDict[obj.currency] = obj;
                
            }];
            
            //刷新界面信息
            [self refreshWalletInfo];
            
        } failure:^(NSError *error) {
            
            [TLAlert alertWithHUDText:@"获取用户账户信息失败"];
            [self.mineTableView endRefreshHeader];
            
        }];
        
        
    }];
    
    
}

- (void)refreshWalletInfo {

    [self.walletViews enumerateObjectsUsingBlock:^(ZHWalletView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        obj.moneyLbl.text = @"￥1000.00";
        
    }];

}

- (void)goWalletDetailWithCode:(NSString *)code {

    ZHBillVC *vc = [[ZHBillVC alloc] init];
    vc.accountNumber = self.currencyDict[code].accountNumber; //账单编号
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark- 修改头像
- (void)choosePhoto {
    
    __weak typeof(self) weakSelf = self;
    if (!self.imagePicker.pickFinish) {
        
        self.imagePicker.pickFinish = ^(NSDictionary *info){
            
            
            TLNetworking *getUploadToken = [TLNetworking new];
            getUploadToken.showView = weakSelf.view;
            getUploadToken.code = @"807900";
            getUploadToken.parameters[@"token"] = [ZHUser user].token;
            [getUploadToken postWithSuccess:^(id responseObject) {
                
                [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
                QNUploadManager *uploadManager = [[QNUploadManager alloc] init];
                NSString *token = responseObject[@"data"][@"uploadToken"];
                
                UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
                NSData *imgData = UIImageJPEGRepresentation(image, 0.4);
                
                [uploadManager putData:imgData key:[TLUploadManager imageNameByImage:image] token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                    [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                    
                    //设置头像
                    
                    TLNetworking *http = [TLNetworking new];
                    http.showView = weakSelf.view;
                    http.code = @"805077";
                    http.parameters[@"userId"] = [ZHUser user].userId;
                    http.parameters[@"photo"] = key;
                    http.parameters[@"token"] = [ZHUser user].token;
                    [http postWithSuccess:^(id responseObject) {
                        
                        [TLAlert alertWithHUDText:@"修改头像成功"];
                        [ZHUser user].userExt.photo = key;
                        weakSelf.headerView.avatarImageV.image = image;
                        
                    } failure:^(NSError *error) {
                        
                        
                    }];
                    
                    
                } option:nil];
                
            } failure:^(NSError *error) {
                
            }];
            
        };
    }
    
    [self.imagePicker picker];
    
}

#pragma mark- 头部信息
- (void)setUptableViewHeader {

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
    self.mineTableView.tableHeaderView = headerView;
    
    //头像等信息
    __weak typeof(self) weakself = self;
    self.headerView = [[ZHUserHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 118)];
    [headerView addSubview:self.headerView];
    self.headerView.changePhoto = ^(){
    
        [weakself choosePhoto];
    
    };
    
    self.headerView.tapAction = ^(){
    
        NSLog(@"我要分享了");
    };
    
    self.headerView.nameLbl.text = [NSString stringWithFormat:@"昵称：%@",[ZHUser user].nickname];
    self.headerView.mobileLbl.text = [NSString stringWithFormat:@"账号：%@",[ZHUser user].mobile];
    self.headerView.hintLbl.text = @"点击分享注册链接到微信";
    
    if ([ZHUser user].userExt.photo) {
        
        NSString *urlStr = [[ZHUser user].userExt.photo convertThumbnailImageUrl];
        [self.headerView.avatarImageV sd_setImageWithURL:[NSURL URLWithString: urlStr]placeholderImage:[UIImage imageNamed:@"user_placeholder"]];
        
    } else {
        
        self.headerView.avatarImageV.image = [UIImage imageNamed:@"user_placeholder"];

    }
    
    //钱包
    
    NSArray *typeNames =  @[@"贡献值",@"分润",@"红包",@"红包业绩",@"钱包币",@"购物币"];
    NSArray *typeCode =  @[kGXB,kFRB,kHBB,kHBYJ,kQBB,kGWB];


    self.walletViews = [[NSMutableArray alloc] initWithCapacity:typeNames.count];
    
    
    CGFloat w = (SCREEN_WIDTH - 1)/2.0;
    CGFloat h = 60;
    CGFloat x = w + 1;
    UIView *lastView;
    
    for (NSInteger i = 0; i < typeNames.count; i ++) {
        
        CGRect frame = CGRectMake((i%2)*x, (h + 1)*(i/2) + self.headerView.yy + 10, w, h);
        ZHWalletView *walletView = [[ZHWalletView alloc] initWithFrame:frame];walletView.backgroundColor = [UIColor whiteColor];
        [headerView addSubview:walletView];
        
        walletView.typeLbl.text = typeNames[i];
        walletView.code = typeCode[i];
        walletView.action = ^(NSString *code){
            [weakself goWalletDetailWithCode:code];
            
        };
        [self.walletViews addObject:walletView];
        lastView = walletView;
        
        walletView.moneyLbl.text = @"￥1000.00";

        
    }
    
    self.mineTableView.tableHeaderView.height = lastView.yy + 10;

}


- (ZHSettingGroup *)group02 {
    __weak typeof(self) weakself = self;
    
    ZHSettingModel *item01 = [[ZHSettingModel alloc] init];
    item01.imgName = @"我的－设置";
    item01.text =  @"设置";
    
    item01.action = ^(){
        
        ZHAccountSecurityVC *vc = [[ZHAccountSecurityVC alloc] init];
        [weakself.navigationController pushViewController:vc animated:YES];
    
    };
    
    ZHSettingGroup *group = [[ZHSettingGroup alloc] init];
    group.items = @[item01];
    return group;
}


- (ZHSettingGroup *)group01 {
    
    __weak typeof(self) weakself = self;
    ZHSettingModel *item01 = [[ZHSettingModel alloc] init];
    item01.imgName = @"我的－汇赚宝";
    item01.text = @"汇赚宝";
    item01.action = ^(){
        //
        ZHHZBVC *vc = [ZHHZBVC new];
        [weakself.navigationController pushViewController:vc animated:YES];
        
    };
    
    ZHSettingModel *item02 = [[ZHSettingModel alloc] init];
    item02.imgName = @"我的－发一发";
    item02.text = @"发一发";
    item02.action = ^(){
        
      
    };
    
    ZHSettingModel *item03 = [[ZHSettingModel alloc] init];
    item03.imgName = @"小目标记录";
    item03.text = @"小目标记录";
    item03.action = ^(){
        
   
        
    };
    
    ZHSettingGroup *group01 = [[ZHSettingGroup alloc] init];
    group01.items = @[item01,item02,item03];
    return group01;
}


#pragma mark- delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZHSettingGroup *group = self.groups[indexPath.section];
    ZHSettingModel *model = group.items[indexPath.row];
    
    if (model.action) {
        model.action();
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}



- (TLImagePicker *)imagePicker {
    
    if (!_imagePicker) {
        _imagePicker = [[TLImagePicker alloc] initWithVC:self];
        _imagePicker.allowsEditing = YES;
        
    }
    return _imagePicker;
}

#pragma mark- dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.groups[section].items.count;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.groups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *zhSettingUpCell = @"ZHSettingUpCellId";
    ZHSettingUpCell *cell = [tableView dequeueReusableCellWithIdentifier:zhSettingUpCell];
    if (!cell) {
        
        cell = [[ZHSettingUpCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:zhSettingUpCell];
        cell.item = self.groups[indexPath.section].items[indexPath.row];
    }
    return cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    if (section == 1) {
        return 10;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}

@end
