//
//  ApplicationListViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/1.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ApplicationListViewController.h"
#import "ApplicationGuaranteeViewController.h"
#import "ApplicationDetailsViewController.h"  //详情

#import "BaseCommitView.h"
#import "EvaTopSwitchView.h"
#import "PowerCell.h"
#import "MessageCell.h"

#import "ApplicationResponse.h"
#import "ApplicationModel.h"

@interface ApplicationListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) EvaTopSwitchView *applicationSwitchView;
@property (nonatomic,strong) UITableView *applicationListTableView;
@property (nonatomic,strong) BaseCommitView *applicationListCommitView;
@property (nonatomic,assign) BOOL didSetupConstraints;

//json
@property (nonatomic,strong) NSMutableArray *guaranteeListArray;
@property (nonatomic,assign) NSInteger pageGuarantee;
@property (nonatomic,strong) NSString *typeStr;

@end

@implementation ApplicationListViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self headerRefreshOfApplicationGuarantee];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的保函";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    self.typeStr = @"1";
    
    [self.view addSubview:self.applicationSwitchView];
    [self.view addSubview:self.applicationListTableView];
    [self.view addSubview:self.applicationListCommitView];
    [self.view addSubview:self.baseRemindImageView];
    [self.baseRemindImageView setHidden:YES];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.applicationSwitchView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.applicationSwitchView autoSetDimension:ALDimensionHeight toSize:50];
        
        [self.applicationListTableView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.applicationSwitchView];
        [self.applicationListTableView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.applicationListTableView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.applicationListTableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.applicationListCommitView];
        
        [self.applicationListCommitView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.applicationListCommitView autoSetDimension:ALDimensionHeight toSize:60];
        
        [self.baseRemindImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [self.baseRemindImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (EvaTopSwitchView *)applicationSwitchView
{
    if (!_applicationSwitchView) {
        _applicationSwitchView = [EvaTopSwitchView newAutoLayoutView];
        [_applicationSwitchView.shortLineLabel setHidden:YES];
        _applicationSwitchView.leftBlueConstraints.constant = 0;
        _applicationSwitchView.widthBlueConstraints.constant = kScreenWidth/2;
        _applicationSwitchView.backgroundColor = kNavColor;
        
        [_applicationSwitchView.getbutton setTitle:@"未完成的订单" forState:0];
        [_applicationSwitchView.sendButton setTitle:@"已完成的订单" forState:0];
        
        QDFWeakSelf;
        [_applicationSwitchView setDidSelectedButton:^(NSInteger tag) {
            if (tag == 33) {
                weakself.applicationSwitchView.leftBlueConstraints.constant = 0;
                [weakself.applicationSwitchView.getbutton setTitleColor:kBlueColor forState:0];
                [weakself.applicationSwitchView.sendButton setTitleColor:kBlackColor forState:0];
                
                weakself.typeStr = @"1";
                [weakself headerRefreshOfApplicationGuarantee];
                
            }else if (tag == 34){
                weakself.applicationSwitchView.leftBlueConstraints.constant = kScreenWidth/2;
                [weakself.applicationSwitchView.sendButton setTitleColor:kBlueColor forState:0];
                [weakself.applicationSwitchView.getbutton setTitleColor:kBlackColor forState:0];
                
                weakself.typeStr = @"2";
                [weakself headerRefreshOfApplicationGuarantee];
            }
        }];
    }
    return _applicationSwitchView;
}

- (UITableView *)applicationListTableView
{
    if (!_applicationListTableView) {
        _applicationListTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _applicationListTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _applicationListTableView.backgroundColor = kBackColor;
        _applicationListTableView.separatorColor = kSeparateColor;
        _applicationListTableView.delegate = self;
        _applicationListTableView.dataSource = self;
        _applicationListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
        [_applicationListTableView addHeaderWithTarget:self action:@selector(headerRefreshOfApplicationGuarantee)];
        [_applicationListTableView addFooterWithTarget:self action:@selector(footerRefreshOfApplicationGuarantee)];
    }
    return _applicationListTableView;
}

- (BaseCommitView *)applicationListCommitView
{
    if (!_applicationListCommitView) {
        _applicationListCommitView = [BaseCommitView newAutoLayoutView];
        [_applicationListCommitView.button setTitle:@"申请保函" forState:0];
        
        QDFWeakSelf;
        [_applicationListCommitView addAction:^(UIButton *btn) {
            UINavigationController *nav = weakself.navigationController;
            [nav popViewControllerAnimated:NO];
            
            ApplicationGuaranteeViewController *applicationGuaranteeVC = [[ApplicationGuaranteeViewController alloc] init];
            applicationGuaranteeVC.hidesBottomBarWhenPushed = YES;
            [nav pushViewController:applicationGuaranteeVC animated:NO];
        }];
    }
    return _applicationListCommitView;
}

- (NSMutableArray *)guaranteeListArray
{
    if (!_guaranteeListArray) {
        _guaranteeListArray = [NSMutableArray array];
    }
    return _guaranteeListArray;
}

#pragma mark -tableview delegate and datasoyrce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.guaranteeListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        return 65;
    }
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    
    ApplicationModel *applicationModel;
    if (self.guaranteeListArray.count > 0) {
        applicationModel = self.guaranteeListArray[indexPath.section];
    }
    
    if (indexPath.row == 0) {
        identifier = @"listas0";
        PowerCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[PowerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.orderButton.userInteractionEnabled = NO;

        NSString *orderID = [NSString stringWithFormat:@"  %@",applicationModel.orderid];
        [cell.orderButton setTitle:orderID forState:0];
        [cell.orderButton setImage:[UIImage imageNamed:@"Lette_of_guarantee"] forState:0];
        
        if ([applicationModel.status integerValue] == 1) {//审核中
            cell.statusLabel.text = @"审核中";
        }else if ([applicationModel.status integerValue] == 10) {//审核通过
            cell.statusLabel.text = @"审核通过";
        }else if ([applicationModel.status integerValue] == 20) {//协议已签订
            cell.statusLabel.text = @"协议已签订";
        }else if ([applicationModel.status integerValue] == 30) {//保函已出
            cell.statusLabel.text = @"保函已出";
        }else if ([applicationModel.status integerValue] == 40) {//完成／退保
            cell.statusLabel.text = @"完成/退保";
        }
        
        return cell;
        
    }else if(indexPath.row == 1){
        identifier = @"listas1";
        MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.countLabel setHidden:YES];
        [cell.actButton setHidden:YES];
        cell.userLabel.textColor = kGrayColor;
        cell.newsLabel.textColor = kGrayColor;
        cell.userLabel.font = kFirstFont;
        cell.newsLabel.font = kFirstFont;
        
        float moneyFloat = [applicationModel.money floatValue]/10000;
        NSString *moneyStr = [NSString stringWithFormat:@"%2.f万",moneyFloat];
        cell.userLabel.text = [NSString stringWithFormat:@"金额：%@",moneyStr];
        cell.timeLabel.text = [NSDate getYMDhmFormatterTime:applicationModel.created_at];
        cell.newsLabel.text = [NSString stringWithFormat:@"法院：%@",applicationModel.fayuan_name];
        
        return cell;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        
        ApplicationModel *appModel = self.guaranteeListArray[indexPath.section];
        
        ApplicationDetailsViewController *applicationDetailsVC = [[ApplicationDetailsViewController alloc] init];
        applicationDetailsVC.idString = appModel.idString;
        [self.navigationController pushViewController:applicationDetailsVC animated:YES];
    }
}

