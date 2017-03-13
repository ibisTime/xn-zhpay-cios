//
//  ZHMapController.m
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/14.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHMapController.h"

//#import <MAMapKit/MAMapKit.h>
//#import <AMapNaviKit/AMapNaviKit.h>
//#import <AMapLocationKit/AMapLocationKit.h>

@interface ZHMapController ()
//<MAMapViewDelegate,AMapNaviDriveManagerDelegate,AMapLocationManagerDelegate>
//
//@property (nonatomic,strong) UIImageView *locationImageView;
//@property (nonatomic,strong) MAMapView *mapV;
//
//@property (nonatomic,assign) BOOL isFirst; //规划定位user成功后 置为NO
//
//@property (nonatomic,assign) BOOL isFailure;
////
//@property (nonatomic,strong) AMapNaviDriveManager *driveManager;
//@property (nonatomic,strong) AMapLocationManager *locationManager;
//
//@property (nonatomic,strong) MAPolyline *polyLine;

@end

@implementation ZHMapController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.isFirst = YES;
//    self.isFailure = NO;
//    MAMapView *mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
//    
//    self.title = @"店铺位置";
//    //显示用户位置
//    mapView.delegate = self;
//    [self.view addSubview:mapView];
//    self.mapV = mapView;
//    
//    //
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"前往店铺" style:UIBarButtonItemStylePlain target:self action:@selector(confirmAction)];
//
//    //设置地图显示区域
//    CLLocationCoordinate2D location = self.point;
//    MACoordinateRegion region = MACoordinateRegionMakeWithDistance(location,1500 ,1500);
//    MACoordinateRegion adjustedRegion = [mapView regionThatFits:region];
//    [mapView setRegion:adjustedRegion animated:NO];
//    
//    //添加店铺标记点,会调用代理方法
//    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
//    pointAnnotation.coordinate = self.point;
//    pointAnnotation.title = self.shopName;
//    [_mapV addAnnotation:pointAnnotation];
//    
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        [self.mapV selectAnnotation:pointAnnotation animated:YES];
//
//    });
    
    
}


