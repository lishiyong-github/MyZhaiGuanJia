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

#import "CompleteCell.h"
#import "CompleteLawCell.h"
#import "CompleteCompanyTableViewCell.h"

#import "CompleteResponse.h"
#import "CertificationModel.h"

#import "UIButton+WebCache.h"
#import "NSString+Fram.h"
#import "UIViewController+ImageBrowser.h"

@interface CompleteViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *completeTableView;
@property (nonatomic,strong) UIButton *comFooterView;
@property (nonatomic,strong) BaseCommitView *completeCommitButton;
@property (nonatomic,strong) UIButton *navRightButton;

@property (nonatomic,strong) NSMutableArray *completeDataArray;

@end

@implementation CompleteViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self showCompleteMessages];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.categoryString intValue] == 1) {
        self.navigationItem.title = @"个人认证成功";
    }else if ([self.categoryString intValue] == 2){
        self.navigationItem.title = @"律所认证成功";
    }else{
        self.navigationItem.title = @"公司认证成功";
    }
    
    self.navigationItem.leftBarButtonItem = self.leftItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.navRightButton];
    
    [self.view addSubview:self.completeTableView];
    [self.view addSubview:self.completeCommitButton];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.completeTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.completeTableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.completeCommitButton];
        
        [self.completeCommitButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.completeCommitButton autoSetDimension:ALDimensionHeight toSize:kCellHeight1];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UIButton *)navRightButton
{
    if (!_navRightButton) {
        _navRightButton = [UIButton buttonWithType:0];
        _navRightButton.frame = CGRectMake(0, 0, 70, 30);
        _navRightButton.layer.cornerRadius = corner;
        _navRightButton.layer.masksToBounds = YES;
        _navRightButton.layer.borderColor = kBlueColor.CGColor;
        _navRightButton.layer.borderWidth = kLineWidth;
        [_navRightButton setTitle:@"编辑资料" forState:0];
        _navRightButton.titleLabel.font = kFirstFont;
        [_navRightButton setTitleColor:kBlueColor forState:0];
        
        QDFWeakSelf;
        [_navRightButton addAction:^(UIButton *btn) {
            if (weakself.completeDataArray.count > 0) {
                CompleteResponse *compleResponse = weakself.completeDataArray[0];
                if ([compleResponse.completionRate integerValue] < 1) {
                    [weakself goToEditCompleteMessagesWithResponseModel:weakself.completeDataArray[0]];
                }else{
                    [weakself showHint:@"认证信息已完善，不能编辑资料了"];
                }
            }
        }];
    }
    return _navRightButton;
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

- (BaseCommitView *)completeCommitButton
{
    if (!_completeCommitButton) {
        _completeCommitButton = [BaseCommitView newAutoLayoutView];
        [_completeCommitButton.button setTitle:@"修改认证" forState:0];
        
        QDFWeakSelf;
        [_completeCommitButton addAction:^(UIButton *btn) {
            AuthentyViewController *authentyVC = [[AuthentyViewController alloc] init];
            authentyVC.typeAuthty = @"1";
            [weakself.navigationController pushViewController:authentyVC animated:YES];
        }];
    }
    return _completeCommitButton;
}

- (UIButton *)comFooterView
{
    if (!_comFooterView) {
        _comFooterView = [UIButton buttonWithType:0];
        _comFooterView.frame = CGRectMake(0, 0, kScreenWidth, 40);
        [_comFooterView setTitle:@"在您未发布及未接单前，您可以根据实际需要，修改您的身份认证" forState:0];
        [_comFooterView setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_comFooterView setTitleColor:kLightGrayColor forState:0];
        _comFooterView.titleLabel.font = kSecondFont;
        _comFooterView.titleLabel.numberOfLines = 0;
        [_comFooterView setContentEdgeInsets:UIEdgeInsetsMake(kSmallPadding, kBigPadding, kBigPadding, kBigPadding)];
    }
    return _comFooterView;
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
    if ([self.categoryString integerValue] > 1) {//律所
        CompleteResponse *response;
        if (self.completeDataArray.count > 0) {
            response = self.completeDataArray[0];
        }
        
        CGSize titleSize = CGSizeMake(kScreenWidth - 137, MAXFLOAT);
        CGSize  actualsize =[response.certification.casedesc boundingRectWithSize:titleSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :kFirstFont} context:nil].size;
        
        if ([self.categoryString integerValue] == 2) {
            if (indexPath.row == 5) {
                return 11 + MAX(actualsize.height, 33);
            }
            return kCellHeight;
        }else{
            if (indexPath.row == 7) {
                return 11 + MAX(actualsize.height, 33);
            }
            return kCellHeight;
        }
    }
    return kCellHeight;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.completeDataArray.count > 0) {
        CompleteResponse *response;
        response = self.completeDataArray[0];
        
        if ([self.categoryString integerValue] == 1) {
            return 4;
        }else if ([self.categoryString integerValue] == 2){
            return 6;
        }else if ([self.categoryString integerValue] == 3){
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
    
    CertificationModel *model;
    if (self.completeDataArray.count > 0) {
        CompleteResponse *response = self.completeDataArray[0];
        model = response.certification;
    }
    
    if ([self.categoryString integerValue] == 1) {//个人
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
    }else if ([self.categoryString integerValue] == 2){//律所
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
    }else if ([self.categoryString integerValue] == 3){//公司
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50;
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

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    
    UILabel *label = [UILabel newAutoLayoutView];
    label.textColor = kLightGrayColor;
    label.text = @"在您未发布及未接单前，您可以根据实际需要，修改您的身份认证";
    label.font = kSmallFont;
    label.numberOfLines = 0;
    [footerView addSubview:label];
    
    [label autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(kBigPadding, kBigPadding, 0, kBigPadding) excludingEdge:ALEdgeBottom];
    
    return footerView;
}

#pragma mark - method
- (void)showCompleteMessages
{
    NSString *completeString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kIsCompleteString];
    NSDictionary *params = @{@"token" : [self getValidateToken]};
    
    QDFWeakSelf;
    [self requestDataPostWithString:completeString params:params successBlock:^(id responseObject){
                
        CompleteResponse *response = [CompleteResponse objectWithKeyValues:responseObject];
        
        [weakself.completeDataArray addObject:response];
        [weakself.completeTableView reloadData];
        
        if ([response.certification.canModify integerValue] == 0) {//canModify＝1可以修改，＝0不可修改
            [weakself.completeCommitButton.button setTitle:@"不可修改认证" forState:0];
            weakself.completeCommitButton.userInteractionEnabled = NO;
        }
    } andFailBlock:^(NSError *error){
        
    }];
}

//跳转
- (void)goToEditCompleteMessagesWithResponseModel:(CompleteResponse *)response
{
    if ([self.categoryString intValue] == 1) {//个人
        AuthenPersonViewController *authenPersonVC = [[AuthenPersonViewController alloc] init];
        authenPersonVC.typeAuthen = @"1";
        authenPersonVC.respnseModel = response;
        authenPersonVC.categoryString = self.categoryString;
        [self.navigationController pushViewController:authenPersonVC animated:YES];
    }else if ([self.categoryString intValue] == 2){//律所
        AuthenLawViewController *authenLawVC = [[AuthenLawViewController alloc] init];
        authenLawVC.responseModel = response;
        authenLawVC.typeAuthen = @"1";
        authenLawVC.categoryString = self.categoryString;
        [self.navigationController pushViewController:authenLawVC animated:YES];
    }else if([self.categoryString intValue] == 3){//公司
        AuthenCompanyViewController *authenCompanyVC = [[AuthenCompanyViewController alloc] init];
        authenCompanyVC.responseModel = response;
        authenCompanyVC.typeAuthen = @"1";
        authenCompanyVC.categoryString = self.categoryString;
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
