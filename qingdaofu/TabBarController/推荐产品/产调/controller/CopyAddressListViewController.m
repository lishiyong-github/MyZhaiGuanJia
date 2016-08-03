//
//  CopyAddressListViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/3.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "CopyAddressListViewController.h"
#import "CopyAddressEditViewController.h"

#import "BaseCommitView.h"

#import "CopyListCell.h"

@interface CopyAddressListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *copyListTableView;
@property (nonatomic,strong) BaseCommitView *copyListCommitView;
@property (nonatomic,assign) BOOL didSetupConstraints;

@end

@implementation CopyAddressListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收货地址";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.copyListTableView];
    [self.view addSubview:self.copyListCommitView];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.copyListTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.copyListTableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.copyListCommitView];
        
        [self.copyListCommitView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.copyListCommitView autoSetDimension:ALDimensionHeight toSize:60];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)copyListTableView
{
    if (!_copyListTableView) {
        _copyListTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _copyListTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _copyListTableView.delegate = self;
        _copyListTableView.dataSource = self;
        _copyListTableView.backgroundColor = kBackColor;
        _copyListTableView.separatorColor = kSeparateColor;
        _copyListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
    }
    return _copyListTableView;
}

- (BaseCommitView *)copyListCommitView
{
    if (!_copyListCommitView) {
        _copyListCommitView = [BaseCommitView newAutoLayoutView];
        [_copyListCommitView.button setTitle:@"新增地址" forState:0];
        
        QDFWeakSelf;
        [_copyListCommitView.button addAction:^(UIButton *btn) {
            CopyAddressEditViewController *copyAddressEditVC = [[CopyAddressEditViewController alloc] init];
            [weakself.navigationController pushViewController:copyAddressEditVC animated:YES];
        }];
    }
    return _copyListCommitView;
}

#pragma mark -tableview delegate and datasoyrce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    
    
    
    
    CopyListCell*cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[CopyListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.nameLabel.text = @"李丽莉";
    cell.phoneLabel.text = @"123456789909";
    cell.addressLabel.text = @"上海市浦东新区浦东南路9855号世界广场34楼";
    [cell.editButton setTitle:@"编辑" forState:0];
    
    return cell;
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
        //        PowerDetailsViewController *powerDetailsVC = [[PowerDetailsViewController alloc] init];
        //        [self.navigationController pushViewController:powerDetailsVC animated:YES];
    }
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
