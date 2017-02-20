//
//  ZHShakeItOffVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/23.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHShakeItOffVC.h"
//#import <AMapLocationKit/AMapLocationKit.h>
#import "UMMobClick/MobClick.h"
#import "ZHHZBModel.h"
#import "ZHHZBListVC.h"
#import "FCUUID.h"
#import "ZHRealNameAuthVC.h"
#import "ZHUserLoginVC.h"
#import "ZHLocationManager.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>


@interface ZHShakeItOffVC ()<CLLocationManagerDelegate>

//@property (nonatomic,strong) AMapLocationManager *locationManager;

@property (nonatomic,strong) ZHHZBListVC *hzbListVC;
//
@property (nonatomic,strong) NSMutableArray *hzbRoom;
@property (nonatomic,assign) BOOL isDoneOnce;

@property (nonatomic,strong) UIButton *noAwardBtn;

@property (nonatomic,copy) NSString *lon; //
@property (nonatomic,copy) NSString *lat; //

//
@property (nonatomic,strong) UIImageView *topImageView;
@property (nonatomic,strong) UIImageView *oneImageView;
@property (nonatomic,strong) UIImageView *bottomImageView;

@property (nonatomic, strong) CAEmitterLayer *currencyLayer;

//
//@property (nonatomic, strong) AVAudioPlayer *musicPlayer ;
@property (nonatomic, strong) CLLocationManager *sysLocationManager;

@property (nonatomic, assign) SystemSoundID resultSoundId;
@property (nonatomic, assign) SystemSoundID beginSoundId;


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


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"摇一摇";
    self.view.backgroundColor = [UIColor whiteColor];
    self.isDoneOnce = YES;
    

    [self setUpUI];
    
    //摸调iphone才会变的标志
    //异步更新用户信息
    if ([ZHUser user].userId) {
        [[ZHUser user] updateUserInfo];
    }
    
    [self.sysLocationManager startUpdatingLocation];
    
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
        _sysLocationManager.distanceFilter = 50.0;
        _sysLocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        
    }
    
    return _sysLocationManager;
}

- (void)remove:(UIButton *)btn {

    [btn removeFromSuperview];
    
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {

    if ([ZHUser user].isLogin) {
        
        [TLAlert alertWithHUDText:@"无法获得您当前位置"];
        
    }

}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {

    CLLocation *location = [locations lastObject];
    
    self.lon = [NSString stringWithFormat:@"%.10f",location.coordinate.longitude];
    self.lat = [NSString stringWithFormat:@"%.10f",location.coordinate.latitude];
    
    //上传用户位置--登录状态--并且已经购买摇钱树
    if ([ZHUser user].isLogin) {
        
        TLNetworking *http = [TLNetworking new];
        http.isShowMsg = NO;
        http.code = @"808456";
        http.parameters[@"userId"] = [ZHUser user].userId;
        http.parameters[@"token"] = [ZHUser user].token;
        [http postWithSuccess:^(id responseObject) {
            
            NSDictionary *data = responseObject[@"data"];
            if (data.allKeys.count > 0) {
                
                TLNetworking *http = [TLNetworking new];
                http.isShowMsg = NO;
                http.code = @"805158";
                http.parameters[@"longitude"] = [NSString stringWithFormat:@"%.10f",location.coordinate.longitude];;
                http.parameters[@"latitude"] = [NSString stringWithFormat:@"%.10f",location.coordinate.latitude];;
                http.parameters[@"token"] = [ZHUser user].token;
                http.parameters[@"userId"] = [ZHUser user].userId;
                [http postWithSuccess:^(id responseObject) {
                    
                } failure:^(NSError *error) {
                    
                }];
                
            }
            
        } failure:^(NSError *error) {
            
        }];
        
    }

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
     
        [TLAlert alertWithTitle:nil Message:@"您的定位服务不可用,无法参加该活动" confirmMsg:@"设置" CancleMsg:@"取消" cancle:^(UIAlertAction *action) {
            
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
    http.code = @"808457";
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
            
            //进行动画
            [UIView animateWithDuration:0.4 animations:^{
                
                [self.oneImageView removeFromSuperview];
                self.topImageView.transform = CGAffineTransformMakeTranslation(0, -100);
                self.bottomImageView.transform = CGAffineTransformMakeTranslation(0, +100);
                
            } completion:^(BOOL finished) {
                
                [UIView animateWithDuration:0.4  animations:^{
                    
                    self.topImageView.transform = CGAffineTransformMakeTranslation(0, 0);
                    self.bottomImageView.transform = CGAffineTransformMakeTranslation(0, 0);
                    
                } completion:^(BOOL finished) {
                    
                    [self.view addSubview:self.oneImageView];
                    
                    self.hzbRoom = [ZHHZBModel tl_objectArrayWithDictionaryArray:array];
                    
                    ZHHZBListVC *hzbListVC = [[ZHHZBListVC alloc] init];
                    hzbListVC.hzbRoom = self.hzbRoom;
                    [self.navigationController pushViewController:hzbListVC animated:YES];
                }];
                
            }];
            
        } else {
            
            [TLAlert alertWithHUDText:@"您的周边没有汇赚宝"];
            
        }
        
        
    } failure:^(NSError *error) {
        
        self.isDoneOnce = YES;
        //        [self.currencyLayer removeFromSuperlayer];
        
//        [self.musicPlayer stop];
        
    }];




}



