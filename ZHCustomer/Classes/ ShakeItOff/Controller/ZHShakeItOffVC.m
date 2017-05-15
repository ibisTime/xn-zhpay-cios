//
//  ZHShakeItOffVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/23.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHShakeItOffVC.h"
#import "UMMobClick/MobClick.h"
#import "ZHHZBModel.h"
#import "ZHHZBListVC.h"
#import "FCUUID.h"
#import "ZHRealNameAuthVC.h"
#import "ZHUserLoginVC.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>
#import "TLHTMLStrVC.h"


@interface ZHShakeItOffVC ()<CLLocationManagerDelegate>

@property (nonatomic,strong) ZHHZBListVC *hzbListVC;
//
@property (nonatomic,strong) NSMutableArray *hzbRoom;
@property (nonatomic,assign) BOOL isDoneOnce;

@property (nonatomic,strong) UIButton *noAwardBtn;

@property (nonatomic,copy) NSString *lon; //
@property (nonatomic,copy) NSString *lat; //

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) CLLocationManager *sysLocationManager;

@property (nonatomic, assign) SystemSoundID resultSoundId;
@property (nonatomic, assign) SystemSoundID beginSoundId;

@property (nonatomic, assign) BOOL firstUpLoaded;

@property (nonatomic, copy) NSString *yyAfterImageName;
@property (nonatomic, copy) NSString *yyBeforeImageName;


@end

@implementation ZHShakeItOffVC

- (void)viewDidAppear:(BOOL)animated
{
    [self.view becomeFirstResponder];
    
 


}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.view resignFirstResponder];
}

#pragma mark - 监听运动事件
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (UIEventSubtypeMotionShake ==motion) {
        
        [self action];
    }
}

- (void)introduce {

    TLHTMLStrVC *vc = [[TLHTMLStrVC alloc] init];
    vc.type = ZHHTMLTypeSendBrebireMoneyIntroduce;
    vc.title = @"玩法介绍";
    [self.navigationController pushViewController:vc animated:YES];

}


- (void)sendLocation {

    if ([ZHUser user].isLogin) {
        
        TLNetworking *http = [TLNetworking new];
        http.isShowMsg = NO;
        http.code = @"805158";
        http.parameters[@"longitude"] = self.lon;
        http.parameters[@"latitude"] = self.lat;
        http.parameters[@"token"] = [ZHUser user].token;
        http.parameters[@"userId"] = [ZHUser user].userId;
        [http postWithSuccess:^(id responseObject) {
            
        } failure:^(NSError *error) {
            
        }];
        
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"摇一摇";
    self.view.backgroundColor = [UIColor whiteColor];
    self.isDoneOnce = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"玩法介绍" style:UIBarButtonItemStylePlain target:self action:@selector(introduce)];
    
    //必须在先
    self.yyBeforeImageName = @"摇";
    self.yyAfterImageName = @"摇";
    
    //必须在后
    [self setUpUI];
    
    //注意顺序
    self.bgImageView.contentMode = UIViewContentModeCenter;

    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"zh_pay_magic"];
    if ([str valid] && [str isEqualToString:@"上线"]) {
        
        self.yyBeforeImageName = @"摇一摇before";
        self.yyAfterImageName = @"摇一摇after";
        
        self.bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.bgImageView.image = [UIImage imageNamed:self.yyBeforeImageName];
        
    } else {
        
        //
        [TLNetworking GET:@"http://itunes.apple.com/lookup?id=1167284604" parameters:nil success:^(NSString *msg, id data) {
            
            NSString *str = data[@"results"][0][@"version"];
            //本地版本号 大于线上版本号，说明在审核,当版本号相等的时候 说明已经正式上线. 进行图片更换
            if ([str isEqualToString:[NSString appCurrentBundleVersion]]) {
                
                [[NSUserDefaults standardUserDefaults] setObject:@"上线" forKey:@"zh_pay_magic"];
                self.yyBeforeImageName = @"摇一摇before";
                self.yyAfterImageName = @"摇一摇after";
                
                self.bgImageView.contentMode = UIViewContentModeScaleAspectFill;
                self.bgImageView.image = [UIImage imageNamed:self.yyBeforeImageName];
            }
            
        } abnormality:nil failure:nil];
    
    }
    
    
    //异步更新用户信息
    if ([ZHUser user].userId) {
        [[ZHUser user] updateUserInfo];
    }
    
    [self.sysLocationManager startUpdatingLocation];
    
    [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(sendLocation) userInfo:nil repeats:YES];
    
    //更新应用
    [self updateApp];
    
}


