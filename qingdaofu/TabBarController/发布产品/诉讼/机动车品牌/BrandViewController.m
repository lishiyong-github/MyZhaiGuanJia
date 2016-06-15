//
//  BrandViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/6/14.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "BrandViewController.h"

@interface BrandViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *brandTableView;

@property (nonatomic,strong) NSDictionary *brandDictionary;

@end

@implementation BrandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择品牌";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.brandTableView];
    
    [self.view setNeedsUpdateConstraints];
    
    [self getBrandList];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.brandTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)brandTableView
{
    if (!_brandTableView) {
        _brandTableView = [UITableView newAutoLayoutView];
        _brandTableView.delegate = self;
        _brandTableView.dataSource = self;
        _brandTableView.separatorColor = kSeparateColor;
        _brandTableView.tableFooterView = [[UIView alloc] init];
    }
    return _brandTableView;
}

- (NSDictionary *)brandDictionary
{
    if (!_brandDictionary) {
        _brandDictionary = [NSDictionary dictionary];
    }
    return _brandDictionary;
}

#pragma mark - delegate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.brandDictionary.allKeys.count;
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 3;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"brand";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = self.brandDictionary.allValues[indexPath.row];
    
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (void)getBrandList
{
    NSString *brandString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kBrandString];
    [self requestDataPostWithString:brandString params:nil successBlock:^(id responseObject) {
        
        self.brandDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        [self.brandTableView reloadData];
        
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