- (void)setUpUI {
    
    UIImageView *iconImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
    iconImageV.image = [UIImage imageNamed:@"zh_icon"];
    iconImageV.centerX = self.oneImageView.centerX;
    iconImageV.centerY = self.oneImageView.centerY - 10;
    [self.view addSubview:iconImageV];
    
    UILabel *lbl = [UILabel labelWithFrame:CGRectMake(0, iconImageV.yy + 10, SCREEN_WIDTH, [FONT(15) lineHeight])
                              textAligment:NSTextAlignmentCenter
                           backgroundColor:[UIColor clearColor]
                                      font:FONT(15)
                                 textColor:[UIColor zh_textColor]];
    lbl.text = @"正汇钱包";
    [self.view addSubview:lbl];
    //
    [self.view addSubview:self.topImageView];
    [self.view addSubview:self.bottomImageView];
    [self.view addSubview:self.oneImageView];
    
    //UIImageView *iconImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, topMargin - 20, 220, 220)];
    //iconImageV.image = [UIImage imageNamed:@"摇"];
    //[self.view addSubview:iconImageV];
    //iconImageV.centerX = SCREEN_WIDTH/2.0;
    
    
    //点击
   // UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, iconImageV.yy + 25, 159, 43)];
    //[self.view addSubview:btn];
   // btn.centerX = iconImageV.centerX;
   // [btn setImage:[UIImage imageNamed:@"点击"] forState:UIControlStateNormal];
    //[btn addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    
}

- (UIImageView *)oneImageView {

    CGFloat topMargin =  (SCREEN_HEIGHT - 288 - 64- 49)/2.0;

    if (!_oneImageView) {
        
     _oneImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, topMargin, 220, 220)];
        _oneImageView.centerX = SCREEN_WIDTH/2.0;
        _oneImageView.image = [UIImage imageNamed:@"摇"];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(action)];
        _oneImageView.userInteractionEnabled = YES;
        [_oneImageView addGestureRecognizer:tap];
        
    }
    
    return _oneImageView;

}


- (UIImageView *)topImageView {
    
    CGFloat topMargin =  (SCREEN_HEIGHT - 288 - 64- 49)/2.0;
    
    if (!_topImageView) {
        
        _topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, topMargin, 220, 110)];
        _topImageView.centerX = self.oneImageView.centerX;
        _topImageView.image = [UIImage imageNamed:@"shake_top"];

    }
    
    return _topImageView;
    
}

- (UIImageView *)bottomImageView {
    
    if (!_bottomImageView) {
        
        _bottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.topImageView.yy, 220, 110)];
        _bottomImageView.centerX = self.oneImageView.centerX;
        _bottomImageView.image = [UIImage imageNamed:@"shake_bottom"];

    }
    
    return _bottomImageView;
    
}


- (CAEmitterLayer *)currencyLayer {
    
    if (!_currencyLayer) {
        
        
        //创建一个CAEmitterLayer
        CAEmitterLayer *snowEmitter = [CAEmitterLayer layer];
        //降落区域的方位
        //    snowEmitter.frame = self.view.bounds;
        snowEmitter.frame = CGRectMake(0, 0, 100, 100);
        //    snowEmitter.backgroundColor = [UIColor orangeColor].CGColor;
        //添加到父视图Layer上
        //        [self.view.layer addSublayer:snowEmitter];
        
        //指定发射源的位置
        snowEmitter.emitterPosition = CGPointMake(SCREEN_WIDTH/2.0,0);
        //指定发射源的大小
        snowEmitter.emitterSize  = CGSizeMake(self.view.bounds.size.width, 0.0);
        
        
        //指定发射源的形状和模式
        snowEmitter.emitterShape = kCAEmitterLayerLine;
        snowEmitter.emitterMode  = kCAEmitterLayerOutline;
        
        
        CAEmitterCell *qbbCell = [self cellWithImgName:@"钱包币"];
        CAEmitterCell *rmbCell = [self cellWithImgName:@"人民币"];
        CAEmitterCell *gwbCell = [self cellWithImgName:@"购物币"];
        CAEmitterCell *hpCell = [self cellWithImgName:@"好评"];
        
        snowEmitter.emitterCells = @[qbbCell,rmbCell,gwbCell,hpCell];
        
        _currencyLayer = snowEmitter;
        
    }
    return _currencyLayer;
    
}


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
