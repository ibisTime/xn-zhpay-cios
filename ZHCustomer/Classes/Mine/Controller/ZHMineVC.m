//
//  ZHMineVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/23.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHMineVC.h"
#import "ZHSettingUpCell.h"
#import "ZHSettingGroup.h"
#import "ZHMineHomeVC.h"
#import "ZHShoppingListVC.h"
#import "ZHMineWalletVC.h"
#import "ZHBuyShareVC.h"
#import "ZHMineShareVC.h"
#import "ZHShopOrderVC.h"
#import "ZHDBRecordVC.h"
#import "ZHRealNameAuthVC.h"
#import "ZHCouponsMgtVC.h"
#import "ZHHZBVC.h"
#import "TLImagePicker.h"
#import "QiniuSDK.h"
#import "TLUploadManager.h"
#import "ZHAboutUsVC.h"

@interface ZHMineVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIView *headerView;

@property (nonatomic,strong) UIImageView *headerImageView;
@property (nonatomic,strong) UILabel *nameLbl;
@property (nonatomic,strong) NSArray <ZHSettingGroup *>*groups;
@property (nonatomic,strong) TLImagePicker *imagePicker;

@end

@implementation ZHMineVC
- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self changeInfo];

}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.shadowImage = [[UIColor zh_backgroundColor] convertToImage];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    UITableView *tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49 - 64) style:UITableViewStyleGrouped];
    [self.view addSubview:tableV];
    tableV.delegate = self;
    tableV.dataSource = self;
    tableV.rowHeight = 56;
    tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    //header
    tableV.tableHeaderView = self.headerView;
    tableV.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    
    //设置用户信息
    self.groups = @[[self group01],[self group02]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeInfo) name:kUserInfoChange object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeInfo) name:kUserLoginNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOut) name:kUserLoginOutNotification object:nil];
    
    //图片选择事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choosePhoto)];
    self.headerImageView.userInteractionEnabled = YES;
    [self.headerImageView addGestureRecognizer:tap];
    
}

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
                         weakSelf.headerImageView.image = image;
                        
                    } failure:^(NSError *error) {
                        
                        
                    }];
                    

                } option:nil];
                
            } failure:^(NSError *error) {
                
            }];
            
        };
    }
    
    [self.imagePicker picker];
    
}

- (void)loginOut {

    self.nameLbl.text = @"";
    self.headerImageView.image = [UIImage imageNamed:@"user_placeholder"];

}

- (void)changeInfo {

    self.nameLbl.text = [ZHUser user].nickname ? [ZHUser user].nickname : @"还未设置昵称" ;
    if ([ZHUser user].userExt.photo) {
        
        NSString *urlStr = [[ZHUser user].userExt.photo convertThumbnailImageUrl];
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString: urlStr]placeholderImage:[UIImage imageNamed:@"user_placeholder"]];
        
    } else {
    
        self.headerImageView.image = [UIImage imageNamed:@"user_placeholder"];
    
    }
    
    
}

