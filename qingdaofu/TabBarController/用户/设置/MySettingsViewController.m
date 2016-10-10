//
//  MySettingsViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/3.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MySettingsViewController.h"

#import "PersonCerterViewController.h" //个人中心
#import "AuthentyViewController.h"
#import "CompleteViewController.h"
#import "ModifyPassWordViewController.h"  //修改密码
#import "ChangeMobileViewController.h"
#import "ReceiptAddressViewController.h" //收货地址

#import "MineUserCell.h"
#import "BidOneCell.h"

@interface MySettingsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *mySettingTableView;

@end

@implementation MySettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    self.navigationItem.leftBarButtonItem = self.leftItem;

    [self.view addSubview:self.mySettingTableView];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.mySettingTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)mySettingTableView
{
    if (!_mySettingTableView) {
        _mySettingTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _mySettingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        _mySettingTableView.delegate = self;
        _mySettingTableView.dataSource = self;
        _mySettingTableView.tableFooterView = [[UIView alloc] init];
        _mySettingTableView.separatorColor = kSeparateColor;
        _mySettingTableView.backgroundColor = kBackColor;
    }
    return _mySettingTableView;
}

#pragma mark - tableView delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        return 2;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return kCellHeight5;
    }
    return kCellHeight2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    
    if (indexPath.section == 0) {
        identifier = @"setting0";
        
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.selectedBackgroundView = [[UIView alloc] init];
        cell.selectedBackgroundView.backgroundColor = kCellSelectedColor;
        cell.userNameButton.userInteractionEnabled = NO;
        cell.userActionButton.userInteractionEnabled = NO;
        
        [cell.userNameButton setImage:[UIImage imageNamed:@""] forState:0];
        [cell.userNameButton setTitle:@"13212222222" forState:0];
        [cell.userActionButton setTitle:@"个人中心    " forState:0];
        [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        
        return cell;
    }else if (indexPath.section == 1){
        identifier = @"setting1";
        
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.selectedBackgroundView = [[UIView alloc] init];
        cell.selectedBackgroundView.backgroundColor = kCellSelectedColor;
        cell.userNameButton.userInteractionEnabled = NO;
        cell.userActionButton.userInteractionEnabled = NO;
        
        [cell.userNameButton setTitle:@"身份认证" forState:0];
        [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        
        if ([self.toModel.code isEqualToString:@"0000"]) {
            [cell.userActionButton setTitle:@"已认证    " forState:0];
        }else{
            [cell.userActionButton setTitle:@"待认证    " forState:0];
        }
        
        return cell;
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            identifier = @"setting20";
            
            MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!cell) {
                cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            
            cell.selectedBackgroundView = [[UIView alloc] init];
            cell.selectedBackgroundView.backgroundColor = kCellSelectedColor;
            cell.userNameButton.userInteractionEnabled = NO;
            cell.userActionButton.userInteractionEnabled = NO;
            
            [cell.userNameButton setTitle:@"设置/修改登录密码" forState:0];
            [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
            
            return cell;
        }
        
        identifier = @"setting21";
        
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.selectedBackgroundView = [[UIView alloc] init];
        cell.selectedBackgroundView.backgroundColor = kCellSelectedColor;
        cell.userNameButton.userInteractionEnabled = NO;
        cell.userActionButton.userInteractionEnabled = NO;
        
        [cell.userNameButton setTitle:@"绑定手机" forState:0];
        [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        
        NSString *mobile = [NSString stringWithFormat:@"%@    ",self.toModel.mobile];
        if (mobile.length == 15) {
            [cell.userActionButton setTitle:mobile forState:0];
        }else{
            [cell.userActionButton setTitle:@"未绑定    " forState:0];
        }
        
        return cell;
    }else if (indexPath.section == 3){
        identifier = @"setting3";
        
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.selectedBackgroundView = [[UIView alloc] init];
        cell.selectedBackgroundView.backgroundColor = kCellSelectedColor;
        cell.userNameButton.userInteractionEnabled = NO;
        cell.userActionButton.userInteractionEnabled = NO;
        
        [cell.userNameButton setTitle:@"收货地址" forState:0];
        [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        [cell.userActionButton setTitle:@"点击设置    " forState:0];
        
        return cell;
    }

    identifier = @"setting4";
    BidOneCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[BidOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectedBackgroundView = [[UIView alloc] init];
    cell.selectedBackgroundView.backgroundColor = kCellSelectedColor;
    
    [cell.oneButton setTitle:@"退出登录" forState:0];
    [cell.oneButton setTitleColor:kBlackColor forState:0];
    cell.oneButton.userInteractionEnabled = NO;
    
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
    
    if (indexPath.section == 0) {//个人中心
        PersonCerterViewController *personCerterVC = [[PersonCerterViewController alloc] init];
        [self.navigationController pushViewController:personCerterVC animated:YES];
    }else if(indexPath.section == 1){//身份认证
    }else if (indexPath.section == 2 && indexPath.row == 0){//设置登录密码
        ModifyPassWordViewController *modifyPassWordVC = [[ModifyPassWordViewController alloc] init];
        [self.navigationController pushViewController:modifyPassWordVC animated:YES];
    }else if (indexPath.section == 2 && indexPath.row == 1){//绑定手机
        ChangeMobileViewController *changeMobileVC = [[ChangeMobileViewController alloc] init];
        [self.navigationController pushViewController:changeMobileVC animated:YES];
    }else if (indexPath.section == 3){//收货地址
        ReceiptAddressViewController *receiptAddressListViewController = [[ReceiptAddressViewController alloc] init];
        receiptAddressListViewController.cateString = @"1";
        [self.navigationController pushViewController:receiptAddressListViewController animated:YES];
    }else if (indexPath.section == 4){//退出登录
        NSString *exitString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kExitString];
        
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        NSDictionary *params = @{@"token" : token};
        
        QDFWeakSelf;
        [self requestDataPostWithString:exitString params:params successBlock:^(id responseObject){
            BaseModel *exitModel = [BaseModel objectWithKeyValues:responseObject];
            [weakself showHint:exitModel.msg];
            
            if ([exitModel.code isEqualToString:@"0000"]) {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"mobile"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [weakself.navigationController popViewControllerAnimated:YES];
            }
        } andFailBlock:^(NSError *error){
            
        }];
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
