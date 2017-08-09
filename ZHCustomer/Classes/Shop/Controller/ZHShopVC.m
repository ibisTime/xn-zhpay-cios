//
//  ZHShopVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/23.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHShopVC.h"
#import "TLBannerView.h"
#import "ZHShopVC.h"
#import "ZHShopCell.h"
#import "TLPageDataHelper.h"
#import "ZHShopTypeView.h"
#import "ZHShopListVC.h"
#import "ZHShopDetailVC.h"
#import "Masonry.h"
#import "ZHBannerModel.h"
#import "ZHSearchVC.h"
#import "ZHMsgVC.h"
#import <CoreLocation/CoreLocation.h>
#import "HYCityViewController.h"
#import "ZHNavigationController.h"
#import "TLWebVC.h"
#import "ZHShareView.h"
#import "CDShopTypeChooseView.h"
#import "TLMarqueeView.h"
#import "TLLocationService.h"
#import "AppConfig.h"
#import "ZHMsg.h"
#import "TLHeader.h"
#import "ZHUser.h"
#import "UIColor+theme.h"


#define USER_CITY_NAME_KEY @"USER_CITY_NAME_KEY"

@interface ZHShopVC ()<UITableViewDelegate, UITableViewDataSource,CLLocationManagerDelegate,HYCityViewDelegate,CDShopTypeChoosDelegate>

@property (nonatomic,strong) TLTableView *shopTableView;
@property (nonatomic,strong) TLPageDataHelper *pageDataHelper;

//公告view
@property (nonatomic,strong) NSMutableArray *shops;

@property (nonatomic,strong) UILabel *cityLbl;

@property (nonatomic, strong) TLMarqueeView *sysMsgView;

@property (nonatomic,strong) TLBannerView *bannerView;
@property (nonatomic,strong) UIView *announcementsView;

//防止多次定位重复刷新
@property (nonatomic,assign) BOOL isFirstDiplayMsg;

//
@property (nonatomic,copy) NSString *lon;
@property (nonatomic,copy) NSString *lat;

@property (nonatomic, strong) NSDate *lastLocationSuccessDate;
//
@property (nonatomic,copy) NSString *currentCityName;

@property (nonatomic,strong) NSMutableArray <ZHBannerModel *>*bannerRoom;
@property (nonatomic,strong) NSMutableArray *bannerPics; //图片

@property (nonatomic, strong) CDShopTypeChooseView *shopTypeChooseView;

@end


@implementation ZHShopVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    if (![TLAuthHelper isEnableLocation]) {
        
        [TLAlert alertWithTitle:@"" Message:@"为了更好的为您服务,请在设置中打开定位服务" confirmMsg:@"设置" CancleMsg:@"取消" cancle:^(UIAlertAction *action) {
            
        } confirm:^(UIAlertAction *action) {
            
            [TLAuthHelper openSetting];

        }];
        
        return;
    }
    
//    if (self.isFirst) {
//        
////        [self.sysLocationManager  startUpdatingLocation];
//        self.isFirst = NO;
//
//    }
    
}



//存储数据
- (void)setCurrentCityName:(NSString *)currentCityName {

    _currentCityName = [currentCityName copy];
    [[NSUserDefaults standardUserDefaults] setObject:self.currentCityName forKey:USER_CITY_NAME_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.isFirstDiplayMsg = YES;

    //搜索 及 位置信息
    [self setUpSearchView];
    
    //先读取上次城市名称
    NSString *cityName =  [[NSUserDefaults standardUserDefaults] objectForKey:USER_CITY_NAME_KEY];
    if (cityName) {
        
        self.cityLbl.text = cityName;
        self.currentCityName = cityName;
        
    }

    //
    TLTableView *tableView = [TLTableView tableViewWithframe:CGRectMake(0,64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49) delegate:self dataSource:self];
    [self.view addSubview:tableView];
    tableView.rowHeight = [ZHShopCell rowHeight];
    self.shopTableView = tableView;
    
    __weak typeof(self) weakSelf = self;
    //顶部 banner 和 店铺类型选择
    [self setUpTableViewHeader];
    
    //
    self.bannerView.selected = ^(NSInteger index){
    
        TLWebVC *webVC = [[TLWebVC alloc] init];
        
        if (!(weakSelf.bannerRoom[index].url && weakSelf.bannerRoom[index].url.length > 0)) {
            return ;
        }
        webVC.url = weakSelf.bannerRoom[index].url;
        webVC.title = weakSelf.bannerRoom[index].name;
        [weakSelf.navigationController pushViewController:webVC animated:YES];
        
    };
    
#pragma mark- 系统公告
//    [self getSysMsg];
    
#pragma mark- 获取店铺类型
    [self getType];
     
#pragma mark- 店铺列表
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    helper.code = @"808217";
//    helper.parameters[@"status"] = kShopOpenStatus;
    
    helper.parameters[@"uiLocation"] = @"1";
    helper.tableView = self.shopTableView;
    [helper modelClass:[ZHShop class]];
    
    self.pageDataHelper = helper;
    
    [self.shopTableView addRefreshAction:^{
        
        //公告
        [weakSelf getSysMsg];
        
        //广告图
        [weakSelf getBanner];
        
        //获取店铺类型
        [weakSelf getType];

        //店铺数据
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.shops = objs;
            [weakSelf.shopTableView reloadData_tl];

        } failure:^(NSError *error) {
        
            
        }];
        
        
    }];

    
    [self.shopTableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.shops = objs;
            [weakSelf.shopTableView reloadData_tl];

        } failure:^(NSError *error) {
            
      
        }];
        
    }];
    
    
    //--//
    [self.shopTableView endRefreshingWithNoMoreData_tl];
    
    //异步更新用户信息
    if ([ZHUser user].userId) {
        [[ZHUser user] updateUserInfo];
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationSuccess) name:kLocationServiceSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationFailure) name:kLocationServiceFailureNotification object:nil];
    [[TLLocationService service] startService];
    
}


