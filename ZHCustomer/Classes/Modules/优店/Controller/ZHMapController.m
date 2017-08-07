//
//  ZHMapController.m
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/14.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHMapController.h"

#import <MapKit/MapKit.h>

@interface ZHMapController ()<MKMapViewDelegate>

@property (nonatomic,strong) UIImageView *locationImageView;

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic,assign) BOOL isFirst; //规划定位user成功后 置为NO

@property (nonatomic,assign) BOOL isFailure;


@end

@implementation ZHMapController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isFirst = YES;
    self.isFailure = NO;
    
    MKMapView *mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    mapView.delegate = self;
    [self.view addSubview:mapView];
    self.mapView = mapView;
    
    self.title = @"店铺位置";
    //显示用户位置
 
    
    //
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"前往店铺" style:UIBarButtonItemStylePlain target:self action:@selector(navShop)];

    //设置地图显示区域
    CLLocationCoordinate2D location = self.point;

    
    //
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, 1500, 1500);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:region];
    [self.mapView setRegion:adjustedRegion animated:YES];
    
    
    MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc] init];
    pointAnnotation.coordinate = self.point;
    pointAnnotation.title = self.shopName;
    [self.mapView addAnnotation:pointAnnotation];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.mapView selectAnnotation:pointAnnotation animated:YES];

    });
    
    
}






- (void)navShop {

    //跳转高德地图进行导航
    CLLocationCoordinate2D toLoc = self.point;
    
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:toLoc addressDictionary:nil]];
    [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                   launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                                   MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
    
//    [self initNav];

}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {

    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MKPinAnnotationView*annotationView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        
        
        if (annotationView == nil)
        {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier] ;
            

        }
        
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;//设置标注可以拖动，默认为NO
        annotationView.pinColor = MKPinAnnotationColorRed;
        
        return annotationView;
    }
    return nil;

}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {

    
//    if (updatingLocation && !_isFirst)
//    {
//        _isFirst = YES;
//        CLLocationCoordinate2D location = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
//        MACoordinateRegion region = MACoordinateRegionMakeWithDistance(location,1500 ,1500);
//        MACoordinateRegion adjustedRegion = [mapView regionThatFits:region];
//        [mapView setRegion:adjustedRegion animated:NO];
//    }

}


//定位失败调用该接口
- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error {

   //NSLog(@"定位失败");
   [TLAlert alertWithHUDText:@"定位失败"];
    
}

//单击地图
- (void)mapView:(MKMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate {

    NSLog(@"%f--%f",coordinate.longitude,coordinate.latitude);
    
    if (mapView.userLocation.location) {
        
        NSLog(@"定位成功");
        
    }

}




@end
