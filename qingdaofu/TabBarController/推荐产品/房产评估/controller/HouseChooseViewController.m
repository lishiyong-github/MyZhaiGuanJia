//
//  HouseChooseViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/7/29.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "HouseChooseViewController.h"

#import "MineUserCell.h"

@interface HouseChooseViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *houseChooseTableView;
@property (nonatomic,assign) BOOL didSetupConstraints;

@property (nonatomic,strong) NSMutableArray *listArray;

@end

@implementation HouseChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择区域";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.houseChooseTableView];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.houseChooseTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)houseChooseTableView
{
    if (!_houseChooseTableView) {
        _houseChooseTableView = [UITableView newAutoLayoutView];
        _houseChooseTableView.delegate = self;
        _houseChooseTableView.dataSource = self;
        _houseChooseTableView.separatorColor = kSeparateColor;
        _houseChooseTableView.tableFooterView = [[UIView alloc] init];
    }
    return _houseChooseTableView;
}

- (NSMutableArray *)listArray
{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
        _listArray = [NSMutableArray arrayWithObjects:@"长宁区",@"崇明",@"宝山",@"嘉定", nil];
    }
    return _listArray;
}

#pragma mark - delegate and datasoyrce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    identifier = @"assess00";
    MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }

    [cell.userNameButton setTitle:self.listArray[indexPath.row] forState:0];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headerLabel = [[UILabel alloc] init];
    headerLabel.text = @"     目前仅支持上海地区的查询";
    headerLabel.textColor = kLightGrayColor;
    headerLabel.font = kTabBarFont;
    headerLabel.backgroundColor = kBackColor;
    
    return headerLabel;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.didSelectedRow) {
        self.didSelectedRow(self.listArray[indexPath.row]);
        [self.navigationController popViewControllerAnimated:YES];
    }
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