#pragma mark- 买股票
- (void)buyStock {

//    if (0) {
//        
//        ZHBuyShareVC *vc = [[ZHBuyShareVC alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
//        
//    } else {
    
        ZHMineShareVC *vc = [[ZHMineShareVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];

//    }


    
}


#pragma mark- 买汇赚宝
- (void)buyTree {
   
    __weak typeof(self) weakself = self;
    [self realNameAuth:^{
        
        ZHHZBVC *vc = [[ZHHZBVC alloc] init];
        [weakself.navigationController pushViewController:vc animated:nil];
        
    }];

}

#pragma mark- 前往个人主页
- (void)goHome {

    ZHMineHomeVC *homeVC = [[ZHMineHomeVC alloc] init];
    [self.navigationController pushViewController:homeVC animated:YES];

}

- (ZHSettingGroup *)group02 {
    __weak typeof(self) weakself = self;

    
    ZHSettingModel *item01 = [[ZHSettingModel alloc] init];
    item01.imgName = @"关于我们";
    item01.text =  @"关于我们";
    
    item01.action = ^(){
    
        [weakself.navigationController pushViewController:[[ZHAboutUsVC alloc] init] animated:YES];
    
    };
    
    ZHSettingGroup *group = [[ZHSettingGroup alloc] init];
    group.items = @[item01];
    return group;
}

- (ZHSettingGroup *)group01 {
    
    __weak typeof(self) weakself = self;
    ZHSettingModel *item01 = [[ZHSettingModel alloc] init];
    item01.imgName = @"我的钱包";
    item01.text = @"我的钱包";
    item01.action = ^(){
            //
      ZHMineWalletVC *walletVC = [[ZHMineWalletVC alloc] init];
      [weakself.navigationController pushViewController:walletVC animated:YES];
        
    };
    
    ZHSettingModel *item02 = [[ZHSettingModel alloc] init];
    item02.imgName = @"我的折扣券";
    item02.text = @"我的折扣券";
    item02.action = ^(){
    
        ZHCouponsMgtVC *mgtVC = [[ZHCouponsMgtVC alloc] init];
        [self.navigationController pushViewController:mgtVC animated:YES];
    
    };
    
    ZHSettingModel *item03 = [[ZHSettingModel alloc] init];
    item03.imgName = @"我的优店";
    item03.text = @"我的优店";
    item03.action = ^(){
    
        ZHShopOrderVC *vc = [[ZHShopOrderVC alloc] init];
        [weakself.navigationController pushViewController:vc animated:YES];
    
    };
    
    ZHSettingModel *item04 = [[ZHSettingModel alloc] init];
    item04.imgName = @"购物清单";
    item04.text =  @"购物清单";
    item04.action = ^(){
    
        ZHShoppingListVC *vc = [[ZHShoppingListVC alloc] init];
        [weakself.navigationController pushViewController:vc animated:YES];
        
    };
    
    
    ZHSettingModel *item05 = [[ZHSettingModel alloc] init];
    item05.imgName = @"夺宝记录";
    item05.text = @"夺宝记录";
    item05.action = ^(){
    
        ZHDBRecordVC *dbRecord = [[ZHDBRecordVC alloc] init];
        [weakself.navigationController pushViewController:dbRecord animated:YES];
        
    };
    
    ZHSettingGroup *group01 = [[ZHSettingGroup alloc] init];
    group01.items = @[item01,item02,item03,item04,item05];
    return group01;
}

- (void)realNameAuth:(void(^)())authSuccess{

    //先判断是否实名
    if (![ZHUser user].realName) {
        [TLAlert alertWithTitle:nil Message:@"您还未进行实名认证\n前往进行实名认证" confirmMsg:@"前往" CancleMsg:@"取消" cancle:^(UIAlertAction *action) {
            
        } confirm:^(UIAlertAction *action) {
            
            ZHRealNameAuthVC *authVC = [[ZHRealNameAuthVC alloc] init];
            authVC.authSuccess = ^(){ //实名认证成功
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    
                    if (authSuccess) {
                        authSuccess();
                    }

                    
                });
                
                
            };
            [self.navigationController pushViewController:authVC animated:YES];
            
        }];
    } else {
        
        
        if (authSuccess) {
            authSuccess();
        }
    }


}

- (TLImagePicker *)imagePicker {

    if (!_imagePicker) {
        _imagePicker = [[TLImagePicker alloc] initWithVC:self];
        _imagePicker.allowsEditing = YES;
        
    }
    return _imagePicker;
}

