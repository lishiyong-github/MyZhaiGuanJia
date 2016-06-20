//
//  MyClosingViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/4.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MyClosingViewController.h"

#import "CheckDetailPublishViewController.h"  //查看发布方
#import "AdditionalEvaluateViewController.h"  //追加评价
#import "AdditionMessageViewController.h"     //补充信息
#import "PaceViewController.h"   //进度
#import "AllEvaluationViewController.h"
#import "AgreementViewController.h"

#import "MineUserCell.h"
#import "BidMessageCell.h"
#import "BidOneCell.h"
#import "EvaluatePhotoCell.h"

#import "BaseCommitButton.h"

#import "PublishingResponse.h"
#import "PublishingModel.h"

//查看进度
#import "ScheduleResponse.h"
#import "ScheduleModel.h"

//评价
#import "EvaluateResponse.h"
#import "LaunchEvaluateModel.h"

@interface MyClosingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *myClosingTableView;
@property (nonatomic,strong) BaseCommitButton *closingCommitButton;

@property (nonatomic,strong) NSMutableArray *orderCloseArray;

@property (nonatomic,strong) NSMutableArray *scheduleOrderCloArray;

@property (nonatomic,strong) NSMutableArray *evaluateResponseArray;
@property (nonatomic,strong) NSMutableArray *evaluateArray;

@end

@implementation MyClosingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"产品详情";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    if (self.pidString) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"查看发布方" style:UIBarButtonItemStylePlain target:self action:@selector(checkClosingDetail)];
    }
    
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:kBigFont,NSForegroundColorAttributeName:kBlueColor} forState:0];
    
    [self.view addSubview:self.myClosingTableView];
    [self.view addSubview:self.closingCommitButton];
    [self.view setNeedsUpdateConstraints];
    
    [self getDetailMessageOfClosing];
    [self lookUpSchedule];
    [self getOrderEvaluateDetails];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.myClosingTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.myClosingTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kTabBarHeight];
        
        [self.closingCommitButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.closingCommitButton autoSetDimension:ALDimensionHeight toSize:kTabBarHeight];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

#pragma mark - setter and getter
- (UITableView *)myClosingTableView
{
    if (!_myClosingTableView) {
        _myClosingTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _myClosingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        _myClosingTableView.delegate = self;
        _myClosingTableView.dataSource = self;
    }
    return _myClosingTableView;
}

- (BaseCommitButton *)closingCommitButton
{
    if (!_closingCommitButton) {
        _closingCommitButton = [BaseCommitButton newAutoLayoutView];
        [_closingCommitButton setTitle:@"评价" forState:0];
        
        QDFWeakSelf;
        [_closingCommitButton addAction:^(UIButton *btn) {
            AdditionalEvaluateViewController *additionalEvaluateVC = [[AdditionalEvaluateViewController alloc] init];
            [weakself.navigationController pushViewController:additionalEvaluateVC animated:YES];
        }];
    }
    return _closingCommitButton;
}

- (NSMutableArray *)orderCloseArray
{
    if (!_orderCloseArray) {
        _orderCloseArray = [NSMutableArray array];
    }
    return _orderCloseArray;
}

