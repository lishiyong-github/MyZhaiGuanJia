//
//  CopyAddressEditViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/3.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "CopyAddressEditViewController.h"
#import "BaseCommitView.h"

#import "AgentCell.h"
#import "EditDebtAddressCell.h"
#import "MineUserCell.h"

@interface CopyAddressEditViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *propertyListTableView;
@property (nonatomic,strong) BaseCommitView *propertyListCommitView;

@property (nonatomic,assign) BOOL didSetupConstraints;

@end

@implementation CopyAddressEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑地址";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(delete)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kRedColor} forState:0];

    [self.view addSubview:self.propertyListTableView];
    [self.view addSubview:self.propertyListCommitView];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)delete
{
    
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.propertyListTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.propertyListTableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.propertyListCommitView];
        
        [self.propertyListCommitView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.propertyListCommitView autoSetDimension:ALDimensionHeight toSize:60];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)propertyListTableView
{
    if (!_propertyListTableView) {
        _propertyListTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _propertyListTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _propertyListTableView.delegate = self;
        _propertyListTableView.dataSource = self;
        _propertyListTableView.backgroundColor = kBackColor;
        _propertyListTableView.separatorColor = kSeparateColor;
        _propertyListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
    }
    return _propertyListTableView;
}

- (BaseCommitView *)propertyListCommitView
{
    if (!_propertyListCommitView) {
        _propertyListCommitView = [BaseCommitView newAutoLayoutView];
        [_propertyListCommitView.button setTitle:@"保存并使用" forState:0];
        
        QDFWeakSelf;
        [_propertyListCommitView.button addAction:^(UIButton *btn) {
            //            UINavigationController *nav = weakself.navigationController;
            //            [nav popViewControllerAnimated:NO];
            //            [nav popViewControllerAnimated:NO];
            //            [nav popViewControllerAnimated:NO];
            //            [nav popViewControllerAnimated:NO];
            
            //            HousePropertyViewController *housePropertyVC = [[HousePropertyViewController alloc] init];
            //            housePropertyVC.hidesBottomBarWhenPushed = YES;
            //            [nav pushViewController:housePropertyVC animated:NO];
        }];
    }
    return _propertyListCommitView;
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
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    
    if (indexPath.row < 2) {
        AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSArray *rere = @[@"收件人：",@"联系方式"];
        NSArray *rtrt = @[@"请输入收件人姓名",@"请输入收件人联系方式"];
        cell.agentLabel.text = rere[indexPath.row];
        cell.agentTextField.placeholder = rtrt[indexPath.row];
        
        return cell;
        
    }else if (indexPath.row == 2){
        
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.userNameButton setTitle:@"选择区域：" forState:0];
        [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        
        return cell;
    }
    
    //详细地址
    EditDebtAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[EditDebtAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.ediLabel.text = @"详细地址";
    cell.ediTextView.placeholder = @"请输入详细地址";
    
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
    if (indexPath.row == 2) {
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
