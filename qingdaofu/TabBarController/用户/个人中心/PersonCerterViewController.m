//
//  PersonCerterViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/10/10.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "PersonCerterViewController.h"
//#import "ChangeMobileViewController.h"
#import "NewMobileViewController.h"

#import "MineUserCell.h"


@interface PersonCerterViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *personCerterTableView;

@end

@implementation PersonCerterViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人中心";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.personCerterTableView];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.personCerterTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)personCerterTableView
{
    if (!_personCerterTableView) {
        _personCerterTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _personCerterTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _personCerterTableView.delegate = self;
        _personCerterTableView.dataSource = self;
        _personCerterTableView.tableFooterView = [[UIView alloc] init];
        _personCerterTableView.separatorColor = kSeparateColor;
        _personCerterTableView.backgroundColor = kBackColor;
    }
    return _personCerterTableView;
}

#pragma mark - tableView delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return kCellHeight3;//
    }
    return kCellHeight2;//
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            identifier = @"person00";
            
            MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!cell) {
                cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            
            cell.selectedBackgroundView = [[UIView alloc] init];
            cell.selectedBackgroundView.backgroundColor = kCellSelectedColor;
            cell.userNameButton.userInteractionEnabled = NO;
            cell.userActionButton.userInteractionEnabled = NO;
            
            [cell.userNameButton setTitle:@"头像" forState:0];
            [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
            
            return cell;

        }else if (indexPath.row == 1){
            identifier = @"person01";
            
            MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!cell) {
                cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            
            cell.selectedBackgroundView = [[UIView alloc] init];
            cell.selectedBackgroundView.backgroundColor = kCellSelectedColor;
            cell.userNameButton.userInteractionEnabled = NO;
            cell.userActionButton.userInteractionEnabled = NO;
            
            [cell.userNameButton setTitle:@"昵称" forState:0];
            [cell.userActionButton setTitle:@"1111  " forState:0];
            [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
            
            return cell;

        }else if (indexPath.row == 2){
            identifier = @"person0";
            
            MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!cell) {
                cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            
            cell.selectedBackgroundView = [[UIView alloc] init];
            cell.selectedBackgroundView.backgroundColor = kCellSelectedColor;
            cell.userNameButton.userInteractionEnabled = NO;
            cell.userActionButton.userInteractionEnabled = NO;
            
            [cell.userNameButton setTitle:@"手机号码" forState:0];
            [cell.userActionButton setTitle:@"11111111111  " forState:0];
            [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
            
            return cell;
        }
    }
    identifier = @"person1";
    
    MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectedBackgroundView = [[UIView alloc] init];
    cell.selectedBackgroundView.backgroundColor = kCellSelectedColor;
    cell.userNameButton.userInteractionEnabled = NO;
    cell.userActionButton.userInteractionEnabled = NO;
    
    [cell.userNameButton setTitle:@"实名认证" forState:0];
    [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
    
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
    
    NSInteger indexRow = 4*indexPath.section + indexPath.row;
    
    switch (indexRow) {
        case 0://头像
            break;
        case 1:{//昵称
            
        }
            break;
        case 2:{//电话
            NewMobileViewController *newMobileVC = [[NewMobileViewController alloc] init];
            [self.navigationController pushViewController:newMobileVC animated:YES];
        }
            break;
        case 4://认证
            break;
        default:
            break;
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
