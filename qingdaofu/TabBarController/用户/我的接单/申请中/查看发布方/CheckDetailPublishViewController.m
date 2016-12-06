//
//  CheckDetailPublishViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/4.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "CheckDetailPublishViewController.h"
#import "AllCommentsViewController.h"  //所有评价
#import "CaseViewController.h"  //经典案例
#import "AgreementViewController.h" //同意

#import "BaseCommitButton.h"
#import "MineUserCell.h"
#import "EvaluatePhotoCell.h"

//详细信息
#import "CompleteResponse.h"
#import "CertificationModel.h"

//收到的评价
#import "EvaluateResponse.h"
#import "EvaluateModel.h"
#import "ImageModel.h"

#import "UIButton+WebCache.h"

@interface CheckDetailPublishViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *checkDetailTableView;
@property (nonatomic,strong) BaseCommitButton *appAgreeButton;

@property (nonatomic,strong) NSMutableArray *certifiDataArray;
@property (nonatomic,strong) NSString *userId;

@end

@implementation CheckDetailPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.navTitle;
    self.navigationItem.leftBarButtonItem = self.leftItem;

    [self.view addSubview:self.checkDetailTableView];
    
    [self.view setNeedsUpdateConstraints];
    
    [self getMessageOfOrderPeople];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.checkDetailTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
//        [self.checkDetailTableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.appAgreeButton];
        
//        [self.appAgreeButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
//        [self.appAgreeButton autoSetDimension:ALDimensionHeight toSize:kTabBarHeight];
        
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)checkDetailTableView
{
    if (!_checkDetailTableView) {
        _checkDetailTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _checkDetailTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _checkDetailTableView.separatorColor = kSeparateColor;
        _checkDetailTableView.backgroundColor = kBackColor;
        _checkDetailTableView.delegate = self;
        _checkDetailTableView.dataSource = self;
        _checkDetailTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
    }
    return _checkDetailTableView;
}

- (BaseCommitButton *)appAgreeButton
{
    if (!_appAgreeButton) {
        _appAgreeButton = [BaseCommitButton newAutoLayoutView];
        [_appAgreeButton setTitle:@"同意该用户申请" forState:0];
        
        QDFWeakSelf;
        [_appAgreeButton addAction:^(UIButton *btn) {
            AgreementViewController *agreementVC = [[AgreementViewController alloc] init];
//            agreementVC.flagString = @"1";
//            agreementVC.idString = weakself.idString;
//            agreementVC.categoryString = weakself.categoryString;
//            agreementVC.pidString = weakself.pidString;
            [weakself.navigationController pushViewController:agreementVC animated:YES];
        }];
    }
    return _appAgreeButton;
}

- (NSMutableArray *)certifiDataArray
{
    if (!_certifiDataArray) {
        _certifiDataArray = [NSMutableArray array];
    }
    return _certifiDataArray;
}

