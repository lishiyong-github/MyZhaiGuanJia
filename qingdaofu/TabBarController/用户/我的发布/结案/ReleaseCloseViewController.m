//
//  ReleaseCloseViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/31.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ReleaseCloseViewController.h"

#import "CheckDetailPublishViewController.h"  //查看发布方
#import "AdditionalEvaluateViewController.h"  //追加评价
#import "AdditionMessageViewController.h"     //补充信息
#import "AgreementViewController.h"            //服务协议
#import "PaceViewController.h"
#import "AllEvaluationViewController.h"

#import "MineUserCell.h"
#import "BidMessageCell.h"
#import "BidOneCell.h"
#import "EvaluatePhotoCell.h"

#import "BaseCommitButton.h"

//详细信息
#import "PublishingResponse.h"
#import "PublishingModel.h"

//查看进度
#import "ScheduleResponse.h"
#import "ScheduleModel.h"

//评价
#import "EvaluateResponse.h"
#import "LaunchEvaluateModel.h"

@interface ReleaseCloseViewController ()

<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *ReleaseCloseTableView;
@property (nonatomic,strong) BaseCommitButton *ReleaseCloseCommitButton;

@property (nonatomic,strong) NSMutableArray *releaseArray;
@property (nonatomic,strong) NSMutableArray *scheduleReleaseCloArray;
@property (nonatomic,strong) NSMutableArray *evaluateResponseArray;
@property (nonatomic,strong) NSMutableArray *evaluateArray;

@end

@implementation ReleaseCloseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"产品详情";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    if (self.pidString) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"查看接单方" style:UIBarButtonItemStylePlain target:self action:@selector(checkReleaseCloseDetail)];
    }
    
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:kBigFont,NSForegroundColorAttributeName:kBlueColor} forState:0];
    
    [self.view addSubview:self.ReleaseCloseTableView];
    [self.view addSubview:self.ReleaseCloseCommitButton];
    [self.view setNeedsUpdateConstraints];
    
    [self getCloseMessages];
    [self getPacesDetails];
    [self getEvaluateDetails];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.ReleaseCloseTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.ReleaseCloseTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kTabBarHeight];
        
        [self.ReleaseCloseCommitButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.ReleaseCloseCommitButton autoSetDimension:ALDimensionHeight toSize:kTabBarHeight];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

#pragma mark - setter and getter
- (UITableView *)ReleaseCloseTableView
{
    if (!_ReleaseCloseTableView) {
        _ReleaseCloseTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _ReleaseCloseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        _ReleaseCloseTableView.delegate = self;
        _ReleaseCloseTableView.dataSource = self;
    }
    return _ReleaseCloseTableView;
}

- (BaseCommitButton *)ReleaseCloseCommitButton
{
    if (!_ReleaseCloseCommitButton) {
        _ReleaseCloseCommitButton = [BaseCommitButton newAutoLayoutView];
        [_ReleaseCloseCommitButton setTitle:@"追加评价" forState:0];
        [_ReleaseCloseCommitButton setTitle:@"评价" forState:0];

        QDFWeakSelf;
        [_ReleaseCloseCommitButton addAction:^(UIButton *btn) {
            AdditionalEvaluateViewController *additionalEvaluateVC = [[AdditionalEvaluateViewController alloc] init];
            [weakself.navigationController pushViewController:additionalEvaluateVC animated:YES];
        }];
    }
    return _ReleaseCloseCommitButton;
}

- (NSMutableArray *)releaseArray
{
    if (!_releaseArray) {
        _releaseArray = [NSMutableArray array];
    }
    return _releaseArray;
}
- (NSMutableArray *)scheduleReleaseCloArray
{
    if (!_scheduleReleaseCloArray) {
        _scheduleReleaseCloArray = [NSMutableArray array];
    }
    return _scheduleReleaseCloArray;
}
- (NSMutableArray *)evaluateArray
{
    if (!_evaluateArray) {
        _evaluateArray = [NSMutableArray array];
    }
    return _evaluateArray;
}

- (NSMutableArray *)evaluateResponseArray
{
    if (!_evaluateResponseArray) {
        _evaluateResponseArray = [NSMutableArray array];
    }
    return _evaluateResponseArray;
}