- (void)locationSuccess {

    TLLog(@"首页——定位成功");
    
    if (self.lastLocationSuccessDate && ([[NSDate date] timeIntervalSinceDate:self.lastLocationSuccessDate] <60*1)) {
        
        return;
    }
    self.lastLocationSuccessDate = [NSDate date];

    //获取当前位置
    CLLocation *location = [TLLocationService service].locationManager.location;
    
    //--------------------------------------------//
    if (self.currentCityName) { //已经有
        
        self.pageDataHelper.parameters[@"city"] = self.currentCityName;
        //
        self.lon = [NSString stringWithFormat:@"%.10f",location.coordinate.longitude];
        self.pageDataHelper.parameters[@"longitude"] = self.lon;
        //
        self.lat = [NSString stringWithFormat:@"%.10f",location.coordinate.latitude];
        self.pageDataHelper.parameters[@"latitude"] = self.lat;
        //
        [self.shopTableView beginRefreshing];
        
    } else { //第一次进入没有记录
        
        // 地址的编码通过经纬度得到具体的地址
        CLGeocoder *gecoder = [[CLGeocoder alloc] init];
        [gecoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            
            CLPlacemark *placemark = [placemarks lastObject];
            
            //获得城市
            if (placemark.locality) {
                
                NSString *cityName = [self getCityNameByPlacemark:placemark];
                
                self.cityLbl.text = cityName;
                self.currentCityName = cityName;
                
                //定位成功
                self.pageDataHelper.parameters[@"city"] = self.currentCityName;
                self.lon = [NSString stringWithFormat:@"%.10f",location.coordinate.longitude];
                self.pageDataHelper.parameters[@"longitude"] = self.lon;
                self.lat = [NSString stringWithFormat:@"%.10f",location.coordinate.latitude];
                self.pageDataHelper.parameters[@"latitude"] = self.lat;
                
                [[NSUserDefaults standardUserDefaults] setObject:self.currentCityName forKey:USER_CITY_NAME_KEY];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self.shopTableView beginRefreshing];
                
            }
            
        }];
        
    }
    
    
    //地址的编码通过经纬度得到具体的地址
    CLGeocoder *gecoder = [[CLGeocoder alloc] init];
    [gecoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        CLPlacemark *placemark = [placemarks lastObject];
        
        NSString *newCityName = [self getCityNameByPlacemark:placemark];
        //异步
        if (newCityName && self.currentCityName && ![newCityName isEqualToString:self.currentCityName]) {
            
            [TLAlert alertWithTitle:nil Message:[NSString stringWithFormat:@"您当前的位置是%@\n是否切换",newCityName] confirmMsg:@"确定" CancleMsg:@"取消" cancle:^(UIAlertAction *action) {
                
            } confirm:^(UIAlertAction *action) {
                
                //展示数据改变
                self.currentCityName = newCityName;
                self.cityLbl.text = newCityName;
                
                //请求数据改变
                self.pageDataHelper.parameters[@"city"] = self.currentCityName;
                //
                self.lon = [NSString stringWithFormat:@"%.10f",location.coordinate.longitude];
                self.pageDataHelper.parameters[@"longitude"] = self.lon;
                
                self.lat = [NSString stringWithFormat:@"%.10f",location.coordinate.latitude];
                self.pageDataHelper.parameters[@"latitude"] = self.lat;
                
                [self.shopTableView beginRefreshing];
                
            }];
            
        }
        
    }];

}


