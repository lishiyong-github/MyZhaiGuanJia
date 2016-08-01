//
//  PowerProtectListViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/1.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "PowerProtectListViewController.h"
#import "PowerProtectViewController.h"
#import "BaseCommitButton.h"

#import "MineUserCell.h"
#import "MessageCell.h"

@interface PowerProtectListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *powerListTableView;
@property (nonatomic,strong) UIView *powerListCommitView;
@property (nonatomic,strong) BaseCommitButton *powerListCommitButton;
@property (nonatomic,assign) BOOL didSetupConstraints;

@end

@implementation PowerProtectListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的保权";
    
    self.navigationItem.leftBarButtonItem = self.leftItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshLists)];
    
    [self.view addSubview:self.powerListTableView];
    [self.view addSubview:self.powerListCommitView];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)refreshLists
{
    
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.powerListTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.powerListTableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.powerListCommitView];
        
        [self.powerListCommitView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.powerListCommitView autoSetDimension:ALDimensionHeight toSize:60];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)powerListTableView
{
    if (!_powerListTableView) {
        _powerListTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _powerListTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _powerListTableView.delegate = self;
        _powerListTableView.dataSource = self;
        _powerListTableView.backgroundColor = kBackColor;
        _powerListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
    }
    return _powerListTableView;
}

- (UIView *)powerListCommitView
{
    if (!_powerListCommitView) {
        _powerListCommitView = [UIView newAutoLayoutView];
        _powerListCommitView.backgroundColor = kNavColor;
        _powerListCommitView.layer.borderColor = kSeparateColor.CGColor;
        _powerListCommitView.layer.borderWidth = kLineWidth;
        [_powerListCommitView addSubview:self.powerListCommitButton];
        
        [self.powerListCommitButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    }
    return _powerListCommitView;
}

- (BaseCommitButton *)powerListCommitButton
{
    if (!_powerListCommitButton) {
        _powerListCommitButton = [BaseCommitButton newAutoLayoutView];
        [_powerListCommitButton setTitle:@"申请保权" forState:0];
        
        QDFWeakSelf;
        [_powerListCommitButton addAction:^(UIButton *btn) {
            UINavigationController *nav = weakself.navigationController;
            [nav popViewControllerAnimated:NO];
            [nav popViewControllerAnimated:NO];
            [nav popViewControllerAnimated:NO];
            
            PowerProtectViewController *powerProtectVC = [[PowerProtectViewController alloc] init];
            powerProtectVC.hidesBottomBarWhenPushed = YES;
            [nav pushViewController:powerProtectVC animated:NO];
        }];
    }
    return _powerListCommitButton;
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
    if (indexPath.row == 0) {
        return kCellHeight;
    }
    
    return 60;
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
        [cell.userNameButton setTitle:@"BH20160928009" forState:0];
        [cell.userNameButton setTitleColor:kGrayColor forState:0];
        [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        
        return cell;
        
    }else{
        identifier = @"listas1";
        MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.userLabel.text = [NSString stringWithFormat:@"保权金额：%@",@"1000万"];
        cell.newsLabel.text = @"2014-09-09 12:12";
        [cell.actButton setTitle:@"审核中" forState:0];
//        [cell.actButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based powerlication, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
