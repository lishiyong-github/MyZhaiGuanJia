//
//  HouseViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/11/29.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "HouseViewController.h"

#import "CourtProvinceResponse.h"
#import "CourtProvinceModel.h"

@interface HouseViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,assign) BOOL didSetupConstarints;
@property (nonatomic,strong) UITableView *tableView1;
@property (nonatomic,strong) UITableView *tableView2;
@property (nonatomic,strong) UITableView *tableView3;

//@property (nonatomic,strong) NSMutableDictionary *brandDic;
//@property (nonatomic,strong) NSMutableDictionary *audiDic;
//@property (nonatomic,strong) NSArray *licenseplateArray;
@property (nonatomic,strong) NSMutableArray *provinceArray;
@property (nonatomic,strong) NSMutableArray *cityArray;
@property (nonatomic,strong) NSMutableArray *districtArray;
@property (nonatomic,strong) NSMutableDictionary *paramDic;

@property (nonatomic,strong) NSString *string1;
@property (nonatomic,strong) NSString *string11;
@property (nonatomic,strong) NSString *string2;
@property (nonatomic,strong) NSString *string22;
@property (nonatomic,strong) NSString *string3;
@property (nonatomic,strong) NSString *string33;

@end

@implementation HouseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择品牌";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.tableView1];
    
    [self.view setNeedsUpdateConstraints];
    
    [self getProvinceList];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstarints) {
        
        [self.tableView1 autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeRight];
        [self.tableView1 autoSetDimension:ALDimensionWidth toSize:kScreenWidth/3];
        
        self.didSetupConstarints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)tableView1
{
    if (!_tableView1) {
        _tableView1 = [UITableView newAutoLayoutView];
        _tableView1.delegate = self;
        _tableView1.dataSource = self;
        _tableView1.tableFooterView = [[UIView alloc] init];
        _tableView1.backgroundColor = kBackColor;
        _tableView1.separatorColor = kSeparateColor;
    }
    return _tableView1;
}

- (UITableView *)tableView2
{
    if (!_tableView2) {
        _tableView2 = [UITableView newAutoLayoutView];
        _tableView2.delegate = self;
        _tableView2.dataSource = self;
        _tableView2.tableFooterView = [[UIView alloc] init];
        _tableView2.backgroundColor = kBackColor;
        _tableView2.separatorColor = kSeparateColor;
    }
    return _tableView2;
}

- (UITableView *)tableView3
{
    if (!_tableView3) {
        _tableView3 = [UITableView newAutoLayoutView];
        _tableView3.delegate = self;
        _tableView3.dataSource = self;
        _tableView3.tableFooterView = [[UIView alloc] init];
        _tableView3.backgroundColor = kBackColor;
        _tableView3.separatorColor = kSeparateColor;
    }
    return _tableView3;
}

//- (NSMutableDictionary *)brandDic
//{
//    if (!_brandDic) {
//        _brandDic = [NSMutableDictionary dictionary];
//    }
//    return _brandDic;
//}
//
//
//- (NSMutableDictionary *)audiDic
//{
//    if (!_audiDic) {
//        _audiDic = [NSMutableDictionary dictionary];
//    }
//    return _audiDic;
//}
//
//- (NSArray *)licenseplateArray
//{
//    if (!_licenseplateArray) {
//        _licenseplateArray = @[@"沪牌",@"非沪牌"];
//    }
//    return _licenseplateArray;
//}

- (NSMutableArray *)provinceArray
{
    if (!_provinceArray) {
        _provinceArray = [NSMutableArray array];
    }
    return _provinceArray;
}

- (NSMutableArray *)cityArray
{
    if (!_cityArray) {
        _cityArray = [NSMutableArray array];
    }
    return _cityArray;
}

- (NSMutableArray *)districtArray
{
    if (!_districtArray) {
        _districtArray = [NSMutableArray array];
    }
    return _districtArray;
}

- (NSMutableDictionary *)paramDic
{
    if (!_paramDic) {
        _paramDic = [NSMutableDictionary dictionary];
    }
    return _paramDic;
}

