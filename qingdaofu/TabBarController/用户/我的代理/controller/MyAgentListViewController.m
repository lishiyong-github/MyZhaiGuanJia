//
//  MyAgentListViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/19.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MyAgentListViewController.h"
#import "MyAgentViewController.h"  //我的代理详细
#import "AddMyAgentViewController.h"  //继续添加代理

#import "MineUserCell.h"

#import "PublishingResponse.h"
#import "UserModel.h"

@interface MyAgentListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *myAgentListTableView;
@property (nonatomic,strong) NSMutableArray *agentDataList;
@property (nonatomic,assign) NSInteger pageAgent;

@end

@implementation MyAgentListViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self headerRefreshOfMyAgent];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"代理人列表";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    
    if ([self.typePid isEqualToString:@"本人"]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(goToAddAgent)];
    }
    
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:kBigFont,NSForegroundColorAttributeName:kBlueColor} forState:0];

    _pageAgent = 1;
    
    [self.view addSubview:self.myAgentListTableView];
    [self.view addSubview:self.baseRemindImageView];
    [self.baseRemindImageView setHidden:YES];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.myAgentListTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        [self.baseRemindImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [self.baseRemindImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)myAgentListTableView
{
    if (!_myAgentListTableView) {
        _myAgentListTableView = [UITableView newAutoLayoutView];
        _myAgentListTableView.delegate = self;
        _myAgentListTableView.dataSource = self;
        _myAgentListTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
        _myAgentListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
        _myAgentListTableView.backgroundColor = kBackColor;
        [_myAgentListTableView addHeaderWithTarget:self action:@selector(headerRefreshOfMyAgent)];
        [_myAgentListTableView addFooterWithTarget:self action:@selector(footerRefreshOfMyAgent)];
    }
    return _myAgentListTableView;
}

- (NSMutableArray *)agentDataList
{
    if (!_agentDataList) {
        _agentDataList = [NSMutableArray array];
    }
    return _agentDataList;
}

#pragma mark - tableView delegate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.agentDataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"agentList";
    MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];
    if (!cell) {
        cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    /* 
     正常状态：kBlackColor：kBlueColor
     停用状态：kLightGrayColor:kBlackColor:kLightGrayColor
     */
    UserModel *model = self.agentDataList[indexPath.row];
    
    NSMutableAttributedString *agentnameStr;
    if ([model.isstop intValue] == 0) {//正常
        agentnameStr = [cell.userNameButton setAttributeString:model.username withColor:kBlackColor andSecond:@"" withColor:kBlackColor withFont:15];
        [cell.userActionButton setImage:[UIImage imageNamed:@"more"] forState:0];
        [cell.userActionButton setTitleColor:kBlueColor forState:0];
    }else if ([model.isstop intValue] == 1){//停用
        agentnameStr = [cell.userNameButton setAttributeString:model.username withColor:kLightGrayColor andSecond:@" [停用]" withColor:kBlackColor withFont:15];
        [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        [cell.userActionButton setTitleColor:kLightGrayColor forState:0];
    }
    
    [cell.userNameButton setAttributedTitle:agentnameStr forState:0];
    [cell.userActionButton setTitle:model.mobile forState:0];
    cell.userActionButton.titleLabel.font = kBigFont;
    cell.userNameButton.userInteractionEnabled = NO;
    cell.userActionButton.userInteractionEnabled = NO;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UserModel *userModel = self.agentDataList[indexPath.row];
    MyAgentViewController *myAgentVC = [[MyAgentViewController alloc] init];
    myAgentVC.agentModel = userModel;
    [self.navigationController pushViewController:myAgentVC animated:YES];
}

#pragma mark - method
- (void)goToAddAgent
{
    AddMyAgentViewController *addMyAgentVC = [[AddMyAgentViewController alloc] init];
    addMyAgentVC.agentFlagString = @"add";
    [self.navigationController pushViewController:addMyAgentVC animated:YES];
}

- (void)getMyagentListWithPage:(NSString *)page
{
    NSString *agentListString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyAgentString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"page" : page
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:agentListString params:params successBlock:^(id responseObject){
        
        if ([page integerValue] == 1) {
            [weakself.agentDataList removeAllObjects];
        }
        
        PublishingResponse *resultModel = [PublishingResponse objectWithKeyValues:responseObject];
        
        if (resultModel.user.count > 0) {
            [weakself.navigationItem.rightBarButtonItem setTitle:@"继续添加"];
        }else{
            _pageAgent--;
            [weakself showHint:@"没有更多"];
        }
        
        for (UserModel *userModel in resultModel.user) {
            [weakself.agentDataList addObject:userModel];
        }
        
        if (weakself.agentDataList.count > 0) {
            [weakself.baseRemindImageView setHidden:YES];
        }else{
            [weakself.baseRemindImageView setHidden:NO];
        }
        
        [weakself.myAgentListTableView reloadData];
        
    } andFailBlock:^(NSError *error){
        
    }];
}

- (void)headerRefreshOfMyAgent
{
    _pageAgent = 1;
    [self getMyagentListWithPage:@"1"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.myAgentListTableView headerEndRefreshing];
    });
}

- (void)footerRefreshOfMyAgent
{
    _pageAgent ++;
    NSString *page = [NSString stringWithFormat:@"%d",_pageAgent];
    [self getMyagentListWithPage:page];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.myAgentListTableView footerEndRefreshing];
    });
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
