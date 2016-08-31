//
//  PaceViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/5.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "PaceViewController.h"

#import "MyScheduleViewController.h"

#import "BaseCommitView.h"
#import "MineUserCell.h"
#import "EditDebtAddressCell.h"

#import "PaceResponse.h"
#import "PaceModel.h"

@interface PaceViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstarits;
@property (nonatomic,strong) UITableView *paceTableView;
@property (nonatomic,strong) BaseCommitView *paceCommitView;
@property (nonatomic,strong) NSMutableArray *paceDataArray;

@property (nonatomic,assign) NSInteger pagePace;

@end

@implementation PaceViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self headerRefreshOfPace];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"处理进度";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.paceTableView];
    
    if ([self.existence integerValue] == 2) {
        [self.view addSubview:self.paceCommitView];
    }
    
    [self.view addSubview:self.baseRemindImageView];
    [self.baseRemindImageView setHidden:YES];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstarits) {
        
        if ([self.existence integerValue] == 2) {
            [self.paceTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
            [self.paceTableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.paceCommitView];
            
            [self.paceCommitView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
            [self.paceCommitView autoSetDimension:ALDimensionHeight toSize:kCellHeight1];
        }else{
            [self.paceTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        }
        
        [self.baseRemindImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.baseRemindImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        self.didSetupConstarits = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)paceTableView
{
    if (!_paceTableView) {
        _paceTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _paceTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _paceTableView.backgroundColor = kBackColor;
        _paceTableView.separatorColor = kSeparateColor;
        _paceTableView.delegate = self;
        _paceTableView.dataSource = self;
        _paceTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
        [_paceTableView addHeaderWithTarget:self action:@selector(headerRefreshOfPace)];
        [_paceTableView addFooterWithTarget:self action:@selector(footerRefreshOfPace)];
    }
    return _paceTableView;
}

- (BaseCommitView *)paceCommitView
{
    if (!_paceCommitView) {
        _paceCommitView = [BaseCommitView newAutoLayoutView];
        [_paceCommitView.button setTitle:@"新增进度" forState:0];
        
        QDFWeakSelf;
        [_paceCommitView addAction:^(UIButton *btn) {
            NSLog(@"填写进度");
            MyScheduleViewController *myScheduleVC = [[MyScheduleViewController alloc] init];
            myScheduleVC.idString = weakself.idString;
            myScheduleVC.categoryString = weakself.categoryString;
            [weakself.navigationController pushViewController:myScheduleVC animated:YES];
        }];
    }
    return _paceCommitView;
}

- (NSMutableArray *)paceDataArray
{
    if (!_paceDataArray) {
        _paceDataArray = [NSMutableArray array];
    }
    return _paceDataArray;
}

#pragma mark - delegate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.paceDataArray.count > 0) {
        if ([self.categoryString integerValue] == 3) {
            return 4;
        }else{
            return 2;
        }
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.paceDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return 145;
    if ([self.categoryString integerValue] == 3) {
        return kCellHeight;
    }
    
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    if ([self.categoryString integerValue] == 3) {//诉讼
        identifier = @"pace3";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.userNameButton.titleLabel.font = kFirstFont;
        [cell.userNameButton setTitleColor:kLightGrayColor forState:0];
        cell.userActionButton.titleLabel.font = kBigFont;
        [cell.userActionButton setTitleColor:kBlackColor forState:0];
        NSArray *susongArray = @[@"案号类型",@"案号",@"处置类型",@"详情"];
        [cell.userNameButton setTitle:susongArray[indexPath.row] forState:0];
        
        PaceModel *sModel;
        if (self.paceDataArray.count > 0) {
            sModel = self.paceDataArray[indexPath.section];
        }
        
        NSArray *array1 = @[@"一审",@"二审",@"再审",@"执行"];
        NSArray *array2 = @[@"债权人上传处置资产",@"律师接单",@"双方洽谈",@"向法院起诉(财产保全)",@"整理诉讼材料",@"法院立案",@"向当事人发出开庭传票",@"开庭前调解",@"开庭",@"判决",@"二次开庭",@"二次判决",@"移交执行局申请执行",@"执行中提供借款人的财产线索",@"调查(公告)",@"拍卖",@"流拍",@"拍卖成功",@"付费"];
        NSInteger a1 = [sModel.audit intValue];
        NSInteger a2 = [sModel.status intValue]-1;
        NSString *caseString = [NSString getValidStringFromString:sModel.caseString];
        NSString *content = [NSString getValidStringFromString:sModel.content];
        
        if (indexPath.row == 0) {
            [cell.userActionButton setTitle:array1[a1] forState:0];
        }else if (indexPath.row == 1){
            [cell.userActionButton setTitle:caseString forState:0];
        }else if (indexPath.row == 2){
            [cell.userActionButton setTitle:array2[a2] forState:0];
        }else if (indexPath.row == 3){
            [cell.userActionButton setTitle:content forState:0];
        }
        
        return cell;
    }
    
    //清收
    identifier = @"pace32";
    MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.userNameButton.titleLabel.font = kFirstFont;
    [cell.userNameButton setTitleColor:kLightGrayColor forState:0];
    cell.userActionButton.titleLabel.font = kBigFont;
    [cell.userActionButton setTitleColor:kBlackColor forState:0];
    NSArray *susongArray = @[@"处置类型",@"详情"];
    [cell.userNameButton setTitle:susongArray[indexPath.row] forState:0];
    
    PaceModel *qModel;
    if (self.paceDataArray.count > 0) {
        qModel = self.paceDataArray[indexPath.section];
    }
    
    NSArray *array4 = @[@"电话",@"上门",@"面谈"];
    NSInteger a4 = [qModel.status intValue]-1;
    NSString *content = [NSString getValidStringFromString:qModel.content];
    if (indexPath.row == 0) {
        [cell.userActionButton setTitle:array4[a4] forState:0];
    }else if (indexPath.row == 1){
        [cell.userActionButton setTitle:content forState:0];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headerTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 35)];
    headerTimeLabel.textAlignment = NSTextAlignmentCenter;
    headerTimeLabel.textColor = kLightGrayColor;
    headerTimeLabel.font = kSmallFont;
    
    PaceModel *sModel;
    if (self.paceDataArray.count > 0) {
        sModel = self.paceDataArray[section];
    }
    
    headerTimeLabel.text = [NSDate getYMDhmFormatterTime:sModel.create_time];
    
    return headerTimeLabel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

#pragma mark - method
- (void)getPaceMessagesListWithPage:(NSString *)page
{
    NSString *paceString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kLookUpScheduleString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"id" : self.idString,
                             @"category" : self.categoryString,
                             @"page" : page
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:paceString params:params successBlock:^(id responseObject) {
        
        NSDictionary *ioioioi = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([page integerValue] == 1) {
            [weakself.paceDataArray removeAllObjects];
        }
        
        PaceResponse *response = [PaceResponse objectWithKeyValues:responseObject];
        
        if (response.disposing.count == 0) {
            _pagePace--;
            [weakself showHint:@"没有更多了"];
        }
        
        for (PaceModel *paceModel in response.disposing) {
            [weakself.paceDataArray addObject:paceModel];
        }
        
        if (weakself.paceDataArray.count > 0) {
            [weakself.baseRemindImageView setHidden:YES];
        }else{
            [weakself.baseRemindImageView setHidden:NO];
        }
        
        [weakself.paceTableView reloadData];
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)headerRefreshOfPace
{
    _pagePace = 1;
    [self getPaceMessagesListWithPage:@"1"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.paceTableView headerEndRefreshing];
    });
}

- (void)footerRefreshOfPace
{
    _pagePace++;
    NSString *page = [NSString stringWithFormat:@"%ld",(long)_pagePace];
    [self getPaceMessagesListWithPage:page];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.paceTableView footerEndRefreshing];
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
