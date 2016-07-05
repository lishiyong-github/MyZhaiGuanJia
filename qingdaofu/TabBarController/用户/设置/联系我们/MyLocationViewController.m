//
//  MyLocationViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/6/30.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MyLocationViewController.h"

#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>

@interface MyLocationViewController ()<MAMapViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraits;
@property (nonatomic,strong) MAMapView *map;
@property (nonatomic,strong) MAPointAnnotation *myAnnotion;

@end

@implementation MyLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"地图";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [AMapServices sharedServices].apiKey = @"947453c33b48d4d7447a58d202f038bb";
    [self.view addSubview:self.map];
}

- (MAMapView *)map
{
    if (!_map) {
        _map = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _map.delegate = self;
        _map.mapType = MAMapTypeStandard;
        
        //经度121.515037
        //纬度:31.232292
        _map.centerCoordinate = CLLocationCoordinate2DMake(31.232292, 121.515037);
        _map.zoomLevel = 17;
        
        //自定义自身位置
        [_map addAnnotation:self.myAnnotion];
    }
    return _map;
}

- (MAPointAnnotation *)myAnnotion
{
    if (!_myAnnotion) {
        _myAnnotion = [[MAPointAnnotation alloc] init];
        _myAnnotion.coordinate = CLLocationCoordinate2DMake(31.232292, 121.515037);
        _myAnnotion.title = @"清道夫债管家";
        _myAnnotion.subtitle = @"直向资产管理有限公司";
    }
    return _myAnnotion;
}

#pragma mark - MAMapViewDelegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *animatedAnnotationIdentifier = @"AnimatedAnnotationIdentifier";
        
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:animatedAnnotationIdentifier];
        
        if (!annotationView)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:animatedAnnotationIdentifier];
        }
        
        annotationView.image = [UIImage imageNamed:@"logo"];
        annotationView.canShowCallout = YES;
        
        return annotationView;
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
