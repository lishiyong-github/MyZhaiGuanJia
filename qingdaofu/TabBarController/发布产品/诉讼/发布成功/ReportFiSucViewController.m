//
//  ReportFiSucViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/23.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ReportFiSucViewController.h"
#import "MyReleaseViewController.h"   //我的发布
#import "ReportSuitViewController.h"
#import "UIViewController+SelectedIndex.h"

#import "UIViewController+BlurView.h"
#import "EvaTopSwitchView.h"

#import "MineUserCell.h"
#import "ReportSuccessCell.h"

@interface ReportFiSucViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *reportSucTableView;
@property (nonatomic,strong) EvaTopSwitchView *reportSucFootView;

@property (nonatomic,strong) UIImageView *headerView;

@end

@implementation ReportFiSucViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"发布成功";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:nil];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:kNavColor} forState:0];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishReport)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:kBigFont,NSForegroundColorAttributeName:kBlueColor} forState:0];
    
    [self.view addSubview:self.reportSucTableView];
    [self.view addSubview:self.reportSucFootView];
    [self.view setNeedsUpdateConstraints];
}

- (void)finishReport
{
    UINavigationController *nav = self.navigationController;
    [nav popViewControllerAnimated:NO];
    [nav popViewControllerAnimated:NO];
    [nav popViewControllerAnimated:NO];
    [nav popViewControllerAnimated:NO];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.reportSucTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.reportSucTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kTabBarHeight];
        
        [self.reportSucFootView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.reportSucFootView autoSetDimension:ALDimensionHeight toSize:kTabBarHeight];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)reportSucTableView
{
    if (!_reportSucTableView) {
        _reportSucTableView = [UITableView newAutoLayoutView];
        _reportSucTableView.backgroundColor = kBackColor;
        _reportSucTableView.separatorColor = kSeparateColor;
        _reportSucTableView.delegate = self;
        _reportSucTableView.dataSource = self;
        _reportSucTableView.separatorInset = UIEdgeInsetsZero;
        _reportSucTableView.tableFooterView = [[UIView alloc] init];
        _reportSucTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 187.5)];
        [_reportSucTableView.tableHeaderView addSubview:self.headerView];
        
        if ([_reportSucTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            
            [_reportSucTableView setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([_reportSucTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            
            [_reportSucTableView setLayoutMargins:UIEdgeInsetsZero];
            
        }
    }
    return _reportSucTableView;
}

- (UIImageView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, 187.5)];
        _headerView.image = [UIImage imageNamed:@"banner"];
    }
    return _headerView;
}

- (EvaTopSwitchView *)reportSucFootView
{
    if (!_reportSucFootView) {
        _reportSucFootView = [[EvaTopSwitchView alloc] initWithFrame:CGRectMake(0, kScreenHeight-kTabBarHeight-kNavHeight, kScreenWidth, kTabBarHeight)];
        _reportSucFootView.backgroundColor = kNavColor;
        _reportSucFootView.heightConstraint.constant = kTabBarHeight;
        [_reportSucFootView.blueLabel setHidden:YES];
        
        [_reportSucFootView.getbutton setTitle:@"  回主页" forState:0];
        [_reportSucFootView.getbutton setImage:[UIImage imageNamed:@"back"] forState:0];
        [_reportSucFootView.getbutton setTitleColor:kBlueColor forState:0];
        [_reportSucFootView.getbutton addTarget:self action:@selector(finishReport) forControlEvents:UIControlEventTouchUpInside];
        
        [_reportSucFootView.sendButton setTitle:@"  继续发布" forState:0];
        [_reportSucFootView.sendButton setImage:[UIImage imageNamed:@"add"] forState:0];
        [_reportSucFootView.sendButton setTitleColor:kBlueColor forState:0];
        QDFWeakSelf;
        [_reportSucFootView.sendButton addAction:^(UIButton *btn) {
            [weakself showBlurInView:[UIApplication sharedApplication].keyWindow withArray:nil finishBlock:^(NSInteger row) {
                UINavigationController *nav = weakself.navigationController;
                [nav popViewControllerAnimated:NO];
                [nav popViewControllerAnimated:NO];
                
                if (row == 12){
                    ReportSuitViewController *collectVC = [[ReportSuitViewController alloc] init];
                    collectVC.categoryString = @"2";
                    collectVC.tagString = @"1";
                    collectVC.hidesBottomBarWhenPushed = YES;
                    [nav pushViewController:collectVC animated:NO];
                }else{
                    ReportSuitViewController *reportSuitVC = [[ReportSuitViewController alloc] init];
                    reportSuitVC.categoryString = @"3";
                    reportSuitVC.tagString = @"1";
                    reportSuitVC.hidesBottomBarWhenPushed = YES;
                    [nav pushViewController:reportSuitVC animated:NO];
                }
            }];
        }];
    }
    return _reportSucFootView;
}

#pragma mark - tableView delegate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 90;
    }
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    
    if (indexPath.row == 0) {
        ReportSuccessCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[ReportSuccessCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        
        NSDate *senddate=[NSDate date];
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
        NSString *locationString=[dateformatter stringFromDate:senddate];
        
        cell.suTimeLabel.text = [NSString stringWithFormat:@"发布时间：%@",locationString];
        //@"发布时间：2016-05-10 17:40";
        cell.suTypeLabel.text = [NSString stringWithFormat:@"产品类型：%@",self.reportType];
        //@"产品类型：融资";
        cell.suStateLabel.text = @"产品状态：已发布";
        
        return cell;
    }
    
    MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [cell.userActionButton setTitle:@"点击查看我的发布" forState:0];
    cell.userActionButton.titleLabel.font = kBigFont;
    [cell.userActionButton setTitleColor:kBlueColor forState:0];
    [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
    QDFWeakSelf;
    [cell.userActionButton addAction:^(UIButton *btn) {
        UINavigationController *nav = weakself.navigationController;
        [nav popViewControllerAnimated:NO];
        [nav popViewControllerAnimated:NO];
        MyReleaseViewController *myReleaseVC = [[MyReleaseViewController alloc] init];
        myReleaseVC.hidesBottomBarWhenPushed = YES;
        myReleaseVC.progreStatus = @"1";
        [weakself setSelectedIndex:4];
        UITabBarController *tabBarController = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        UINavigationController *NavVC = tabBarController.selectedViewController;
        [NavVC pushViewController:myReleaseVC animated:NO];
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kBigPadding;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = kBackColor;
    return headerView;
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
