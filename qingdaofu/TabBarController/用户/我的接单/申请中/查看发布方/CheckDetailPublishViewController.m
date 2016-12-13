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
#import "EvaluatePhotoCell.h"//评论

//详细信息
#import "CompleteResponse.h"
#import "CertificationModel.h"

//收到的评价
#import "CheckEvaluateResponse.h"
#import "EvaluateModel.h"
#import "ImageModel.h"

#import "UIButton+WebCache.h"
#import "UIViewController+ImageBrowser.h"

@interface CheckDetailPublishViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *checkDetailTableView;

//json
@property (nonatomic,strong) NSMutableArray *personMessageArray;

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

- (NSMutableArray *)personMessageArray
{
    if (!_personMessageArray) {
        _personMessageArray = [NSMutableArray array];
    }
    return _personMessageArray;
}

#pragma mark - 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.personMessageArray.count > 0) {
        CompleteResponse *response = self.personMessageArray[0];
        if (response.certification) {
            return 2;
        }else{
            return 0;
        }
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {//认证信息
        CompleteResponse *response = self.personMessageArray[0];
        CertificationModel *certificationModel = response.certification;
        if ([certificationModel.category integerValue] == 1) {//个人
            return 6;
        }else if ([certificationModel.category integerValue] == 2){//律所
            return 8;
        }else if ([certificationModel.category integerValue] == 3){//公司
            return 10;
        }
    }else if(section == 1){//评论
        CompleteResponse *response = self.personMessageArray[0];
        CheckEvaluateResponse *evaluateResponse = response.commentdata;
        if (evaluateResponse.Comments1.count > 0) {//有评论
            return 2;
        }else{//无评论
            return 1;
        }
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (indexPath.row > 0) {
            CompleteResponse *response = self.personMessageArray[0];
            CheckEvaluateResponse *evaluateResponse = response.commentdata;
            EvaluateModel *evaluateModel = evaluateResponse.Comments1[0];
            if (evaluateModel.filesImg.count > 0) {
                return 145;
            }else{
                return 85;
            }
        }else{
            return kCellHeight;
        }
    }
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

        CompleteResponse *response = self.personMessageArray[0];
        CertificationModel *certificateModel = response.certification;;
        
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
        
        CompleteResponse *response = self.personMessageArray[0];
        CheckEvaluateResponse *evaluateResponse = response.commentdata;
        
        NSString *scores;
        if (evaluateResponse.Comments1.count > 0) {
            scores = [NSString stringWithFormat:@"收到的评价(%@分)",evaluateResponse.commentsScore];
        }else{
            scores = @"收到的评价";
        }
        [cell.userNameButton setTitle:scores forState:0];
        
        if (evaluateResponse.Comments1.count > 0) {
            [cell.userActionButton setTitle:@"点击查看" forState:0];
            [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        }else{
            [cell.userActionButton setTitle:@"暂无" forState:0];
        }
        
        return cell;
    }else{//具体评价
        identifier = @"evaluate1";
        EvaluatePhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[EvaluatePhotoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CompleteResponse *response = self.personMessageArray[0];
        CheckEvaluateResponse *evaluateResponse = response.commentdata;
        EvaluateModel *evaluateModel = evaluateResponse.Comments1[0];
        
        NSString *sss = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,evaluateModel.headimg.file];
        [cell.evaNameButton sd_setImageWithURL:[NSURL URLWithString:sss] forState:0 placeholderImage:[UIImage imageNamed:@"icon_head"]];
        NSString *namee = [NSString getValidStringFromString:evaluateModel.realname toString:evaluateModel.username];
        cell.evaNameLabel.text = namee;
        
        cell.evaTimeLabel.text = [NSDate getYMDFormatterTime:evaluateModel.action_at];
        cell.evaTextLabel.text = [NSString getValidStringFromString:evaluateModel.memo toString:@"未填写评价内容"];
        [cell.evaStarImage setCurrentIndex:[evaluateModel.assort_score integerValue]];
        
        //图片
        QDFWeakSelf;
        if (evaluateModel.filesImg.count == 0) {
            [cell.evaProImageView1 setHidden:YES];
            [cell.evaProImageView2 setHidden:YES];
        }else if (evaluateModel.filesImg.count == 1) {
            
            ImageModel *imageModel = [ImageModel objectWithKeyValues:evaluateModel.filesImg[0]];
            
            [cell.evaProImageView1 setHidden:NO];
            [cell.evaProImageView2 setHidden:YES];
            NSString *imageStr1 = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,imageModel.file];
            NSURL *url1 = [NSURL URLWithString:imageStr1];
            
            [cell.evaProImageView1 sd_setImageWithURL:url1 forState:0 placeholderImage:[UIImage imageNamed:@"account_bitmap"]];
            
            [cell.evaProImageView1 addAction:^(UIButton *btn) {
                [weakself showImages:@[url1]];
            }];
        }else if (evaluateModel.filesImg.count >= 2){
            [cell.evaProImageView1 setHidden:NO];
            [cell.evaProImageView2 setHidden:NO];
            
            ImageModel *imageModel1 = [ImageModel objectWithKeyValues:evaluateModel.filesImg[0]];
            ImageModel *imageModel2 = [ImageModel objectWithKeyValues:evaluateModel.filesImg[1]];
            
            NSString *imageStr1 = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,imageModel1.file];
            NSURL *url1 = [NSURL URLWithString:imageStr1];
            NSString *imageStr2 = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,imageModel2.file];
            NSURL *url2 = [NSURL URLWithString:imageStr2];
            [cell.evaProImageView1 sd_setBackgroundImageWithURL:url1 forState:0 placeholderImage:[UIImage imageNamed:@"account_bitmap"]];
            [cell.evaProImageView2 sd_setBackgroundImageWithURL:url2 forState:0 placeholderImage:[UIImage imageNamed:@"account_bitmap"]];
            [cell.evaProImageView1 addAction:^(UIButton *btn) {
                [weakself showImages:@[url1,url2]];
            }];
            [cell.evaProImageView2 addAction:^(UIButton *btn) {
                [weakself showImages:@[url1,url2]];
            }];
        }
        
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
        
        CompleteResponse *repsonse = self.personMessageArray[0];
        CertificationModel *certificateModel =repsonse.certification;
        
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
        CompleteResponse *response = self.personMessageArray[0];
        CheckEvaluateResponse *checkEvaluateResponse = response.commentdata;
        if (checkEvaluateResponse.Comments1.count > 0) {
            AllCommentsViewController *allCommentsVC = [[AllCommentsViewController alloc] init];
            allCommentsVC.userid = self.userid;
            [self.navigationController pushViewController:allCommentsVC animated:YES];
        }
    }
}

#pragma mark - method
- (void)getMessageOfOrderPeople
{
    NSString *yyyString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kPersonCenterMessageString];
    
    NSDictionary *params = @{@"userid" : self.userid,
                             @"productid" : self.productid,
                             @"token" : [self getValidateToken],
                             @"status" : @"status"
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:yyyString params:params successBlock:^(id responseObject) {
        
        CompleteResponse *response = [CompleteResponse objectWithKeyValues:responseObject];
        
        if ([response.code isEqualToString:@"0000"]) {
            //先是电话与否
            if ([response.canContacts integerValue] == 1) {
                weakself.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:weakself.rightButton];
                [weakself.rightButton setImage:[UIImage imageNamed:@"contacts_phone"] forState:0];
            }
            
            [weakself.personMessageArray addObject:response];
            
            [weakself.checkDetailTableView reloadData];
            
        }else{
            [weakself showHint:response.msg];
        }
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)rightItemAction
{
    //显示电话
    CompleteResponse *response = self.personMessageArray[0];
    NSMutableString *phonne = [NSMutableString stringWithFormat:@"telprompt://%@",response.mobile];
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
