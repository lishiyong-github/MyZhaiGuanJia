//
//  AboutViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/3.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "AboutViewController.h"
#import "CompanyWebSiteViewController.h"
#import <StoreKit/StoreKit.h>

#import "SingleButton.h"
#import "MineUserCell.h"
//#import "UIButton.h"

@interface AboutViewController ()<UITableViewDataSource,UITableViewDelegate,SKStoreProductViewControllerDelegate>

@property (nonatomic,assign) BOOL didSetupConstaints;
@property (nonatomic,strong) UITableView *aboutTableView;
//@property (nonatomic,strong) UIButton *aboutHeaderView;
@property (nonatomic,strong) UIButton *aboutCommitButton;

@property (nonatomic,strong) SingleButton *aboutHeaderView;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关于清道夫";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.aboutTableView];
    [self.view addSubview:self.aboutCommitButton];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstaints) {
        [self.aboutTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        [self.aboutCommitButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.aboutCommitButton autoSetDimension:ALDimensionHeight toSize:80];
        
        self.didSetupConstaints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)aboutTableView
{
    if (!_aboutTableView) {
        _aboutTableView = [UITableView newAutoLayoutView];
        _aboutTableView.separatorColor = kSeparateColor;
        _aboutTableView.backgroundColor = kBackColor;
        _aboutTableView.delegate = self;
        _aboutTableView.dataSource = self;
        _aboutTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
        _aboutTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 142)];
        [_aboutTableView.tableHeaderView addSubview:self.aboutHeaderView];
        
        [self.aboutHeaderView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.aboutHeaderView autoSetDimensionsToSize:CGSizeMake(85, 100)];
        [self.aboutHeaderView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:30];
    }
    return _aboutTableView;
}

- (SingleButton *)aboutHeaderView
{
    if (!_aboutHeaderView) {
        _aboutHeaderView = [SingleButton newAutoLayoutView];
        _aboutHeaderView.spaceConstraints.constant = 0;
        [_aboutHeaderView.button setImage:[UIImage imageNamed:@"logo"] forState:0];
        _aboutHeaderView.label.font = kSecondFont;
        _aboutHeaderView.label.textColor = kLightGrayColor;

        //当前版本
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        NSString *currentVersion = [infoDic objectForKey:@"CFBundleVersion"];
        NSString *versionString = [NSString stringWithFormat:@"清道夫V%@",currentVersion];
        [_aboutHeaderView.label setText:versionString];
    }
    return _aboutHeaderView;
}

- (UIButton *)aboutCommitButton
{
    if (!_aboutCommitButton) {
        _aboutCommitButton = [UIButton newAutoLayoutView];
        _aboutCommitButton.backgroundColor = kBackColor;
        _aboutCommitButton.titleLabel.numberOfLines = 0;
        _aboutCommitButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_aboutCommitButton setTitle:@"Copyright©2015-2016 直向资产管理有限公司　沪ICP备15055061号-1" forState:0];
        [_aboutCommitButton setTitleColor:kLightGrayColor forState:0];
        _aboutCommitButton.titleLabel.font = kTabBarFont;
    }
    
    return _aboutCommitButton;
}

#pragma mark - tableView delegate and dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"about";
    MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell.userNameButton setTitle:@"去评分" forState:0];
    [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
    cell.userNameButton.userInteractionEnabled = NO;
    cell.userActionButton.userInteractionEnabled = NO;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/wu-hao-zhang-gui/id1030735463?mt=8"]];
    
    Class isAllow = NSClassFromString(@"SKStoreProductViewController");
    
    if (isAllow != nil) {
        SKStoreProductViewController *sKStoreProductViewController = [[SKStoreProductViewController alloc] init];
        [sKStoreProductViewController.view setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [sKStoreProductViewController setDelegate:self];
        [sKStoreProductViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier: AppID} completionBlock:^(BOOL result, NSError *error) {
            if (result) {
                [self presentViewController:sKStoreProductViewController animated:YES completion:nil];
            }else{
            }
        }];
    }
}

#pragma mark - SKStoreProductViewControllerDelegate
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
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
