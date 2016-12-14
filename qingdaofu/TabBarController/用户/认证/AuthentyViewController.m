//
//  AuthentyViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/4/28.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "AuthentyViewController.h"
#import "AuthenPersonViewController.h"
#import "AuthenLawViewController.h"
#import "AuthenCompanyViewController.h"

#import "MineUserCell.h"

@interface AuthentyViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *authenTableView;
@property (nonatomic,strong) UIButton *authenHeadView;

@end

@implementation AuthentyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    self.navigationItem.title = @"身份认证";
    
    [self.view addSubview:self.authenTableView];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.authenTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)authenTableView
{
    if (!_authenTableView) {
        _authenTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _authenTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _authenTableView.delegate = self;
        _authenTableView.dataSource = self;
        _authenTableView.tableFooterView = [[UIView alloc] init];
        _authenTableView.separatorColor = kSeparateColor;
        _authenTableView.backgroundColor = kBackColor;
    }
    return _authenTableView;
}

#pragma mark - tabelView delegate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80 + kBigPadding*2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"authenty";
    MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *messageArray = @[@[@"personal_authentication",@"  个人认证"],@[@"firm_certification",@"  律所认证"],@[@"company_certification",@"  公司认证"]];
    [cell.userNameButton setImage:[UIImage imageNamed:messageArray[indexPath.section][0]] forState:0];
    [cell.userNameButton setTitle:messageArray[indexPath.section][1] forState:0];
    
    [cell.userActionButton setImage:[UIImage imageNamed:@"unauthorized"] forState:0];
    [cell.userActionButton setTitle:@"  未认证" forState:0];
    [cell.userActionButton setTitleColor:kYellowColor forState:0];
    [cell.userActionButton swapImage];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kBigPadding;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {//个人
        AuthenPersonViewController *authenPersonVC = [[AuthenPersonViewController alloc] init];
        [self.navigationController pushViewController:authenPersonVC animated:YES];
    }else if (indexPath.section == 1){//律所
        AuthenLawViewController *authenLawVC = [[AuthenLawViewController alloc] init];
        [self.navigationController pushViewController:authenLawVC animated:YES];
    }else{//公司
        AuthenCompanyViewController *authenCompanyVC = [[AuthenCompanyViewController alloc] init];
        [self.navigationController pushViewController:authenCompanyVC animated:YES];
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
