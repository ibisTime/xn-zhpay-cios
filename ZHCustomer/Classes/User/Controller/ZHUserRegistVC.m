//
//  ZHUserRegistVC.m
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/12.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHUserRegistVC.h"
#import "ZHCaptchaView.h"
#import "ChatManager.h"
//#import <AMapLocationKit/AMapLocationKit.h>
#import "AddressPickerView.h"
#import "SGScanningQRCodeVC.h"
#import <Photos/Photos.h>
#import <CoreLocation/CoreLocation.h>
#import "ZHUserProtocalVC.h"

@interface ZHUserRegistVC ()<CLLocationManagerDelegate>

@property (nonatomic,strong) ZHAccountTf *phoneTf;
@property (nonatomic,strong) ZHCaptchaView *captchaView;
@property (nonatomic,strong) ZHAccountTf *referrer;
@property (nonatomic,strong) ZHAccountTf *pwdTf;
@property (nonatomic,strong) ZHAccountTf *addressTf;

@property (nonatomic,strong) CLLocationManager *sysLocationManager;

@property (nonatomic,strong) AddressPickerView *addressPicker;

//
@property (nonatomic,copy) NSString *province;
@property (nonatomic,copy) NSString *city;
@property (nonatomic,copy) NSString *area;
@property (nonatomic,assign) BOOL isBuild;


@end

@implementation ZHUserRegistVC

- (CLLocationManager *)sysLocationManager {

    if (!_sysLocationManager) {
      
        _sysLocationManager = [[CLLocationManager alloc] init];
        _sysLocationManager.delegate = self;
        _sysLocationManager.distanceFilter = 50.0;
        
    }
    return _sysLocationManager;

}

#pragma mark - 系统定位
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    
    [self setUpUI];
    [MBProgressHUD hideHUDForView:self.view animated:YES];

}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {

    //该代理方法 会调用多次， 通过isBuild 变量只创建一次ui
//    <+30.29055724,+119.99690671>
//    <+30.29057788,+119.99699431>
//    <+30.29052650,+119.99688861>
    //反地理编码
//  [self.sysLocationManager stopUpdatingLocation];
    [manager stopUpdatingLocation];
   
    CLGeocoder *gecoder = [[CLGeocoder alloc] init];
    CLLocation *location = manager.location;
    
    [gecoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        CLPlacemark *placemark = [placemarks lastObject];
        
        //获得城市
//        if (placemark.locality) {
        if (error) {
            

        } else {
            
            self.province = placemark.administrativeArea ;
            self.city = placemark.locality ? : placemark.administrativeArea; //市
            self.area = placemark.subLocality; //区

            
        }
        
        [self setUpUI];
        
    }];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"注册";
    self.isBuild = NO;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //连续定位，时间较短，可能首次经度低
    [self.sysLocationManager startUpdatingLocation];
//    [self.sysLocationManager requestLocation];

    
    
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
    
    //单次定位 精度较高,定位时间较长
//    [self.sysLocationManager requestLocation];
    
}

