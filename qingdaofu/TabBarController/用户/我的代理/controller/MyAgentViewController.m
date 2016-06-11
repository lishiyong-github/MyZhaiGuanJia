//
//  MyAgentViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/17.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MyAgentViewController.h"

#import "AddMyAgentViewController.h"

#import "MyAgentCell.h"
#import "BaseCommitButton.h"

#import "UIView+UITextColor.h"

@interface MyAgentViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *myAgentTableView;
@property (nonatomic,strong) BaseCommitButton *myAgentCommitButton;

@end

@implementation MyAgentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"代理人详情";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.myAgentTableView];
    [self.view addSubview:self.myAgentCommitButton];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.myAgentTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.myAgentTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kTabBarHeight];
        
        [self.myAgentCommitButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.myAgentCommitButton autoSetDimension:ALDimensionHeight toSize:kTabBarHeight];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)myAgentTableView
{
    if (!_myAgentTableView) {
        _myAgentTableView = [UITableView newAutoLayoutView];
        _myAgentTableView.delegate = self;
        _myAgentTableView.dataSource = self;
        _myAgentTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
        _myAgentTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
        _myAgentTableView.backgroundColor = kBackColor;
    }
    return _myAgentTableView;
}

- (BaseCommitButton *)myAgentCommitButton
{
    if (!_myAgentCommitButton) {
        _myAgentCommitButton = [BaseCommitButton newAutoLayoutView];
        [_myAgentCommitButton setTitle:@"停用" forState:0];
        QDFWeakSelf;
        [_myAgentCommitButton addAction:^(UIButton *btn) {
            
            UIAlertController *agentAlertVC = [UIAlertController alertControllerWithTitle:@"" message:@"确认停用？" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *agentAct0 = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [btn setBackgroundColor:kSelectedColor];
                btn.userInteractionEnabled = YES;
            }];
            
            UIAlertAction *agentAct1 = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:nil];
            
            [agentAlertVC addAction:agentAct0];
            [agentAlertVC addAction:agentAct1];
            
            [weakself presentViewController:agentAlertVC animated:YES completion:nil];
        }];
    }
    return _myAgentCommitButton;
}

#pragma mark - tableView delegate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"myAgent";
    MyAgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MyAgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSMutableAttributedString *str1 = [cell.agentNameLabel setAttributeString:@"姓        名：" withColor:kBlackColor andSecond:@"张三三" withColor:kLightGrayColor withFont:12];
    [cell.agentNameLabel setAttributedText:str1];
    
    NSMutableAttributedString *str2 = [cell.agentTelLabel setAttributeString:@"联系方式：" withColor:kBlackColor andSecond:@"12345678900" withColor:kLightGrayColor withFont:12];
    [cell.agentTelLabel setAttributedText:str2];
    
    NSMutableAttributedString *str3 = [cell.agentIDLabel setAttributeString:@"身份证号：" withColor:kBlackColor andSecond:@"123456789856432134" withColor:kLightGrayColor withFont:12];
    [cell.agentIDLabel setAttributedText:str3];
    
    NSMutableAttributedString *str4 = [cell.agentCerLabel setAttributeString:@"执业证号：" withColor:kBlackColor andSecond:@"1234455555555555555" withColor:kLightGrayColor withFont:12];
    [cell.agentCerLabel setAttributedText:str4];
    
    NSMutableAttributedString *str5 = [cell.agentPassLabel setAttributeString:@"登录密码：" withColor:kBlackColor andSecond:@"123ghjk" withColor:kLightGrayColor withFont:12];
    [cell.agentPassLabel setAttributedText:str5];
    
    QDFWeakSelf;
    [cell.agentEditButton addAction:^(UIButton *btn) {
        AddMyAgentViewController *addMyagentVc = [[AddMyAgentViewController alloc] init];
        [weakself.navigationController pushViewController:addMyagentVc animated:YES];
    }];
    
    return cell;
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
