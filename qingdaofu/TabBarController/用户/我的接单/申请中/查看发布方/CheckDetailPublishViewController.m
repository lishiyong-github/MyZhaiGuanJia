//
//  CheckDetailPublishViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/4.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "CheckDetailPublishViewController.h"
#import "AllEvaluationViewController.h"  //所有评价
#import "CaseViewController.h"  //经典案例
#import "AgreementViewController.h"  //服务协议

#import "MineUserCell.h"
#import "EvaluatePhotoCell.h"
#import "BaseCommitButton.h"

//详细信息
#import "CompleteResponse.h"
#import "CertificationModel.h"

//收到的评价
#import "EvaluateResponse.h"
#import "EvaluateModel.h"

#import "UIButton+WebCache.h"
#import "UIImage+Color.h"
@interface CheckDetailPublishViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *checkDetailTableView;
@property (nonatomic,strong) BaseCommitButton *appAgreeButton;

@property (nonatomic,strong) UIButton *rightBarBtn;

@property (nonatomic,strong) NSMutableArray *certifiDataArray;
@property (nonatomic,strong) NSMutableArray *allEvaResponse;
@property (nonatomic,strong) NSMutableArray *allEvaDataArray;

@end

@implementation CheckDetailPublishViewController

- (void)viewDidDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:kNavColor1]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:kSeparateColor]];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@信息",self.typeString];
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    if ([self.typeString isEqualToString:@"发布方"]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBarBtn];
    }

    [self.view addSubview:self.checkDetailTableView];
    [self.view addSubview:self.appAgreeButton];
    [self.view setNeedsUpdateConstraints];
    
    [self getMessageOfOrderPeople];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        if ([self.typeString isEqualToString:@"申请人"]) {
            [self.checkDetailTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
            [self.checkDetailTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kTabBarHeight];
            
            [self.appAgreeButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
            [self.appAgreeButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.checkDetailTableView];
        }else{
            if ([self.typeDegreeString isEqualToString:@"处理中"]) {
                
                [self.checkDetailTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
                [self.checkDetailTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kTabBarHeight];
                
                [self.appAgreeButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
                [self.appAgreeButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.checkDetailTableView];
            }else{
                [self.checkDetailTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
            }
        }
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UIButton *)rightBarBtn
{
    if (!_rightBarBtn) {
        _rightBarBtn = [UIButton buttonWithType:0];
        _rightBarBtn.bounds = CGRectMake(0, 0, 24, 24);
        [_rightBarBtn setImage:[UIImage imageNamed:@"information_nav_remind"] forState:0];
        QDFWeakSelf;
        [_rightBarBtn addAction:^(UIButton *btn) {
            [weakself warnning];
        }];
    }
    return _rightBarBtn;
}

- (UITableView *)checkDetailTableView
{
    if (!_checkDetailTableView) {
        _checkDetailTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _checkDetailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
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
        
        QDFWeakSelf;
        if ([self.typeString isEqualToString:@"申请人"]) {
            [_appAgreeButton setTitle:@"同意申请" forState:0];
            [_appAgreeButton addAction:^(UIButton *btn) {
                AgreementViewController *agreementVC = [[AgreementViewController alloc] init];
                agreementVC.flagString = @"1";
                agreementVC.idString = weakself.idString;
                agreementVC.categoryString = weakself.categoryString;
                agreementVC.pidString = weakself.pidString;
                [weakself.navigationController pushViewController:agreementVC animated:YES];
            }];
        }else{
            //1.处理中
            if ([self.typeDegreeString isEqualToString:@"处理中"]) {
                [_appAgreeButton setTitle:@"已同意" forState:0];
                [_appAgreeButton setBackgroundColor:kSelectedColor];
                [_appAgreeButton setTitleColor:kBlackColor forState:0];
                
                //添加电话按钮
                UIButton *phoneButton = [UIButton newAutoLayoutView];
                [phoneButton setImage:[UIImage imageNamed:@"phone"] forState:0];
                phoneButton.backgroundColor = kBlueColor;
                [phoneButton addAction:^(UIButton *btn) {
                    if (weakself.certifiDataArray.count > 0) {
                        CertificationModel *model = weakself.certifiDataArray[0];
                        NSString *phoneStr = [NSString stringWithFormat:@"telprompt://%@",model.mobile];
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr]];
                    }
                }];
                [self.appAgreeButton addSubview:phoneButton];
                
                [phoneButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.appAgreeButton];
                [phoneButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.appAgreeButton];
                [phoneButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.appAgreeButton];
                [phoneButton autoSetDimension:ALDimensionWidth toSize:kTabBarHeight];
            }else{
                [_appAgreeButton setHidden:YES];
            }
        }
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

- (NSMutableArray *)allEvaResponse
{
    if (!_allEvaResponse) {
        _allEvaResponse = [NSMutableArray array];
    }
    return _allEvaResponse;
}

- (NSMutableArray *)allEvaDataArray
{
    if (!_allEvaDataArray) {
        _allEvaDataArray = [NSMutableArray array];
    }
    return _allEvaDataArray;
}

#pragma mark - 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        
        if (self.certifiDataArray.count > 0) {
            CertificationModel *model = self.certifiDataArray[0];
            if ([model.category integerValue] == 1) {//个人
                return 7;
            }else if ([model.category integerValue] == 2){//律所
                return 8;
            }else if ([model.category integerValue] == 3){//公司
                return 10;
            }
        }
    }
    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.section == 1) && (indexPath.row > 0)) {
        
        return 170;
//        if (self.allEvaDataArray.count > 0) {
//            EvaluateModel *model = self.allEvaDataArray[0];
//            if (model.picture == nil || [model.picture isEqualToString:@""]) {
//                return 105;
//            }else{
//                return 170;
//            }
//        }else{
//            return 105;
//        }
    }
    
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    
    if (indexPath.section == 0) {
        identifier = @"publish0";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CertificationModel *cerModel;
        if (self.certifiDataArray.count > 0) {
           cerModel = self.certifiDataArray[0];
        }
        
        if ([cerModel.category integerValue] == 1) {//个人
            NSString *tytyString = [NSString stringWithFormat:@"|  %@信息",self.typeString];
            NSArray *pubArray = @[tytyString,@"姓名",@"身份证号码",@"身份图片",@"联系电话",@"邮箱",@"经典案例"];
            [cell.userNameButton setTitle:pubArray[indexPath.row] forState:0];
            
            if (indexPath.row == 0) {
                [cell.userNameButton setTitleColor:kBlueColor forState:0];
                [cell.userActionButton setImage:[UIImage imageNamed:@"publish_list_authentication"] forState:0];
            }else if (indexPath.row == 1){
                [cell.userActionButton setTitle:cerModel.name forState:0];
            }else if (indexPath.row == 2){
                [cell.userActionButton setTitle:cerModel.cardno forState:0];
            }else if(indexPath.row == 3){
                if ([cerModel.cardimg isEqualToString:@"undefined"]) {
                    [cell.userActionButton setTitle:@"未上传" forState:0];
                }else{
                    [cell.userActionButton setTitle:@"已上传" forState:0];
                }
            }else if (indexPath.row == 4){
                [cell.userActionButton setTitle:[NSString getValidStringFromString:cerModel.mobile] forState:0];
            }else if (indexPath.row == 5){
                [cell.userActionButton setTitle:[NSString getValidStringFromString:cerModel.email] forState:0];
                
            }else if (indexPath.row == 6){
                [cell.userActionButton setTitle:@"查看" forState:0];
                cell.userActionButton.userInteractionEnabled = NO;
                [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
            }
            return cell;
        }else if ([cerModel.category integerValue] == 2){//律所
            
            NSString *tytyString = [NSString stringWithFormat:@"|  %@信息",self.typeString];
            NSArray *pubArray = @[tytyString,@"律所名称",@"执业证号",@"图片",@"联系人",@"联系方式",@"邮箱",@"经典案例"];
            [cell.userNameButton setTitle:pubArray[indexPath.row] forState:0];
            
            if (indexPath.row == 0) {
                [cell.userNameButton setTitleColor:kBlueColor forState:0];
                [cell.userActionButton setImage:[UIImage imageNamed:@"publish_list_authentication"] forState:0];
            }else if (indexPath.row == 1){
                [cell.userActionButton setTitle:cerModel.name forState:0];
            }else if (indexPath.row == 2){
                [cell.userActionButton setTitle:cerModel.cardno forState:0];
            }else if(indexPath.row == 3){
                if ([cerModel.cardimg isEqualToString:@"undefined"]) {
                    [cell.userActionButton setTitle:@"未上传" forState:0];
                }else{
                    [cell.userActionButton setTitle:@"已上传" forState:0];
                }
            }else if (indexPath.row == 4){
                [cell.userActionButton setTitle:[NSString getValidStringFromString:cerModel.contact] forState:0];
            }else if (indexPath.row == 5){
                [cell.userActionButton setTitle:[NSString getValidStringFromString:cerModel.mobile] forState:0];
                
            }else if (indexPath.row == 6){
                [cell.userActionButton setTitle:[NSString getValidStringFromString:cerModel.email] forState:0];
            }else if (indexPath.row == 7){
                [cell.userActionButton setTitle:@"查看" forState:0];
                cell.userActionButton.userInteractionEnabled = NO;
                [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
            }
            return cell;
        }else if ([cerModel.category integerValue] == 3){//公司
            
            NSString *tytyString = [NSString stringWithFormat:@"|  %@信息",self.typeString];
            NSArray *pubArray = @[tytyString,@"公司名称",@"营业执照号",@"图片",@"联系人",@"联系方式",@"企业邮箱",@"公司经营地址",@"公司网站",@"经典案例"];
            [cell.userNameButton setTitle:pubArray[indexPath.row] forState:0];
            
            if (indexPath.row == 0) {
                [cell.userNameButton setTitleColor:kBlueColor forState:0];
                [cell.userActionButton setImage:[UIImage imageNamed:@"publish_list_authentication"] forState:0];
            }else if (indexPath.row == 1){
                [cell.userActionButton setTitle:cerModel.name forState:0];
            }else if (indexPath.row == 2){
                [cell.userActionButton setTitle:cerModel.cardno forState:0];
            }else if(indexPath.row == 3){
                if ([cerModel.cardimg isEqualToString:@"undefined"]) {
                    [cell.userActionButton setTitle:@"未上传" forState:0];
                }else{
                    [cell.userActionButton setTitle:@"已上传" forState:0];
                }
            }else if (indexPath.row == 4){
                [cell.userActionButton setTitle:[NSString getValidStringFromString:cerModel.contact] forState:0];
            }else if (indexPath.row == 5){
                [cell.userActionButton setTitle:[NSString getValidStringFromString:cerModel.mobile] forState:0];
                
            }else if (indexPath.row == 6){
                [cell.userActionButton setTitle:[NSString getValidStringFromString:cerModel.email] forState:0];
            }else if (indexPath.row == 7){
                [cell.userActionButton setTitle:[NSString getValidStringFromString:cerModel.address] forState:0];
            }else if (indexPath.row == 8){
                [cell.userActionButton setTitle:[NSString getValidStringFromString:cerModel.enterprisewebsite] forState:0];
            }else if (indexPath.row == 9){
                [cell.userActionButton setTitle:@"查看" forState:0];
                cell.userActionButton.userInteractionEnabled = NO;
                [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
            }
            return cell;
        }
    }
    
    //评价
    if (indexPath.row == 0) {
        identifier = @"publish10";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.userNameButton setTitleColor:kBlueColor forState:0];
        cell.userActionButton.userInteractionEnabled = NO;
        if (self.allEvaDataArray.count > 0) {
            EvaluateResponse *response = self.allEvaResponse[0];
            float creditor = [response.creditor floatValue];
            NSString *creditorStr = [NSString stringWithFormat:@"|  收到的评价(%.1f分)",creditor];
            [cell.userNameButton setTitle:creditorStr forState:0];
            
            [cell.userActionButton setTitle:@"查看更多" forState:0];
            [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        }else{
            [cell.userNameButton setTitle:@"|  收到的评价" forState:0];
            [cell.userActionButton setTitle:@"暂无" forState:0];
        }
        return cell;
    }
    
    identifier = @"publish11";
    EvaluatePhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[EvaluatePhotoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    EvaluateModel *evaModel;
    if (self.allEvaDataArray.count > 0 ) {
        [cell.remindImageButton setHidden:YES];
        [cell.evaProductButton setHidden:YES];
        [cell.evaNameLabel setHidden:NO];
        [cell.evaTimeLabel setHidden:NO];
        [cell.evaTextLabel setHidden:NO];
        [cell.evaStarImage setHidden:NO];
        [cell.evaProImageView1 setHidden:NO];
        [cell.evaProImageView2 setHidden:NO];
        
        evaModel = self.allEvaDataArray[indexPath.row-1];
        
        NSString *isHideStr = evaModel.isHide?@"匿名":evaModel.mobile;
        cell.evaNameLabel.text = isHideStr;
        cell.evaTimeLabel.text = [NSDate getYMDFormatterTime:evaModel.create_time];
        cell.evaStarImage.currentIndex = [evaModel.creditor integerValue];
        cell.evaProImageView1.backgroundColor = kLightGrayColor;
        cell.evaProImageView2.backgroundColor = kLightGrayColor;
        cell.evaTextLabel.text = [NSString getValidStringFromString:evaModel.content toString:@"未填写评价内容"];
        
       // 图片
        if (evaModel.pictures.count == 1) {
            if ([evaModel.pictures[0] isEqualToString:@""]) {//没有图片
                [cell.evaProImageView1 setImage:[UIImage imageNamed:@"account_bitmap"] forState:0];
                [cell.evaProImageView2 setImage:[UIImage imageNamed:@"account_bitmap"] forState:0];

            }else{//有图片
                NSString *str1 = [evaModel.pictures[0] substringWithRange:NSMakeRange(1, [evaModel.pictures[0] length]-2)];
                NSString *imageStr1 = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,str1];
                NSURL *url1 = [NSURL URLWithString:imageStr1];

                [cell.evaProImageView1 sd_setBackgroundImageWithURL:url1 forState:0 placeholderImage:[UIImage imageNamed:@"account_bitmap"]];
                [cell.evaProImageView2 setImage:[UIImage imageNamed:@"account_bitmap"] forState:0];
            }
        }else if (evaModel.pictures.count >= 2){
            NSString *str1 = [evaModel.pictures[0] substringWithRange:NSMakeRange(1, [evaModel.pictures[0] length]-2)];
            NSString *imageStr1 = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,str1];
            NSURL *url1 = [NSURL URLWithString:imageStr1];
            NSString *str2 = [evaModel.pictures[1] substringWithRange:NSMakeRange(1, [evaModel.pictures[1] length]-2)];
            NSString *imageStr2 = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,str2];
            NSURL *url2 = [NSURL URLWithString:imageStr2];

            [cell.evaProImageView1 sd_setBackgroundImageWithURL:url1 forState:0 placeholderImage:[UIImage imageNamed:@"account_bitmap"]];
            [cell.evaProImageView2 sd_setBackgroundImageWithURL:url2 forState:0 placeholderImage:[UIImage imageNamed:@"account_bitmap"]];
        }
    }else{
        [cell.remindImageButton setHidden:NO];
        [cell.evaProductButton setHidden:YES];
        [cell.evaNameLabel setHidden:YES];
        [cell.evaTimeLabel setHidden:YES];
        [cell.evaTextLabel setHidden:YES];
        [cell.evaStarImage setHidden:YES];
        [cell.evaProImageView1 setHidden:YES];
        [cell.evaProImageView2 setHidden:YES];
        [cell.evaProductButton setHidden:YES];
    }
    
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
    if (indexPath.section == 0) {
        
        CertificationModel *cerModel;
        if (self.certifiDataArray.count > 0) {
            cerModel = self.certifiDataArray[0];
        }
        
        if ([cerModel.category integerValue] == 1) {
            if (indexPath.row == 6) {
                CaseViewController *caseVC = [[CaseViewController alloc] init];
                caseVC.caseString = cerModel.casedesc;
                [self.navigationController pushViewController:caseVC animated:YES];
            }
        }else if ([cerModel.category integerValue] == 2){
            if (indexPath.row == 7) {
                CaseViewController *caseVC = [[CaseViewController alloc] init];
                caseVC.caseString = cerModel.casedesc;
                [self.navigationController pushViewController:caseVC animated:YES];
            }
        }else if ([cerModel.category integerValue] == 3){
            if (indexPath.row == 9) {
                CaseViewController *caseVC = [[CaseViewController alloc] init];
                caseVC.caseString = cerModel.casedesc;
                [self.navigationController pushViewController:caseVC animated:YES];
            }
        }

    }else if ((indexPath.section == 1) && (indexPath.row == 0)) {//全部评价
        
        if (self.allEvaDataArray.count > 0) {
            AllEvaluationViewController *allEvaluationVC = [[AllEvaluationViewController alloc] init];
            allEvaluationVC.idString = self.idString;
            allEvaluationVC.categoryString = self.categoryString;
            allEvaluationVC.pidString = self.pidString;
            allEvaluationVC.evaTypeString = @"evaluate";
            [self.navigationController pushViewController:allEvaluationVC animated:YES];
        }
    }
}

#pragma mark - method
- (void)warnning
{
    NSString *ssss = [NSString stringWithFormat:@"是否提醒%@完善信息",self.typeString];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:ssss preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"确认发布方信息");
        [self warnningMethod];
    }];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:actionOK];
    [alertController addAction:actionCancel];
    
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
}

