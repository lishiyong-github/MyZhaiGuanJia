//
//  HouseAssessListViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/15.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "HouseAssessListViewController.h"
#import "HouseAssessViewController.h"
#import "AssessSuccessViewController.h"

#import "BaseCommitView.h"
#import "MineUserCell.h"
#import "MessageCell.h"

@interface HouseAssessListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *houseListTableView;
@property (nonatomic,strong) BaseCommitView *houseListCommitView;
@property (nonatomic,assign) BOOL didSetupConstraints;

@end

@implementation HouseAssessListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的房产评估结果";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.houseListTableView];
    [self.view addSubview:self.houseListCommitView];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.houseListTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.houseListTableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.houseListCommitView];
        
        [self.houseListCommitView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.houseListCommitView autoSetDimension:ALDimensionHeight toSize:60];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

#pragma mark - setter and getter
- (UITableView *)houseListTableView
{
    if (!_houseListTableView) {
        _houseListTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _houseListTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _houseListTableView.delegate = self;
        _houseListTableView.dataSource = self;
        _houseListTableView.separatorColor = kSeparateColor;
    }
    return _houseListTableView;
}

- (UIView *)houseListCommitView
{
    if (!_houseListCommitView) {
        _houseListCommitView = [BaseCommitView newAutoLayoutView];
        
        [_houseListCommitView.button setTitle:@"房产评估" forState:0];
        
        QDFWeakSelf;
        [_houseListCommitView.button addAction:^(UIButton *btn) {
            HouseAssessViewController *houseAssessListVC = [[HouseAssessViewController alloc] init];
            [weakself.navigationController pushViewController:houseAssessListVC animated:YES];
        }];
        
    }
    return _houseListCommitView;
}

#pragma mark -tableview delegate and datasoyrce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        return 60;
    }
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    
    if (indexPath.row == 0) {
        identifier = @"houseList0";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.userNameButton setImage:[UIImage imageNamed:@"house_property_evaluation"] forState:0];
        
        
        NSMutableAttributedString *resultStr = [cell.userNameButton setAttributeString:@"  评估结果：" withColor:kBlackColor andSecond:@"200万" withColor:kRedColor withFont:16];
        [cell.userNameButton setAttributedTitle:resultStr forState:0];
//        NSString *resultStr = [NSString stringWithFormat:@"  评估结果：%@万",@"600"];
//        [cell.userNameButton setTitle:resultStr forState:0];
        [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        
        return cell;
    }
    identifier = @"houseList1";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.timeLabel setHidden:YES];
    [cell.countLabel setHidden:YES];
    [cell.actButton setHidden:YES];

    cell.userLabel.text = [NSString stringWithFormat:@"房源信息：%@",@"浦东新区孙环路177弄1号101室"];
    cell.newsLabel.text = [NSString stringWithFormat:@"评估时间：%@",@"2016-09-09"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kBigPadding;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return kBigPadding;
    }
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        AssessSuccessViewController *assessSuccessVC = [[AssessSuccessViewController alloc] init];
        assessSuccessVC.fromType = @"2";
        [self.navigationController pushViewController:assessSuccessVC animated:YES];
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