#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.releaseArray.count > 0) {
        return 5;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.releaseArray.count > 0) {
        if (section == 1) {
            return 6;
        }else if (section > 2){
            return 2;
        }
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.section == 3) && (indexPath.row == 1)){
        return 145;
    }else if ((indexPath.section == 4) && (indexPath.row == 1)){
        return 170;
    }
    
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    
    PublishingResponse *responseModel;
    PublishingModel *releaseModel;
    
    if (self.releaseArray.count > 0) {
      responseModel = self.releaseArray[0];
      releaseModel = responseModel.product;
    }    
    
    if (indexPath.section == 0) {
        identifier = @"releaseClose0";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = UIColorFromRGB(0x42566d);
        
        NSString *code = [NSString stringWithFormat:@"产品编号:%@",releaseModel.codeString];
        [cell.userNameButton setTitle:code forState:0];
        [cell.userNameButton setTitleColor:UIColorFromRGB(0xcfd4e8) forState:0];
        
        /*0为待发布（保存未发布的）。 1为发布中（已发布的）。
         2为处理中（有人已接单发布方也已同意）。
         3为终止（只用发布方可以终止）。
         4为结案（双方都可以申请，一方申请一方同意*/
        if ([releaseModel.progress_status intValue] == 0) {
            [cell.userActionButton setTitle:@"待发布" forState:0];
        }else if ([releaseModel.progress_status intValue] == 1){
            [cell.userActionButton setTitle:@"发布中" forState:0];
        }else if ([releaseModel.progress_status intValue] == 2){
            [cell.userActionButton setTitle:@"处理中" forState:0];
        }else if ([releaseModel.progress_status intValue] == 3){
            [cell.userActionButton setTitle:@"终止" forState:0];
        }else if ([releaseModel.progress_status intValue] == 4){
            [cell.userActionButton setTitle:@"结案" forState:0];
        }
        [cell.userActionButton setTitleColor:kNavColor forState:0];
        cell.userActionButton.titleLabel.font = kBigFont;
        
        return cell;
        
    }else if (indexPath.section == 1){
        if (indexPath.row < 5) {
            identifier = @"releaseClose11";
            MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!cell) {
                cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NSString *string22;
            NSString *string3;
            NSString *imageString3;
            NSString *string33;
            NSString *string4;
            NSString *imageString4;
            NSString *string44;
            if ([releaseModel.category intValue] == 1) {//融资
                string22 = @"融资";
                if ([releaseModel.rate_cat intValue] == 1) {
                    string3 = @"  借款利率(天)";
                }else if ([releaseModel.rate_cat intValue] == 2){
                    string3 = @"  借款利率(月)";
                }
                imageString3 = @"conserve_interest_icon";
                string33 = releaseModel.rate;
                string4 = @"  返点";
                imageString4 = @"conserve_rebate_icon";
                string44 = releaseModel.rebate;
            }else if ([releaseModel.category intValue] == 2){//催收
                string22 = @"催收";
                string3 = @"  代理费用(万)";
                imageString3 = @"conserve_fixed_icon";
                string33 = releaseModel.agencycommission;
                string4 = @"  债权类型";
                imageString4 = @"conserve_rights_icon";
                if ([releaseModel.loan_type intValue] == 1) {
                    string44 = @"房产抵押";
                }else if ([releaseModel.loan_type intValue] == 2){
                    string44 = @"应收账款";
                }else if ([releaseModel.loan_type intValue] == 3){
                    string44 = @"机动车抵押";
                }else if ([releaseModel.loan_type intValue] == 4){
                    string44 = @"无抵押";
                }
            }else if ([releaseModel.category intValue] == 3){//诉讼
                string22 = @"诉讼";
                if ([releaseModel.agencycommissiontype intValue] == 1) {
                    string3 = @"  固定费用(万)";
                }else if ([releaseModel.agencycommissiontype intValue] == 2){
                    string3 = @"  风险费率(%)";
                }
                imageString3 = @"conserve_fixed_icon";
                string33 = releaseModel.agencycommission;
                string4 = @"  债权类型";
                imageString4 = @"conserve_rights_icon";
                if ([releaseModel.loan_type intValue] == 1) {
                    string44 = @"房产抵押";
                }else if ([releaseModel.loan_type intValue] == 2){
                    string44 = @"应收账款";
                }else if ([releaseModel.loan_type intValue] == 3){
                    string44 = @"机动车抵押";
                }else if ([releaseModel.loan_type intValue] == 4){
                    string44 = @"无抵押";
                }
            }
            
            NSArray *dataArray = @[@"|  基本信息",@"  投资类型",@"  借款本金(万)",string3,string4];
            NSArray *imageArray = @[@"",@"conserve_investment_icon",@"conserve_loan_icon",imageString3,imageString4];
            NSArray *detailArray = @[@"",string22,releaseModel.money,string33,string44];
            
            [cell.userNameButton setTitle:dataArray[indexPath.row] forState:0];
            [cell.userNameButton setImage:[UIImage imageNamed:imageArray[indexPath.row]] forState:0];
            [cell.userActionButton setTitle:detailArray[indexPath.row] forState:0];
            
            if (indexPath.row == 0) {
                [cell.userNameButton setTitleColor:kBlueColor forState:0];
                
                if ([releaseModel.progress_status intValue] < 2) {
                    [cell.userActionButton setTitle:@"编辑" forState:0];
                    [cell.userActionButton setTitleColor:kBlueColor forState:0];
                }
            }
            return cell;
        }
        identifier = @"releaseClose12";
        BidOneCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[BidOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.oneButton setTitle:@"查看补充信息" forState:0];
        [cell.oneButton setImage:[UIImage imageNamed:@"more"] forState:0];
        cell.oneButton.userInteractionEnabled = NO;
        
        return cell;
        
    }else if (indexPath.section == 2){
        identifier = @"releaseClose3";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.userNameButton setTitleColor:kBlueColor forState:0];
        [cell.userNameButton setTitle:@"|  服务协议" forState:0];
        [cell.userActionButton setTitle:@"点击查看" forState:0];
        [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        cell.userActionButton.userInteractionEnabled = NO;
        
        return cell;
        
    }else if(indexPath.section == 3){
        if (indexPath.row == 0) {//进度详情
            identifier = @"releaseClose40";
            MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell.userNameButton setTitleColor:kBlueColor forState:0];
            [cell.userNameButton setTitle:@"|  进度详情" forState:0];
            cell.userActionButton.userInteractionEnabled = NO;
            
            if (self.scheduleReleaseCloArray.count > 0) {
                [cell.userActionButton setTitle:@"查看更多" forState:0];
                [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
            }else{
                [cell.userActionButton setTitle:@"无" forState:0];
            }
            
            return cell;
            
        }else if (indexPath.row == 1){
            identifier = @"releaseClose41";
            BidMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[BidMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (self.scheduleReleaseCloArray.count > 0) {
                ScheduleModel *scheduleModel = self.scheduleReleaseCloArray[0];
                [cell.remindImageButton setHidden:YES];
                [cell.deadlineLabel setHidden:NO];
                [cell.timeLabel setHidden:NO];
                [cell.dateLabel setHidden:NO];
                [cell.areaLabel setHidden:NO];
                [cell.addressLabel setHidden:NO];
                
                //案号类型
                NSArray *auditArray = @[@"一审",@"二审",@"再审",@"执行"];
                NSInteger auditInt = [scheduleModel.audit intValue];
                NSString *auditStr = auditArray[auditInt];
                
                NSMutableAttributedString *caseTypestring = [cell.deadlineLabel setAttributeString:@"案号类型：" withColor:kBlackColor andSecond:auditStr?auditStr:@"无" withColor:kLightGrayColor withFont:12];
                [cell.deadlineLabel setAttributedText:caseTypestring];
                
                cell.timeLabel.text = @"2016-05-30";
                
                NSMutableAttributedString *caseNoString = [cell.dateLabel setAttributeString:@"案        号：" withColor:kBlackColor andSecond:scheduleModel.caseString?scheduleModel.caseString:@"无" withColor:kLightGrayColor withFont:12];
                [cell.dateLabel setAttributedText:caseNoString];
                
                NSArray *suitArr3 = @[@"债权人上传处置资产",@"律师接单",@"双方洽谈",@"向法院起诉(财产保全)",@"整理诉讼材料",@"法院立案",@"向当事人发出开庭传票",@"开庭前调解",@"开庭",@"判决",@"二次开庭",@"二次判决",@"移交执行局申请执行",@"执行中提供借款人的财产线索",@"调查(公告)",@"拍卖",@"流拍",@"拍卖成功",@"付费"];
                NSArray *suitArray1 = @[@"尽职调查",@"公证",@"抵押",@"放款",@"返点",@"其他"];
                NSArray *suitArray2 = @[@"电话",@"上门",@"面谈"];
                
                NSInteger number = [scheduleModel.status intValue];
                NSString *dealTypeStr;
                
                if ([self.categaryString intValue] == 1) {
                    dealTypeStr = suitArray1[number-1];
                }else if ([self.categaryString intValue] == 2){
                    dealTypeStr = suitArray2[number-1];
                }else{
                    dealTypeStr = suitArr3[number-1];
                }
                
                NSMutableAttributedString *dealTypeString = [cell.areaLabel setAttributeString:@"处置类型：" withColor: kBlackColor andSecond:dealTypeStr withColor:kLightGrayColor withFont:12];
                [cell.areaLabel setAttributedText:dealTypeString];
                
                NSMutableAttributedString *dealDeailString = [cell.addressLabel setAttributeString:@"详        情：" withColor:kBlackColor andSecond:scheduleModel.content?scheduleModel.content:@"无" withColor:kLightGrayColor withFont:12];
                [cell.addressLabel setAttributedText:dealDeailString];
            }else{
                [cell.remindImageButton setHidden:NO];
                [cell.deadlineLabel setHidden:YES];
                [cell.timeLabel setHidden:YES];
                [cell.dateLabel setHidden:YES];
                [cell.areaLabel setHidden:YES];
                [cell.addressLabel setHidden:YES];
            }
            return cell;
        }
    }else{
        if (indexPath.row == 0) {
            identifier = @"releaseClose50";
            MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell .selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell.userNameButton setTitleColor:kBlueColor forState:0];
            cell.userActionButton.userInteractionEnabled = NO;
            
            [cell.userNameButton setTitleColor:kBlueColor forState:0];
            cell.userActionButton.userInteractionEnabled = NO;
            if (self.evaluateResponseArray.count > 0) {
                EvaluateResponse *response = self.evaluateResponseArray[0];
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
        //具体评级
            identifier = @"releaseClose51";
            EvaluatePhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[EvaluatePhotoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (self.evaluateArray.count > 0) {
            EvaluateResponse *response = self.evaluateArray[0];
            LaunchEvaluateModel *launchModel;
            if (self.evaluateResponseArray.count > 0) {
                [cell.remindImageButton setHidden:YES];
                [cell.evaProductButton setHidden:YES];
                [cell.evaNameLabel setHidden: NO];
                [cell.evaStarImage setHidden:NO];
                [cell.evaTimeLabel setHidden:NO];
                [cell.evaTextLabel setHidden:NO];
                [cell.evaProImageView1 setHidden:NO];
                [cell.evaProImageView2 setHidden:NO];
                
                launchModel = response.launchevaluation[0];
                cell.evaNameLabel.text = launchModel.mobile;
                cell.evaStarImage.currentIndex = [response.creditor intValue];
                cell.evaProImageView1.backgroundColor = kLightGrayColor;
                cell.evaProImageView2.backgroundColor = kLightGrayColor;
                
                if (launchModel.content == nil || [launchModel.content isEqualToString:@""]) {
                    cell.evaTextLabel.text = @"未填写评价内容";
                }else{
                    cell.evaTextLabel.text = launchModel.content;
                }
            }else{
                [cell.remindImageButton setHidden:NO];
                [cell.evaProductButton setHidden:YES];
                [cell.evaNameLabel setHidden: YES];
                [cell.evaStarImage setHidden:YES];
                [cell.evaTimeLabel setHidden:YES];
                [cell.evaTextLabel setHidden:YES];
                [cell.evaProImageView1 setHidden:YES];
                [cell.evaProImageView2 setHidden:YES];
           }
        }
        
            return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return kBigPadding;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PublishingResponse *resModel = self.releaseArray[0];
    PublishingModel *dealModel = resModel.product;
    
    if ((indexPath.section == 1) && (indexPath.row == 5)) {
        AdditionMessageViewController *additionMessageVC = [[AdditionMessageViewController alloc] init];
        additionMessageVC.idString = dealModel.idString;
        additionMessageVC.categoryString = dealModel.category;
        [self.navigationController pushViewController:additionMessageVC animated:YES];
    }else if (indexPath.section == 2) {
        AgreementViewController *agreementVC = [[AgreementViewController alloc] init];
        agreementVC.idString = dealModel.idString;
        agreementVC.categoryString = dealModel.category;
        [self.navigationController pushViewController:agreementVC animated:YES];
    }else if ((indexPath.section == 3) && (indexPath.row == 0)){
        if (self.scheduleReleaseCloArray.count > 0) {
        PaceViewController *paceVC = [[PaceViewController alloc] init];
        paceVC.idString = dealModel.idString;
        paceVC.categoryString = dealModel.category;
        [self.navigationController pushViewController:paceVC animated:YES];
        }
    }else if ((indexPath.section == 4) && (indexPath.row == 0)){
        if (self.evaluateResponseArray.count > 0) {
            AllEvaluationViewController *allEvaluationVC = [[AllEvaluationViewController alloc] init];
            allEvaluationVC.idString = dealModel.idString;
            allEvaluationVC.categoryString = dealModel.category;
//            allEvaluationVC.pidString = self.pidString;
            allEvaluationVC.evaTypeString = @"evaluate";
            [self.navigationController pushViewController:allEvaluationVC animated:YES];
        }
    }
}

#pragma mark - method
- (void)checkReleaseCloseDetail
{
    CheckDetailPublishViewController *checkDetailPublishVC = [[CheckDetailPublishViewController alloc] init];
    checkDetailPublishVC.idString = self.idString;
    checkDetailPublishVC.categoryString = self.categaryString;
    checkDetailPublishVC.pidString = self.pidString;
    checkDetailPublishVC.typeString = @"接单方";
    checkDetailPublishVC.evaTypeString = @"launchevaluation";
    [self.navigationController pushViewController:checkDetailPublishVC animated:YES];
}

- (void)getCloseMessages
{
    NSString *releaseString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyReleaseDetailString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"id" : self.idString,
                             @"category" : self.categaryString
                             };
    [self requestDataPostWithString:releaseString params:params successBlock:^(id responseObject){
        PublishingResponse *response = [PublishingResponse objectWithKeyValues:responseObject];
        [self.releaseArray addObject:response];
        [self.ReleaseCloseTableView reloadData];
        
    } andFailBlock:^(NSError *error){
        
    }];
}

- (void)getPacesDetails
{
    NSString *scheduleString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kLookUpScheduleString];
    NSDictionary *params = @{@"id" : self.idString,
                             @"category" : self.categaryString,
                             @"token" : [self getValidateToken]
                             };
    [self requestDataPostWithString:scheduleString params:params successBlock:^(id responseObject) {
        
        ScheduleResponse *response = [ScheduleResponse objectWithKeyValues:responseObject];
        for (ScheduleModel *model in response.disposing) {
            [self.scheduleReleaseCloArray addObject:model];
        }
        [self.ReleaseCloseTableView reloadData];
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)getEvaluateDetails
{
    NSString *evaluateString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyEvaluateString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"id" : self.idString,
                             @"category" : self.categaryString
                             };
    [self requestDataPostWithString:evaluateString params:params successBlock:^(id responseObject) {
        
        EvaluateResponse *response = [EvaluateResponse objectWithKeyValues:responseObject];
        
        [self.evaluateArray addObject:response];
        
        for (LaunchEvaluateModel *launchModel in response.launchevaluation) {
            [self.evaluateArray addObject:launchModel];
        }
        
        [self.ReleaseCloseTableView reloadData];
        
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