#pragma mark- 定位失败
- (void)locationFailure {

    [self.shopTableView beginRefreshing];

}


#pragma mark- 获得店铺类型
- (void)getType {

    TLNetworking *http = [TLNetworking new];
    http.code = @"808007";
    http.parameters[@"status"] = @"1";
    http.parameters[@"type"] = @"2";
    [http postWithSuccess:^(id responseObject) {
        
        //1.获取数据
        NSArray <ZHShopTypeModel *>* models = [ZHShopTypeModel tl_objectArrayWithDictionaryArray:responseObject[@"data"]];
        self.shopTypeChooseView.typeModels = models;

        
    } failure:^(NSError *error) {
        
    }];

}


- (void)getBanner {

    //广告图
    __weak typeof(self) weakSelf = self;
    TLNetworking *http = [TLNetworking new];
    http.code = @"806052";
    http.parameters[@"type"] = @"2";
    [http postWithSuccess:^(id responseObject) {
        
        weakSelf.bannerRoom = [ZHBannerModel tl_objectArrayWithDictionaryArray:responseObject[@"data"]];
        //组装数据
        weakSelf.bannerPics = [NSMutableArray arrayWithCapacity:weakSelf.bannerRoom.count];
        
        //取出图片
        [weakSelf.bannerRoom enumerateObjectsUsingBlock:^(ZHBannerModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [weakSelf.bannerPics addObject:[obj.pic convertImageUrl]];
        }];
        
        weakSelf.bannerView.imgUrls = weakSelf.bannerPics;
        
    } failure:^(NSError *error) {
        
    }];

}


- (void)getSysMsg {

    TLNetworking *sysMsgHttp = [TLNetworking new];
    sysMsgHttp.code = @"804040";
    
    //0 未读 1 已读 2未读被删 3 已读被删
    sysMsgHttp.parameters[@"channelType"] = @"4";;
    //sysMsgHttp.parameters[@"token"] = [ZHUser user].token;
    sysMsgHttp.parameters[@"pushType"] = @"41";
    sysMsgHttp.parameters[@"start"] = @"1";
    sysMsgHttp.parameters[@"limit"] = @"1";
    sysMsgHttp.parameters[@"toKind"] = @"1";
    sysMsgHttp.parameters[@"smsType"] = @"1";
    sysMsgHttp.parameters[@"status"] = @"1";
    sysMsgHttp.parameters[@"fromSystemCode"] = @"CD-CZH000001";
    [sysMsgHttp postWithSuccess:^(id responseObject) {
        
    
        NSArray <ZHMsg *>*msgs = [ZHMsg tl_objectArrayWithDictionaryArray:responseObject[@"data"][@"list"]];
        
        //
        if (msgs.count > 0) {
            
            self.sysMsgView.msg = msgs[0].smsTitle;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if (self.isFirstDiplayMsg) {
                    
                    self.isFirstDiplayMsg = NO;
                    
                    NSString *content = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastDisplayMsgTag"];
                    if (content && [content isEqualToString:msgs[0].smsContent]) {
                        
                        //同一个消息只弹出一次即可
                        return ;
                    }
                    
                    [TLAlert alertWithTitile:self.sysMsgView.msg message:msgs[0].smsContent confirmAction:^{
                        
                       [[NSUserDefaults standardUserDefaults] setObject:msgs[0].smsContent forKey:@"lastDisplayMsgTag"];
                        
                    }];
                    
                }
                
            });
         
        }
        
        
    } failure:^(NSError *error) {
        
        
    }];

    
}


#pragma mark - 搜索
- (void)search {

    ZHSearchVC *searchVC = [[ZHSearchVC alloc] init];
    searchVC.type = ZHSearchVCTypeShop;
    searchVC.lon = self.lon;
    searchVC.lat = self.lat;
    [self.navigationController pushViewController:searchVC animated:YES];
    
}


- (NSString *)getCityNameByPlacemark:(CLPlacemark *)placemark {

    NSString *cityName = nil;
    
    if (placemark.locality) {
        
        cityName = placemark.locality;
        
    } else {
        
        if (placemark.subLocality) {
            
            cityName = placemark.subLocality;
            
        } else {
            
            cityName = placemark.administrativeArea;
            
        }
        
    }

    return cityName;

}