////
//- (void)initNav {
//
//    //获取用户当前位置
////    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [ self.locationManager startUpdatingLocation];
//    
//    return;
//    
//    
//     [self.locationManager requestLocationWithReGeocode:NO completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
//         
//         [MBProgressHUD hideHUDForView:self.view animated:YES];
//
//         if (!error) {
//    
//             //
//             AMapNaviPoint *startPoint = [AMapNaviPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
//             //
//             AMapNaviPoint *endPoint = [AMapNaviPoint locationWithLatitude:self.point.latitude longitude:self.point.longitude];
//             
//             //计算路线
//             BOOL isSuccess = [self.driveManager calculateDriveRouteWithStartPoints:@[startPoint] endPoints:@[endPoint] wayPoints:nil drivingStrategy:AMapNaviDrivingStrategySingleDefault];
//             if (isSuccess) {
//                 
//                 
//             } else {
//                 
//                 [TLAlert alertWithHUDText:@"路线规划失败"];
//             }
//             
//             return ;
//         }
//         
//         [TLAlert alertWithHUDText:@"无法获取您的当前位置"];
//
//     }];
//
//    
//}
//
//#pragma mark - locationManagerDelegate
//- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
//{
//    [TLAlert alertWithHUDText:@"无法获取您的当前位置"];
//    //定位错误
//}
//
//- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
//{
//    
//    if (self.isFirst) {
//        
//        self.isFirst = NO;
//    
//    //
//    AMapNaviPoint *startPoint = [AMapNaviPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
//    //
//    AMapNaviPoint *endPoint = [AMapNaviPoint locationWithLatitude:self.point.latitude longitude:self.point.longitude];
//    
//    //计算路线
//    BOOL isSuccess = [self.driveManager calculateDriveRouteWithStartPoints:@[startPoint]
//                                                                 endPoints:@[endPoint]
//                                                                 wayPoints:nil
//                                                           drivingStrategy:AMapNaviDrivingStrategySingleDefault];
//        
//    if (isSuccess) {
//        
//        
//    } else {
//        
//        [TLAlert alertWithHUDText:@"路线规划失败"];
//        
//    }
//        
//    }
//}
//
//#pragma mark - 路线规划 -delegate
//- (void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager {
//
//    AMapNaviRoute *naviRoute = driveManager.naviRoute;
//    
//    //进行路线绘制
//    NSArray <AMapNaviPoint *>*points = naviRoute.routeCoordinates;
//    
//    CLLocationCoordinate2D lineCoords[points.count];
//    
//    for (NSInteger i = 0; i < points.count; i ++) {
//        lineCoords[i].longitude = points[i].longitude;
//        lineCoords[i].latitude = points[i].latitude;
//        
//    }
//
//    if (self.polyLine) {
//        [self.mapV removeOverlay:self.polyLine];
//    }
//    
//    MAPolyline *line = [MAPolyline polylineWithCoordinates:lineCoords count:points.count];
//    self.polyLine = line;
//    self.mapV.showsUserLocation = YES;
//    [self.mapV addOverlay:line];
//    [self.mapV showOverlays:@[line] animated:YES];
//
//}
//
//
//- (void)confirmAction {
//
//    [self initNav];
//
//}
//
//#pragma mark - mapViewDelegate
//- (void)mapViewWillStartLocatingUser:(MAMapView *)mapView {
//
//
//    NSLog(@"开始定位");
//
//
//}
//
//- (void)mapViewDidStopLocatingUser:(MAMapView *)mapView {
//
//    NSLog(@"停止定位");
//
//}
//
//- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {
//
//    
//
//}
//
//- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
//{
//    if ([overlay isKindOfClass:[MAPolyline class]])
//    {
//        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:(MAPolyline *)overlay];
//        
//        polylineRenderer.lineWidth    = 5.f;
//        polylineRenderer.strokeColor  = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.6];
//        polylineRenderer.lineJoinType = kMALineJoinRound;
//        polylineRenderer.lineCapType  = kMALineCapRound;
//        
//        return polylineRenderer;
//    }
//    
//    return nil;
//}
//
//- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
//{
//    if ([annotation isKindOfClass:[MAPointAnnotation class]])
//    {
//        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
//        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
//        if (annotationView == nil)
//        {
//            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
//        }
//        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
//        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
//        annotationView.draggable = YES;//设置标注可以拖动，默认为NO
//        annotationView.pinColor = MAPinAnnotationColorPurple;
//
//        return annotationView;
//    }
//    return nil;
//}
//
//- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
//
//    
////    if (updatingLocation && !_isFirst)
////    {
////        _isFirst = YES;
////        CLLocationCoordinate2D location = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
////        MACoordinateRegion region = MACoordinateRegionMakeWithDistance(location,1500 ,1500);
////        MACoordinateRegion adjustedRegion = [mapView regionThatFits:region];
////        [mapView setRegion:adjustedRegion animated:NO];
////    }
//
//}
//
////定位失败调用该接口
//- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error {
//
//    NSLog(@"定位失败");
//   [TLAlert alertWithHUDText:@"定位失败"];
//    
//}
//
//
////单击地图
//- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate {
//
//    NSLog(@"%f--%f",coordinate.longitude,coordinate.latitude);
//    
//    if (mapView.userLocation.location) {
//        
//        NSLog(@"定位成功");
//        
//    }
//
//}
//
//- (AMapNaviDriveManager *)driveManager {
//    
//    if (!_driveManager) {
//        _driveManager = [[AMapNaviDriveManager alloc] init];
//        _driveManager.delegate = self;
//    }
//    return _driveManager;
//}
//
//- (AMapLocationManager *)locationManager {
//    
//    if (!_locationManager) {
//        
//        _locationManager = [[AMapLocationManager alloc] init];
//        _locationManager.delegate = self;
//        _locationManager.distanceFilter = 5;
//        
//    }
//    return _locationManager;
//}


@end
