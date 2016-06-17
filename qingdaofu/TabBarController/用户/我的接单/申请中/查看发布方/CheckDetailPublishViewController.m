//
//  CheckDetailPublishViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/4.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "CheckDetailPublishViewController.h"
#import "AllEvaluationViewController.h"
#import "CaseViewController.h"  //经典案例

#import "MineUserCell.h"
#import "EvaluatePhotoCell.h"
#import "BaseCommitButton.h"

//详细信息
#import "CompleteResponse.h"
#import "CertificationModel.h"

//评价
#import "EvaluateResponse.h"
#import "EvaluateModel.h"

@interface CheckDetailPublishViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *checkDetailTableView;

@property (nonatomic,strong) UIButton *rightBarBtn;

@property (nonatomic,strong) NSMutableArray *certifiDataArray;
@property (nonatomic,strong) NSMutableArray *allEvaResponse;
@property (nonatomic,strong) NSMutableArray *allEvaDataArray;

@end

@implementation CheckDetailPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [NSString stringWithFormat:@"%@信息",self.typeString];
    self.navigationItem.leftBarButtonItem = self.leftItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBarBtn];

    [self.view addSubview:self.checkDetailTableView];
    [self.view setNeedsUpdateConstraints];
    
    [self getMessageOfOrderPeople];
    [self getAllEvaluationListWithPage:@"0"];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.checkDetailTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
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
        return 6;
    }
    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.section == 1) && (indexPath.row >0)) {
        return 170;
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
        
        NSArray *pubArray = @[@"|  申请人信息",@"姓名",@"身份证号码",@"身份图片",@"邮箱",@"经典案例"];
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
            if ([cerModel.email isEqualToString:@""]) {
                [cell.userActionButton setTitle:@"未填写" forState:0];
            }else{
                [cell.userActionButton setTitle:cerModel.email forState:0];
            }
        }else if (indexPath.row == 5){
            [cell.userActionButton setTitle:@"查看" forState:0];
            [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        }
        return cell;
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
        if (self.allEvaResponse.count > 0) {
            EvaluateResponse *response = self.allEvaResponse[0];
            float creditor = [response.creditor floatValue];
            NSString *creditorStr = [NSString stringWithFormat:@"|  收到的评价(%.1f分)",creditor];
            [cell.userNameButton setTitle:creditorStr forState:0];
            
            [cell.userActionButton setTitle:@"查看更多" forState:0];
            [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        }else{
            [cell.userNameButton setTitle:@"|  收到的评价" forState:0];
            [cell.userActionButton setTitle:@"无" forState:0];
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
        
        EvaluateResponse *evaResponse = self.allEvaResponse[0];
        evaModel = self.allEvaDataArray[indexPath.row-1];
        
        NSString *isHideStr = evaModel.isHide?@"匿名":evaModel.mobile;
        cell.evaNameLabel.text = isHideStr;
        cell.evaTimeLabel.text = [NSDate getYMDFormatterTime:evaModel.create_time];
        cell.evaStarImage.currentIndex = [evaResponse.creditor intValue];
        cell.evaProImageView1.backgroundColor = kLightGrayColor;
        cell.evaProImageView2.backgroundColor = kLightGrayColor;
        if (evaModel.content == nil || [evaModel.content isEqualToString:@""]) {
            cell.evaTextLabel.text = @"未填写评价内容";
        }else{
            cell.evaTextLabel.text = evaModel.content;
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
    if ((indexPath.section == 0) && (indexPath.row == 5)) {
        
        CertificationModel *cerModel;
        if (self.certifiDataArray.count > 0) {
            cerModel = self.certifiDataArray[0];
        }

        CaseViewController *caseVC = [[CaseViewController alloc] init];
        caseVC.caseString = cerModel.casedesc;
        [self.navigationController pushViewController:caseVC animated:YES];
    }else if ((indexPath.section == 1) && (indexPath.row == 0)) {//全部评价
        AllEvaluationViewController *allEvaluationVC = [[AllEvaluationViewController alloc] init];
        allEvaluationVC.idString = self.idString;
        allEvaluationVC.categoryString = self.categoryString;
        allEvaluationVC.pidString = self.pidString;
        allEvaluationVC.evaTypeString = self.evaTypeString;
        [self.navigationController pushViewController:allEvaluationVC animated:YES];
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
    [self requestDataPostWithString:warnString params:params successBlock:^(id responseObject) {
        BaseModel *warnModel = [BaseModel objectWithKeyValues:responseObject];
        
        [self showHint:warnModel.msg];
        
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
    [self requestDataPostWithString:yyyString params:params successBlock:^(id responseObject) {
        CompleteResponse *response = [CompleteResponse objectWithKeyValues:responseObject];
        [self.certifiDataArray addObject:response.certification];
        
        [self.checkDetailTableView reloadData];
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
    [self requestDataPostWithString:evaluateString params:params successBlock:^(id responseObject) {
        
        EvaluateResponse *response = [EvaluateResponse objectWithKeyValues:responseObject];
        [self.allEvaResponse addObject:response];
        
        for (EvaluateModel *model in response.evaluate) {
            [self.allEvaDataArray addObject:model];
        }
        [self.checkDetailTableView reloadData];
        
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
