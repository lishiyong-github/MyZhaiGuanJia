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
#import "AuthentyWaitingViewController.h" //等待审核
#import "ModifyPassWordViewController.h"  //修改密码
#import "NewMobileViewController.h"
#import "ReceiptAddressViewController.h" //收货地址

#import "MineUserCell.h"
#import "BidOneCell.h"
#import "MessageTableViewCell.h"

#import "CompleteResponse.h"
#import "CertificationModel.h"

#import "UIButton+WebCache.h"

@interface MySettingsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *mySettingTableView;

//json
@property (nonatomic,strong) NSMutableArray *mySettingArray;

@end

@implementation MySettingsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self getDetailOfUserPerson];
}

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

- (NSMutableArray *)mySettingArray
{
    if (!_mySettingArray) {
        _mySettingArray = [NSMutableArray array];
    }
    return _mySettingArray;
}

#pragma mark - tableView delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.mySettingArray.count > 0) {
        return 5;
    }
    return 0;
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
    
    CompleteResponse *response = self.mySettingArray[0];
    
    if (indexPath.section == 0) {
        identifier = @"setting0";
        
        MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[MessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectedBackgroundView = [[UIView alloc] init];
        cell.selectedBackgroundView.backgroundColor = kCellSelectedColor;
        [cell.countLabel setHidden:YES];
        cell.imageButton.layer.cornerRadius = 25;
        cell.imageButton.layer.masksToBounds = YES;
        [cell.imageButton sd_setImageWithURL:[NSURL URLWithString:response.pictureurl] forState:0 placeholderImage:[UIImage imageNamed:@"news_system"]];
        
        cell.contentLabel.numberOfLines = 0;
        NSString *ccc1 = [NSString stringWithFormat:@"%@\n",[NSString getValidStringFromString:response.realname toString:response.username]];
        NSString *ccc2 = response.mobile;
        NSString *ccc = [NSString stringWithFormat:@"%@%@",ccc1,ccc2];
        NSMutableAttributedString *attributeCCC = [[NSMutableAttributedString alloc] initWithString:ccc];
        [attributeCCC setAttributes:@{NSFontAttributeName:kBigFont,NSForegroundColorAttributeName:kBlackColor} range:NSMakeRange(0, ccc1.length)];
        [attributeCCC setAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(ccc1.length, ccc2.length)];
        NSMutableParagraphStyle *styorr = [[NSMutableParagraphStyle alloc] init];
        [styorr setParagraphSpacing:kSpacePadding];
        [attributeCCC addAttribute:NSParagraphStyleAttributeName value:styorr range:NSMakeRange(0, ccc.length)];
        [cell.contentLabel setAttributedText:attributeCCC];
        
        [cell.timeButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        
        return cell;
    }else if (indexPath.section == 1){
        identifier = @"setting1";
        
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.selectedBackgroundView = [[UIView alloc] init];
        cell.selectedBackgroundView.backgroundColor = kCellSelectedColor;
        
        [cell.userNameButton setTitle:@"身份认证" forState:0];
        [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        
        if (response.certification) {
            if (!response.certification.state) {
                [cell.userActionButton setTitle:@"未认证" forState:0];
            }else if([response.certification.state integerValue] == 0){
                [cell.userActionButton setTitle:@"等待客服审核" forState:0];
            }else if ([response.certification.state integerValue] == 1){
                if ([response.certification.category integerValue] == 1) {
                    [cell.userActionButton setTitle:@"已认证个人" forState:0];
                }else if ([response.certification.category integerValue] == 2) {
                    [cell.userActionButton setTitle:@"已认证律所" forState:0];
                }else if ([response.certification.category integerValue] == 3) {
                    [cell.userActionButton setTitle:@"已认证公司" forState:0];
                }
            }else if ([response.certification.state integerValue] == 2){
                [cell.userActionButton setTitle:@"认证失败" forState:0];
            }
        }else{
            [cell.userActionButton setTitle:@"未认证" forState:0];
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
        
        if (response.mobile) {
            [cell.userActionButton setTitle:response.mobile forState:0];
        }else{
            [cell.userActionButton setTitle:@"未绑定" forState:0];
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
    [cell.oneButton setTitleColor:kRedColor forState:0];
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
    
    CompleteResponse *response = self.mySettingArray[0];
    
    if (indexPath.section == 0) {//个人中心
        PersonCerterViewController *personCerterVC = [[PersonCerterViewController alloc] init];
        [self.navigationController pushViewController:personCerterVC animated:YES];
    }else if(indexPath.section == 1){//身份认证
        if (response.certification) {
            if (!response.certification.state) {
                AuthentyViewController *authentyVC = [[AuthentyViewController alloc] init];
//                authentyVC.typeAuthty = @"0";
                [self.navigationController pushViewController:authentyVC animated:YES];
            }else if([response.certification.state integerValue] == 0){
                AuthentyWaitingViewController *authentyWaitingVC = [[AuthentyWaitingViewController alloc] init];
                authentyWaitingVC.backString = @"1";
                [self.navigationController pushViewController:authentyWaitingVC animated:YES];
            }else if ([response.certification.state integerValue] == 1){
                CompleteViewController *completeVC = [[CompleteViewController alloc] init];
                [self.navigationController pushViewController:completeVC animated:YES];
            }else if ([response.certification.state integerValue] == 2){
                AuthentyViewController *authentyVC = [[AuthentyViewController alloc] init];
//                authentyVC.typeAuthty = @"0";
                [self.navigationController pushViewController:authentyVC animated:YES];
            }
        }else{
            AuthentyViewController *authentyVC = [[AuthentyViewController alloc] init];
//            authentyVC.typeAuthty = @"0";
            [self.navigationController pushViewController:authentyVC animated:YES];
        }
    }else if (indexPath.section == 2 && indexPath.row == 0){//设置登录密码
        ModifyPassWordViewController *modifyPassWordVC = [[ModifyPassWordViewController alloc] init];
        modifyPassWordVC.ifFirst = response.isSetPassword;
        [self.navigationController pushViewController:modifyPassWordVC animated:YES];
    }else if (indexPath.section == 2 && indexPath.row == 1){//绑定手机
        UIAlertController *newMobileAlert = [UIAlertController alertControllerWithTitle:@"确认更改绑定手机？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        QDFWeakSelf;
        UIAlertAction *newAct0 = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NewMobileViewController *newMobileVC = [[NewMobileViewController alloc] init];
            newMobileVC.mobile = response.mobile;
            [weakself.navigationController pushViewController:newMobileVC animated:YES];
        }];
        UIAlertAction *newAct1 = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:nil];
        [newMobileAlert addAction:newAct0];
        [newMobileAlert addAction:newAct1];
        [self presentViewController:newMobileAlert animated:YES completion:nil];
    }else if (indexPath.section == 3){//收货地址
        ReceiptAddressViewController *receiptAddressListViewController = [[ReceiptAddressViewController alloc] init];
        receiptAddressListViewController.cateString = @"1";
        [self.navigationController pushViewController:receiptAddressListViewController animated:YES];
    }else if (indexPath.section == 4){//退出登录
        [self exitUser];
    }
}

#pragma mark - method
- (void)getDetailOfUserPerson
{
    NSString *aoaoa = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kPersonCenterMessagesString];
    NSDictionary *params = @{@"token" : [self getValidateToken]};
    
    QDFWeakSelf;
    [self requestDataPostWithString:aoaoa params:params successBlock:^(id responseObject) {
        
        [weakself.mySettingArray removeAllObjects];
        
        CompleteResponse *response = [CompleteResponse objectWithKeyValues:responseObject];
        [weakself.mySettingArray addObject:response];
        
        [weakself.mySettingTableView reloadData];
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)exitUser
{
    NSString *exitString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kExitString];
    NSDictionary *params = @{@"token" : [self getValidateToken]};
    
    QDFWeakSelf;
    [self requestDataPostWithString:exitString params:params successBlock:^(id responseObject){
        BaseModel *exitModel = [BaseModel objectWithKeyValues:responseObject];
        [weakself showHint:exitModel.msg];
        
        if ([exitModel.code isEqualToString:@"0000"]) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [weakself.navigationController popViewControllerAnimated:YES];
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