#pragma mark - refresh
- (void)getListsOfApplicationGuaranteeWithPage:(NSString *)page
{
    NSString *appGuaranteeString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kApplicationGuaranteeListString];
    NSDictionary *params = @{@"page" : page,
                             @"limit" : @"10",
                             @"type" : self.typeStr,  //未1，已2
                             @"token" : [self getValidateToken]
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:appGuaranteeString params:params successBlock:^(id responseObject) {
        
        if ([page integerValue] == 1) {
            [weakself.guaranteeListArray removeAllObjects];
        }
        
        ApplicationResponse *response = [ApplicationResponse objectWithKeyValues:responseObject];
        
        if (response.result.count == 0) {
            _pageGuarantee--;
        }
        
        for (ApplicationModel *applicationModel in response.result) {
            [weakself.guaranteeListArray addObject:applicationModel];
        }
        
        if (weakself.guaranteeListArray.count == 0) {
            [weakself.baseRemindImageView setHidden:NO];
        }else{
            [weakself.baseRemindImageView setHidden:YES];
        }
        
        [weakself.applicationListTableView reloadData];
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)headerRefreshOfApplicationGuarantee
{
    _pageGuarantee = 1;
    [self getListsOfApplicationGuaranteeWithPage:@"1"];
    
    QDFWeakSelf;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakself.applicationListTableView headerEndRefreshing];
    });
}

- (void)footerRefreshOfApplicationGuarantee
{
    _pageGuarantee++;
    NSString *page = [NSString stringWithFormat:@"%ld",(long)_pageGuarantee];
    [self getListsOfApplicationGuaranteeWithPage:page];
    
    QDFWeakSelf;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakself.applicationListTableView footerEndRefreshing];
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
