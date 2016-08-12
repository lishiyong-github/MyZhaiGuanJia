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
    self.navigationItem.title = @"认证";
    
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
        _authenTableView = [UITableView newAutoLayoutView];
        _authenTableView.delegate = self;
        _authenTableView.dataSource = self;
        _authenTableView.tableFooterView = [[UIView alloc] init];
        _authenTableView.separatorColor = kSeparateColor;
        _authenTableView.backgroundColor = kBackColor;
        _authenTableView.tableHeaderView = self.authenHeadView;
        _authenTableView.tableFooterView = self.authenFootView;
    }
    return _authenTableView;
}

- (UIButton *)authenHeadView
{
    if (!_authenHeadView) {
        _authenHeadView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 56)];
        
        [_authenHeadView setTitle:@"请选择认证的身份" forState:0];
        _authenHeadView.titleLabel.font = [UIFont systemFontOfSize:22];
        [_authenHeadView setTitleColor:kBlackColor forState:0];
//        _authenHeadView.label.textAlignment = NSTextAlignmentCenter;
//        _authenHeadView.label.font = [UIFont systemFontOfSize:22];
//        _authenHeadView.label.text = @"请选择认证的身份";
    }
    return _authenHeadView;
}

- (UIButton *)authenFootView
{
    if (!_authenFootView) {
        _authenFootView = [[UIButton alloc ] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        [_authenFootView setTitle:@"在您未发布及未接单前，您可以根据实际需要，修改您的身份认证" forState:0];
        [_authenFootView setTitleColor:kLightGrayColor forState:0];;
        _authenFootView.titleLabel.font = kSecondFont;
        [_authenFootView setContentEdgeInsets:UIEdgeInsetsMake(0, kSmallPadding, 0, kSmallPadding)];
        _authenFootView.titleLabel.numberOfLines = 0;
    }
    return _authenFootView;
}

#pragma mark - tabelView delegate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *wtwt = @"可发布融资、清收、诉讼";
    
    CGSize titleSize = CGSizeMake(kScreenWidth - 175, MAXFLOAT);
    CGSize  actualsize =[wtwt boundingRectWithSize:titleSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :kFirstFont} context:nil].size;
    
    return 105 + MAX(actualsize.height, 16);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"authenty";
    
    AuthenCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[AuthenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *imageArr = @[@"list_icon_personal",@"list_icon_firm",@"list_icon_company"];
    NSArray *textArr = @[@"认证个人",@"认证律所",@"认证公司"];
    NSArray *detailArr = @[@"可发布清收、诉讼",@"可发布清收、诉讼",@"可发布清收、诉讼"];
    NSArray *deArr = @[@"暂不支持代理",@"可代理诉讼、清收",@"可代理诉讼、清收"];
    
    cell.aImageView.image = [UIImage imageNamed:imageArr[indexPath.row]];
    cell.bLabel.text = textArr[indexPath.row];
    cell.cLabel.text = detailArr[indexPath.row];
    cell.dLabel.text = deArr[indexPath.row];
    
    QDFWeakSelf;
    [cell.AuthenButton addAction:^(UIButton *btn) {
        if (indexPath.row == 0) {//认证个人
            AuthenPersonViewController *authenPersonVC = [[AuthenPersonViewController alloc] init];
            authenPersonVC.typeAuthen = self.typeAuthty;
            authenPersonVC.categoryString = [NSString stringWithFormat:@"%ld",indexPath.row+1];
            [weakself.navigationController pushViewController:authenPersonVC animated:YES];
        }else if (indexPath.row == 1){//认证律所
            AuthenLawViewController *authenLawVC = [[AuthenLawViewController alloc] init];
            authenLawVC.typeAuthen = self.typeAuthty;
            authenLawVC.categoryString = [NSString stringWithFormat:@"%ld",indexPath.row+1];
            [weakself.navigationController pushViewController:authenLawVC animated:YES];
        }else{//认证公司
            AuthenCompanyViewController *authenCompanyVC = [[AuthenCompanyViewController alloc] init];
            authenCompanyVC.typeAuthen = self.typeAuthty;
            authenCompanyVC.categoryString = [NSString stringWithFormat:@"%ld",indexPath.row+1];
            [weakself.navigationController pushViewController:authenCompanyVC animated:YES];
        }
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
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