#pragma mark- tableView  --- delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    ZHShopDetailVC *detailVC = [[ZHShopDetailVC alloc] init];
    ZHShop *shop = self.shops[indexPath.row];
    detailVC.shopCode = shop.code;
    //
    [self.navigationController pushViewController:detailVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark- 地铺选择代理
- (void)didChoose:(NSInteger)idx typeModel:(ZHShopTypeModel *)model {

    if (!model) {
        NSLog(@"请选择模型");
        return;
    }
    
    ZHShopListVC *listVC = [[ZHShopListVC alloc] init];
    //    listVC.title = self.types[index];
    listVC.lon = self.lon;
    listVC.lat = self.lat;
    listVC.cityName = self.currentCityName;
    listVC.type = model.code;
    [self.navigationController pushViewController:listVC animated:YES];

}


#pragma mark- 选择城市
- (void)sendCityName:(NSString *)name {

    //获取数据成功，在改变城市名称
    NSString *nameCopy = [name stringByAppendingString:@"市"];
    self.pageDataHelper.parameters[@"city"] = nameCopy;
    self.currentCityName = nameCopy;
    self.cityLbl.text = nameCopy;
    
    //开始刷新
    [self.shopTableView beginRefreshing];
    
}


- (void)changCity {

    HYCityViewController *cityVC = [[HYCityViewController alloc] init];
    cityVC.delegate = self;
    ZHNavigationController *nav = [[ZHNavigationController alloc] initWithRootViewController:cityVC];
    [self presentViewController:nav animated:YES completion:nil];
    
}


- (void)setUpSearchView {

    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    [self.view addSubview:topView];
    topView.backgroundColor = [UIColor whiteColor];
    
    //城市名称
    UILabel *cityNameLbl = [UILabel labelWithFrame:CGRectMake(15, 0, 50, 30)
                                      textAligment:NSTextAlignmentLeft
                                   backgroundColor:[UIColor whiteColor]
                                              font:[UIFont secondFont]
                                         textColor:[UIColor zh_textColor]];
    [topView addSubview:cityNameLbl];
    cityNameLbl.text = @"未知";
    self.cityLbl = cityNameLbl;
    [cityNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView.mas_left).offset(15);
        make.top.equalTo(topView.mas_top).offset(28);
        make.height.mas_equalTo(@30);
    }];
    
    //arrow
    UIImageView *arrowImageV = [[UIImageView alloc] initWithFrame:CGRectMake(cityNameLbl.xx + 9, 0, 10, 30)];
    [topView addSubview:arrowImageV];
    arrowImageV.contentMode = UIViewContentModeScaleAspectFit;
    arrowImageV.image = [UIImage imageNamed:@"arrow_down"];
    [arrowImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(cityNameLbl.mas_right).offset(9);
        make.top.equalTo(cityNameLbl.mas_top);
        make.width.mas_equalTo(@10);
        make.height.equalTo(cityNameLbl.mas_height);
        
    }];
    
    //按钮切换事件
    UIButton *chooseCityBtn = [[UIButton alloc] init];
    [topView addSubview:chooseCityBtn];
    [chooseCityBtn addTarget:self action:@selector(changCity) forControlEvents:UIControlEventTouchUpInside];
    
    [chooseCityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(topView);
        make.right.equalTo(arrowImageV.mas_right);
    }];
    
    //2.搜索
    UIView *searchBgView = [[UIView alloc] initWithFrame:CGRectZero];
    [topView addSubview:searchBgView];
    
    [searchBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cityNameLbl.mas_top);
        make.left.equalTo(arrowImageV.mas_right).offset(12);
        
        make.right.equalTo(topView.mas_right).offset(-15);
        make.height.mas_equalTo(@30);
    }];

    searchBgView.layer.masksToBounds = YES;
    searchBgView.layer.cornerRadius = 3;
    searchBgView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    UITapGestureRecognizer *searchTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(search)];
    searchBgView.userInteractionEnabled = YES;
    [searchBgView addGestureRecognizer:searchTap];
    //搜索按钮
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(15, 0, 15, 15)];
    [searchBgView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(searchBgView.mas_left).offset(15);
        make.height.mas_equalTo(@15);
        make.width.mas_equalTo(@15);
        make.centerY.equalTo(searchBgView);
    }];
    [btn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    
    //搜索文字
    UILabel *searchLbl = [UILabel labelWithFrame:CGRectMake(btn.xx + 2, 0, 80, btn.height)
                                    textAligment:NSTextAlignmentLeft
                                 backgroundColor:[UIColor clearColor]
                                            font:FONT(14)
                                       textColor:[UIColor zh_textColor2]];
    [searchBgView addSubview:searchLbl];
    searchLbl.text = @"搜索";
    searchLbl.centerY = btn.centerY;
    [searchLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btn.mas_left).offset(20);
        make.top.equalTo(btn.mas_top);
        make.height.equalTo(btn.mas_height);
    }];
    
}

