//
//  CompleteViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/4/28.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "CompleteViewController.h"

#import "AuthentyViewController.h"//修改认证
#import "AuthenPersonViewController.h"  //认证个人
#import "AuthenLawViewController.h"
#import "AuthenCompanyViewController.h"

#import "MineUserCell.h"
#import "BaseCommitView.h"

#import "CompetetesResponse.h"
#import "CertificationModel.h"

#import "UIButton+WebCache.h"
#import "NSString+Fram.h"
#import "UIViewController+ImageBrowser.h"

@interface CompleteViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *completeTableView;

//json
@property (nonatomic,strong) NSMutableArray *completeDataArray;

@end

@implementation CompleteViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self showCompleteMessages];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = self.leftItem;
    [self.view addSubview:self.completeTableView];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.completeTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)completeTableView
{
    if (!_completeTableView) {
        _completeTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _completeTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _completeTableView.delegate = self;
        _completeTableView.dataSource = self;
        _completeTableView.backgroundColor = kBackColor;
        _completeTableView.separatorInset = UIEdgeInsetsZero;
        _completeTableView.separatorColor = kSeparateColor;
    }
    return _completeTableView;
}

- (NSMutableArray *)completeDataArray
{
    if (!_completeDataArray) {
        _completeDataArray = [NSMutableArray array];
    }
    return _completeDataArray;
}

#pragma mark - tableView delegate and datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CompetetesResponse *response = self.completeDataArray[0];
    
    CGSize titleSize = CGSizeMake(kScreenWidth - 137, MAXFLOAT);
    CGSize  actualsize =[response.certification.casedesc boundingRectWithSize:titleSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :kFirstFont} context:nil].size;
    
    if ([response.certification.category integerValue] == 1) {
         return kCellHeight;
    }else if ([response.certification.category integerValue] == 2){
        if (indexPath.row == 5) {
            return 11 + MAX(actualsize.height, 33);
        }
        return kCellHeight;
    }else if ([response.certification.category integerValue] == 3){
        if (indexPath.row == 7) {
            return 11 + MAX(actualsize.height, 33);
        }
        return kCellHeight;
    }
    
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.completeDataArray.count > 0) {
        CompetetesResponse *response = self.completeDataArray[0];
        
        if ([response.certification.category integerValue] == 1) {
            return 4;
        }else if ([response.certification.category integerValue] == 2){
            return 6;
        }else if ([response.certification.category integerValue] == 3){
            return 8;
        }
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"complete";
    MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.userNameButton setTitleColor:kLightGrayColor forState:0];
    cell.userNameButton.titleLabel.font = kFirstFont;
    [cell.userActionButton setTitleColor:kBlackColor forState:0];
    cell.userActionButton.titleLabel.font = kBigFont;
    
    CompetetesResponse *response = self.completeDataArray[0];
    CertificationModel *model = response.certification;
    
    if ([response.certification.category integerValue] == 1) {//个人
        if (indexPath.row == 0) {
            [cell.userNameButton setTitle:@"姓名" forState:0];
            [cell.userActionButton setTitle:model.name forState:0];
        }else if (indexPath.row == 1){
            [cell.userNameButton setTitle:@"身份证" forState:0];
            [cell.userActionButton setTitle:model.cardno forState:0];
        }else if (indexPath.row == 2){
            [cell.userNameButton setTitle:@"联系方式" forState:0];
            [cell.userActionButton setTitle:model.mobile forState:0];
        }else if (indexPath.row == 3){
            [cell.userNameButton setTitle:@"邮箱" forState:0];
            [cell.userActionButton setTitle:[NSString getValidStringFromString:model.email] forState:0];
        }
    }else if ([response.certification.category integerValue] == 2){//律所
        if (indexPath.row == 0) {
            [cell.userNameButton setTitle:@"律所名称" forState:0];
            [cell.userActionButton setTitle:model.name forState:0];
        }else if (indexPath.row == 1){
            [cell.userNameButton setTitle:@"执业证号" forState:0];
            [cell.userActionButton setTitle:model.cardno forState:0];
        }else if (indexPath.row == 2){
            [cell.userNameButton setTitle:@"联系人" forState:0];
            [cell.userActionButton setTitle:model.contact forState:0];
        }else if (indexPath.row == 3){
            [cell.userNameButton setTitle:@"联系方式" forState:0];
            [cell.userActionButton setTitle:model.mobile forState:0];
        }else if (indexPath.row == 4){
            [cell.userNameButton setTitle:@"邮箱" forState:0];
            [cell.userActionButton setTitle:[NSString getValidStringFromString:model.email] forState:0];
        }else if (indexPath.row == 5){
            [cell.userNameButton setTitle:@"经典案例" forState:0];
            [cell.userActionButton setTitle:[NSString getValidStringFromString:model.casedesc] forState:0];
        }
    }else if ([response.certification.category integerValue] == 3){//公司
        if (indexPath.row == 0) {
            [cell.userNameButton setTitle:@"公司名称" forState:0];
            [cell.userActionButton setTitle:model.name forState:0];
        }else if (indexPath.row == 1){
            [cell.userNameButton setTitle:@"营业执照号" forState:0];
            [cell.userActionButton setTitle:model.cardno forState:0];
        }else if (indexPath.row == 2){
            [cell.userNameButton setTitle:@"联系人" forState:0];
            [cell.userActionButton setTitle:model.contact forState:0];
        }else if (indexPath.row == 3){
            [cell.userNameButton setTitle:@"联系方式" forState:0];
            [cell.userActionButton setTitle:model.mobile forState:0];
        }else if (indexPath.row == 4){
            [cell.userNameButton setTitle:@"企业邮箱" forState:0];
            [cell.userActionButton setTitle:[NSString getValidStringFromString:model.email] forState:0];
        }
        else if (indexPath.row == 5){
            [cell.userNameButton setTitle:@"企业地址" forState:0];
            [cell.userActionButton setTitle:[NSString getValidStringFromString:model.address] forState:0];
        }
        else if (indexPath.row == 6){
            [cell.userNameButton setTitle:@"公司网站" forState:0];
            [cell.userActionButton setTitle:[NSString getValidStringFromString:model.enterprisewebsite] forState:0];
        }
        else if (indexPath.row == 7){
            [cell.userNameButton setTitle:@"经典案例" forState:0];
            [cell.userActionButton setTitle:[NSString getValidStringFromString:model.casedesc] forState:0];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 150;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
    headerView.backgroundColor = kBackColor;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 140)];
    [imageView setImage:[UIImage imageNamed:@"certification_success_banner"]];
    [headerView addSubview:imageView];
    
    return headerView;
}

