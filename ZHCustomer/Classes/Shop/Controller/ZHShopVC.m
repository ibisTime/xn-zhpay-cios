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
#import <MapKit/MapKit.h>
#import "ZHShopTypeDisplayView.h"
#import <CoreLocation/CoreLocation.h>
#import "ZHShopTypeModel.h"
#import "UIButton+WebCache.h"
#import "HYCityViewController.h"
#import "ZHNavigationController.h"
#import "TLWebVC.h"
#import "ZHShareView.h"

#define USER_CITY_NAME_KEY @"USER_CITY_NAME_KEY"

@interface ZHShopVC ()<UITableViewDelegate, UITableViewDataSource,CLLocationManagerDelegate,HYCityViewDelegate>

@property (nonatomic,strong) TLTableView *shopTableView;

@property (nonatomic,strong) TLPageDataHelper *pageDataHelper;
//公告view
@property (nonatomic,strong) NSMutableArray *shops;

@property (nonatomic,strong) UILabel *cityLbl;
@property (nonatomic,strong) UILabel *announceContentLbl;
@property (nonatomic,strong) TLBannerView *bannerView;
@property (nonatomic,strong) UIView *announcementsView;

@property (nonatomic,assign) BOOL isLocationSuccess;
@property (nonatomic,assign) BOOL isFirst;

@property (nonatomic,strong) CLLocationManager *sysLocationManager;
@property (nonatomic, strong) UIScrollView *shopTypeScrollView;
//
@property (nonatomic,copy) NSString *lon;
@property (nonatomic,copy) NSString *lat;

//
@property (nonatomic,copy) NSString *currentCityName;
@property (nonatomic,copy) NSString *willDisplayCityName;

//
@property (nonatomic,strong) MBProgressHUD *hud;

@property (nonatomic,strong) NSMutableArray <ZHBannerModel *>*bannerRoom;
@property (nonatomic,strong) NSMutableArray <ZHShopTypeView *>*shopTypeRooms;

@property (nonatomic,strong) NSMutableArray *bannerPics; //图片

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
    
    if (self.isFirst) {
        
        [self.sysLocationManager  startUpdatingLocation];
        self.isFirst = NO;

    }
    
}

