//
//  ViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/1/28.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "APIKey.h"

@interface ViewController ()<MAMapViewDelegate>

@property (nonatomic,strong) MAMapView *mapView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"公司地址";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = self.leftItem;
    [MAMapServices sharedServices].apiKey = (NSString *)APIKey;
    [self.view addSubview:self.mapView];
}

-(MAMapView *)mapView
{
    if (!_mapView) {
        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
//        _mapView.delegate = self;
        _mapView.showsUserLocation = YES;
        [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
//        _mapView.userLocation.coordinate.latitude = 31.234133;
//        _mapView.userLocation.coordinate.longitude = 121.514196;
        
        /*
        经度： 121.472644   \\\  121.514196
        纬度：31.231706      \\\ 31.234133
         */
        
    }
    return _mapView;
}

#pragma mark - mapView delegate
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if (updatingLocation) {
        NSLog(@"latitude is %f,longitude is %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    }
}

- (void)mapViewWillStartLocatingUser:(MAMapView *)mapView
{
    NSLog(@"开始定位");
}

- (void)mapViewDidFinishLoadingMap:(MAMapView *)mapView
{
    NSLog(@"加载成功");
}

- (void)mapViewDidFailLoadingMap:(MAMapView *)mapView withError:(NSError *)error
{
    NSLog(@"加载失败");
    NSLog(@"失败原因：%@",error);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