#pragma mark - method
- (void)showCompleteMessages
{
    NSString *completeString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kAuthenCompeteString];
    NSDictionary *params = @{@"token" : [self getValidateToken]};
    
    QDFWeakSelf;
    [self requestDataPostWithString:completeString params:params successBlock:^(id responseObject){
        [weakself.completeDataArray removeAllObjects];
                        
        CompetetesResponse *response = [CompetetesResponse objectWithKeyValues:responseObject];
        
        if ([response.certification.category integerValue] == 1) {
            self.title = @"个人认证成功";
        }else if ([response.certification.category integerValue] == 2){
            self.title = @"律所认证成功";
        }else if ([response.certification.category integerValue] == 3){
            self.title = @"公司认证成功";
        }
        
        [weakself.completeDataArray addObject:response];
        [weakself.completeTableView reloadData];
        
    } andFailBlock:^(NSError *error){
        
    }];
}

//跳转
- (void)goToEditCompleteMessagesWithResponseModel:(CompetetesResponse *)response
{
    if ([response.certification.category intValue] == 1) {//个人
        AuthenPersonViewController *authenPersonVC = [[AuthenPersonViewController alloc] init];
        [self.navigationController pushViewController:authenPersonVC animated:YES];
    }else if ([response.certification.category intValue] == 2){//律所
        AuthenLawViewController *authenLawVC = [[AuthenLawViewController alloc] init];
        [self.navigationController pushViewController:authenLawVC animated:YES];
    }else if([response.certification.category intValue] == 3){//公司
        AuthenCompanyViewController *authenCompanyVC = [[AuthenCompanyViewController alloc] init];
        [self.navigationController pushViewController:authenCompanyVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