#pragma mark- dasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.shops.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *zhShopCellId = @"zhShopCellId";
    ZHShopCell *cell = [tableView dequeueReusableCellWithIdentifier:zhShopCellId];
    if (!cell) {
        
        cell = [[ZHShopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:zhShopCellId];
        
    }
    cell.shop = self.shops[indexPath.row];
    return cell;
}


#pragma mark- 头部view
- (void)setUpTableViewHeader {

    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180 + 194 + 40 + 5)];
    bgView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    self.shopTableView.tableHeaderView = bgView;
    
    //顶部轮播
    TLBannerView *bannerView = [[TLBannerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
    [bgView addSubview:bannerView];
    self.bannerView = bannerView;
    
    //地铺分类
    self.shopTypeChooseView = [CDShopTypeChooseView chooseView];
    [bgView addSubview:self.shopTypeChooseView];
    self.shopTypeChooseView.delegate = self;
    self.shopTypeChooseView.x = 0;
    self.shopTypeChooseView.y = bannerView.yy;
    //底部--公告
    [bgView addSubview:self.announcementsView];
    self.announcementsView.y = self.shopTypeChooseView.yy;
    //调节高度
    bgView.height = self.announcementsView.yy + 5;

}


#pragma mark- 查看公告
- (void)lookGG {

    ZHMsgVC *msgVC = [[ZHMsgVC alloc] init];
    [self.navigationController pushViewController:msgVC animated:YES];

}


//公告view
- (UIView *)announcementsView {

    if (!_announcementsView) {
        _announcementsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        _announcementsView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *notice = [[UIImageView alloc] initWithFrame:CGRectMake(15, 14, 57, 12)];
        notice.image = [UIImage imageNamed:@"notice"];
        [_announcementsView addSubview:notice];
        
        //
        UILabel *lbl = [UILabel labelWithFrame:CGRectMake(notice.xx + 20, 11, 35, 18) textAligment:NSTextAlignmentCenter backgroundColor:[UIColor colorWithHexString:@"#fff8ce"] font:FONT(12) textColor:[UIColor colorWithHexString:@"#222222"] ];
        lbl.text = @"公告";
        lbl.layer.cornerRadius = 2;
        lbl.layer.masksToBounds = YES;
        [_announcementsView addSubview:lbl];
        
        //
        self.sysMsgView = [[TLMarqueeView alloc] initWithFrame:CGRectMake(lbl.xx + 5, 0, SCREEN_WIDTH - lbl.xx  - 10 , 20)];
         [_announcementsView addSubview:self.sysMsgView];
        
         self.sysMsgView.centerY = _announcementsView.height/2.0;
         self.sysMsgView.msg = @"系统公告";
        self.sysMsgView.font = [UIFont thirdFont];
        self.sysMsgView.backgroundColor = [UIColor whiteColor];
        self.sysMsgView.textColor = [UIColor colorWithHexString:@"#222222"];
        [self.sysMsgView begin];
         self.sysMsgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookGG)];
        [self.sysMsgView addGestureRecognizer:tap];
        
    }

    return _announcementsView;
    
}


- (UIView *)funcViewWithFrame:(CGRect) frame imageName:(NSString *)imgName funcName:(NSString *)funcName {

    UIView *bgView = [[UIView alloc] initWithFrame:frame];
    bgView.backgroundColor = [UIColor whiteColor];
    
    UIButton *funcBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 14, 45, 45)];
    [bgView addSubview:funcBtn];
    funcBtn.centerX = bgView.width/2.0;
    [funcBtn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    
    CGFloat h = [[UIFont thirdFont] lineHeight];
    UILabel *nameLbl = [UILabel labelWithFrame:CGRectMake(0, funcBtn.yy + 7, bgView.width, h) textAligment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor] font:[UIFont thirdFont] textColor:[UIColor zh_textColor]];
    nameLbl.centerX = funcBtn.centerX;
    nameLbl.text = funcName;
    [bgView addSubview:nameLbl];
    
    return bgView;

}

@end
