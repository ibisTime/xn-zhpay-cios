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
#import "ZHMineDBRecordVC.h"
#import "TLWXManager.h"
#import "SGQRCodeTool.h"
#import "ZHBriberyMoneyVC.h"

@interface ZHMineViewCtrl ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSArray <ZHSettingGroup *>*groups;
@property (nonatomic,strong) NSMutableArray <ZHWalletView *>*walletViews;
@property (nonatomic,strong) TLTableView *mineTableView;
@property (nonatomic,strong) ZHUserHeaderView *headerView;

@property (nonatomic,strong) TLImagePicker *imagePicker;

@property (nonatomic,strong) NSMutableArray <ZHCurrencyModel *>*currencyRoom; //币种
@property (nonatomic,strong) NSMutableDictionary <NSString *,ZHCurrencyModel *>*currencyDict;

@property (nonatomic,assign) BOOL   isFist;


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
    [tableV addRefreshAction:^{
        
        TLNetworking *http = [TLNetworking new];
//        http.showView = self.view;
        http.code = @"802503";
        http.parameters[@"token"] = [ZHUser user].token;
        http.parameters[@"userId"] = [ZHUser user].userId;
        [http postWithSuccess:^(id responseObject) {
            
            [self.mineTableView endRefreshHeader];

            self.currencyRoom = [ZHCurrencyModel tl_objectArrayWithDictionaryArray:responseObject[@"data"]];
            
            //把币种分开
            self.currencyDict = [[NSMutableDictionary alloc] initWithCapacity:self.currencyRoom.count];
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
    
    self.currencyRoom = nil;
    self.currencyDict = nil;
    
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
    
    [self.mineTableView beginRefreshing];
    
}



- (void)refreshWalletInfo {

    [self.walletViews enumerateObjectsUsingBlock:^(ZHWalletView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSNumber *amount = self.currencyDict[obj.code].amount;
        obj.moneyLbl.text = [amount convertToRealMoney];
        
    }];

}

- (void)goWalletDetailWithCode:(NSString *)code {

    ZHBillVC *vc = [[ZHBillVC alloc] init];
    vc.currencyModel = self.currencyDict[code];
//    vc.accountNumber = self.currencyDict[code].accountNumber; //账单编号
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

#pragma mark- 分享出去
- (void)shareToWX {

    UIControl *maskCtrl = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [maskCtrl addTarget:self action:@selector(cancleShare:) forControlEvents:UIControlEventTouchUpInside];
    maskCtrl.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.65];
//    [UIColor colorWithWhite:0.2 alpha:0.5];
    
    [[UIApplication sharedApplication].keyWindow addSubview:maskCtrl];
    
    //添加二维码
    UIImageView *qrImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 69, 200, 200)];
    qrImageView.layer.cornerRadius = 5;
    qrImageView.clipsToBounds = YES;
    qrImageView.center = self.view.center;
    qrImageView.centerY = qrImageView.centerY - 40;
    [maskCtrl addSubview:qrImageView];
    
    //二维码
    UIImage *image = [SGQRCodeTool SG_generateWithDefaultQRCodeData:@"我的号码" imageViewWidth:SCREEN_WIDTH];
    qrImageView.image = image;
    
    //分享界面
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 139 - 54, SCREEN_WIDTH, 139 + 54)];
    bgView.backgroundColor = [UIColor colorWithHexString:@"#dcdbdb"];
    
    [maskCtrl addSubview:bgView];
    
    //
    UILabel *hintLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor clearColor]
                                          font:FONT(14)
                                     textColor:[UIColor zh_textColor]];
    [bgView addSubview:hintLbl];
    hintLbl.text = @"分享到";
    [hintLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset(15);
        make.top.equalTo(bgView.mas_top).offset(16);
    }];
    
    //分享给好友
    CGFloat w = 50;
    UIButton *shareFriendBtn = [[UIButton alloc] init];
    [shareFriendBtn setImage:[UIImage imageNamed:@"朋友圈"] forState:UIControlStateNormal];
    [bgView addSubview:shareFriendBtn];
    [shareFriendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(hintLbl.mas_bottom).offset(23);
        make.left.equalTo(bgView.mas_left).offset(15);
        make.width.mas_equalTo(w);
        make.height.mas_equalTo(w);

    }];
    
    //微信
    UIButton *shareWXZoneBtn = [[UIButton alloc] init];
    [shareWXZoneBtn setImage:[UIImage imageNamed:@"微信"] forState:UIControlStateNormal];
    [bgView addSubview:shareWXZoneBtn];
    [shareWXZoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(hintLbl.mas_bottom).offset(23);
        make.left.equalTo(shareFriendBtn.mas_right).offset(15);
        make.width.mas_equalTo(w);
        make.height.mas_equalTo(w);
        
    }];
    
    //
    UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 139, SCREEN_WIDTH, 54)];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    
    [bgView addSubview:cancleBtn];
    cancleBtn.backgroundColor = [UIColor whiteColor];
    [cancleBtn setTitleColor:[UIColor zh_textColor] forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(cancleShare:) forControlEvents:UIControlEventTouchUpInside];
    
    shareFriendBtn.tag = 100;
    shareWXZoneBtn.tag = 101;
    [shareFriendBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    [shareWXZoneBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    

}

- (void)share:(UIButton *)btn {

    [TLWXManager manager].wxShare = ^(BOOL isSuccess,int errorCode){
    
        if (isSuccess) {
            [TLAlert alertWithHUDText:@"分享成功"];

            [(UIControl *)[[btn nextResponder] nextResponder] removeFromSuperview];
            
        } else {
            [TLAlert alertWithHUDText:@"分享失败"];

        }
        
    };
    
    [TLWXManager wxShareWebPageWithScene:btn.tag == 100 ? WXSceneTimeline : WXSceneSession title:@"注册" desc:@"注册有奖" url:@"www.baidu.com"];

}


- (void)cancleShare:(UIControl *)ctrl {

    //
    if ([ctrl isMemberOfClass:[UIButton class]]) {
        
        [(UIControl *)[[ctrl nextResponder] nextResponder] removeFromSuperview];
        
    } else {
        
        [ctrl removeFromSuperview];

    
    }
    

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
        
        walletView.moneyLbl.text = @"0.00";

        
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
        
        ZHBriberyMoneyVC *vc = [[ZHBriberyMoneyVC alloc] init];
        vc.displayType = ZHBriberyMoneyVCTypeSecondUI;
        [self.navigationController pushViewController:vc animated:YES];
      
    };
    
    ZHSettingModel *item03 = [[ZHSettingModel alloc] init];
    item03.imgName = @"小目标记录";
    item03.text = @"小目标记录";
    item03.action = ^(){
        
        ZHMineDBRecordVC  *dbRecordVC = [[ZHMineDBRecordVC alloc] init];
        [weakself.navigationController pushViewController:dbRecordVC animated:YES];
        
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