- (NSMutableArray *)scheduleOrderCloArray
{
    if (!_scheduleOrderCloArray) {
        _scheduleOrderCloArray = [NSMutableArray array];
    }
    return _scheduleOrderCloArray;
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
    if (self.orderCloseArray.count > 0) {
        return 5;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.orderCloseArray.count > 0) {
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
    
    PublishingResponse *responde = self.orderCloseArray[0];
    PublishingModel *closeModel = responde.product;
    
    if (indexPath.section == 0) {
        identifier = @"closing0";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = UIColorFromRGB(0x42566d);
        
        NSString *codeStr = [NSString stringWithFormat:@"产品编号：%@",closeModel.codeString];
        [cell.userNameButton setTitle:codeStr forState:0];
        [cell.userNameButton setTitleColor:UIColorFromRGB(0xcfd4e8) forState:0];
        cell.userNameButton.titleLabel.font = kFirstFont;
        
        /*0为待发布（保存未发布的）。 1为发布中（已发布的）。
         2为处理中（有人已接单发布方也已同意）。
         3为终止（只用发布方可以终止）。
         4为结案（双方都可以申请，一方申请一方同意*/
        if ([closeModel.progress_status intValue] == 0) {
            [cell.userActionButton setTitle:@"待发布" forState:0];
        }else if ([closeModel.progress_status intValue] == 1){
            [cell.userActionButton setTitle:@"申请中" forState:0];
        }else if ([closeModel.progress_status intValue] == 2){
            [cell.userActionButton setTitle:@"处理中" forState:0];
        }else if ([closeModel.progress_status intValue] == 3){
            [cell.userActionButton setTitle:@"终止" forState:0];
        }else if ([closeModel.progress_status intValue] == 4){
            [cell.userActionButton setTitle:@"结案" forState:0];
        }
        [cell.userActionButton setTitleColor:kNavColor forState:0];
        cell.userActionButton.titleLabel.font = kBigFont;
        
        return cell;
        
    }else if (indexPath.section == 1){
        if (indexPath.row < 5) {
            identifier = @"closing1";
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
            if ([closeModel.category intValue] == 1) {//融资
                string22 = @"融资";
                if ([closeModel.rate_cat intValue] == 1) {
                    string3 = @"  借款利率(天)";
                }else if ([closeModel.rate_cat intValue] == 2){
                    string3 = @"  借款利率(月)";
                }
                imageString3 = @"conserve_interest_icon";
                string33 = closeModel.rate;
                string4 = @"  返点";
                imageString4 = @"conserve_rebate_icon";
                string44 = closeModel.rebate;
            }else if ([closeModel.category intValue] == 2){//催收
                string22 = @"催收";
                string3 = @"  代理费用(万)";
                imageString3 = @"conserve_fixed_icon";
                string33 = closeModel.agencycommission;
                string4 = @"  债权类型";
                imageString4 = @"conserve_rights_icon";
                if ([closeModel.loan_type intValue] == 1) {
                    string44 = @"房产抵押";
                }else if ([closeModel.loan_type intValue] == 2){
                    string44 = @"应收账款";
                }else if ([closeModel.loan_type intValue] == 3){
                    string44 = @"机动车抵押";
                }else if ([closeModel.loan_type intValue] == 4){
                    string44 = @"无抵押";
                }
            }else if ([closeModel.category intValue] == 3){//诉讼
                string22 = @"诉讼";
                if ([closeModel.agencycommissiontype intValue] == 1) {
                    string3 = @"  固定费用(万)";
                }else if ([closeModel.agencycommissiontype intValue] == 2){
                    string3 = @"  风险费率(%)";
                }
                imageString3 = @"conserve_fixed_icon";
                string33 = closeModel.agencycommission;
                string4 = @"  债权类型";
                imageString4 = @"conserve_rights_icon";
                if ([closeModel.loan_type intValue] == 1) {
                    string44 = @"房产抵押";
                }else if ([closeModel.loan_type intValue] == 2){
                    string44 = @"应收账款";
                }else if ([closeModel.loan_type intValue] == 3){
                    string44 = @"机动车抵押";
                }else if ([closeModel.loan_type intValue] == 4){
                    string44 = @"无抵押";
                }
            }
            
            NSArray *dataArray = @[@"|  基本信息",@"  投资类型",@"  借款本金(万)",string3,string4];
            NSArray *imageArray = @[@"",@"conserve_investment_icon",@"conserve_loan_icon",imageString3,imageString4];
            NSArray *detailArray = @[@"",string22,closeModel.money,string33,string44];
            
            [cell.userNameButton setTitle:dataArray[indexPath.row] forState:0];
            [cell.userNameButton setImage:[UIImage imageNamed:imageArray[indexPath.row]] forState:0];
            [cell.userActionButton setTitle:detailArray[indexPath.row] forState:0];
            
            if (indexPath.row == 0) {
                [cell.userNameButton setTitleColor:kBlueColor forState:0];
            }
            
            return cell;
        }
        
        identifier = @"closing11";
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
        identifier = @"closing2";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.userNameButton setTitle:@"|  服务协议" forState:0];
        [cell.userNameButton setTitleColor:kBlueColor forState:0];
        [cell.userActionButton setTitle:@"点击查看" forState:0];
        [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        cell.userActionButton.userInteractionEnabled = NO;
        
        return cell;

    }else if(indexPath.section == 3){
        //进度
        if (indexPath.row == 0) {
            identifier = @"ending30";
            MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell.userNameButton setTitleColor:kBlueColor forState:0];
            [cell.userNameButton setTitle:@"|  进度详情" forState:0];
            cell.userActionButton.userInteractionEnabled = NO;
            if (self.scheduleOrderCloArray.count > 0) {
                [cell.userActionButton setTitle:@"查看更多" forState:0];
                [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
            }else{
                [cell.userActionButton setTitle:@"无" forState:0];
            }
            
            return cell;
            
        }else if (indexPath.row == 1){
            identifier = @"ending31";
            BidMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[BidMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (self.scheduleOrderCloArray.count > 0) {
                ScheduleModel *scheduleModel = self.scheduleOrderCloArray[0];
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
        }else{
            identifier = @"ending32";
            BidOneCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!cell) {
                cell = [[BidOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell.oneButton setTitle:@"填写进度" forState:0];
            [cell.oneButton setTitleColor:kLightGrayColor forState:0];
            [cell.oneButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
            [cell.oneButton setTitleColor:kLightGrayColor forState:0];
            
            return cell;
        }
    }else{
        if (indexPath.row ==0) {
            identifier = @"closing40";
            MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell .selectionStyle = UITableViewCellSelectionStyleNone;
            
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
            
        }else{
            identifier = @"closing41";
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
    PublishingResponse *resModel = self.orderCloseArray[0];
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
    }else if ((indexPath.section == 3) && (indexPath.row == 0)) {
        if (self.scheduleOrderCloArray.count > 0) {
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
            allEvaluationVC.evaTypeString = @"launchevaluation";
            [self.navigationController pushViewController:allEvaluationVC animated:YES];
        }
    }
}

#pragma mark - method
- (void)checkClosingDetail
{
    CheckDetailPublishViewController *checkDetailPublishVC = [[CheckDetailPublishViewController alloc] init];
    checkDetailPublishVC.idString = self.idString;
    checkDetailPublishVC.categoryString = self.categaryString;
    checkDetailPublishVC.pidString = self.pidString;
    checkDetailPublishVC.typeString = @"发布方";
    checkDetailPublishVC.evaTypeString = @"evaluate";
    [self.navigationController pushViewController:checkDetailPublishVC animated:YES];
}

- (void)getDetailMessageOfClosing
{
    NSString *detailString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyReleaseDetailString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"id" : self.idString,
                             @"category" : self.categaryString
                             };
    [self requestDataPostWithString:detailString params:params successBlock:^(id responseObject){
        PublishingResponse *response = [PublishingResponse objectWithKeyValues:responseObject];
        [self.orderCloseArray addObject:response];
        [self.myClosingTableView reloadData];
        
    } andFailBlock:^(NSError *error){
        
    }];
}

//进度
- (void)lookUpSchedule
{
    NSString *schedule = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kLookUpScheduleString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"id" : self.idString,
                             @"category" : self.categaryString
                             };
    [self requestDataPostWithString:schedule params:params successBlock:^(id responseObject) {
        
        ScheduleResponse *scheduleResponse = [ScheduleResponse objectWithKeyValues:responseObject];
        
        for (ScheduleModel *scheduleModel in scheduleResponse.disposing) {
            [self.scheduleOrderCloArray addObject:scheduleModel];
        }
        [self.myClosingTableView reloadData];
        
    } andFailBlock:^(NSError *error) {
        
    }];
}
    
- (void)getOrderEvaluateDetails
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
        
        [self.myClosingTableView reloadData];
        
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