//存储数据
- (void)setCurrentCityName:(NSString *)currentCityName {

    _currentCityName = [currentCityName copy];
    [[NSUserDefaults standardUserDefaults] setObject:self.currentCityName forKey:USER_CITY_NAME_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



- (void)viewDidLoad {
    [super viewDidLoad];

    self.isLocationSuccess = NO;

    
    
    //顶部视图
    [self setUpSearchView];
    self.isFirst = YES;
    
    
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
    [self getSysMsg];
    
#pragma mark- 店铺列表
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    helper.code = @"808217";
    helper.parameters[@"status"] = kShopOpenStatus;
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
    
//    [self.sysLocationManager startUpdatingLocation];
    
    [self getType];
    
}

#pragma mark- 获得店铺类型
- (void)getType {

    if (self.shopTypeRooms.count > 8) {
        //两页显示，左右滑动
         self.shopTypeScrollView.contentSize = CGSizeMake(2*SCREEN_WIDTH, self.shopTypeScrollView.height);
        
    } else {
        //一页显示，
    
     self.shopTypeScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.shopTypeScrollView.height);
    }
   
    //
    if (self.shopTypeRooms.count > 0) {
        
        [self.shopTypeRooms makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.shopTypeRooms removeAllObjects];
    }
    

    TLNetworking *http = [TLNetworking new];
//  http.showView = self.view;
    http.code = @"808007";
    http.parameters[@"status"] = @"1";
    http.parameters[@"type"] = @"2";
     
    [http postWithSuccess:^(id responseObject) {
        
        NSArray <ZHShopTypeModel *>* models = [ZHShopTypeModel tl_objectArrayWithDictionaryArray:responseObject[@"data"]];
        
        
        //
//        NSArray *imgNames = @[@"美食",@"KTV",@"美发",@"便利店",@"足浴",@"酒店",@"亲子",@"蔬果"];
        CGFloat margin = 0.5;
        
        //
        CGFloat w = (SCREEN_WIDTH - 3*margin)/4.0;
        CGFloat h = 97;
        
        __weak typeof(self) weakSelf = self;
        for (NSInteger i = 0; i < models.count; i ++) {
            
            CGFloat x = (w + margin)*(i%4) + SCREEN_WIDTH *(i/8);
            
            CGFloat y = 0;
            if (i > 7) {
                
                y = (97 + margin)*((i - 7)/4) + 0.5;

            } else {
            
                y = (97 + margin)*(i/4) + 0.5;

            }
            ZHShopTypeView *shopTypeView = [[ZHShopTypeView alloc] initWithFrame:CGRectMake(x, y, w, h)
                                            
                                                                       funcImage:nil
                                                                        funcName:models[i].name];
            [self.shopTypeScrollView  addSubview:shopTypeView];
            
            [self.shopTypeRooms addObject:shopTypeView];
            [shopTypeView.funcBtn sd_setImageWithURL:[NSURL URLWithString:[models[i].pic convertImageUrl]] forState:UIControlStateNormal];
            shopTypeView.index = i;
            shopTypeView.selected = ^(NSInteger index) {
                
                [weakSelf selectedShopType:models[index].code];
                
            };
            
        }
        
    } failure:^(NSError *error) {
        
    }];

    
    
//        //
//        NSArray *imgNames = @[@"美食",@"KTV",@"美发",@"便利店",@"足浴",@"酒店",@"亲子",@"蔬果"];
//        CGFloat margin = 0.5;
//    
//    
//        //
//        CGFloat w = (SCREEN_WIDTH - 3*margin)/4.0;
//        CGFloat h = 97;
//    
//        __weak typeof(self) weakSelf = self;
//        for (NSInteger i = 0; i < imgNames.count; i ++) {
//    
//            CGFloat x = (w + margin)*(i%4);
//            CGFloat y = (97 + margin)*(i/4);
//            ZHShopTypeView *shopTypeView = [[ZHShopTypeView alloc] initWithFrame:CGRectMake(x, y, w, h) funcImage:imgNames[i] funcName:imgNames[i]];
//            [self.shopTypeScrollView  addSubview:shopTypeView];
//            [self.shopTypeRooms addObject:shopTypeView];
//            shopTypeView.index = i;
//            shopTypeView.selected = ^(NSInteger index) {
//    
//                [weakSelf selectedShopType:index];
//            
//            };
//            
//        }

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
    
    //    0 未读 1 已读 2未读被删 3 已读被删
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
        
        NSArray *msgs = responseObject[@"data"][@"list"];
        if (msgs.count > 0) {
            
            self.announceContentLbl.text = msgs[0][@"smsTitle"];
            
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

//- (NSArray *)types {
//    
//    if (!_types) {
//        _types = @[@"美食",@"KTV",@"美发",@"便利店",@"足浴",@"酒店",@"亲子",@"蔬果"];
//    }
//    return _types;
//    
//}

- (CLLocationManager *)sysLocationManager {

    if (!_sysLocationManager) {
        
        _sysLocationManager = [[CLLocationManager alloc] init];
        _sysLocationManager.delegate = self;
        _sysLocationManager.distanceFilter = 300.0;
//        [_sysLocationManager requestLocation]; //只定为一次
        
    }
    
    return _sysLocationManager;
}

#pragma mark - 系统定位
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {

    [self.shopTableView beginRefreshing];

}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    //获取当前位置
    CLLocation *location = manager.location;
    
//--------------------------------------------//
    if (self.currentCityName) { //已经有
        
#warning -打开
        self.pageDataHelper.parameters[@"city"] = self.currentCityName;
        //
        self.lon = [NSString stringWithFormat:@"%.10f",location.coordinate.longitude];
        self.pageDataHelper.parameters[@"longitude"] = self.lon;
        
        self.lat = [NSString stringWithFormat:@"%.10f",location.coordinate.latitude];
        self.pageDataHelper.parameters[@"latitude"] = self.lat;
        
        //
        if (!self.isLocationSuccess) {
            
            [self.shopTableView beginRefreshing];
            self.isLocationSuccess = YES;
            
        }
        
        
    } else { //第一次进入没有记录
        
        //        if (!self.hud) {
        //            self.hud  = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

        // 地址的编码通过经纬度得到具体的地址
        CLGeocoder *gecoder = [[CLGeocoder alloc] init];
        [gecoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            
            CLPlacemark *placemark = [placemarks lastObject];
            
            //获得城市
            if (placemark.locality) {
                //            [self.hud hideAnimated:YES];
                //            self.hud = nil;
                
                self.cityLbl.text = placemark.locality ? : placemark.administrativeArea;
                self.currentCityName = placemark.locality ? : placemark.administrativeArea;
                
                //        [manager stopUpdatingLocation];
                //定位成功
//                self.locationManager.distanceFilter = 10;
                self.pageDataHelper.parameters[@"city"] = self.currentCityName;
                self.lon = [NSString stringWithFormat:@"%.10f",location.coordinate.longitude];
                self.pageDataHelper.parameters[@"longitude"] = self.lon;
                
                self.lat = [NSString stringWithFormat:@"%.10f",location.coordinate.latitude];
                self.pageDataHelper.parameters[@"latitude"] = self.lat;
                
                [[NSUserDefaults standardUserDefaults] setObject:self.currentCityName forKey:USER_CITY_NAME_KEY];
                [[NSUserDefaults standardUserDefaults] synchronize];
                if (!self.isLocationSuccess) {
                    
                    [self.shopTableView beginRefreshing];
                    self.isLocationSuccess = YES;
                    
                }
                
            }

        }];
        
    }
    
    //地址的编码通过经纬度得到具体的地址
    CLGeocoder *gecoder = [[CLGeocoder alloc] init];
    [gecoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        CLPlacemark *placemark = [placemarks lastObject];
        
        NSString *newCityName = placemark.locality ? : placemark.administrativeArea;
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
                
//                if (!self.isLocationSuccess) {
//
                //                self.isLocationSuccess = YES;
//
//                    
//                }
                [self.shopTableView beginRefreshing];
                
            }];
            
        }
        
    }];

}


