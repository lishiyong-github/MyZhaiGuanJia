//
//  BrandsViewController.m
//  qingdaofu
//
//  Created by shiyong_li on 16/6/20.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "BrandsViewController.h"

@interface BrandsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,assign) BOOL didSetupConstarints;
@property (nonatomic,strong) UITableView *tableView1;
@property (nonatomic,strong) UITableView *tableView2;
@property (nonatomic,strong) UITableView *tableView3;

@property (nonatomic,strong) NSMutableDictionary *brandDic;
@property (nonatomic,strong) NSMutableDictionary *audiDic;
@property (nonatomic,strong) NSArray *licenseplateArray;

@property (nonatomic,strong) NSString *string1;
@property (nonatomic,strong) NSString *string11;
@property (nonatomic,strong) NSString *string2;
@property (nonatomic,strong) NSString *string22;
@property (nonatomic,strong) NSString *string3;
@property (nonatomic,strong) NSString *string33;

@end

@implementation BrandsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择品牌";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.tableView1];
    [self.view setNeedsUpdateConstraints];
    if (!self.dataList) {
        [self getBrandList];
    }
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
    }
    return _tableView3;
}

- (NSMutableDictionary *)brandDic
{
    if (!_brandDic) {
        _brandDic = [NSMutableDictionary dictionary];
    }
    return _brandDic;
}


- (NSMutableDictionary *)audiDic
{
    if (!_audiDic) {
        _audiDic = [NSMutableDictionary dictionary];
    }
    return _audiDic;
}

- (NSArray *)licenseplateArray
{
    if (!_licenseplateArray) {
        _licenseplateArray = @[@"沪牌",@"非沪牌"];
    }
    return _licenseplateArray;
}

#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView1) {
        
        return self.brandDic.allKeys.count;
    }else if(tableView == self.tableView2){
        return self.audiDic.allKeys.count;
    }else{
        return self.licenseplateArray.count;
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
        
        NSString *key = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
        cell.textLabel.text = self.brandDic[key];
        
        return cell;
    }else if(tableView == self.tableView2){
        identifier = @"car2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.textLabel.text = self.audiDic.allValues[indexPath.row];
        
        return cell;
    }else{
        identifier = @"car2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.textLabel.text = self.licenseplateArray[indexPath.row];
        
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
        
        NSString *bb = [NSString stringWithFormat:@"%ld",indexPath.row+1];
        _string11 = self.brandDic[bb];
        _string1 = bb;
        [self getAudiListWithBrand:bb];
        
    }else if(tableView == self.tableView2){
        
        [self.view addSubview:self.tableView3];
        [self.tableView3 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.tableView2];
        [self.tableView3 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.tableView1];
        [self.tableView3 autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.tableView1];
        [self.tableView3 autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.tableView1];
        
        _string2 = self.audiDic.allKeys[indexPath.row];
        _string22 = self.audiDic.allValues[indexPath.row];
        
    }else{
        
        _string3 = [NSString stringWithFormat:@"%ld",indexPath.row+1];
        _string33 = self.licenseplateArray[indexPath.row];
        
        if (self.didSelectedRow) {
            self.didSelectedRow(_string1,_string11,_string2,_string22,_string3,_string33);
        }
        
        [self back];
    }
}

#pragma mark - method
- (void)getBrandList
{
    NSString *brandString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kBrandString];
    
    QDFWeakSelf;
    [self requestDataPostWithString:brandString params:nil successBlock:^(id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        weakself.brandDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [weakself.tableView1 reloadData];
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

//车系
- (void)getAudiListWithBrand:(NSString *)brand
{
    [self.audiDic removeAllObjects];
    
    NSString *auditString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kBrandAudiString];
    NSDictionary *params = @{@"pid" : brand};
    
    QDFWeakSelf;
    [self requestDataPostWithString:auditString params:params successBlock:^(id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];

        weakself.audiDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [weakself.tableView2 reloadData];
        
    } andFailBlock:^(NSError *error) {
        
    }];
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
