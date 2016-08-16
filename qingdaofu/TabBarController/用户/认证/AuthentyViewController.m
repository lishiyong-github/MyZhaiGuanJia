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

#import "AuthenCell.h"

@interface AuthentyViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *authenTableView;
@property (nonatomic,strong) UIButton *authenFootView;
@property (nonatomic,strong) UIButton *authenHeadView;

@end

@implementation AuthentyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    if ([self.typeAuthty isEqualToString:@"0"]) {
        self.navigationItem.title = @"身份认证";
    }else{
        self.navigationItem.title = @"修改认证";
    }
    
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
        _authenTableView.tableFooterView = self.authenFootView;
    }
    return _authenTableView;
}

- (UIButton *)authenFootView
{
    if (!_authenFootView) {
        _authenFootView = [[UIButton alloc ] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        [_authenFootView setTitle:@"在您未发布及未接单前，您可以根据实际需要，修改您的身份认证" forState:0];
        [_authenFootView setTitleColor:kLightGrayColor forState:0];;
        _authenFootView.titleLabel.font = kSmallFont;
        [_authenFootView setContentEdgeInsets:UIEdgeInsetsMake(0, kSmallPadding, 0, kSmallPadding)];
        _authenFootView.titleLabel.numberOfLines = 0;
    }
    return _authenFootView;
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
    
    AuthenCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[AuthenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.AuthenButton.userInteractionEnabled = NO;
    
    NSArray *imageArr = @[@"personal_authentication",@"firm_certification",@"company_certification"];
    NSArray *textArr = @[@"个人认证",@"律所认证",@"公司认证"];
    NSArray *deArr = @[@"暂不支持代理",@"可代理诉讼、清收",@"可代理清收"];
    
    cell.aImageView.image = [UIImage imageNamed:imageArr[indexPath.section]];
    cell.bLabel.text = textArr[indexPath.section];
    cell.cLabel.text = @"可发布清收、诉讼";
    cell.dLabel.text = deArr[indexPath.section];
    [cell.AuthenButton setTitle:@"  未认证" forState:0];
    [cell.AuthenButton setTitleColor:kYellowColor forState:0];
    [cell.AuthenButton setImage:[UIImage imageNamed:@"unauthorized"] forState:0];//authenticated@3x
    
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
        authenPersonVC.typeAuthen = self.typeAuthty;
        authenPersonVC.categoryString = [NSString stringWithFormat:@"%ld",indexPath.row+1];
        [self.navigationController pushViewController:authenPersonVC animated:YES];
    }else if (indexPath.section == 1){//律所
        AuthenLawViewController *authenLawVC = [[AuthenLawViewController alloc] init];
        authenLawVC.typeAuthen = self.typeAuthty;
        authenLawVC.categoryString = [NSString stringWithFormat:@"%ld",indexPath.row+1];
        [self.navigationController pushViewController:authenLawVC animated:YES];
    }else{//公司
        AuthenCompanyViewController *authenCompanyVC = [[AuthenCompanyViewController alloc] init];
        authenCompanyVC.typeAuthen = self.typeAuthty;
        authenCompanyVC.categoryString = [NSString stringWithFormat:@"%ld",indexPath.row+1];
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
