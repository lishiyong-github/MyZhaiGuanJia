//
//  OperatorListViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/10/21.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "OperatorListViewController.h"

#import "MyMailListsViewController.h"  //通讯录

#import "MineUserCell.h"

#import "OperatorResponse.h"
#import "OperatorModel.h"

@interface OperatorListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *operatorListTableView;

@property (nonatomic,strong) NSMutableArray *operatorListArray;

@end

@implementation OperatorListViewController

- (void)viewWillAppear:(BOOL)animated
{
//    [self getOperatoeLists];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"经办人";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    [self.rightButton setTitle:@"编辑" forState:0];
    
    [self.view addSubview:self.operatorListTableView];
    [self.view setNeedsUpdateConstraints];
}

 -(void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.operatorListTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)operatorListTableView
{
    if (!_operatorListTableView) {
        _operatorListTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _operatorListTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _operatorListTableView.backgroundColor = kBackColor;
        _operatorListTableView.separatorColor = kSeparateColor;
        _operatorListTableView.delegate = self;
        _operatorListTableView.dataSource = self;
    }
    return _operatorListTableView;
}

- (NSMutableArray *)operatorListArray
{
    if (!_operatorListArray) {
        _operatorListArray = [NSMutableArray array];
    }
    return _operatorListArray;
}

#pragma mark - delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    return 2+self.operatorListArray.count;
    if (self.operatorListArray.count <= 0) {
        return 2;
    }
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.operatorListArray.count <= 0) {
        return 1;
    }
    if (section == 0 || section == 2) {
        return 1;
    }
    return self.operatorListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    if (indexPath.section == 0) {//MineUserCell.h
        identifier = @"operator0";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.userNameButton setTitle:@"从通讯录选择经办人" forState:0];
        [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        
        return cell;
    }else{
        //没有经办人的时候
        if (self.operatorListArray.count <= 0) {
            if (indexPath.section == 1){
                identifier = @"operator1";
                MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!cell) {
                    cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.userActionButton setHidden:YES];
                [cell.userNameButton swapImage];
                
                [cell.userNameButton setTitle:@"接单方  " forState:0];
                [cell.userNameButton setImage:[UIImage imageNamed:@"succee"] forState:0];
                
                return cell;
            }
        
        }else{
            //有经办人的时候
            if (indexPath.section == 2){
                identifier = @"operator2";
                MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!cell) {
                    cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.userActionButton setHidden:YES];
                [cell.userNameButton swapImage];
                
                [cell.userNameButton setTitle:@"接单方  " forState:0];
                [cell.userNameButton setImage:[UIImage imageNamed:@"succee"] forState:0];
                
                return cell;
            }else if(indexPath.section == 1){
                identifier = @"operator1";
                MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!cell) {
                    cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                //        [cell.userNameButton setTitle:@"张三" forState:0];
                //        [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
                
                OperatorModel *operatorModel = self.operatorListArray[indexPath.row];
                
//                [cell.userNameButton setTitle:operatorModel.owner forState:0];
                
                if ([operatorModel.level isEqualToString:@"1"]) {
                    [cell.userActionButton setHidden:NO];
                    [cell.userActionButton setImage:[UIImage imageNamed:@"phone_blue"] forState:0];
                }else{
                    [cell.userActionButton setHidden:YES];
                }
                
                return cell;
            }

        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if (section == 0 || section == self.operatorListArray.count+1) {
//        return 0.1;
//    }
//    
//    return kCellHeight;
    
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
//    if (section == 0 || section == self.operatorListArray.count || section == self.operatorListArray.count + 1) {
//        return kBigPadding;
//    }
//    
//    return 0.1;
    
    return kBigPadding;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kCellHeight)];
//    headerView.backgroundColor = kRedColor;
//    return headerView;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        MyMailListsViewController *myMailListsVC = [[MyMailListsViewController alloc] init];
        myMailListsVC.mailType = @"2";
        [self.navigationController pushViewController:myMailListsVC animated:YES];
    }
}

#pragma mark - method
- (void)rightItemAction
{
    [self showHint:@"编辑"];
    self.rightButton.selected = !self.rightButton.selected;
    
    if (self.rightButton.selected) {
        [self.rightButton setTitle:@"完成" forState:0];

        for (NSInteger i=0; i<self.operatorListArray.count; i++) {
            OperatorModel *operatorModel = self.operatorListArray[i];
            
            if ([operatorModel.level isEqualToString:@"1"]) {
                MineUserCell *cell = [self.operatorListTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1]];
                [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
            }
        }
        
        
    }else{
        [self.rightButton setTitle:@"编辑" forState:0];
    }
    
}

- (void)getOperatoeLists
{
    
    NSString *operatorString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,@"productorders/orders-operator-list"];
    NSDictionary *params = @{@"token" : @"XXX",
                             @"ordersid" : @"41"
                             };
    
    QDFWeakSelf;
    [self requestDataPostWithString:operatorString params:params successBlock:^(id responseObject) {
        OperatorResponse *responff = [OperatorResponse objectWithKeyValues:responseObject];
        for (OperatorModel *operatorModel in responff.operators) {
            [weakself.operatorListArray addObject:operatorModel];
        }
        
        [weakself.operatorListTableView reloadData];
        
    } andFailBlock:^(NSError *error) {
        
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
