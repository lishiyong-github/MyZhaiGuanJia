//
//  MySaveViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/4/29.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MySaveViewController.h"
#import "MyDetailSaveViewController.h"
#import "MyReleaseViewController.h"  //我的发布

#import "MineUserCell.h"

#import "ReleaseResponse.h"
#import "RowsModel.h"

@interface MySaveViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *mySavetableView;

@property (nonatomic,strong) NSMutableArray *mySaveDataList;
@property (nonatomic,assign) NSInteger pageSave;

@end

@implementation MySaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的保存";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.mySavetableView];
    [self.view addSubview:self.baseRemindImageView];
    [self.baseRemindImageView setHidden:YES];
    
    [self.view setNeedsUpdateConstraints];
    
    [self refreshHeaderOfMySave];
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
        _mySavetableView.delegate = self;
        _mySavetableView.dataSource = self;
        _mySavetableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
        _mySavetableView.backgroundColor = kBackColor;
        _mySavetableView.separatorColor = kSeparateColor;
        _mySavetableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
        [_mySavetableView addHeaderWithTarget:self action:@selector(refreshHeaderOfMySave)];
        [_mySavetableView addFooterWithTarget:self action:@selector(refreshFooterOfMySave)];
    }
    return _mySavetableView;
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
    return kCellHeight;
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
    
    if ([rowModel.category isEqualToString:@"1"]) {//融资
        [cell.userNameButton setImage:[UIImage imageNamed:@"list_financing"] forState:0];
    }else if ([rowModel.category isEqualToString:@"2"]){//清收
        [cell.userNameButton setImage:[UIImage imageNamed:@"list_collection"] forState:0];
    }else if([rowModel.category isEqualToString:@"3"]){//诉讼
        [cell.userNameButton setImage:[UIImage imageNamed:@"list_litigation"] forState:0];
    }

    NSString *dString = [NSString stringWithFormat:@"  %@",rowModel.codeString];
    [cell.userNameButton setTitle:dString forState:0];
    cell.userNameButton.userInteractionEnabled = NO;
    NSString *timeStr = [NSDate getYMDFormatterTime:rowModel.modify_time];
    [cell.userActionButton setTitle:timeStr forState:0];
    [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
    cell.userActionButton.userInteractionEnabled = NO;
    
    return cell;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"直接发布" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        [self goToPublishWithRow:indexPath.row];
        
    }];
    editAction.backgroundColor = kBlueColor;
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        
        [self deleteOneSaveOfRow:indexPath.row];
        
    }];
    deleteAction.backgroundColor = kRedColor;
    
    return @[deleteAction,editAction];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RowsModel *deModel = self.mySaveDataList[indexPath.row];
    MyDetailSaveViewController *myDetailSaveVC = [[MyDetailSaveViewController alloc] init];
    myDetailSaveVC.idString = deModel.idString;
    myDetailSaveVC.categaryString = deModel.category;
    [self.navigationController pushViewController:myDetailSaveVC animated:YES];
}

#pragma mark - method
- (void)getMySaveListWithPage:(NSString *)page
{
    NSString *mySaveString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMySaveString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"page" : page,
                             @"limit" : @"10"
                             };
    [self requestDataPostWithString:mySaveString params:params successBlock:^(id responseObject){
        if ([page integerValue] == 0) {
            [self.mySaveDataList removeAllObjects];
        }
        
        ReleaseResponse *responseModel = [ReleaseResponse objectWithKeyValues:responseObject];
        
        if (responseModel.rows.count == 0) {
            [self showHint:@"没有更多了"];
            _pageSave--;
        }
        
        for (RowsModel *model in responseModel.rows) {
            [self.mySaveDataList addObject:model];
        }
        
        if (self.mySaveDataList.count > 0) {
            [self.baseRemindImageView setHidden:YES];
        }else{
            [self.baseRemindImageView setHidden:NO];
        }
        
        [self.mySavetableView reloadData];
    } andFailBlock:^(NSError *error){
        
    }];
}

- (void)refreshHeaderOfMySave
{
    [self getMySaveListWithPage:@"0"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.mySavetableView headerEndRefreshing];
    });
}

- (void)refreshFooterOfMySave
{
    _pageSave ++;
    NSString *page = [NSString stringWithFormat:@"%d",_pageSave];
    [self getMySaveListWithPage:page];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.mySavetableView footerEndRefreshing];
    });
}

#pragma mark - method
- (void)goToPublishWithRow:(NSInteger)row
{
    RowsModel *pubModel = self.mySaveDataList[row];
    
    NSString *reportString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMySavePublishString];
    
    NSDictionary *params = @{@"id" : pubModel.idString,
                             @"category" : pubModel.category,
                             @"token" : [self getValidateToken]
                             };
    
    [self requestDataPostWithString:reportString params:params successBlock:^(id responseObject) {
        BaseModel *model = [BaseModel objectWithKeyValues:responseObject];
        
        if ([model.code isEqualToString:@"0000"]) {
            [self showHint:@"发布成功"];
            
            UINavigationController *nav = self.navigationController;
            [nav popViewControllerAnimated:NO];
            
            MyReleaseViewController *myReleaseVC = [[MyReleaseViewController alloc] init];
            myReleaseVC.progreStatus = @"1";
            [nav pushViewController:myReleaseVC animated:YES];
        }
        
    } andFailBlock:^(NSError *error) {
        
    }];
}




//删除
- (void)deleteOneSaveOfRow:(NSInteger)indexRow
{
    RowsModel *deleteModel = self.mySaveDataList[indexRow];
    NSString *deleteSaveString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kDeleteSaveString];
    NSDictionary *params = @{@"id" : deleteModel.idString,
                             @"category" : deleteModel.category,
                             @"token" : [self getValidateToken]
                             };
    
    [self requestDataPostWithString:deleteSaveString params:params successBlock:^(id responseObject){
        BaseModel *model = [BaseModel objectWithKeyValues:responseObject];
        [self showHint:model.msg];
        if ([model.code isEqualToString:@"0000"]) {
            [self.mySaveDataList removeObjectAtIndex:indexRow];
            [self.mySavetableView reloadData];
            
            if (self.mySaveDataList.count > 0) {
                [self.baseRemindImageView setHidden:YES];
            }else{
                [self.baseRemindImageView setHidden:NO];
            }
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
