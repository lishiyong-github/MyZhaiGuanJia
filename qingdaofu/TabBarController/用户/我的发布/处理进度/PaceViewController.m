//
//  PaceViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/5.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "PaceViewController.h"

//#import "BaseCommitView.h"
//#import "EditDebtAddressCell.h"

#import "MineUserCell.h"
#import "ProgressCell.h"

#import "PaceResponse.h"
#import "OrdersLogsModel.h"

#import "UIImageView+WebCache.h"

@interface PaceViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstarits;
@property (nonatomic,strong) UITableView *paceTableView;
//@property (nonatomic,strong) BaseCommitView *paceCommitView;
@property (nonatomic,strong) NSMutableArray *paceDataArray;

@property (nonatomic,assign) NSInteger pagePace;

@end

@implementation PaceViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self getPaceMessagesList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"处理进度";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.paceTableView];
    
//    if ([self.existence integerValue] == 2) {
//        [self.view addSubview:self.paceCommitView];
//    }
    
    [self.view addSubview:self.baseRemindImageView];
    [self.baseRemindImageView setHidden:YES];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstarits) {
        
        [self.paceTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        [self.baseRemindImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.baseRemindImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        self.didSetupConstarits = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)paceTableView
{
    if (!_paceTableView) {
        _paceTableView = [UITableView newAutoLayoutView];
        _paceTableView.backgroundColor = kBackColor;
        _paceTableView.separatorColor = [UIColor clearColor];
        _paceTableView.delegate = self;
        _paceTableView.dataSource = self;
        _paceTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
    }
    return _paceTableView;
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
        return 3;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{   
    return kCellHeight4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"pace";
    ProgressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ProgressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    OrdersLogsModel *logsModel = self.paceDataArray[indexPath.row];
    
    
    cell.ppLabel.text = [NSDate getYMDhmsFormatterTime:logsModel.action_at];
    cell.ppLabel.font = kSmallFont;
    cell.ppLabel.textAlignment = 2;
    
    NSString *textxx = [NSString getValidStringFromString:logsModel.memo toString:@"无内容"];
    [cell.ppTextButton setTitle:textxx forState:0];
    [cell.ppTextButton setTitleColor:kGrayColor forState:0];
    cell.ppTextButton.titleLabel.font = kFirstFont;
    cell.ppTextButton.contentHorizontalAlignment = 1;
    cell.ppTextButton.contentEdgeInsets = UIEdgeInsetsZero;
    
    if (indexPath.row == 0) {
        [cell.ppLine1 setHidden:YES];
    }else if (indexPath.row == self.paceDataArray.count-1){
        [cell.ppLine2 setHidden:YES];
    }
    
    return cell;
}

#pragma mark - method
- (void)getPaceMessagesList
{
    NSString *paceString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyorderDetailOfProgressLogs];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"ordersid" : self.ordersid
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:paceString params:params successBlock:^(id responseObject) {
        
        NSDictionary *apapa = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        PaceResponse *response = [PaceResponse objectWithKeyValues:responseObject];
        
        for (OrdersLogsModel *logsModel in response.data) {
            [weakself.paceDataArray addObject:logsModel];
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

//- (void)headerRefreshOfPace
//{
//    _pagePace = 1;
//    [self getPaceMessagesListWithPage:@"1"];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.paceTableView headerEndRefreshing];
//    });
//}
//
//- (void)footerRefreshOfPace
//{
//    _pagePace++;
//    NSString *page = [NSString stringWithFormat:@"%ld",(long)_pagePace];
//    [self getPaceMessagesListWithPage:page];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.paceTableView footerEndRefreshing];
//    });
//}

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
