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
#import "BaseCommitButton.h"

#import "CompleteCell.h"
#import "CompleteLawCell.h"
#import "CompleteCompanyTableViewCell.h"

#import "CompleteResponse.h"
#import "CertificationModel.h"

#import "UIButton+WebCache.h"
#import "NSString+Fram.h"

@interface CompleteViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *completeTableView;
@property (nonatomic,strong) UIButton *comFooterView;
@property (nonatomic,strong) BaseCommitButton *completeCommitButton;
@property (nonatomic,strong) UIButton *navRightButton;

@property (nonatomic,strong) NSMutableArray *completeDataArray;

@end

@implementation CompleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.categoryString intValue] == 1) {
        self.navigationItem.title = @"个人信息";
    }else if ([self.categoryString intValue] == 2){
        self.navigationItem.title = @"律所信息";
    }else{
        self.navigationItem.title = @"公司信息";
    }
    
    self.navigationItem.leftBarButtonItem = self.leftItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.navRightButton];
    
    [self.view addSubview:self.completeTableView];
    [self.view addSubview:self.completeCommitButton];
    [self.view setNeedsUpdateConstraints];
    
    [self showCompleteMessages];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.completeTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.completeTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kTabBarHeight];
        
        [self.completeCommitButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.completeCommitButton autoSetDimension:ALDimensionHeight toSize:kTabBarHeight];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UIButton *)navRightButton
{
    if (!_navRightButton) {
        _navRightButton = [UIButton buttonWithType:0];
        _navRightButton.frame = CGRectMake(0, 0, 24, 24);
        [_navRightButton setImage:[UIImage imageNamed:@"nav_tip"] forState:0];
        
        UIImageView *remindImageView = [UIImageView newAutoLayoutView];
        remindImageView.image = [UIImage imageNamed:@"tip_image"];
        [_navRightButton addSubview:remindImageView];
        [remindImageView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_navRightButton withOffset:5];
        [remindImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_navRightButton];
        [remindImageView setHidden:YES];
        
        [_navRightButton addAction:^(UIButton *btn) {
            btn.selected = !btn.selected;
            
            if (btn.selected) {
                [remindImageView setHidden:NO];
            }else{
                [remindImageView setHidden:YES];
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [remindImageView setHidden:YES];
                btn.selected = NO;
            });
        }];
    }
    return _navRightButton;
}

- (UITableView *)completeTableView
{
    if (!_completeTableView) {
        _completeTableView = [UITableView newAutoLayoutView];
        _completeTableView.delegate = self;
        _completeTableView.dataSource = self;
        _completeTableView.backgroundColor = kBackColor;
        _completeTableView.separatorInset = UIEdgeInsetsZero;
        _completeTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
        _completeTableView.tableFooterView = [[UIView alloc] init];
        [_completeTableView.tableFooterView addSubview:self.comFooterView];
    }
    return _completeTableView;
}

