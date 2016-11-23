//
//  MySaveViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/4/29.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MySaveViewController.h"

#import "ReportSuitViewController.h"  //发布


#import "MineUserCell.h"

#import "ReleaseResponse.h"
#import "RowsModel.h"

@interface MySaveViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *mySavetableView;

@property (nonatomic,strong) NSMutableArray *mySaveResponse;
@property (nonatomic,strong) NSMutableArray *mySaveDataList;
@property (nonatomic,assign) NSInteger pageSave;

@end

@implementation MySaveViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self refreshHeaderOfMySave];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的草稿";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    [self.rightButton setTitle:@"编辑" forState:0];
    
    [self.view addSubview:self.mySavetableView];
    [self.view addSubview:self.baseRemindImageView];
    [self.baseRemindImageView setHidden:YES];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.mySavetableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        [self.baseRemindImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [self.baseRemindImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)mySavetableView
{
    if (!_mySavetableView) {
        _mySavetableView = [UITableView newAutoLayoutView];
        _mySavetableView.backgroundColor = kBackColor;
        _mySavetableView.separatorColor = kSeparateColor;
        _mySavetableView.delegate = self;
        _mySavetableView.dataSource = self;
        _mySavetableView.tableFooterView = [[UIView alloc] init];
        [_mySavetableView addHeaderWithTarget:self action:@selector(refreshHeaderOfMySave)];
        [_mySavetableView addFooterWithTarget:self action:@selector(refreshFooterOfMySave)];
    }
    return _mySavetableView;
}

- (NSMutableArray *)mySaveResponse
{
    if (!_mySaveResponse) {
        _mySaveResponse = [NSMutableArray array];
    }
    return _mySaveResponse;
}


- (NSMutableArray *)mySaveDataList
{
    if (!_mySaveDataList) {
        _mySaveDataList = [NSMutableArray array];
    }
    return _mySaveDataList;
}

#pragma mark - tableView delegate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mySaveDataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"save";
    MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectedBackgroundView = [[UIView alloc] init];
    cell.selectedBackgroundView.backgroundColor = kCellSelectedColor;
    
    RowsModel *rowModel = self.mySaveDataList[indexPath.row];

    cell.userNameButton.titleLabel.numberOfLines = 0;
    NSString *ss1 = [NSString stringWithFormat:@"债权%@\n",rowModel.number];
    NSString *ss2 = [NSDate getYMDhmFormatterTime:rowModel.create_at];
    NSString *ss = [NSString stringWithFormat:@"%@%@",ss1,ss2];
    NSMutableAttributedString *attributeS = [[NSMutableAttributedString alloc] initWithString:ss];
    [attributeS setAttributes:@{NSFontAttributeName:kBigFont,NSForegroundColorAttributeName:kBlackColor} range:NSMakeRange(0, ss1.length)];
    [attributeS setAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kGrayColor} range:NSMakeRange(ss1.length, ss2.length)];
    
    NSMutableParagraphStyle *stylee = [[NSMutableParagraphStyle alloc] init];
    [stylee setParagraphSpacing:kSpacePadding];
    [attributeS addAttribute:NSParagraphStyleAttributeName value:stylee range:NSMakeRange(0, ss.length)];
    [cell.userNameButton setAttributedTitle:attributeS forState:0];
    
    [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
    
    return cell;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setEditing:YES animated:YES];
    return UITableViewCellEditingStyleDelete;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        
        [self deleteOneSaveOfRow:indexPath.row];
        
    }];
    deleteAction.backgroundColor = kRedColor;
    
    return @[deleteAction];
}

//编辑状态不缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RowsModel *rowModel = self.mySaveDataList[indexPath.row];
    
    ReportSuitViewController *reportSuitVC = [[ReportSuitViewController alloc] init];
    reportSuitVC.productid = rowModel.productid;
    reportSuitVC.tagString = @"2";
    UINavigationController *nabb = [[UINavigationController alloc] initWithRootViewController:reportSuitVC];
    [self presentViewController:nabb animated:YES completion:nil];
}

#pragma mark - method
- (void)getMySaveListWithPage:(NSString *)page
{
    NSString *mySaveString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMySaveString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"page" : page,
                             @"limit" : @"10"
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:mySaveString params:params successBlock:^(id responseObject){
                        
        if ([page integerValue] == 0) {
            [weakself.mySaveDataList removeAllObjects];
        }
        
        ReleaseResponse *responseModel = [ReleaseResponse objectWithKeyValues:responseObject];
        
        if (responseModel.data.count == 0) {
            _pageSave--;
        }
        
        for (RowsModel *model in responseModel.data) {
            [weakself.mySaveDataList addObject:model];
        }
        
        if (weakself.mySaveDataList.count > 0) {
            [weakself.baseRemindImageView setHidden:YES];
        }else{
            [weakself.baseRemindImageView setHidden:NO];
        }
        
        [weakself.mySavetableView reloadData];
    } andFailBlock:^(NSError *error){
        
    }];
}

- (void)refreshHeaderOfMySave
{
    _pageSave = 0;
    [self getMySaveListWithPage:@"0"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.mySavetableView headerEndRefreshing];
    });
}

- (void)refreshFooterOfMySave
{
    _pageSave ++;
    NSString *page = [NSString stringWithFormat:@"%ld",(long)_pageSave];
    [self getMySaveListWithPage:page];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.mySavetableView footerEndRefreshing];
    });
}

#pragma mark - method
- (void)rightItemAction
{
    [self.mySavetableView setEditing:!self.mySavetableView.editing animated:YES];
    
    if (self.mySavetableView.editing){
        [self.rightButton setTitle:@"完成" forState:0];
    }else{
        [self.rightButton setTitle:@"编辑" forState:0];
    }
}

//删除
- (void)deleteOneSaveOfRow:(NSInteger)indexRow
{
    RowsModel *rowModel = self.mySaveDataList[indexRow];
    NSString *deleteSaveString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyReleaseOfDeleteString];
    NSDictionary *params = @{
                             @"productid" : rowModel.productid,
                             @"token" : [self getValidateToken]                             };
    QDFWeakSelf;
    [self requestDataPostWithString:deleteSaveString params:params successBlock:^(id responseObject){
        BaseModel *model = [BaseModel objectWithKeyValues:responseObject];
        [weakself showHint:model.msg];
        
        if ([model.code isEqualToString:@"0000"]) {
            [weakself refreshHeaderOfMySave];
        }
        
    } andFailBlock:^(NSError *error){
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    }
//
//}


@end
