//
//  DebtCreditMessageViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/17.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "DebtCreditMessageViewController.h"

#import "EditDebtCreditMessageViewController.h"

#import "BaseCommitButton.h"
#import "DebtCell.h"

#import "UIView+UITextColor.h"

@interface DebtCreditMessageViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *debtCreditTableView;
@property (nonatomic,strong) BaseCommitButton *debtCreditCommitButton;

@end

@implementation DebtCreditMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"债权人信息";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.debtCreditTableView];
    [self.view addSubview:self.debtCreditCommitButton];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.debtCreditTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.debtCreditTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kTabBarHeight];
        
        [self.debtCreditCommitButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.debtCreditCommitButton autoSetDimension:ALDimensionHeight toSize:kTabBarHeight];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)debtCreditTableView
{
    if (!_debtCreditTableView) {
//        _debtCreditTableView = [UITableView newAutoLayoutView];
        _debtCreditTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _debtCreditTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        _debtCreditTableView.delegate = self;
        _debtCreditTableView.dataSource = self;
        _debtCreditTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
        _debtCreditTableView.backgroundColor = kBackColor;
    }
    return _debtCreditTableView;
}

- (BaseCommitButton *)debtCreditCommitButton
{
    if (!_debtCreditCommitButton) {
        _debtCreditCommitButton = [BaseCommitButton newAutoLayoutView];
        QDFWeakSelf;
        [_debtCreditCommitButton addAction:^(UIButton *btn) {
            EditDebtCreditMessageViewController *editDebtCreditMessageVC = [[EditDebtCreditMessageViewController alloc] init];
            [weakself.navigationController pushViewController:editDebtCreditMessageVC animated:YES];
        }];
        
        if ([self.tagString integerValue] == 1) {
            [_debtCreditCommitButton setTitle:@"继续添加" forState:0];
        }else{
            [_debtCreditCommitButton setTitle:@"添加" forState:0];
        }
    }
    return _debtCreditCommitButton;
}

#pragma mark - tableView delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.tagString integerValue] == 1) {
        return 4;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"debtCredit";
    DebtCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[DebtCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSMutableAttributedString *nameStr = [cell.debtNameLabel setAttributeString:@"姓        名    " withColor:kBlackColor andSecond:@"离意义" withColor:kLightGrayColor withFont:12];
    [cell.debtNameLabel setAttributedText:nameStr];
    
    NSMutableAttributedString *telStr = [cell.debtTelLabel setAttributeString:@"联系方式    " withColor:kBlackColor andSecond:@"12345678905" withColor:kLightGrayColor withFont:12];
    [cell.debtTelLabel setAttributedText:telStr];
    
    cell.debtAddressLabel.text = @"联系地址";
    cell.debtAddressLabel1.text = @"上海市浦东新区浦东南路855号世界广场34楼清道夫债管家";
    
    NSMutableAttributedString *IDStr = [cell.debtIDLabel setAttributeString:@"证件号        " withColor:kBlackColor andSecond:@"1234567890456789566" withColor:kLightGrayColor withFont:12];
    [cell.debtIDLabel setAttributedText:IDStr];
    
    QDFWeakSelf;
    [cell.debtEditButton addAction:^(UIButton *btn) {
        EditDebtCreditMessageViewController *editDebtCreditMessageVc = [[EditDebtCreditMessageViewController alloc] init];
        [weakself.navigationController pushViewController:editDebtCreditMessageVc animated:YES];
    }];
    
    return cell;
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