//--//
- (void)sendCaptcha {

    if (![self.phoneTf.text isPhoneNum]) {
        
        [TLAlert alertWithHUDText:@"请输入正确的手机号"];
        
        return;
    }
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = CAPTCHA_CODE;
    http.parameters[@"bizType"] = USER_REG_CODE;
    http.parameters[@"mobile"] = self.phoneTf.text;
    
    [http postWithSuccess:^(id responseObject) {
        
        [self.captchaView.captchaBtn begin];
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

- (void)goReg {

    if (![self.phoneTf.text isPhoneNum]) {
        
        [TLAlert alertWithHUDText:@"请输入正确的手机号"];
        
        return;
    }
    
    if (!(self.captchaView.captchaTf.text && self.captchaView.captchaTf.text.length > 3)) {
        [TLAlert alertWithHUDText:@"请输入正确的验证码"];

        return;
    }
    
    if (!(self.captchaView.captchaTf.text && self.captchaView.captchaTf.text.length > 3)) {
        [TLAlert alertWithHUDText:@"请输入正确的验证码"];
        
        return;
    }
    
    if (![self.referrer.text isPhoneNum]) {
        [TLAlert alertWithHUDText:@"请输入推荐人手机号"];
        
        return;
    }
    
    if (!(self.pwdTf.text &&self.pwdTf.text.length > 5)) {
        
        [TLAlert alertWithHUDText:@"请输入6位以上密码"];
        return;
    }
    
    if (!(self.province && self.city && self.area)) {
        
        [TLAlert alertWithHUDText:@"请选择省市区"];
        return;
    }
    
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = USER_REG_CODE;
    http.parameters[@"mobile"] = self.phoneTf.text;
    http.parameters[@"loginPwd"] = self.pwdTf.text;
    http.parameters[@"userReferee"] = self.referrer.text;
    http.parameters[@"loginPwdStrength"] = @"2";
    http.parameters[@"isRegHx"] = @"1";
    http.parameters[@"smsCaptcha"] = self.captchaView.captchaTf.text;
    
    http.parameters[@"province"] = self.province;
    http.parameters[@"city"] = self.city;
    http.parameters[@"area"] = self.area;
    
    [http postWithSuccess:^(id responseObject) {
       
        [TLAlert alertWithHUDText:@"注册成功"];
        NSString *tokenId = responseObject[@"data"][@"token"];
        NSString *userId = responseObject[@"data"][@"userId"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            //获取用户信息
            TLNetworking *http = [TLNetworking new];
            http.showView = self.view;
            http.code = USER_INFO;
            http.parameters[@"userId"] = userId;
            http.parameters[@"token"] = tokenId;
            [http postWithSuccess:^(id responseObject) {
                
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                if ([[ChatManager defaultManager] loginWithUserName:userId]) {
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    NSDictionary *userInfo = responseObject[@"data"];
                    [ZHUser user].userId = userId;
                    [ZHUser user].token = tokenId;
                    [[ZHUser user] saveUserInfo:userInfo];
                    [[ZHUser user] setUserInfoWithDict:userInfo];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginNotification object:nil];
                    
                } else {
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [TLAlert alertWithHUDText:@"登录失败"];
                    
                }
                
            } failure:^(NSError *error) {
                
            }];
            
        });
  
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (AddressPickerView *)addressPicker {
    
    if (!_addressPicker) {
        
        _addressPicker = [[AddressPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        
        __weak typeof(self) weakSelf = self;
        _addressPicker.confirm = ^(NSString *province,NSString *city,NSString *area){
            
            
            weakSelf.province = province;
            weakSelf.city = city;
            weakSelf.area = area;
            
            weakSelf.addressTf.text = [NSString stringWithFormat:@"%@ %@ %@",weakSelf.province,weakSelf.city,weakSelf.area];
            
        };
        
    }
    return _addressPicker;
    
}

- (void)scan {

    NSString * mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus  authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (authorizationStatus == AVAuthorizationStatusRestricted|| authorizationStatus == AVAuthorizationStatusDenied) {
        
        [TLAlert alertWithTitle:nil Message:@"没有权限访问您的相机,请在设置中打开" confirmMsg:@"设置" CancleMsg:@"取消" cancle:^(UIAlertAction *action) {
            
            
        } confirm:^(UIAlertAction *action) {
            
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
            
        }];
        
        return;
        
    }
    
    SGScanningQRCodeVC *scanningQRCodeVC = [[SGScanningQRCodeVC alloc] init];
    scanningQRCodeVC.scannSuccess = ^(NSString *result){
        
        self.referrer.text = result;
        
    };
    [self.navigationController pushViewController:scanningQRCodeVC animated:YES];
    
    

}

#pragma mark- 定位不成功是选择地址
- (void)chooseAddress {
    [self.view endEditing:YES];
    [[UIApplication sharedApplication].keyWindow addSubview:self.addressPicker];
    
}

- (void)setUpUI {

    if (!self.isBuild) {
        
        self.isBuild = YES;
        
    } else {
    
        return;
    }

    
    CGFloat margin = ACCOUNT_MARGIN;
    CGFloat w = SCREEN_WIDTH - 2*margin;
    CGFloat h = ACCOUNT_HEIGHT;
    CGFloat middleMargin = ACCOUNT_MIDDLE_MARGIN;
    
    //账号
    ZHAccountTf *phoneTf = [[ZHAccountTf alloc] initWithFrame:CGRectMake(margin, 30, w, h)];
    phoneTf.zh_placeholder = @"请输入手机号";
    phoneTf.leftIconView.image = [UIImage imageNamed:@"手机号"];
    [self.bgSV addSubview:phoneTf];
    self.phoneTf = phoneTf;
    phoneTf.keyboardType = UIKeyboardTypeNumberPad;
    
    //验证码
    ZHCaptchaView *captchaView = [[ZHCaptchaView alloc] initWithFrame:CGRectMake(margin, phoneTf.yy + middleMargin, w, h)];
    [self.bgSV addSubview:captchaView];
    captchaView.captchaTf.leftIconView.image = [UIImage imageNamed:@"验证码"];
    captchaView.captchaTf.zh_placeholder = @"请输入验证码";
    [captchaView.captchaBtn addTarget:self action:@selector(sendCaptcha) forControlEvents:UIControlEventTouchUpInside];
    self.captchaView = captchaView;
    
    //推荐人
    ZHAccountTf *referrer = [[ZHAccountTf alloc] initWithFrame:CGRectMake(margin, captchaView.yy + middleMargin, w, h)];
    referrer.zh_placeholder = @"请输入推荐人手机号";
    referrer.keyboardType = UIKeyboardTypeNumberPad;
    referrer.leftIconView.image = [UIImage imageNamed:@"手机号"];
    [self.bgSV addSubview:referrer];
    self.referrer = referrer;
    
    UIButton *scanBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 35)];
    referrer.rightView = scanBtn;
    [scanBtn setImage:[UIImage imageNamed:@"扫一扫"] forState:UIControlStateNormal];
    [scanBtn addTarget:self action:@selector(scan) forControlEvents:UIControlEventTouchUpInside];
    
    referrer.rightViewMode = UITextFieldViewModeAlways;
    
    //密码
    ZHAccountTf *pwdTf = [[ZHAccountTf alloc] initWithFrame:CGRectMake(margin, referrer.yy + middleMargin, w, h)];
    pwdTf.secureTextEntry = YES;
    pwdTf.zh_placeholder = @"请输入密码";
    pwdTf.leftIconView.image = [UIImage imageNamed:@"密码"];
    [self.bgSV addSubview:pwdTf];
    self.pwdTf = pwdTf;
    
    //选择地区
    
    self.addressTf = [[ZHAccountTf alloc] initWithFrame:CGRectMake(margin, pwdTf.yy + middleMargin, w, h)];
    self.addressTf.zh_placeholder = @"请选择地区";
    self.addressTf.leftIconView.image = [UIImage imageNamed:@"reg_location"];
    [self.bgSV addSubview:self.addressTf];
//  self.addressTf.userInteractionEnabled = NO;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:self.addressTf.bounds];
    [self.addressTf addSubview:btn];
    [btn addTarget:self action:@selector(chooseAddress) forControlEvents:UIControlEventTouchUpInside];
    
    //定位成功 隐藏地址选择
    if (self.province && self.city && self.area) {
        
        self.addressTf.height = 0.1;
        
    } else {
    

    }
    
    //登陆
    UIButton *regBtn = [UIButton zhBtnWithFrame:CGRectMake(margin,self.addressTf.yy + 25, w, h) title:@"注册"];
    [regBtn addTarget:self action:@selector(goReg) forControlEvents:UIControlEventTouchUpInside];
    [self.bgSV addSubview:regBtn];
    
    //协议按钮
    UIButton *protocalBtn = [[UIButton alloc] initWithFrame:CGRectMake(margin,regBtn.yy + 10, w, 25) title:@"注册即代表同意《正汇钱包用户协议》" backgroundColor:[UIColor clearColor]];
    protocalBtn.titleLabel.font = FONT(12);
    [protocalBtn addTarget:self action:@selector(readProtocal) forControlEvents:UIControlEventTouchUpInside];
    [self.bgSV addSubview:protocalBtn];
    protocalBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [protocalBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        

}

- (void)readProtocal {

    ZHUserProtocalVC *protocalVC = [[ZHUserProtocalVC alloc] init];
    [self.navigationController pushViewController:protocalVC animated:YES];

}



@end