//
- (void)updateApp {

    
    [TLNetworking GET:@"http://itunes.apple.com/lookup?id=1167284604" parameters:nil success:^(NSString *msg, id data) {
        
        NSString *str = data[@"results"][0][@"version"];
        //版本号不同就要更新
        if (![str isEqualToString:[NSString appCurrentBundleVersion]]) {
            
            UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"有新版本了,前往更新" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            
            //
            UIAlertAction *updateAction = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/%E6%AD%A3%E6%B1%87%E9%92%B1%E5%8C%85/id1167284604?mt=8"]];
                
            }];
            
            //
            UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertCtrl addAction:cancleAction];
            [alertCtrl addAction:updateAction];
            
            //
            [self presentViewController:alertCtrl animated:YES completion:nil];

        }
        
    } abnormality:nil failure:nil];
    
    
}


- (SystemSoundID)beginSoundId {

    if (!_beginSoundId) {
        
        _beginSoundId  = 10; //相当于自己注册的ID，如果有1个以上，可以命名为2、3、4等。
        NSString *path = [[NSBundle mainBundle] pathForResource:@"yaoyiyao.wav" ofType:nil];
        if (path) {
            //注册声音到系统
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&_beginSoundId);
        }
        
    }
    
    return _beginSoundId;
    
}


- (SystemSoundID)resultSoundId {

    if (!_resultSoundId) {
        
        _resultSoundId  = 100; //相当于自己注册的ID，如果有1个以上，可以命名为2、3、4等。
        NSString *path = [[NSBundle mainBundle] pathForResource:@"yaoyiyaoResult.wav" ofType:nil];
        if (path) {
            //注册声音到系统
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&_resultSoundId);
        }
        
    }
    
    return _resultSoundId;

}

- (CLLocationManager *)sysLocationManager {
    
    if (!_sysLocationManager) {
        
        _sysLocationManager = [[CLLocationManager alloc] init];
        _sysLocationManager.delegate = self;
        _sysLocationManager.distanceFilter = 20.0;
        _sysLocationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        
    }
    
    return _sysLocationManager;
}

- (void)remove:(UIButton *)btn {

    [btn removeFromSuperview];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {

    if ([ZHUser user].isLogin) {
        
//        [TLAlert alertWithHUDText:@"无法获得您当前位置"];
        
    }

}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {

    CLLocation *location = [locations lastObject];
    
    self.lon = [NSString stringWithFormat:@"%.10f",location.coordinate.longitude];
    self.lat = [NSString stringWithFormat:@"%.10f",location.coordinate.latitude];
    
    //首次上传 以后交给定时器上传
    if (!self.firstUpLoaded) {
        [self sendLocation];
        self.firstUpLoaded = YES;
    }
    //
    //上传用户位置--登录状态--并且已经购买摇钱树
//  self.sendLocationTimer.fireDate = [NSDate distantPast];
    
    
//    if ([ZHUser user].isLogin) {
//        
//        TLNetworking *http = [TLNetworking new];
//        http.isShowMsg = NO;
//        http.code = @"805158";
//        http.parameters[@"longitude"] = [NSString stringWithFormat:@"%.10f",location.coordinate.longitude];;
//        http.parameters[@"latitude"] = [NSString stringWithFormat:@"%.10f",location.coordinate.latitude];;
//        http.parameters[@"token"] = [ZHUser user].token;
//        http.parameters[@"userId"] = [ZHUser user].userId;
//        [http postWithSuccess:^(id responseObject) {
//            
//        } failure:^(NSError *error) {
//            
//        }];
//        
//    }
}


#pragma mark- 摇动事件处理
- (void)action {
    
    if (![ZHUser user].isLogin) {
       
        ZHUserLoginVC *loginVC = [[ZHUserLoginVC alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        loginVC.loginSuccess = ^(){
        };
        [self presentViewController:nav animated:YES completion:nil];
        
        return;
    }

    
    if (!self.isDoneOnce) {
        return;
    }
    
    //1.判断设备是否越狱
    if ([MobClick isPirated] || [MobClick isJailbroken] || [[NSFileManager defaultManager] fileExistsAtPath:@"/User/Applications/"]) {
        
        [TLAlert alertWithHUDText:@"检测到您当前设备属于非法设备，您不能参加该活动"];
        return;
    }
    
    
    //3.判断该应用定位服务是否可用
    CLAuthorizationStatus authStatus = [CLLocationManager authorizationStatus];
    if (authStatus == kCLAuthorizationStatusDenied) { //定位权限不可用可用
     
        [TLAlert alertWithTitle:nil Message:@"您的定位服务不可用,无法参加该活动,请在设置中打开" confirmMsg:@"设置" CancleMsg:@"取消" cancle:^(UIAlertAction *action) {
            
        } confirm:^(UIAlertAction *action) {
            
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
            
        }];
        
        return;
        
    }
    
    //4.经纬度
    if (!(self.lon && self.lat)) {
        
        [TLAlert alertWithMsg:@"暂时无法获得您的位置信息"];
        return;
    }
    
    //获取周边汇赚宝
    //获取经纬度
    self.isDoneOnce = NO;
    
    //播放开始声音
    AudioServicesPlaySystemSoundWithCompletion(self.beginSoundId, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self getBaoBei];
        });
        
    });
    
}

