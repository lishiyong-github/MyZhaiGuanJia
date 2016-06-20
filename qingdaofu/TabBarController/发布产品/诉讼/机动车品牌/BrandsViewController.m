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
@property (nonatomic,strong) NSMutableArray *brandArray;
@property (nonatomic,strong) NSMutableArray *audiArray;

@property (nonatomic,strong) NSMutableDictionary *brandDic;
@property (nonatomic,strong) NSMutableDictionary *audiDic;


@property (nonatomic,assign) NSInteger row1;
@property (nonatomic,assign) NSInteger *row2;

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
        [self.tableView1 autoSetDimension:ALDimensionWidth toSize:kScreenWidth/2];
//        [self.tableView2 autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeLeft];
//        [self.tableView2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.tableView1];
        
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

- (NSMutableArray *)brandArray
{
    if (!_brandArray) {
        _brandArray = [NSMutableArray array];
    }
    return _brandArray;
}

- (NSMutableArray *)audiArray
{
    if (!_audiArray) {
        _audiArray = [NSMutableArray array];
    }
    return _audiArray;
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

#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tableView1) {
        
        return self.brandDic.allKeys.count;
    }else{
        return self.audiArray.count;
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
        
        NSString *key = [NSString stringWithFormat:@"%d",indexPath.row + 1];
        cell.textLabel.text = self.brandDic[key];
        
        return cell;
    }else{
        identifier = @"car2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.textLabel.text = self.audiArray[indexPath.row];
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == self.tableView1) {
        
        _row1 = indexPath.row + 1;
        
        [self.view addSubview:self.tableView2];
        [self.tableView2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.tableView1];
        [self.tableView2 autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeLeft];
        
        NSString *bb = [NSString stringWithFormat:@"%d",indexPath.row+1];
        NSString *ww = self.brandDic[bb];
        [self getAudiListWithBrand:bb];
        
    }else{
        
        [self back];
    }
}

#pragma mark - method
- (void)getBrandList
{
    NSString *brandString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kBrandString];
    [self requestDataPostWithString:brandString params:nil successBlock:^(id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"@@@@@@@@@ %@",dic);
        
//        for (int i=0; i<[[dic allKeys] count]; i++) {
//            [self.brandArray addObject:dic.allValues[i]];
//        }
        
        self.brandDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        
        [self.tableView1 reloadData];
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

//车系
- (void)getAudiListWithBrand:(NSString *)brand
{
    [self.audiArray removeAllObjects];
//    [self.audiArray addObjectsFromArray:@[@"A版",@"B版",@"C版",@"D版"]];
//    [self.tableView2 reloadData];
    
    NSString *auditString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kBrandAudiString];
    NSDictionary *params = @{@"carbrand" : brand};
    
    [self requestDataPostWithString:auditString params:params successBlock:^(id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"MMMMMMM %@",dic);

        
    } andFailBlock:^(NSError *error) {
        
    }];
    
    
    /*
    [self requestDataPostWithString:auditString params:nil successBlock:^(id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"MMMMMMM %@",dic);
        
        for (int p=0; p<[[dic allKeys] count]; p++) {
            [self.audiArray addObject:dic.allValues[p]];
        }
     
        [self.tableView2 reloadData];
        
    } andFailBlock:^(NSError *error) {
        
    }];
     */
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
