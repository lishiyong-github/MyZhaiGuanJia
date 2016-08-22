//
//  MyAgentViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/17.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MyAgentViewController.h"

#import "AddMyAgentViewController.h"  //编辑

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
        _myAgentTableView.separatorColor = kSeparateColor;
    }
    return _myAgentTableView;
}

- (BaseCommitButton *)myAgentCommitButton
{
    if (!_myAgentCommitButton) {
        _myAgentCommitButton = [BaseCommitButton newAutoLayoutView];
        
        if ([self.agentModel.isstop intValue] == 0) {//正常
            [_myAgentCommitButton setTitle:@"停用" forState:0];
        }else if ([self.agentModel.isstop intValue] == 1){//停用
            [_myAgentCommitButton setTitle:@"已停用" forState:0];
            _myAgentCommitButton.backgroundColor = kSelectedColor;
            _myAgentCommitButton.userInteractionEnabled = NO;
            [_myAgentCommitButton setTitleColor:kBlackColor forState:0];
        }
        
        QDFWeakSelf;
        [_myAgentCommitButton addAction:^(UIButton *btn) {
            
            UIAlertController *agentAlertVC = [UIAlertController alertControllerWithTitle:@"" message:@"确认停用？" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *agentAct0 = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakself stopAgent];
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
    
    NSString *nameStr = [NSString getValidStringFromString:self.agentModel.username];
    NSMutableAttributedString *str1 = [cell.agentNameLabel setAttributeString:@"姓        名：" withColor:kBlackColor andSecond:nameStr withColor:kLightGrayColor withFont:12];
    [cell.agentNameLabel setAttributedText:str1];
    
    NSString *mobileStr = [NSString getValidStringFromString:self.agentModel.mobile];
    NSMutableAttributedString *str2 = [cell.agentTelLabel setAttributeString:@"联系方式：" withColor:kBlackColor andSecond:mobileStr withColor:kLightGrayColor withFont:12];
    [cell.agentTelLabel setAttributedText:str2];
    
    NSString *cardnoStr = [NSString getValidStringFromString:self.agentModel.cardno];
    NSMutableAttributedString *str3 = [cell.agentIDLabel setAttributeString:@"身份证号：" withColor:kBlackColor andSecond:cardnoStr withColor:kLightGrayColor withFont:12];
    [cell.agentIDLabel setAttributedText:str3];
    
    
    NSString *zycardno = [NSString getValidStringFromString:self.agentModel.zycardno];
    NSMutableAttributedString *str4 = [cell.agentCerLabel setAttributeString:@"执业证号：" withColor:kBlackColor andSecond:zycardno withColor:kLightGrayColor withFont:12];
    [cell.agentCerLabel setAttributedText:str4];
    
    NSMutableAttributedString *str5 = [cell.agentPassLabel setAttributeString:@"登录密码：" withColor:kBlackColor andSecond:@"******" withColor:kLightGrayColor withFont:12];
    [cell.agentPassLabel setAttributedText:str5];
    
    if ([self.agentModel.isstop intValue] == 0) {//正常
        [cell.agentEditButton setTitle:@"编辑" forState:0];
        QDFWeakSelf;
        [cell.agentEditButton addAction:^(UIButton *btn) {
            AddMyAgentViewController *addMyagentVC = [[AddMyAgentViewController alloc] init];
            addMyagentVC.model = weakself.agentModel;
            addMyagentVC.agentFlagString = @"update";
            
            [addMyagentVC setDidSaveModel:^(UserModel *uModel) {
                weakself.agentModel = uModel;
                [weakself.myAgentTableView reloadData];
            }];
            
            [weakself.navigationController pushViewController:addMyagentVC animated:YES];
        }];
    }else if ([self.agentModel.isstop intValue] == 1){//停用
        [cell.agentEditButton setHidden:YES];
    }
    
    return cell;
}

#pragma mark - method
- (void)stopAgent
{
    NSString *stopString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyAgentStopString];
    NSDictionary *params = @{@"id" : self.agentModel.idString,
                             @"status" : @"0",
                             @"token" : [self getValidateToken],
                             @"limit" : @"10"
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:stopString params:params successBlock:^(id responseObject) {
        BaseModel *reModel = [BaseModel objectWithKeyValues:responseObject];
        [weakself showHint:reModel.msg];
        if ([reModel.code isEqualToString:@"0000"]) {
            [weakself.navigationController popViewControllerAnimated:YES];
        }
    } andFailBlock:^(NSError *error) {
        
    }];
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
