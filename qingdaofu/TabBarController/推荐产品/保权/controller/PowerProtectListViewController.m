//
//  PowerProtectListViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/1.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "PowerProtectListViewController.h"

#import "PowerProtectViewController.h" //申请保全
#import "PowerDetailsViewController.h"  //保权详情

#import "BaseCommitView.h"
#import "EvaTopSwitchView.h"
#import "PowerCell.h"
#import "MessageCell.h"

#import "PowerResponse.h"
#import "PowerModel.h"

@interface PowerProtectListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) EvaTopSwitchView *powerSwitchView;
@property (nonatomic,strong) UITableView *powerListTableView;
@property (nonatomic,strong) BaseCommitView *powerListCommitView;
@property (nonatomic,assign) BOOL didSetupConstraints;

@property (nonatomic,strong) NSString *typeString;
@property (nonatomic,assign) NSInteger pagePower;
@property (nonatomic,strong) NSMutableArray *powerListArray;
@end

@implementation PowerProtectListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的保全";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    self.typeString = @"1";
    
    [self.view addSubview:self.powerSwitchView];
    [self.view addSubview:self.powerListTableView];
    [self.view addSubview:self.powerListCommitView];
    [self.view addSubview:self.baseRemindImageView];
    [self.baseRemindImageView setHidden:YES];
    
    [self.view setNeedsUpdateConstraints];
    
    [self headerRefreshOfPowerList];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.powerSwitchView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.powerSwitchView autoSetDimension:ALDimensionHeight toSize:50];
        
        [self.powerListTableView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.powerSwitchView];
        [self.powerListTableView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.powerListTableView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.powerListTableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.powerListCommitView];
        
        [self.powerListCommitView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.powerListCommitView autoSetDimension:ALDimensionHeight toSize:60];
        
        [self.baseRemindImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [self.baseRemindImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (EvaTopSwitchView *)powerSwitchView
{
    if (!_powerSwitchView) {
        _powerSwitchView = [EvaTopSwitchView newAutoLayoutView];
        [_powerSwitchView.shortLineLabel setHidden:YES];
        _powerSwitchView.leftBlueConstraints.constant = 0;
        _powerSwitchView.widthBlueConstraints.constant = kScreenWidth/2;
        _powerSwitchView.backgroundColor = kWhiteColor;
        
        [_powerSwitchView.getbutton setTitle:@"未完成的订单" forState:0];
        [_powerSwitchView.sendButton setTitle:@"已完成的订单" forState:0];
        
        QDFWeakSelf;
        [_powerSwitchView setDidSelectedButton:^(NSInteger tag) {
            [weakself.powerListArray removeAllObjects];
            if (tag == 33) {
                weakself.powerSwitchView.leftBlueConstraints.constant = 0;
                [weakself.powerSwitchView.getbutton setTitleColor:kBlueColor forState:0];
                [weakself.powerSwitchView.sendButton setTitleColor:kBlackColor forState:0];
                weakself.typeString = @"1";
            }else if (tag == 34){
                weakself.powerSwitchView.leftBlueConstraints.constant = kScreenWidth/2;
                [weakself.powerSwitchView.sendButton setTitleColor:kBlueColor forState:0];
                [weakself.powerSwitchView.getbutton setTitleColor:kBlackColor forState:0];
                weakself.typeString = @"2";
            }
            [weakself headerRefreshOfPowerList];
        }];
    }
    return _powerSwitchView;
}

- (UITableView *)powerListTableView
{
    if (!_powerListTableView) {
        _powerListTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _powerListTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _powerListTableView.delegate = self;
        _powerListTableView.dataSource = self;
        _powerListTableView.backgroundColor = kBackColor;
        _powerListTableView.separatorColor = kSeparateColor;
        _powerListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
        [_powerListTableView addHeaderWithTarget:self action:@selector(headerRefreshOfPowerList)];
        [_powerListTableView addFooterWithTarget:self action:@selector(footerRefreshOfPowerList)];
    }
    return _powerListTableView;
}

- (BaseCommitView *)powerListCommitView
{
    if (!_powerListCommitView) {
        _powerListCommitView = [BaseCommitView newAutoLayoutView];
        [_powerListCommitView.button setTitle:@"申请保全" forState:0];
        
        QDFWeakSelf;
        [_powerListCommitView addAction:^(UIButton *btn) {
            UINavigationController *nav = weakself.navigationController;
            [nav popViewControllerAnimated:NO];
            [nav popViewControllerAnimated:NO];
            [nav popViewControllerAnimated:NO];
            
            PowerProtectViewController *powerProtectVC = [[PowerProtectViewController alloc] init];
            powerProtectVC.hidesBottomBarWhenPushed = YES;
            [nav pushViewController:powerProtectVC animated:NO];
        }];
    }
    return _powerListCommitView;
}

- (NSMutableArray *)powerListArray
{
    if (!_powerListArray) {
        _powerListArray = [NSMutableArray array];
    }
    return _powerListArray;
}

#pragma mark -tableview delegate and datasoyrce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.powerListArray.count;
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
    
    PowerModel *tModel = self.powerListArray[indexPath.section];

    if (indexPath.row == 0) {
        identifier = @"listas0";
        PowerCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[PowerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.orderButton.userInteractionEnabled = NO;
        
        NSString *orderID = [NSString stringWithFormat:@"  %@",tModel.number];
        [cell.orderButton setTitle:orderID forState:0];
        [cell.orderButton setImage:[UIImage imageNamed:@"right"] forState:0];
        
        if ([tModel.status integerValue] == 1) {//审核中
            [cell.statusButton setTitle:@"审核中" forState:0];
        }else if ([tModel.status integerValue] == 10) {//审核通过
            [cell.statusButton setTitle:@"审核通过" forState:0];
        }else if ([tModel.status integerValue] == 20) {//协议已签订
            [cell.statusButton setTitle:@"协议已签订" forState:0];
        }else if ([tModel.status integerValue] == 30) {//保函已出
            [cell.statusButton setTitle:@"保全已出" forState:0];
        }else if ([tModel.status integerValue] == 40) {//完成／退保
            [cell.statusButton setTitle:@"完成/退保" forState:0];
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

        float account = [tModel.account floatValue]/10000;
        cell.userLabel.text = [NSString stringWithFormat:@"金额：%2.f万",account];
        cell.timeLabel.text = [NSDate getYMDhmFormatterTime:tModel.create_time];
        cell.newsLabel.text = [NSString stringWithFormat:@"法院：%@",tModel.fayuan_name];
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
        PowerModel *pModel = self.powerListArray[indexPath.section];
        PowerDetailsViewController *powerDetailsVC = [[PowerDetailsViewController alloc] init];
        powerDetailsVC.idString = pModel.idString;
        [self.navigationController pushViewController:powerDetailsVC animated:YES];
    }
}

#pragma mark - method
- (void)getPowerAssessListWithPage:(NSString *)page
{
    NSString *assessListString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kPowerAssessListString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"page" : page,
                             @"limit" : @"10",
                             @"type" : self.typeString //1未完成，2已完成
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:assessListString params:params successBlock:^(id responseObject) {
        
        if ([page integerValue] == 1) {
            [weakself.powerListArray removeAllObjects];
            _pagePower = 1;
        }
        
        PowerResponse *responsey = [PowerResponse objectWithKeyValues:responseObject];
        
        if (responsey.data.count == 0) {
            _pagePower--;
        }
        
        for (PowerModel *tModel in responsey.data) {
            [weakself.powerListArray addObject:tModel];
        }
        
        if (weakself.powerListArray.count > 0) {
            [weakself.baseRemindImageView setHidden:YES];
        }else{
            [weakself.baseRemindImageView setHidden:NO];
        }
        
        [weakself.powerListTableView reloadData];
        
    } andFailBlock:^(NSError *error) {
        if ([page integerValue] == 1) {
            [weakself.powerListArray removeAllObjects];
            _pagePower = 1;
        }
    }];
}

- (void)headerRefreshOfPowerList
{
    _pagePower = 1;
    [self getPowerAssessListWithPage:@"1"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.powerListTableView headerEndRefreshing];
    });
}

- (void)footerRefreshOfPowerList
{
    _pagePower++;
    NSString *page = [NSString stringWithFormat:@"%ld",_pagePower];
    [self getPowerAssessListWithPage:page];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.powerListTableView footerEndRefreshing];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based powerlication, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
