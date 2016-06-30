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
        
        //经度121.515037
        //纬度:31.232292
        _map.centerCoordinate = CLLocationCoordinate2DMake(31.232292, 121.515037);
        _map.zoomLevel = 17;
    }
    return _map;
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