- (void)getBaoBei {
    
    //获取汇赚宝位置
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"615117";
    http.parameters[@"token"] = [ZHUser user].token;
    http.parameters[@"longitude"] = self.lon;
    http.parameters[@"latitude"] = self.lat;
    http.parameters[@"userId"] = [ZHUser user].userId;
    http.parameters[@"deviceNo"] = [NSString stringWithFormat:@"%@",[FCUUID uuidForDevice]];
    
    [http postWithSuccess:^(id responseObject) {
        
        self.isDoneOnce = YES;
        
        if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]] && responseObject[@"data"][@"errorCode"]) {
            
            [[UIApplication sharedApplication].keyWindow addSubview:self.noAwardBtn];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.noAwardBtn removeFromSuperview];
                
            });
            return ;
        }
        
        
       
        NSArray *array = responseObject[@"data"];
        
        if (array.count > 0) {
            
            //播放结果声音
            AudioServicesPlaySystemSound(self.resultSoundId);
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            self.bgImageView.image = [UIImage imageNamed:self.yyAfterImageName];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                 self.hzbRoom = [ZHHZBModel tl_objectArrayWithDictionaryArray:array];
                
                 ZHHZBListVC *hzbListVC = [[ZHHZBListVC alloc] init];
                 hzbListVC.hzbRoom = self.hzbRoom;
                [self.navigationController pushViewController:hzbListVC animated:YES];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    self.bgImageView.image = [UIImage imageNamed:self.yyBeforeImageName];

                });

            });
            
//            //进行动画
//            [UIView animateWithDuration:0.4 animations:^{
//                
//                [self.oneImageView removeFromSuperview];
//                self.topImageView.transform = CGAffineTransformMakeTranslation(0, -100);
//                self.bottomImageView.transform = CGAffineTransformMakeTranslation(0, +100);
//                
//            } completion:^(BOOL finished) {
//                
//                [UIView animateWithDuration:0.4  animations:^{
//                    
//                    self.topImageView.transform = CGAffineTransformMakeTranslation(0, 0);
//                    self.bottomImageView.transform = CGAffineTransformMakeTranslation(0, 0);
//                    
//                } completion:^(BOOL finished) {
//                    
//                    [self.view addSubview:self.oneImageView];
//                    
//                    self.hzbRoom = [ZHHZBModel tl_objectArrayWithDictionaryArray:array];
//                    
//                    ZHHZBListVC *hzbListVC = [[ZHHZBListVC alloc] init];
//                    hzbListVC.hzbRoom = self.hzbRoom;
//                    [self.navigationController pushViewController:hzbListVC animated:YES];
//                }];
//                
//        
//                
//            }];
            
        } else {
            
            [TLAlert alertWithHUDText:@"您的周边没有汇赚宝"];
            
        }
        
        
    } failure:^(NSError *error) {
        
        self.isDoneOnce = YES;
        
    }];

}



- (void)setUpUI {
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49 - 64)];
    [self.view addSubview:imageV];
    imageV.contentMode = UIViewContentModeScaleAspectFill;
    imageV.image = [UIImage imageNamed:self.yyBeforeImageName];
    
    self.bgImageView = imageV;
    imageV.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(action)];
    [imageV addGestureRecognizer:tap];
    
}