#pragma mark - 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.certifiDataArray.count > 0) {
        return 2;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        CertificationModel *certificationModel = self.certifiDataArray[0];
        if ([certificationModel.category integerValue] == 1) {//个人
            return 6;
        }else if ([certificationModel.category integerValue] == 2){//律所
            return 8;
        }else if ([certificationModel.category integerValue] == 3){//公司
            return 10;
        }
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    
    if (indexPath.section == 0) {
        identifier = @"certificate0";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.userNameButton setTitleColor:kLightGrayColor forState:0];
        cell.userNameButton.titleLabel.font = kFirstFont;
        [cell.userActionButton setTitleColor:kGrayColor forState:0];
        cell.userActionButton.titleLabel.font = kFirstFont;

        CertificationModel *certificateModel = self.certifiDataArray[0];
        
        if ([certificateModel.category integerValue] == 1) {//个人
            NSArray *pubArray = @[@"基本信息",@"姓名",@"身份证号码",@"身份图片",@"联系电话",@"邮箱"];
            [cell.userNameButton setTitle:pubArray[indexPath.row] forState:0];
            
            if (indexPath.row == 0) {
                [cell.userNameButton setTitleColor:kBlackColor forState:0];
                cell.userNameButton.titleLabel.font = kBigFont;
                [cell.userActionButton setTitle:@"已认证个人" forState:0];
                [cell.userActionButton setTitleColor:kYellowColor forState:0];
            }else if (indexPath.row == 1){
                [cell.userActionButton setTitle:certificateModel.name forState:0];
            }else if (indexPath.row == 2){
                [cell.userActionButton setTitle:certificateModel.cardno forState:0];
            }else if(indexPath.row == 3){
                [cell.userActionButton setTitle:@"已验证" forState:0];
            }else if (indexPath.row == 4){
                [cell.userActionButton setTitle:[NSString getValidStringFromString:certificateModel.mobile] forState:0];
            }else if (indexPath.row == 5){
                [cell.userActionButton setTitle:[NSString getValidStringFromString:certificateModel.email] forState:0];
            }
            
            return cell;
            
        }else if ([certificateModel.category integerValue] == 2){//律所
            NSArray *pubArray = @[@"基本信息",@"律所名称",@"执业证号",@"身份图片",@"联系人",@"联系方式",@"邮箱",@"经典案例"];
            [cell.userNameButton setTitle:pubArray[indexPath.row] forState:0];
            
            if (indexPath.row == 0) {
                [cell.userNameButton setTitleColor:kBlackColor forState:0];
                cell.userNameButton.titleLabel.font = kBigFont;
                [cell.userActionButton setTitle:@"已认证律所" forState:0];
                [cell.userActionButton setTitleColor:kYellowColor forState:0];
            }else if (indexPath.row == 1){
                [cell.userActionButton setTitle:certificateModel.name forState:0];
            }else if (indexPath.row == 2){
                [cell.userActionButton setTitle:certificateModel.cardno forState:0];
            }else if(indexPath.row == 3){
                [cell.userActionButton setTitle:@"已验证" forState:0];
            }else if (indexPath.row == 4){
                [cell.userActionButton setTitle:[NSString getValidStringFromString:certificateModel.contact] forState:0];
            }else if (indexPath.row == 5){
                [cell.userActionButton setTitle:[NSString getValidStringFromString:certificateModel.mobile] forState:0];
            }else if (indexPath.row == 6){
                [cell.userActionButton setTitle:[NSString getValidStringFromString:certificateModel.email] forState:0];
            }else if (indexPath.row == 7){
                cell.userActionButton.userInteractionEnabled = NO;
                if ([certificateModel.casedesc isEqualToString:@""] || !certificateModel.casedesc) {
                    [cell.userActionButton setTitle:@"暂无" forState:0];
                }else{
                    [cell.userActionButton setTitle:@"查看" forState:0];
                    [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
                }
            }
            return cell;
        }else if ([certificateModel.category integerValue] == 3){//公司
            NSArray *pubArray = @[@"基本信息",@"公司名称",@"营业执照号",@"身份图片",@"联系人",@"联系方式",@"企业邮箱",@"公司经营地址",@"公司网站",@"经典案例"];
            [cell.userNameButton setTitle:pubArray[indexPath.row] forState:0];
            
            if (indexPath.row == 0) {
                [cell.userNameButton setTitleColor:kBlackColor forState:0];
                cell.userNameButton.titleLabel.font = kBigFont;
                [cell.userActionButton setTitle:@"已认证公司" forState:0];
                [cell.userActionButton setTitleColor:kYellowColor forState:0];
            }else if (indexPath.row == 1){
                [cell.userActionButton setTitle:certificateModel.name forState:0];
            }else if (indexPath.row == 2){
                [cell.userActionButton setTitle:certificateModel.cardno forState:0];
            }else if(indexPath.row == 3){
                [cell.userActionButton setTitle:@"已验证" forState:0];
            }else if (indexPath.row == 4){
                [cell.userActionButton setTitle:[NSString getValidStringFromString:certificateModel.contact] forState:0];
            }else if (indexPath.row == 5){
                [cell.userActionButton setTitle:[NSString getValidStringFromString:certificateModel.mobile] forState:0];
            }else if (indexPath.row == 6){
                [cell.userActionButton setTitle:[NSString getValidStringFromString:certificateModel.email] forState:0];
            }else if (indexPath.row == 7){
                [cell.userActionButton setTitle:[NSString getValidStringFromString:certificateModel.address] forState:0];
            }else if (indexPath.row == 8){
                [cell.userActionButton setTitle:[NSString getValidStringFromString:certificateModel.enterprisewebsite] forState:0];
            }else if (indexPath.row == 9){
                cell.userNameButton.userInteractionEnabled = NO;
                cell.userActionButton.userInteractionEnabled = NO;
                if ([certificateModel.casedesc isEqualToString:@""] || !certificateModel.casedesc) {
                    [cell.userActionButton setTitle:@"暂无" forState:0];
                }else{
                    [cell.userActionButton setTitle:@"查看" forState:0];
                    [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
                }
            }
            return cell;
        }
    }
    
    //section=1评价
    if (indexPath.row == 0) {
        identifier = @"evaluate00";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.userNameButton setTitle:@"收到的评价" forState:0];
        [cell.userActionButton setTitle:@"点击查看" forState:0];
        [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        
        return cell;
    }
    return nil;
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
    if (indexPath.section == 0) {
        
        CertificationModel *certificateModel = self.certifiDataArray[0];
        
        if ([certificateModel.category integerValue] == 2){
            if (indexPath.row == 7) {
                if ([certificateModel.casedesc isEqualToString:@""] || !certificateModel.casedesc) {
                }else{
                    CaseViewController *caseVC = [[CaseViewController alloc] init];
                    caseVC.caseString = certificateModel.casedesc;
                    [self.navigationController pushViewController:caseVC animated:YES];
                }
            }
        }else if ([certificateModel.category integerValue] == 3){
            if (indexPath.row == 9) {
                if ([certificateModel.casedesc isEqualToString:@""] || !certificateModel.casedesc) {
                }else{
                    CaseViewController *caseVC = [[CaseViewController alloc] init];
                    caseVC.caseString = certificateModel.casedesc;
                    [self.navigationController pushViewController:caseVC animated:YES];
                }
            }
        }
    }else if ((indexPath.section == 1) && (indexPath.row == 0)) {//全部评价
        
        AllCommentsViewController *allCommentsVC = [[AllCommentsViewController alloc] init];
        allCommentsVC.userid = self.userid;
        [self.navigationController pushViewController:allCommentsVC animated:YES];
    }
}

#pragma mark - method
- (void)getMessageOfOrderPeople
{
    NSString *yyyString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kPersonCenterMessageString];
    
    NSDictionary *params = @{@"userid" : self.userid,
                             @"productid" : self.productid,
                             @"token" : [self getValidateToken]
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:yyyString params:params successBlock:^(id responseObject) {
        
        CompleteResponse *response = [CompleteResponse objectWithKeyValues:responseObject];
        
        weakself.userid = response.userid;
        
        if ([response.code isEqualToString:@"0000"]) {
            if (response.certification) {
                [weakself.certifiDataArray addObject:response.certification];
            
                if ([weakself.navTitle containsString:@"申请方"]) {
                    weakself.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:weakself.rightButton];
                    [weakself.rightButton setImage:[UIImage imageNamed:@"contacts_phone"] forState:0];
                }
            }
            
        }else{
            [weakself showHint:response.msg];
        }
        [weakself.checkDetailTableView reloadData];
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)rightItemAction
{
    CertificationModel *certificationModel = self.certifiDataArray[0];
    //显示电话
    NSMutableString *phonne = [NSMutableString stringWithFormat:@"telprompt://%@",certificationModel.mobile];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phonne]];

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
