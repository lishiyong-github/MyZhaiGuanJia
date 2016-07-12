//
//  MyStoreViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/4/29.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MyStoreViewController.h"
#import "MyDetailStoreViewController.h"    //收藏详细
#import "MyOrderViewController.h" //我的接单

#import "MyStoreCell.h"
#import "MineUserCell.h"

#import "ReleaseResponse.h"
#import "RowsModel.h"

@interface MyStoreViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *myStoreTableView;
@property (nonatomic,strong) NSMutableArray *storeDataList;
@property (nonatomic,assign) NSInteger pageStore;

@end

@implementation MyStoreViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self refreshHeaderOfMySave];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的收藏";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.myStoreTableView];
    [self.view addSubview:self.baseRemindImageView];
    [self.baseRemindImageView setHidden:YES];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.myStoreTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        [self.baseRemindImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.baseRemindImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)myStoreTableView
{
    if (!_myStoreTableView) {
        _myStoreTableView = [UITableView newAutoLayoutView];
        _myStoreTableView.delegate = self;
        _myStoreTableView.dataSource = self;
        _myStoreTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
        _myStoreTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
        _myStoreTableView.separatorColor = kSeparateColor;
        _myStoreTableView.backgroundColor = kBackColor;
        [_myStoreTableView addHeaderWithTarget:self action:@selector(refreshHeaderOfMySave)];
        [_myStoreTableView addFooterWithTarget:self action:@selector(refreshFooterOfMySave)];
    }
    return _myStoreTableView;
}

- (NSMutableArray *)storeDataList
{
    if (!_storeDataList) {
        _storeDataList = [NSMutableArray array];
    }
    return _storeDataList;
}

#pragma mark - tableView delegate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.storeDataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"store";
    MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    RowsModel *storeModel = self.storeDataList[indexPath.row];
    
    if ([storeModel.category isEqualToString:@"1"]) {//融资
        [cell.userNameButton setImage:[UIImage imageNamed:@"list_financing"] forState:0];
    }else if ([storeModel.category isEqualToString:@"2"]){//清收
        [cell.userNameButton setImage:[UIImage imageNamed:@"list_collection"] forState:0];
    }else if([storeModel.category isEqualToString:@"3"]){//诉讼
        [cell.userNameButton setImage:[UIImage imageNamed:@"list_litigation"] forState:0];
    }
    
    NSString *dString = [NSString stringWithFormat:@"  %@",storeModel.codeString];
    [cell.userNameButton setTitle:dString forState:0];
    cell.userNameButton.userInteractionEnabled = NO;
    NSString *timeStr = [NSDate getYMDFormatterTime:storeModel.modify_time];
    [cell.userActionButton setTitle:timeStr forState:0];
    [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
    cell.userActionButton.userInteractionEnabled = NO;

    return cell;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"立即申请" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        [self goToApplyWithRow:indexPath.row];
    }];
    editAction.backgroundColor = kBlueColor;
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"取消收藏"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        [self deleteOneStoreOfRow:indexPath.row];
    }];
    deleteAction.backgroundColor = kRedColor;
    
    return @[deleteAction,editAction];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RowsModel *rowModel = self.storeDataList[indexPath.row];
    
    MyDetailStoreViewController *myDetailStoreVC = [[MyDetailStoreViewController alloc] init];
    myDetailStoreVC.idString = rowModel.idString;
    myDetailStoreVC.categoryString = rowModel.category;
    myDetailStoreVC.codeString = rowModel.codeString;
    [self.navigationController pushViewController:myDetailStoreVC animated:YES];
}

#pragma mark - refresh method
- (void)getMyStoreListWithPage:(NSString *)page
{
    NSString *storeString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyStoreString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"page" : page,
                             @"limit" : @"10"
                             };
    [self requestDataPostWithString:storeString params:params successBlock:^(id responseObject){
        
        if ([page integerValue] == 1) {
            [self.storeDataList removeAllObjects];
        }
        
        ReleaseResponse *responseModel = [ReleaseResponse objectWithKeyValues:responseObject];
        
        if (responseModel.rows.count == 0) {
            [self showHint:@"没有更多了"];
            _pageStore--;
        }
        
        for (RowsModel *storeModel in responseModel.rows) {
            [self.storeDataList addObject:storeModel];
        }
        
        if (self.storeDataList.count > 0) {
            [self.baseRemindImageView setHidden:YES];
        }else{
            [self.baseRemindImageView setHidden:NO];
        }
        
        [self.myStoreTableView reloadData];
        
    } andFailBlock:^(NSError *error){
        
    }];
}

- (void)refreshHeaderOfMySave
{
    _pageStore = 1;
    [self getMyStoreListWithPage:@"1"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.myStoreTableView headerEndRefreshing];
    });
}

- (void)refreshFooterOfMySave
{
    _pageStore ++;
    NSString *page = [NSString stringWithFormat:@"%d",_pageStore];
    [self getMyStoreListWithPage:page];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.myStoreTableView footerEndRefreshing];
    });
}

#pragma mark - method
- (void)goToApplyWithRow:(NSInteger)row
{
    RowsModel *appModel = self.storeDataList[row];
    NSString *appString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kProductHouseString];
    NSDictionary *params = @{@"id" : appModel.idString,
                             @"category" : appModel.category,
                             @"token" : [self getValidateToken]
                             };
    [self requestDataPostWithString:appString params:params successBlock:^(id responseObject) {
        BaseModel *appModel = [BaseModel objectWithKeyValues:responseObject];
        [self showHint:appModel.msg];
        if ([appModel.code isEqualToString:@"0000"]) {
            [self.storeDataList removeObjectAtIndex:row];
            [self.myStoreTableView reloadData];
            
            UINavigationController *nav = self.navigationController;
            [nav popViewControllerAnimated:NO];
            
            MyOrderViewController *myOrderVC = [[MyOrderViewController alloc] init];
            myOrderVC.status = @"0";
            myOrderVC.progresStatus = @"1";
            [nav pushViewController:myOrderVC animated:NO];
        }
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

//删除
- (void)deleteOneStoreOfRow:(NSInteger)indexRow
{
    RowsModel *deleteModel = self.storeDataList[indexRow];
    NSString *deleteString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kDeleteStoreString];
    NSDictionary *params = @{@"product_id" : deleteModel.idString,
                             @"category" : deleteModel.category,
                             @"token" : [self getValidateToken]
                             };
    [self requestDataPostWithString:deleteString params:params successBlock:^(id responseObject){
        BaseModel *deleteModel = [BaseModel objectWithKeyValues:responseObject];
        [self showHint:deleteModel.msg];
        if ([deleteModel.code isEqualToString:@"0000"]) {
            [self.storeDataList removeObjectAtIndex:indexRow];
            [self.myStoreTableView reloadData];
            if (self.storeDataList.count > 0) {
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
