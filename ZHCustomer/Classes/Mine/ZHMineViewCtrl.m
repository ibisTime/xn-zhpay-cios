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
#import "TLMsgPlayView.h"
#import "CDUserReleationVC.h"
#import "ZHUserHeaderView.h"
#import "TLImagePicker.h"
#import "TLUploadManager.h"
#import "QNUploadManager.h"
#import "ZHBillVC.h"
#import "TLWXManager.h"
#import "ZHShareView.h"
#import "AppConfig.h"
#import "ZHShoppingListVC.h"
#import "ZHShopOrderVC.h"
#import "TLHeader.h"
#import "ZHNewMineWalletVC.h"
#import "CDFenHongQuanVC.h"
#import "ZHUser.h"
#import "UIColor+theme.h"

@interface ZHMineViewCtrl ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSArray <ZHSettingGroup *>*groups;

//@property (nonatomic,strong) NSMutableArray <ZHWalletView *>*walletViews;

@property (nonatomic,strong) TLTableView *mineTableView;
@property (nonatomic,strong) ZHUserHeaderView *headerView;

@property (nonatomic,strong) TLImagePicker *imagePicker;

@property (nonatomic,assign) BOOL isFist;


@end

@implementation ZHMineViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    self.isFist = YES;
    
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
    __weak typeof(self) weakSelf = self;
    [tableV addRefreshAction:^{
        

        [weakSelf.mineTableView endRefreshHeader];
        [[ZHUser user] updateUserInfo];
        
    }];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeInfo) name:kUserInfoChange object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeInfo) name:kUserLoginNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOut) name:kUserLoginOutNotification object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.isFist) {
        
       [self changeInfo];
        self.isFist = NO;
    }

    
}

#pragma mark- 通知处理
- (void)loginOut {
    
    self.headerView.nameLbl.text = @"";
    self.headerView.mobileLbl.text = @"";
    self.headerView.avatarImageV.image = [UIImage imageNamed:@"user_placeholder"];
    
//    self.currencyRoom = nil;
//    self.currencyDict = nil;
    
}


- (void)changeInfo {
    
    self.headerView.nameLbl.text = [NSString stringWithFormat:@"昵称：%@",[ZHUser user].nickname];
    self.headerView.mobileLbl.text = [NSString stringWithFormat:@"账号：%@",[ZHUser user].mobile];
    self.headerView.hintLbl.text = @"点击分享注册链接到微信";
    
    if ([ZHUser user].userExt.photo) {
        
        NSString *urlStr = [[ZHUser user].userExt.photo convertThumbnailImageUrl];
        [self.headerView.avatarImageV sd_setImageWithURL:[NSURL URLWithString: urlStr]placeholderImage:[UIImage imageNamed:@"user_placeholder"]];
        
    } else {
        
        self.headerView.avatarImageV.image = [UIImage imageNamed:@"user_placeholder"];
        
    }
    
//    [self.mineTableView beginRefreshing];
    
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
                
//                [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
                
                [TLProgressHUD showWithStatus:nil];
                QNUploadManager *uploadManager = [[QNUploadManager alloc] init];
                NSString *token = responseObject[@"data"][@"uploadToken"];
                
                UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
                NSData *imgData = UIImageJPEGRepresentation(image, 0.4);
                
                [uploadManager putData:imgData key:[TLUploadManager imageNameByImage:image] token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                    
                    [TLProgressHUD dismiss];

//                    [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                    
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

#pragma mark- 分享出去
- (void)shareToWX {
    
    
    ZHShareView *shareView = [[ZHShareView alloc] init];
    shareView.title = @"共享消费平台";
    shareView.wxShare = ^(BOOL isSuccess, int code){
    
        if (isSuccess) {
            [TLAlert alertWithHUDText:@"分享成功"];
        }
    };
    shareView.content = @"利润共享，数据共享，股权共享";
    shareView.shareUrl = [NSString stringWithFormat:@"%@/user/register.html?userReferee=%@",[AppConfig config].shareBaseUrl,[[ZHUser user] mobile]];
    shareView.qrContentStr = [ZHUser user].mobile;
    [shareView show];
    
    return;
    
}

#pragma mark- 查看收益
- (void)lookMineEarnings {


    CDFenHongQuanVC *vc = [CDFenHongQuanVC new];
    [self.navigationController pushViewController:vc animated:YES];
    
//    ZHMineEarningsVC *vc = [ZHMineEarningsVC new];
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark- 推荐关系
- (void)lookMineHZB {
    
    CDUserReleationVC *vc = [[CDUserReleationVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
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
    
        [weakself shareToWX];
        
    };
    
    //我的收益 汇赚宝
    CGFloat w0 = (SCREEN_WIDTH - 1)/2.0;
    UIButton *earningBtn = [self twoBtnWithFrame:CGRectMake(0, self.headerView.yy,w0, 50) title:@"我的收益" imagName:@"我的收益"];
    
    [earningBtn setTitleColor:[UIColor zh_textColor] forState:UIControlStateNormal];
    [earningBtn addTarget:self action:@selector(lookMineEarnings) forControlEvents:UIControlEventTouchUpInside];

    [headerView addSubview:earningBtn];
    
    //
    UIButton *hzbBtn = [self twoBtnWithFrame:CGRectMake(earningBtn.xx  + 1, self.headerView.yy,w0, 50) title:@"推荐关系" imagName:@"汇赚宝"];
    [hzbBtn addTarget:self action:@selector(lookMineHZB) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:hzbBtn];
    
    
    self.mineTableView.tableHeaderView.height = hzbBtn.yy + 10;

}

- (UIButton *)twoBtnWithFrame:(CGRect)frame title:(NSString *)title imagName:(NSString *)imageName {

    UIButton *hzbBtn = [[UIButton alloc] initWithFrame:frame title:title backgroundColor:[UIColor whiteColor]];
    hzbBtn.titleLabel.font = FONT(14);
    [hzbBtn setTitleColor:[UIColor zh_textColor] forState:UIControlStateNormal];

    hzbBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    [hzbBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];

    return hzbBtn;

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
    
    //钱包
    ZHSettingModel *mineWallet = [[ZHSettingModel alloc] init];
    mineWallet.imgName = @"我的钱包";
    mineWallet.text = @"我的钱包";
    mineWallet.action = ^(){
        //
        ZHNewMineWalletVC *vc = [ZHNewMineWalletVC new];
        [weakself.navigationController pushViewController:vc animated:YES];
        
    };
    
    //尖货清单
    ZHSettingModel *goodsDetail = [[ZHSettingModel alloc] init];
    goodsDetail.imgName = @"购物清单";
    goodsDetail.text = @"尖货清单";
    goodsDetail.action = ^(){
        //
        ZHShoppingListVC  *vc = [ZHShoppingListVC new];
        [weakself.navigationController pushViewController:vc animated:YES];
        
    };
    
    
    //优店清单
    ZHSettingModel *shopDetail = [[ZHSettingModel alloc] init];
    shopDetail.imgName = @"我的优店";
    shopDetail.text = @"优店清单";
    shopDetail.action = ^(){
        
        //
        ZHShopOrderVC  *vc = [ZHShopOrderVC new];
        [weakself.navigationController pushViewController:vc animated:YES];
        //
        
    };
    

    ZHSettingGroup *group01 = [[ZHSettingGroup alloc] init];
    group01.items = @[mineWallet,goodsDetail,shopDetail];
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