#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView1) {
        return self.provinceArray.count;
    }else if(tableView == self.tableView2){
        return self.cityArray.count;
    }else{
        return self.districtArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    if (tableView == self.tableView1) {
        identifier = @"car1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        CourtProvinceModel *nameModel = self.provinceArray[indexPath.row];
        cell.textLabel.text = nameModel.name;
        
        return cell;
    }else if(tableView == self.tableView2){
        identifier = @"car2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        CourtProvinceModel *nameModel = self.cityArray[indexPath.row];
        cell.textLabel.text = nameModel.name;
        
        return cell;
    }else{
        identifier = @"car2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        CourtProvinceModel *nameModel = self.districtArray[indexPath.row];
        cell.textLabel.text = nameModel.name;
        
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView1) {
        [self.view addSubview:self.tableView2];
        [self.tableView2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.tableView1];
        [self.tableView2 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.tableView1];
        [self.tableView2 autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.tableView1];
        [self.tableView2 autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.tableView1];
        
        CourtProvinceModel *proModel = self.provinceArray[indexPath.row];
        
        //params
        [self.paramDic setValue:proModel.name forKey:@"provinceName"];
        [self.paramDic setValue:proModel.idString forKey:@"provinceId"];

        //method
        [self getCityListWithProvinceID:proModel.idString];
        
    }else if(tableView == self.tableView2){
        
        [self.view addSubview:self.tableView3];
        [self.tableView3 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.tableView2];
        [self.tableView3 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.tableView1];
        [self.tableView3 autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.tableView1];
        [self.tableView3 autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.tableView1];
        
        CourtProvinceModel *cityModel = self.cityArray[indexPath.row];
        
        [self.paramDic setValue:cityModel.name forKey:@"cityName"];
        [self.paramDic setValue:cityModel.idString forKey:@"cityId"];
        
        [self getDistrictListWithCityID:cityModel.idString];
        
    }else{
        
        CourtProvinceModel *districtModel = self.districtArray[indexPath.row];
        [self.paramDic setValue:districtModel.name forKey:@"districtName"];
        [self.paramDic setValue:districtModel.idString forKey:@"districtId"];
        
        if (self.didSelectedRow) {
            self.didSelectedRow(self.paramDic[@"provinceId"],self.paramDic[@"provinceName"],self.paramDic[@"cityId"],self.paramDic[@"cityName"],self.paramDic[@"districtId"],self.paramDic[@"districtName"]);
        }
        
        [self back];
    }
}

#pragma mark - method
- (void)getProvinceList
{
    NSString *provinceString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kPublishproductOfProvince];
    
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"type" : @"app"};
    
    QDFWeakSelf;
    [self requestDataPostWithString:provinceString params:params successBlock:^(id responseObject) {
        
        CourtProvinceResponse *courtResponse = [CourtProvinceResponse objectWithKeyValues:responseObject];
        for (CourtProvinceModel *proModel in courtResponse.data) {
            [weakself.provinceArray addObject:proModel];
        }
        
        [weakself.tableView1 reloadData];
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)getCityListWithProvinceID:(NSString *)provinceId
{
    NSString *cityString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kPublishproductOfCity];
    NSDictionary *params = @{@"province_id" : provinceId,
                             @"token" : [self getValidateToken],
                             @"type" : @"app"};
    
    QDFWeakSelf;
    [self requestDataPostWithString:cityString params:params successBlock:^(id responseObject) {
        
        [weakself.cityArray removeAllObjects];
        
        CourtProvinceResponse *courtResponse = [CourtProvinceResponse objectWithKeyValues:responseObject];
        
        for (CourtProvinceModel *cityModel in courtResponse.data) {
            [weakself.cityArray addObject:cityModel];
        }
        
        [weakself.tableView2 reloadData];

    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)getDistrictListWithCityID:(NSString *)cityId
{
    NSString *districtString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kPublishproductOfArea];
    NSDictionary *params = @{@"city" : cityId,
                             @"token" : [self getValidateToken],
                             @"type" : @"app"};
    
    QDFWeakSelf;
    [self requestDataPostWithString:districtString params:params successBlock:^(id responseObject) {
        [weakself.districtArray removeAllObjects];
        
        CourtProvinceResponse *courtResponse = [CourtProvinceResponse objectWithKeyValues:responseObject];
        
        for (CourtProvinceModel *districtModel in courtResponse.data) {
            [weakself.districtArray addObject:districtModel];
        }
        
        [weakself.tableView3 reloadData];
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

//- (void)getBrandList
//{
//    NSString *brandString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kPublishproductOfProvince];
//    
//    QDFWeakSelf;
//    [self requestDataPostWithString:brandString params:nil successBlock:^(id responseObject) {
//        
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//        weakself.brandDic = [NSMutableDictionary dictionaryWithDictionary:dic];
//        [weakself.tableView1 reloadData];
//        
//    } andFailBlock:^(NSError *error) {
//        
//    }];
//}
//
////车系
//- (void)getAudiListWithBrand:(NSString *)brand
//{
//    [self.audiDic removeAllObjects];
//    
//    NSString *auditString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kBrandAudiString];
//    NSDictionary *params = @{@"pid" : brand};
//    
//    QDFWeakSelf;
//    [self requestDataPostWithString:auditString params:params successBlock:^(id responseObject) {
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//        
//        weakself.audiDic = [NSMutableDictionary dictionaryWithDictionary:dic];
//        [weakself.tableView2 reloadData];
//        
//    } andFailBlock:^(NSError *error) {
//        
//    }];
//}

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
