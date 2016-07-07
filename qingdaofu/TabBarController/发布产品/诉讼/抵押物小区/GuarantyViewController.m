//
//  GuarantyViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/6/21.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "GuarantyViewController.h"

#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

#import "GuarantyResponse.h"
#import "GuarantyModel.h"

@interface GuarantyViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UISearchBarDelegate,AMapSearchDelegate>

@property (nonatomic,assign) BOOL didSetupConstarints;
@property (nonatomic,strong) UITableView *guTableView;
@property (nonatomic,strong) UISearchBar *guSearchBar;
@property (nonatomic,strong) AMapSearchAPI *fSearchAPI;

@property (nonatomic,strong) NSMutableArray *guDataArray;
@property (nonatomic,strong) NSString *titleString;  // 选中的小区地址

@end

@implementation GuarantyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"抵押物地址";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    self.navigationItem.titleView = self.guSearchBar;
    
    [self.view addSubview:self.guTableView];
    [self.view setNeedsUpdateConstraints];
    
    [AMapServices sharedServices].apiKey = @"947453c33b48d4d7447a58d202f038bb";
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstarints) {
        
        [self.guTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstarints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)guTableView
{
    if (!_guTableView) {
        _guTableView = [UITableView newAutoLayoutView];
        _guTableView.delegate = self;
        _guTableView.dataSource = self;
        _guTableView.tableFooterView = [[UIView alloc] init];
        _guTableView.backgroundColor = kBackColor;
    }
    return _guTableView;
}

- (UISearchBar *)guSearchBar
{
    if (!_guSearchBar) {
        _guSearchBar = [[UISearchBar alloc] init];
        _guSearchBar.searchBarStyle = UISearchBarStyleMinimal;
        _guSearchBar.delegate = self;
        _guSearchBar.placeholder = @"请输入小区/写字楼/商铺等";
        [_guSearchBar setTintColor:kLightGrayColor];
        _guSearchBar.showsCancelButton = YES;
    }
    return _guSearchBar;
}

- (NSMutableArray *)guDataArray
{
    if (!_guDataArray) {
        _guDataArray = [NSMutableArray array];
    }
    return _guDataArray;
}

#pragma mark - tabelView deleagte and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.guDataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"gu";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.backgroundColor = kBackColor;
    
    GuarantyModel *model = self.guDataArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",model.name];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
    NSString *title = cell.textLabel.text;
    _titleString = title;
    
    self.fSearchAPI = [[AMapSearchAPI alloc] init];
    self.fSearchAPI.delegate = self;
    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
    geo.address = title;
    [self.fSearchAPI AMapGeocodeSearch:geo];
}

#pragma mark - method
- (void)getGuarantyListWithString:(NSString *)predicate
{
    NSString *guarantyString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kGuarantyString];
    NSDictionary *params = @{@"name" : predicate};
    [self requestDataPostWithString:guarantyString params:params successBlock:^(id responseObject) {
        
        [self.guDataArray removeAllObjects];
        
        GuarantyResponse *response = [GuarantyResponse objectWithKeyValues:responseObject];
        
        for (GuarantyModel *model in response.result) {
            [self.guDataArray addObject:model];
        }
        
        // 刷新列表
        [self.guTableView reloadData];
        
    } andFailBlock:^(NSError *error) {
        [self showHint:@"加载失败"];
    }];
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = nil;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText) {
        // 调用小区的方法
        [self getGuarantyListWithString:searchBar.text];
    }
}

#pragma mark - AMapSearchDelegate
//实现正向地理编码的回调函数
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{
    if(response.geocodes.count == 0)
    {
        if (self.didSelectedArea) {
            self.didSelectedArea(_titleString,@"");
        }
        [self back];
        return;
    }
    
    CGFloat latitude = 0.0;
    CGFloat longitude = 0.0;
    
    for (AMapTip *p in response.geocodes) {
        latitude = p.location.latitude;
        longitude = p.location.longitude;
    }
    
    //构造AMapReGeocodeSearchRequest对象
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location = [AMapGeoPoint locationWithLatitude:latitude     longitude:longitude];
    regeo.radius = 10000;
    regeo.requireExtension = YES;
    
    [self.fSearchAPI AMapReGoecodeSearch:regeo];
}

//实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil)
    {
        //1.
        AMapReGeocode *regeocode = response.regeocode;
        ///////2.////
        //格式化地址
         AMapAddressComponent *addressComponent = regeocode.addressComponent;
        AMapStreetNumber *streetNumber = addressComponent.streetNumber;
        
        NSString *address = [NSString stringWithFormat:@"%@%@%@%@%@%@",addressComponent.province,addressComponent.city,addressComponent.district,addressComponent.township,streetNumber.street,streetNumber.number];
        
        if (self.didSelectedArea) {
            self.didSelectedArea(_titleString,address);
        }
        [self back];
        return;
        
    }else{
        if (self.didSelectedArea) {
            self.didSelectedArea(_titleString,@"");
        }
        [self back];
    }
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    if (self.didSelectedArea) {
        self.didSelectedArea(_titleString,@"");
    }
    [self back];
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