- (BaseCommitButton *)completeCommitButton
{
    if (!_completeCommitButton) {
        _completeCommitButton = [BaseCommitButton newAutoLayoutView];
        [_completeCommitButton setTitle:@"修改认证" forState:0];
        
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CompleteResponse *response;
    if (self.completeDataArray.count > 0) {
        response = self.completeDataArray[0];
    }
    
    CGSize titleSize = CGSizeMake(0, MAXFLOAT);
    NSDictionary *tdic = [NSDictionary dictionaryWithObjectsAndKeys:kFirstFont,NSFontAttributeName,nil];
    CGSize  actualsize =[response.certification.casedesc boundingRectWithSize:titleSize options:NSStringDrawingUsesLineFragmentOrigin attributes:tdic context:nil].size;

    NSLog(@"actualsize is %f",actualsize.height);
    
    if ([self.categoryString intValue] == 1) {//个人
        if (indexPath.row == 0) {
            return kCellHeight;
        }
        return 230+actualsize.height;
        
    }else if ([self.categoryString intValue] == 2){//律所
        if (indexPath.row == 0) {
            return kCellHeight;
        }
        
        return 260+actualsize.height;
    }
    
    //公司
    if (indexPath.row == 0) {
        return kCellHeight;
    }
    return 345 + actualsize.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    if (indexPath.row == 0) {
        identifier = @"complete0";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.userNameButton setTitle:@"|  认证信息" forState:0];
        [cell.userNameButton setTitleColor:kBlueColor forState:0];
        
        CompleteResponse *response;
        if (self.completeDataArray.count > 0) {
            response = self.completeDataArray[0];
        }
        
        if ([response.certification.canModify integerValue] == 0) {//canModify＝1可以修改，＝0不可修改
            [cell.userActionButton setHidden:YES];
        }
        
        if ([response.completionRate floatValue] < 1) {
            [cell.userActionButton setHidden:NO];
            [cell.userActionButton setTitle:@"编辑" forState:0];
            [cell.userActionButton setTitleColor:kBlueColor forState:0];
            cell.userActionButton.titleLabel.font = kFirstFont;
            QDFWeakSelf;
            [cell.userActionButton addAction:^(UIButton *btn) {
                [weakself goToEditCompleteMessagesWithResponseModel:response];
            }];
        }
        return cell;
    }
    
    //具体信息
    CompleteResponse *response;
    CertificationModel *certificationModel;
    if (self.completeDataArray.count > 0) {
        response = self.completeDataArray[0];
        certificationModel = response.certification;
    }
    
    if ([self.categoryString intValue] == 1) {//个人
        identifier = @"complete11";
        CompleteCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[CompleteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSMutableAttributedString *nameString = [cell.comNameLabel setAttributeString:@"姓名：            " withColor:kBlackColor andSecond:certificationModel.name withColor:kLightGrayColor withFont:14];
        [cell.comNameLabel setAttributedText:nameString];
        
        NSMutableAttributedString *IDString = [cell.comIDLabel setAttributeString:@"身份证号码：" withColor:kBlackColor andSecond:certificationModel.cardno withColor:kLightGrayColor withFont:14];
        [cell.comIDLabel setAttributedText:IDString];
        
        //图片
        NSString *subString = [certificationModel.cardimg substringWithRange:NSMakeRange(1, certificationModel.cardimg.length-2)];
        NSString *urlString = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,subString];
        NSURL *url = [NSURL URLWithString:urlString];
        [cell.comPicButton sd_setBackgroundImageWithURL:url forState:0 placeholderImage:[UIImage imageNamed:@"account_bitmap"]];
        
        NSMutableAttributedString *mobileString = [cell.comIDLabel setAttributeString:@"联系方式：    " withColor:kBlackColor andSecond:certificationModel.mobile withColor:kLightGrayColor withFont:14];
        [cell.mobileLabel setAttributedText:mobileString];
        
        NSMutableAttributedString *mailString = [cell.comMailLabel setAttributeString:@"邮箱：            " withColor:kBlackColor andSecond:certificationModel.email?certificationModel.email:@"未填写" withColor:kLightGrayColor withFont:14];
        [cell.comMailLabel setAttributedText:mailString];
        
        cell.comExampleLabel.text = @"经典案例：   ";
        cell.comExampleLabel2.text = certificationModel.casedesc?certificationModel.casedesc:@"未填写";
        
        return cell;
        
    }else if ([self.categoryString intValue] == 2){//律所
        identifier = @"complete12";
        CompleteLawCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[CompleteLawCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSMutableAttributedString *nameString = [cell.comNameLabel setAttributeString:@"律所名称：" withColor:kBlackColor andSecond:certificationModel.name withColor:kLightGrayColor withFont:14];
        [cell.comNameLabel setAttributedText:nameString];
        
        NSMutableAttributedString *IDString = [cell.comIDLabel setAttributeString:@"执业证号：" withColor:kBlackColor andSecond:certificationModel.cardno withColor:kLightGrayColor withFont:14];
        [cell.comIDLabel setAttributedText:IDString];
        
        //图片
        NSString *subString = [certificationModel.cardimg substringWithRange:NSMakeRange(1, certificationModel.cardimg.length-2)];
        NSString *urlString = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,subString];
        NSURL *url = [NSURL URLWithString:urlString];
        [cell.comPicButton sd_setBackgroundImageWithURL:url forState:0 placeholderImage:[UIImage imageNamed:@"account_bitmap"]];
        
        NSMutableAttributedString *personNameString = [cell.comPersonNameLabel setAttributeString:@"联系人：    " withColor:kBlackColor andSecond:certificationModel.contact withColor:kLightGrayColor withFont:14];
        [cell.comPersonNameLabel setAttributedText:personNameString];
        
        NSMutableAttributedString *personTelString = [cell.comPersonTelLabel setAttributeString:@"联系方式：" withColor:kBlackColor andSecond:certificationModel.mobile withColor:kLightGrayColor withFont:14];
        [cell.comPersonTelLabel setAttributedText:personTelString];
        
        NSMutableAttributedString *mailString = [cell.comMailLabel setAttributeString:@"邮箱：        " withColor:kBlackColor andSecond:certificationModel.email withColor:kLightGrayColor withFont:14];
        [cell.comMailLabel setAttributedText:mailString];
        
        cell.comExampleLabel.text = @"经典案例：";
        cell.comExampleLabel2.text = certificationModel.casedesc;
        
        return cell;

    }else if([self.categoryString intValue] == 3){//公司
        identifier = @"complete13";
        CompleteCompanyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[CompleteCompanyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSMutableAttributedString *nameString = [cell.comNameLabel setAttributeString:@"公司名称：        " withColor:kBlackColor andSecond:certificationModel.name withColor:kLightGrayColor withFont:14];
        [cell.comNameLabel setAttributedText:nameString];
        
        NSMutableAttributedString *IDString = [cell.comIDLabel setAttributeString:@"营业执照号：    " withColor:kBlackColor andSecond:certificationModel.cardno withColor:kLightGrayColor withFont:14];
        [cell.comIDLabel setAttributedText:IDString];
        
        //图片
        NSString *subString = [certificationModel.cardimg substringWithRange:NSMakeRange(1, certificationModel.cardimg.length-2)];
        NSString *urlString = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,subString];
        NSURL *url = [NSURL URLWithString:urlString];
        [cell.comPicButton sd_setBackgroundImageWithURL:url forState:0 placeholderImage:[UIImage imageNamed:@"account_bitmap"]];
        
        NSMutableAttributedString *personNameString = [cell.comPersonNameLabel setAttributeString:@"联系人：            " withColor:kBlackColor andSecond:certificationModel.contact withColor:kLightGrayColor withFont:14];
        [cell.comPersonNameLabel setAttributedText:personNameString];
        
        NSMutableAttributedString *personTelString = [cell.comPersonTelLabel setAttributeString:@"联系方式：        " withColor:kBlackColor andSecond:certificationModel.mobile withColor:kLightGrayColor withFont:14];
        [cell.comPersonTelLabel setAttributedText:personTelString];
        
        NSMutableAttributedString *mailString = [cell.comMailLabel setAttributeString:@"企业邮箱：        " withColor:kBlackColor andSecond:certificationModel.email withColor:kLightGrayColor withFont:14];
        [cell.comMailLabel setAttributedText:mailString];
        
        NSMutableAttributedString *addressString = [cell.comAddressLabel setAttributeString:@"企业经营地址：" withColor:kBlackColor andSecond:certificationModel.address withColor:kLightGrayColor withFont:14];
        [cell.comAddressLabel setAttributedText:addressString];
        
        NSMutableAttributedString *websiteString = [cell.comWebsiteLabel setAttributeString:@"公司网站：        " withColor:kBlackColor andSecond:certificationModel.enterprisewebsite withColor:kLightGrayColor withFont:14];
        [cell.comWebsiteLabel setAttributedText:websiteString];
        
        cell.comExampleLabel.text = @"经典案例：";
        cell.comExampleLabel2.text = certificationModel.casedesc;
        
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}


#pragma mark - method

#pragma mark - method
- (void)showCompleteMessages
{
    NSString *completeString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kIsCompleteString];
    NSDictionary *params = @{@"token" : [self getValidateToken]};
    [self requestDataPostWithString:completeString params:params successBlock:^(id responseObject){
        
        CompleteResponse *response = [CompleteResponse objectWithKeyValues:responseObject];
        
        [self.completeDataArray addObject:response];
        [self.completeTableView reloadData];
        
        if ([response.certification.canModify integerValue] == 0) {//canModify＝1可以修改，＝0不可修改
            [self.completeCommitButton setBackgroundColor:kSelectedColor];
            [self.completeCommitButton setTitle:@"不可修改认证" forState:0];
            [self.completeCommitButton setTitleColor:kBlackColor forState:0];
            self.completeCommitButton.userInteractionEnabled = NO;
        }
    } andFailBlock:^(NSError *error){
        
    }];
}

- (void)showRemindMessage:(UIBarButtonItem *)barButton
{
    UIButton *remindButton = [UIButton newAutoLayoutView];
    [self.view addSubview:remindButton];
    
    [remindButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:-10];
    [remindButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5];
    [remindButton autoSetDimensionsToSize:CGSizeMake(100, 40)];
    remindButton.backgroundColor = kBlueColor;
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
