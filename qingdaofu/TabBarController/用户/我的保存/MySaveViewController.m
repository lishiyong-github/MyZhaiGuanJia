//
//  MySaveViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/4/29.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MySaveViewController.h"
//#import "MyDetailSaveViewController.h"
#import "ReportSuitViewController.h"  //发布


#import "MineUserCell.h"
#import "SaveCell.h"

#import "ReleaseResponse.h"
#import "RowsModel.h"

@interface MySaveViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *mySavetableView;
@property (nonatomic,strong) UIButton *saveRightNavButton;

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
    self.navigationItem.title = @"我的保存";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.saveRightNavButton];
    
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

- (UIButton *)saveRightNavButton
{
    if (!_saveRightNavButton) {
        _saveRightNavButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
        _saveRightNavButton.titleLabel.font = kFirstFont;
        [_saveRightNavButton setTitle:@"编辑" forState:0];
        [_saveRightNavButton setTitleColor:kBlueColor forState:0];
        
        QDFWeakSelf;
        [_saveRightNavButton addAction:^(UIButton *btn) {
            
            [weakself.mySavetableView setEditing:!weakself.mySavetableView.editing animated:YES];
            
            if (weakself.mySavetableView.editing){
                [btn setTitle:@"完成" forState:0];
            }else{
                [btn setTitle:@"编辑" forState:0];
            }
        }];
    }
    return _saveRightNavButton;
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
    return kCellHeight1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"save";
    SaveCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[SaveCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectedBackgroundView = [[UIView alloc] init];
    cell.selectedBackgroundView.backgroundColor = kCellSelectedColor;
    cell.codeButton.userInteractionEnabled = NO;
    cell.actButton.userInteractionEnabled = NO;
    [cell.actButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
    
    RowsModel *rowModel = self.mySaveDataList[indexPath.row];

    if ([rowModel.category isEqualToString:@"2"]){//清收
        [cell.codeButton setImage:[UIImage imageNamed:@"list_collection"] forState:0];
        NSString *dString1 = [NSString stringWithFormat:@"  清收%@",rowModel.codeString];
        [cell.codeButton setTitle:dString1 forState:0];
    }else if([rowModel.category isEqualToString:@"3"]){//诉讼
        [cell.codeButton setImage:[UIImage imageNamed:@"list_litigation"] forState:0];
        NSString *dString2 = [NSString stringWithFormat:@"  诉讼%@",rowModel.codeString];
        [cell.codeButton setTitle:dString2 forState:0];
    }
    
    cell.timeLabel.text = [NSDate getYMDhmFormatterTime:rowModel.modify_time];
    
    return cell;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.editing) {//是否处于编辑状态
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}


- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"直接发布" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
//        [self goToPublishWithRow:indexPath.row];
//        
//    }];
//    editAction.backgroundColor = kBlueColor;
    
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        
        [self deleteOneSaveOfRow:indexPath.row];
        
    }];
    deleteAction.backgroundColor = kRedColor;
    
    return @[deleteAction];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RowsModel *deModel = self.mySaveDataList[indexPath.row];
    [self editSaveDetailMessageWithRowModel:deModel];
//    ReportSuitViewController *reportSuitVC = [[ReportSuitViewController alloc] init];
//    reportSuitVC.suResponse = self.mySaveResponse[0];
//    reportSuitVC.categoryString = self.categaryString;
//    reportSuitVC.tagString = @"2";
//    [weakself.navigationController pushViewController:reportSuitVC animated:YES];
    
//    MyDetailSaveViewController *myDetailSaveVC = [[MyDetailSaveViewController alloc] init];
//    myDetailSaveVC.idString = deModel.idString;
//    myDetailSaveVC.categaryString = deModel.category;
//    [self.navigationController pushViewController:myDetailSaveVC animated:YES];
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
        
        if ([page integerValue] == 1) {
            [weakself.mySaveDataList removeAllObjects];
        }
        
        ReleaseResponse *responseModel = [ReleaseResponse objectWithKeyValues:responseObject];
        
//        [weakself.mySaveResponse addObject:responseModel];
        
        if (responseModel.rows.count == 0) {
            _pageSave--;
        }
        
        for (RowsModel *model in responseModel.rows) {
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
    _pageSave = 1;
    [self getMySaveListWithPage:@"1"];
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
- (void)goToPublishWithRow:(NSInteger)row
{
    RowsModel *pubModel = self.mySaveDataList[row];
    
    NSString *reportString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMySavePublishString];
    
    NSDictionary *params = @{@"id" : pubModel.idString,
                             @"category" : pubModel.category,
                             @"token" : [self getValidateToken]
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:reportString params:params successBlock:^(id responseObject) {
        BaseModel *model = [BaseModel objectWithKeyValues:responseObject];
        
        if ([model.code isEqualToString:@"0000"]) {
            [weakself showHint:@"发布成功"];
            
            UINavigationController *nav = self.navigationController;
            [nav popViewControllerAnimated:NO];
            
//            MyReleaseViewController *myReleaseVC = [[MyReleaseViewController alloc] init];
//            myReleaseVC.progreStatus = @"1";
//            [nav pushViewController:myReleaseVC animated:NO];
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
    QDFWeakSelf;
    [self requestDataPostWithString:deleteSaveString params:params successBlock:^(id responseObject){
        BaseModel *model = [BaseModel objectWithKeyValues:responseObject];
        [weakself showHint:model.msg];
        if ([model.code isEqualToString:@"0000"]) {
            [weakself.mySaveDataList removeObjectAtIndex:indexRow];
            [weakself.mySavetableView reloadData];
            
            if (weakself.mySaveDataList.count > 0) {
                [weakself.baseRemindImageView setHidden:YES];
            }else{
                [weakself.baseRemindImageView setHidden:NO];
            }
        }
        
    } andFailBlock:^(NSError *error){
        
    }];
}

#pragma mark - 再次编辑
- (void)editSaveDetailMessageWithRowModel:(RowsModel *)rowModel
{
    NSString *sDetailString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kProdutsDetailString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"id" : rowModel.idString,
                             @"category" : rowModel.category
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:sDetailString params:params successBlock:^(id responseObject){
        
        PublishingResponse *responseModel = [PublishingResponse objectWithKeyValues:responseObject];
        
        if ([responseModel.code isEqualToString:@"0000"]) {
            ReportSuitViewController *reportSuitVC = [[ReportSuitViewController alloc] init];
            reportSuitVC.categoryString = rowModel.category;
            reportSuitVC.suResponse = responseModel;
            reportSuitVC.tagString = @"2";
            
            UINavigationController *nabc = [[UINavigationController alloc] initWithRootViewController:reportSuitVC];
            [weakself presentViewController:nabc animated:YES completion:nil];
        }else{
            [weakself showHint:responseModel.msg];
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
