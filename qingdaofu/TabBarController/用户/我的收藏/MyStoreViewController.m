//
//  MyStoreViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/4/29.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MyStoreViewController.h"
#import "MyDetailStoreViewController.h"    //收藏详细

#import "MyStoreCell.h"
#import "MineUserCell.h"

#import "ReleaseResponse.h"
#import "RowsModel.h"

@interface MyStoreViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *myStoreTableView;
@property (nonatomic,strong) NSMutableArray *storeDataList;

@end

@implementation MyStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的收藏";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.myStoreTableView];
    [self.view setNeedsUpdateConstraints];
    [self getMyStoreListWithPage:@"0"];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.myStoreTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
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
    }
    return _myStoreTableView;
}

- (NSMutableArray *)storeDataList
{
    if (!_storeDataList) {
//        NSArray *aa = @[@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
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
    }else if ([storeModel.category isEqualToString:@"2"]){//催收
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
    [self.navigationController pushViewController:myDetailStoreVC animated:YES];
}

#pragma mark - method
- (void)getMyStoreListWithPage:(NSString *)page
{
    NSString *storeString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyStoreString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"page" : page
                             };
    [self requestDataPostWithString:storeString params:params successBlock:^(id responseObject){
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@" ?????????? %@",dic);
        
        ReleaseResponse *responseModel = [ReleaseResponse objectWithKeyValues:responseObject];
        
        for (RowsModel *storeModel in responseModel.rows) {
            [self.storeDataList addObject:storeModel];
        }
        
        [self.myStoreTableView reloadData];
        
    } andFailBlock:^(NSError *error){
        
    }];
}

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