#pragma mark- tableView  --- delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    ZHShopDetailVC *detailVC = [[ZHShopDetailVC alloc] init];
    detailVC.shop = self.shops[indexPath.row];
    //
    [self.navigationController pushViewController:detailVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)selectedShopType:(NSString *)code {

    ZHShopListVC *listVC = [[ZHShopListVC alloc] init];
//    listVC.title = self.types[index];
    listVC.lon = self.lon;
    listVC.lat = self.lat;
    listVC.cityName = self.currentCityName;
    listVC.type = code;
    [self.navigationController pushViewController:listVC animated:YES];

}

#pragma mark- 选择城市
- (void)sendCityName:(NSString *)name {

    //获取数据成功，在改变城市名称
    NSString *nameCopy = [name stringByAppendingString:@"市"];
    self.pageDataHelper.parameters[@"city"] = nameCopy;
    self.willDisplayCityName = nameCopy;
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

    
//    return 0;
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

- (NSMutableArray<ZHShopTypeView *> *)shopTypeRooms {

    if (!_shopTypeRooms) {
        
        _shopTypeRooms = [[NSMutableArray alloc] init];
    }
    
    return _shopTypeRooms;

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
    
    
    
    //中部分类
    CGFloat h = 2*(SCREEN_WIDTH - 1.5)/4.0 + 1;
    
    CGFloat margin = 0.5;
    //
    UIScrollView *shopTypeScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, bannerView.yy, SCREEN_WIDTH, h)];
    shopTypeScrollView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    [bgView addSubview:shopTypeScrollView];
    shopTypeScrollView.pagingEnabled = YES;
    shopTypeScrollView.showsHorizontalScrollIndicator = NO;
    self.shopTypeScrollView = shopTypeScrollView;
    
    //可能出现pageControll
    
    //底部--公告
    [bgView addSubview:self.announcementsView];
    self.announcementsView.y = shopTypeScrollView.yy + margin;
    
    //
    bgView.height = self.announcementsView.yy + 5;
    
//    ZHShopTypeDisplayView *typeDisplayView = [[ZHShopTypeDisplayView alloc] init];
//    [bgView addSubview:typeDisplayView];
//    typeDisplayView.y = bannerView.yy;
//    
//    //底部--公告
//    [bgView addSubview:self.announcementsView];
//    self.announcementsView.y = typeDisplayView.yy + margin;

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
        UILabel *announceContentLbl = [UILabel labelWithFrame:CGRectMake(lbl.xx + 5, 0, SCREEN_WIDTH - lbl.xx  - 10 , 20)
                                        
                                                  textAligment:NSTextAlignmentLeft
                                               backgroundColor:[UIColor whiteColor]
                                                          font:[UIFont thirdFont]
                                                     textColor:[UIColor colorWithHexString:@"#222222"]];
        [_announcementsView addSubview:announceContentLbl];
        announceContentLbl.text = @"系统公告";
        self.announceContentLbl = announceContentLbl;
        announceContentLbl.userInteractionEnabled = YES;
        announceContentLbl.centerY = _announcementsView.height/2.0;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookGG)];
        [announceContentLbl addGestureRecognizer:tap];
                                       
        
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