- (void)warnningMethod
{
    NSString *warnString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kCheckOrderToWarnning];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"id" : self.idString,
                             @"category" : self.categoryString,
                             @"pid" : self.pidString
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:warnString params:params successBlock:^(id responseObject) {
        BaseModel *warnModel = [BaseModel objectWithKeyValues:responseObject];
        [weakself showHint:warnModel.msg];
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)getMessageOfOrderPeople
{
    NSString *yyyString;
    if ([self.typeString isEqualToString:@"发布方"]) {
        yyyString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kCheckReleasePeople];
    }else{
        yyyString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kCheckOrderPeople];
    }
    
    NSDictionary *params = @{@"category" : self.categoryString,
                             @"id" : self.idString,
                             @"pid" : self.pidString,
                             @"token" : [self getValidateToken]
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:yyyString params:params successBlock:^(id responseObject) {
        
        CompleteResponse *response = [CompleteResponse objectWithKeyValues:responseObject];
        
        if (response.certification) {
            [weakself.certifiDataArray addObject:response.certification];
        }
        
        [weakself.checkDetailTableView reloadData];
        [weakself getAllEvaluationListWithPage:@"1"];
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)getAllEvaluationListWithPage:(NSString *)page
{
    NSString *evaluateString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kCheckOrderToEvaluationString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"page" : page,
                             @"pid" : self.pidString
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:evaluateString params:params successBlock:^(id responseObject) {
        EvaluateResponse *response = [EvaluateResponse objectWithKeyValues:responseObject];
        [weakself.allEvaResponse addObject:response];
        
        for (EvaluateModel *model in response.evaluate) {
            [weakself.allEvaDataArray addObject:model];
        }
        [weakself.checkDetailTableView reloadData];
        
    } andFailBlock:^(NSError *error) {
        
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