//- (CAEmitterLayer *)currencyLayer {
//    
//    if (!_currencyLayer) {
//        
//        
//        //创建一个CAEmitterLayer
//        CAEmitterLayer *snowEmitter = [CAEmitterLayer layer];
//        //降落区域的方位
//        //    snowEmitter.frame = self.view.bounds;
//        snowEmitter.frame = CGRectMake(0, 0, 100, 100);
//        //    snowEmitter.backgroundColor = [UIColor orangeColor].CGColor;
//        //添加到父视图Layer上
//        //        [self.view.layer addSublayer:snowEmitter];
//        
//        //指定发射源的位置
//        snowEmitter.emitterPosition = CGPointMake(SCREEN_WIDTH/2.0,0);
//        //指定发射源的大小
//        snowEmitter.emitterSize  = CGSizeMake(self.view.bounds.size.width, 0.0);
//        
//        
//        //指定发射源的形状和模式
//        snowEmitter.emitterShape = kCAEmitterLayerLine;
//        snowEmitter.emitterMode  = kCAEmitterLayerOutline;
//        
//        
//        CAEmitterCell *qbbCell = [self cellWithImgName:@"钱包币"];
//        CAEmitterCell *rmbCell = [self cellWithImgName:@"人民币"];
//        CAEmitterCell *gwbCell = [self cellWithImgName:@"购物币"];
//        CAEmitterCell *hpCell = [self cellWithImgName:@"好评"];
//        
//        snowEmitter.emitterCells = @[qbbCell,rmbCell,gwbCell,hpCell];
//        
//        _currencyLayer = snowEmitter;
//        
//    }
//    return _currencyLayer;
//    
//}


//没有，提示动画
- (UIButton *)noAwardBtn {
    
    if (!_noAwardBtn) {
        
        _noAwardBtn = [[UIButton alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _noAwardBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        [_noAwardBtn addTarget:self action:@selector(remove:) forControlEvents:UIControlEventTouchUpInside];
        //
        CGFloat w = 200;
        CGFloat h = w*90/121.0;
        CGFloat topM = SCREEN_HEIGHT/2.0 - h;
        UIImageView *iconV = [[UIImageView alloc] initWithFrame:CGRectMake(0, topM, w,h)];
        iconV.image = [UIImage imageNamed:@"心"];
        iconV.centerX = SCREEN_WIDTH/2.0;
        [_noAwardBtn addSubview:iconV];
        
        UILabel *lbl1 = [UILabel labelWithFrame:CGRectMake(0, iconV.yy + 30, SCREEN_WIDTH, [FONT(18) lineHeight]) textAligment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor] font:FONT(18) textColor:[UIColor whiteColor]];
        [_noAwardBtn addSubview:lbl1];
        lbl1.numberOfLines = 0;
        
        [lbl1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(iconV.mas_bottom).offset(30);
            make.left.equalTo(_noAwardBtn.mas_left);
            make.right.equalTo(_noAwardBtn.mas_right);
            
        }];
        lbl1.text = @"^ - ^ 很遗憾，您今天摇一摇次数\n超限,请明天再来哦";
    }
    
    return _noAwardBtn;
    
}

- (ZHHZBListVC *)hzbListVC {
    
    if (!_hzbListVC) {
        _hzbListVC = [[ZHHZBListVC alloc] init];
        _hzbListVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH - 0, SCREEN_HEIGHT - 64 - 49 - 0);
    }
    
    return _hzbListVC;
    
}


- (CAEmitterCell *)cellWithImgName:(NSString *)imgName {
    
    //创建CAEmitterCell
    CAEmitterCell *snowflake = [CAEmitterCell emitterCell];
    //每秒多少个
    snowflake.birthRate = 1.5;
    //存活时间
    snowflake.lifetime = 30.0;
    //初速度，因为动画属于落体效果，所以我们只需要设置它在y方向上的加速度就行了。
    snowflake.velocity = 20;
    //初速度范围
    snowflake.velocityRange = 5;
    //y轴方向的加速度
    snowflake.yAcceleration = 30;
    //以锥形分布开的发射角度。角度用弧度制。粒子均匀分布在这个锥形范围内。
    snowflake.emissionRange = 5;
    //设置降落的图片
    snowflake.contents  = (id) [[UIImage imageNamed:imgName] CGImage];
    //图片缩放比例
    snowflake.scale = 0.7;
    //开始动画
    
    return snowflake;
    
    
}

@end