- (UIView *)headerView {

    if (!_headerView) {
        
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,190)];
        _headerView.backgroundColor = [UIColor whiteColor];
        _headerView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goHome)];
        [_headerView addGestureRecognizer:tap];
        
        
        //头像
        UIImageView *avatar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 65, 65)];
        [_headerView addSubview:avatar];
        avatar.centerX = _headerView.width/2.0;
        avatar.layer.cornerRadius = 32.5;
        avatar.clipsToBounds = YES;
        avatar.contentMode = UIViewContentModeScaleAspectFill;
        self.headerImageView = avatar;
        
        
    
        
        //
        UILabel *nameLbl = [UILabel labelWithFrame:CGRectMake(0, avatar.yy + 10, SCREEN_WIDTH, [[UIFont secondFont] lineHeight])
                                      textAligment:NSTextAlignmentCenter
                                   backgroundColor:[UIColor clearColor]
                                              font:[UIFont secondFont]
                                         textColor:[UIColor zh_textColor]];
        [_headerView addSubview:nameLbl];
        self.nameLbl = nameLbl;
        
        //查看个人主页
        UILabel *hintLbl = [UILabel labelWithFrame:CGRectMake(0, nameLbl.yy + 11, SCREEN_WIDTH, [[UIFont thirdFont] lineHeight])
                                      textAligment:NSTextAlignmentCenter
                                   backgroundColor:[UIColor whiteColor]
                                              font:[UIFont thirdFont]
                                         textColor:[UIColor zh_textColor]];
        [_headerView addSubview:hintLbl];
        hintLbl.text = @"查看个人主页";
        
        CGFloat x = SCREEN_WIDTH/4.0;
        //买股票  和
        
        UIButton *stockBGBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, hintLbl.yy + 29, SCREEN_WIDTH/2.0, 30)];
        [_headerView addSubview:stockBGBtn];
        [stockBGBtn addTarget:self action:@selector(buyStock) forControlEvents:UIControlEventTouchUpInside];
        UIButton *stockBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, hintLbl.yy + 29, 30, 30)];
        stockBtn.xx_size = x - 15;
        [_headerView addSubview:stockBtn];
        [stockBtn setImage:[UIImage imageNamed:@"股票"] forState:UIControlStateNormal];
        [stockBtn addTarget:self action:@selector(buyStock) forControlEvents:UIControlEventTouchUpInside];
        UILabel *lbl1 = [UILabel labelWithFrame:CGRectMake(x, stockBtn.y, 70, stockBtn.height) textAligment:NSTextAlignmentLeft backgroundColor:[UIColor whiteColor] font:FONT(13) textColor:[UIColor zh_textColor]];
        [_headerView addSubview:lbl1];
        lbl1.text = @"福利月卡";
        
        //买摇钱树
        UIButton *treeBGBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0, hintLbl.yy + 29, SCREEN_WIDTH/2.0, 30)];
        [_headerView addSubview:treeBGBtn];
        [treeBGBtn addTarget:self action:@selector(buyTree) forControlEvents:UIControlEventTouchUpInside];
        UIButton *treeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, hintLbl.yy + 29, 30, 30)];
        [treeBtn addTarget:self action:@selector(buyTree) forControlEvents:UIControlEventTouchUpInside];
        treeBtn.xx_size = 3*x - 15;
        [treeBtn setImage:[UIImage imageNamed:@"摇钱树"] forState:UIControlStateNormal];
        [_headerView addSubview:treeBtn];
        UILabel *lbl2 = [UILabel labelWithFrame:CGRectMake(x*3, stockBtn.y, 70, stockBtn.height)
                                   textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor whiteColor]
                                           font:FONT(13)
                                      textColor:[UIColor zh_textColor]];
        [_headerView addSubview:lbl2];
        lbl2.text = @"汇赚宝";
        
        
    }
    return _headerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return 0.1;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    ZHSettingGroup *group = self.groups[section];
    return group.items.count;
    
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {

    return self.groups.count;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    ZHSettingGroup *group = self.groups[indexPath.section];
    ZHSettingModel *model = group.items[indexPath.row];
    
    if (model.action) {
        model.action();
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}




@end
