//
//  ApplicationListViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/1.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ApplicationListViewController.h"
#import "ApplicationGuaranteeViewController.h"

#import "BaseCommitButton.h"
#import "MineUserCell.h"

@interface ApplicationListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *appListTableView;
@property (nonatomic,strong) UIView *appListCommitView;
@property (nonatomic,strong) BaseCommitButton *appListCommitButton;
@property (nonatomic,assign) BOOL didSetupConstraints;

@end

@implementation ApplicationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的保函";
    
    self.navigationItem.leftBarButtonItem = self.leftItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"refresh"] style:UIBarButtonItemStylePlain target:self action:@selector(refreshList)];
    
    [self.view addSubview:self.appListTableView];
    [self.view addSubview:self.appListCommitView];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)refreshList
{
    
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.appListTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.appListTableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.appListCommitView];
        
        [self.appListCommitView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.appListCommitView autoSetDimension:ALDimensionHeight toSize:60];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)appListTableView
{
    if (!_appListTableView) {
        _appListTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _appListTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _appListTableView.delegate = self;
        _appListTableView.dataSource = self;
        _appListTableView.backgroundColor = kBackColor;
        _appListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
    }
    return _appListTableView;
}

- (UIView *)appListCommitView
{
    if (!_appListCommitView) {
        _appListCommitView = [UIView newAutoLayoutView];
        _appListCommitView.backgroundColor = kNavColor;
        _appListCommitView.layer.borderColor = kSeparateColor.CGColor;
        _appListCommitView.layer.borderWidth = kLineWidth;
        [_appListCommitView addSubview:self.appListCommitButton];
        
        [self.appListCommitButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    }
    return _appListCommitView;
}

- (BaseCommitButton *)appListCommitButton
{
    if (!_appListCommitButton) {
        _appListCommitButton = [BaseCommitButton newAutoLayoutView];
        [_appListCommitButton setTitle:@"申请保函" forState:0];
        
        QDFWeakSelf;
        [_appListCommitButton addAction:^(UIButton *btn) {
            UINavigationController *nav = weakself.navigationController;
            [nav popViewControllerAnimated:NO];
            [nav popViewControllerAnimated:NO];
            [nav popViewControllerAnimated:NO];
            
            ApplicationGuaranteeViewController *applicationGuaranteeVC = [[ApplicationGuaranteeViewController alloc] init];
            applicationGuaranteeVC.hidesBottomBarWhenPushed = YES;
            [nav pushViewController:applicationGuaranteeVC animated:NO];
        }];
    }
    return _appListCommitButton;
}

#pragma mark -tableview delegate and datasoyrce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
        [cell.userNameButton setTitle:@"  BH20160928009" forState:0];
        [cell.userNameButton setImage:[UIImage imageNamed:@"Lette_of_guarantee"] forState:0];
        [cell.userNameButton setTitleColor:kGrayColor forState:0];
        [cell.userActionButton setTitle:@"审核中" forState:0];
        [cell.userActionButton setTitleColor:kBlackColor forState:0];
        
        return cell;
        
    }else{
        identifier = @"listas1";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSArray *lawArray = @[@"法院",@"申请人",@"电话号码",@"保权金额",@"申请时间"];
        
        [cell.userNameButton setTitleColor:kLightGrayColor forState:0];
        cell.userNameButton.titleLabel.font = kFirstFont;
        [cell.userNameButton setTitle:lawArray[indexPath.row-1] forState:0];
        [cell.userActionButton setTitleColor:kGrayColor forState:0];
        cell.userActionButton.titleLabel.font = kFirstFont;
        
        if (indexPath.row == 1) {
            [cell.userActionButton setTitle:@"上海市浦东新区上海中级人民法院" forState:0];
        }else if (indexPath.row == 2) {
            [cell.userActionButton setTitle:@"意义" forState:0];
        }else if (indexPath.row == 3) {
            [cell.userActionButton setTitle:@"13289090099" forState:0];
        }else if (indexPath.row == 4) {
            [cell.userActionButton setTitle:@"999万" forState:0];
        }else if (indexPath.row == 5){
            [cell.userActionButton setTitle:@"2015-09-09 12:12" forState:0];
        }
        
        return cell;
        
        /*
        [cell.userActionButton setHidden:YES];
        [cell.userNameButton setTitleColor:kGrayColor forState:0];
        cell.userNameButton.titleLabel.font = kFirstFont;

        NSString *rowStr1 = [NSString stringWithFormat:@"法院：        %@",@"上海市浦东新区上海中级人民法院"];
        NSString *rowStr2 = [NSString stringWithFormat:@"申请人：    %@",@"意义"];
        NSString *rowStr3 = [NSString stringWithFormat:@"电话号码：%@",@"13289090099"];
        NSString *rowStr4 = [NSString stringWithFormat:@"保全金额：%@",@"999万"];
        NSArray *rowArray = @[rowStr1,rowStr2,rowStr3,rowStr4];
    
        [cell.userNameButton setTitle:rowArray[indexPath.row-1] forState:0];
        return cell;
         */
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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
