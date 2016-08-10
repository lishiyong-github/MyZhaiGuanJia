//
//  ApplicationListViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/1.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ApplicationListViewController.h"
#import "ApplicationGuaranteeViewController.h"
#import "ApplicationDetailsViewController.h"  //详情

//#import "BaseCommitButton.h"
//#import "MineUserCell.h"


#import "BaseCommitView.h"
#import "EvaTopSwitchView.h"

#import "MineUserCell.h"
#import "MessageCell.h"

@interface ApplicationListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) EvaTopSwitchView *applicationSwitchView;
@property (nonatomic,strong) UITableView *applicationListTableView;
@property (nonatomic,strong) BaseCommitView *applicationListCommitView;
@property (nonatomic,assign) BOOL didSetupConstraints;

@end

@implementation ApplicationListViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的保函";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.applicationSwitchView];
    [self.view addSubview:self.applicationListTableView];
    [self.view addSubview:self.applicationListCommitView];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.applicationSwitchView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.applicationSwitchView autoSetDimension:ALDimensionHeight toSize:50];
        
        [self.applicationListTableView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.applicationSwitchView];
        [self.applicationListTableView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.applicationListTableView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.applicationListTableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.applicationListCommitView];
        
        [self.applicationListCommitView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.applicationListCommitView autoSetDimension:ALDimensionHeight toSize:60];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (EvaTopSwitchView *)applicationSwitchView
{
    if (!_applicationSwitchView) {
        _applicationSwitchView = [EvaTopSwitchView newAutoLayoutView];
        [_applicationSwitchView.shortLineLabel setHidden:YES];
        _applicationSwitchView.leftBlueConstraints.constant = 0;
        _applicationSwitchView.widthBlueConstraints.constant = kScreenWidth/2;
        _applicationSwitchView.backgroundColor = kNavColor;
        
        [_applicationSwitchView.getbutton setTitle:@"未完成的订单" forState:0];
        [_applicationSwitchView.sendButton setTitle:@"已完成的订单" forState:0];
        
        QDFWeakSelf;
        [_applicationSwitchView setDidSelectedButton:^(NSInteger tag) {
            if (tag == 33) {
                weakself.applicationSwitchView.leftBlueConstraints.constant = 0;
                [weakself.applicationSwitchView.getbutton setTitleColor:kBlueColor forState:0];
                [weakself.applicationSwitchView.sendButton setTitleColor:kBlackColor forState:0];
            }else if (tag == 34){
                weakself.applicationSwitchView.leftBlueConstraints.constant = kScreenWidth/2;
                [weakself.applicationSwitchView.sendButton setTitleColor:kBlueColor forState:0];
                [weakself.applicationSwitchView.getbutton setTitleColor:kBlackColor forState:0];
            }
        }];
    }
    return _applicationSwitchView;
}

- (UITableView *)applicationListTableView
{
    if (!_applicationListTableView) {
        _applicationListTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _applicationListTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _applicationListTableView.delegate = self;
        _applicationListTableView.dataSource = self;
        _applicationListTableView.backgroundColor = kBackColor;
        _applicationListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
    }
    return _applicationListTableView;
}

- (BaseCommitView *)applicationListCommitView
{
    if (!_applicationListCommitView) {
        _applicationListCommitView = [BaseCommitView newAutoLayoutView];
        [_applicationListCommitView.button setTitle:@"申请保函" forState:0];
        
        QDFWeakSelf;
        [_applicationListCommitView.button addAction:^(UIButton *btn) {
            UINavigationController *nav = weakself.navigationController;
            [nav popViewControllerAnimated:NO];
            
            ApplicationGuaranteeViewController *applicationGuaranteeVC = [[ApplicationGuaranteeViewController alloc] init];
            applicationGuaranteeVC.hidesBottomBarWhenPushed = YES;
            [nav pushViewController:applicationGuaranteeVC animated:NO];
        }];
    }
    return _applicationListCommitView;
}

#pragma mark -tableview delegate and datasoyrce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        return 65;
    }
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    
    if (indexPath.row == 0) {
        identifier = @"listas0";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.userNameButton.userInteractionEnabled = NO;
        cell.userActionButton.userInteractionEnabled = NO;
        
        [cell.userNameButton setTitle:@"  BH20160928009" forState:0];
        [cell.userNameButton setTitleColor:kGrayColor forState:0];
        [cell.userNameButton setImage:[UIImage imageNamed:@"Lette_of_guarantee"] forState:0];
        [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        
        return cell;
    }else if(indexPath.row == 1){
        identifier = @"listas1";
        MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.countLabel setHidden:YES];
        [cell.actButton setHidden:YES];
        cell.userLabel.textColor = kGrayColor;
        cell.newsLabel.textColor = kGrayColor;
        cell.userLabel.font = kFirstFont;
        cell.newsLabel.font = kFirstFont;
        
        cell.userLabel.text = [NSString stringWithFormat:@"金额：%@万",@"1000"];
        cell.timeLabel.text = @"2016-09-09 12:12";
        cell.newsLabel.text = [NSString stringWithFormat:@"法院：%@",@"上海市高级人民法院"];
        
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kBigPadding;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        ApplicationDetailsViewController *applicationDetailsVC = [[ApplicationDetailsViewController alloc] init];
        [self.navigationController pushViewController:applicationDetailsVC animated:YES];
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
