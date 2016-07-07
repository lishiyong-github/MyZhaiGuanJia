//
//  MyProcessingViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/4.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MyProcessingViewController.h"
#import "DelayRequestsViewController.h"  //申请延期
#import "CheckDetailPublishViewController.h"//查看发布方
#import "MyScheduleViewController.h"   //填写进度
#import "AdditionMessageViewController.h"  //查看更多
#import "AgreementViewController.h"   //服务协议
#import "PaceViewController.h"

#import "BaseCommitButton.h"

#import "MineUserCell.h"
#import "BidMessageCell.h"
#import "BidOneCell.h"

//详细信息
#import "PublishingResponse.h"
#import "PublishingModel.h"

//查看进度
#import "ScheduleResponse.h"
#import "ScheduleModel.h"

//申请延期
#import "DelayResponse.h"
#import "DelayModel.h"

@interface MyProcessingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *myProcessingTableView;
@property (nonatomic,strong) BaseCommitButton *processingCommitButton;

@property (nonatomic,strong) NSMutableArray *processArray;
@property (nonatomic,strong) NSMutableArray *scheduleOrderProArray;
@property (nonatomic,strong) NSMutableArray *delayArray;
@end

@implementation MyProcessingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"产品详情";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    if (self.pidString) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"查看发布方" style:UIBarButtonItemStylePlain target:self action:@selector(checkProcessingDetail)];
    }
    
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:kBigFont,NSForegroundColorAttributeName:kBlueColor} forState:0];
    
    [self.view addSubview:self.myProcessingTableView];
    [self.view addSubview:self.processingCommitButton];
    [self.view setNeedsUpdateConstraints];
    
    [self getDetailMessageOfProcessing];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.myProcessingTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.myProcessingTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kTabBarHeight];
        
        [self.processingCommitButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.processingCommitButton autoSetDimension:ALDimensionHeight toSize:kTabBarHeight];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)myProcessingTableView
{
    if (!_myProcessingTableView) {
//        _myProcessingTableView = [UITableView newAutoLayoutView];
        _myProcessingTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _myProcessingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        _myProcessingTableView.delegate = self;
        _myProcessingTableView.dataSource = self;
    }
    return _myProcessingTableView;
}
- (BaseCommitButton *)processingCommitButton
{
    if (!_processingCommitButton) {
        _processingCommitButton = [BaseCommitButton newAutoLayoutView];
    }
    return _processingCommitButton;
}

- (NSMutableArray *)processArray
{
    if (!_processArray) {
        _processArray = [NSMutableArray array];
    }
    return _processArray;
}

- (NSMutableArray *)scheduleOrderProArray
{
    if (!_scheduleOrderProArray) {
        _scheduleOrderProArray = [NSMutableArray array];
    }
    return _scheduleOrderProArray;
}

- (NSMutableArray *)delayArray
{
    if (!_delayArray) {
        _delayArray = [NSMutableArray array];
    }
    return _delayArray;
}

#pragma mark - 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.processArray.count > 0) {
        return 5;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.processArray.count > 0) {
        if (section == 1) {
            return 6;
        }else if (section == 3){
            return 3;
        }
        return 1;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.section == 3) && (indexPath.row == 1)){
        return 145;
    }
    
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PublishingResponse *response;
    PublishingModel *processModel;
    if (self.processArray.count > 0) {
        response = self.processArray[0];
        processModel = response.product;
    }
    
    static NSString *identifier;
    if (indexPath.section == 0) {
        identifier = @"processing0";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = UIColorFromRGB(0x42566d);
        
        NSString *codeStr = [NSString stringWithFormat:@"产品编号：%@",processModel.codeString];
        [cell.userNameButton setTitle:codeStr forState:0];
        [cell.userNameButton setTitleColor:UIColorFromRGB(0xcfd4e8) forState:0];
        cell.userNameButton.titleLabel.font = kFirstFont;
        
        [cell.userActionButton setTitleColor:kNavColor forState:0];
        cell.userActionButton.titleLabel.font = kBigFont;
        /*0为待发布（保存未发布的）。 1为发布中（已发布的）。
         2为处理中（有人已接单发布方也已同意）。
         3为终止（只用发布方可以终止）。
         4为结案（双方都可以申请，一方申请一方同意*/
        if ([processModel.progress_status intValue] == 0) {
            [cell.userActionButton setTitle:@"待发布" forState:0];
        }else if ([processModel.progress_status intValue] == 1){
            [cell.userActionButton setTitle:@"申请中" forState:0];
        }else if ([processModel.progress_status intValue] == 2){
            [cell.userActionButton setTitle:@"处理中" forState:0];
        }else if ([processModel.progress_status intValue] == 3){
            [cell.userActionButton setTitle:@"终止" forState:0];
        }else if ([processModel.progress_status intValue] == 4){
            [cell.userActionButton setTitle:@"结案" forState:0];
        }
        
        return cell;
    }else if (indexPath.section == 1){
        if (indexPath.row < 5) {
            identifier = @"processing1";
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
            if ([processModel.category intValue] == 1) {//融资
                string22 = @"融资";
                if ([processModel.rate_cat intValue] == 1) {
                    string3 = @"  借款利率(天)";
                }else if ([processModel.rate_cat intValue] == 2){
                    string3 = @"  借款利率(月)";
                }
                imageString3 = @"conserve_interest_icon";
                string33 = processModel.rate;
                string4 = @"  返点";
                imageString4 = @"conserve_rebate_icon";
                string44 = processModel.rebate;
            }else if ([processModel.category intValue] == 2){//清收
                string22 = @"清收";
                string3 = @"  代理费用(万)";
                imageString3 = @"conserve_fixed_icon";
                string33 = processModel.agencycommission;
                string4 = @"  债权类型";
                imageString4 = @"conserve_rights_icon";
                if ([processModel.loan_type intValue] == 1) {
                    string44 = @"房产抵押";
                }else if ([processModel.loan_type intValue] == 2){
                    string44 = @"应收账款";
                }else if ([processModel.loan_type intValue] == 3){
                    string44 = @"机动车抵押";
                }else if ([processModel.loan_type intValue] == 4){
                    string44 = @"无抵押";
                }
            }else if ([processModel.category intValue] == 3){//诉讼
                string22 = @"诉讼";
                if ([processModel.agencycommissiontype intValue] == 1) {
                    string3 = @"  固定费用(万)";
                }else if ([processModel.agencycommissiontype intValue] == 2){
                    string3 = @"  风险费率(%)";
                }
                imageString3 = @"conserve_fixed_icon";
                string33 = processModel.agencycommission;
                string4 = @"  债权类型";
                imageString4 = @"conserve_rights_icon";
                if ([processModel.loan_type intValue] == 1) {
                    string44 = @"房产抵押";
                }else if ([processModel.loan_type intValue] == 2){
                    string44 = @"应收账款";
                }else if ([processModel.loan_type intValue] == 3){
                    string44 = @"机动车抵押";
                }else if ([processModel.loan_type intValue] == 4){
                    string44 = @"无抵押";
                }
            }
            
            NSArray *dataArray = @[@"|  基本信息",@"  投资类型",@"  借款本金(万)",string3,string4];
            NSArray *imageArray = @[@"",@"conserve_investment_icon",@"conserve_loan_icon",imageString3,imageString4];
            NSArray *detailArray = @[@"",string22,processModel.money,string33,string44];
            
            [cell.userNameButton setTitle:dataArray[indexPath.row] forState:0];
            [cell.userNameButton setImage:[UIImage imageNamed:imageArray[indexPath.row]] forState:0];
            [cell.userActionButton setTitle:detailArray[indexPath.row] forState:0];
            
            if (indexPath.row == 0) {
                [cell.userNameButton setTitleColor:kBlueColor forState:0];
            }
            
            return cell;
        }
        
        identifier = @"processing11";
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

        identifier = @"processing2";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.userNameButton setTitle:@"|  服务协议" forState:0];
        [cell.userNameButton setTitleColor:kBlueColor forState:0];
        
        [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        [cell.userActionButton setTitle:@"点击查看" forState:0];
        cell.userActionButton.titleLabel.font = kSecondFont;
        [cell.userActionButton setTitleColor:kLightGrayColor forState:0];
        cell.userActionButton.userInteractionEnabled = NO;
  
        return cell;
    }else if (indexPath.section == 3){
        if (indexPath.row == 0) {
            identifier = @"processing40";
            MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell.userNameButton setTitleColor:kBlueColor forState:0];
            [cell.userNameButton setTitle:@"|  进度详情" forState:0];
            cell.userActionButton.userInteractionEnabled = NO;
            
            if (self.scheduleOrderProArray.count > 0) {
                [cell.userActionButton setTitle:@"查看更多" forState:0];
                [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
            }else{
                [cell.userActionButton setTitle:@"暂无" forState:0];
            }
            return cell;
            
        }else if (indexPath.row == 1){//具体进度
            
            identifier = @"processing31";
            BidMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[BidMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
           
            if (self.scheduleOrderProArray.count > 0) {
                 ScheduleModel *scheduleModel = self.scheduleOrderProArray[0];
                [cell.remindImageButton setHidden:YES];
                [cell.deadlineLabel setHidden:NO];
                [cell.timeLabel setHidden:NO];
                [cell.dateLabel setHidden:NO];
                [cell.areaLabel setHidden:NO];
                [cell.addressLabel setHidden:NO];
                
                //案号类型
                NSString *auditStr;
                if ([self.categaryString integerValue] == 3) {
                    NSArray *auditArray = @[@"一审",@"二审",@"再审",@"执行"];
                    NSInteger auditInt = [scheduleModel.audit intValue];
                    auditStr = auditArray[auditInt];
                }else{
                    auditStr = @"暂无";
                }
                NSMutableAttributedString *caseTypestring = [cell.deadlineLabel setAttributeString:@"案号类型：" withColor:kBlackColor andSecond:auditStr withColor:kLightGrayColor withFont:12];
                [cell.deadlineLabel setAttributedText:caseTypestring];
                
                //时间
                cell.timeLabel.text = @"2016-05-30";
                
                //案号
                NSString *caseStr = [NSString getValidStringFromString:scheduleModel.caseString];
                NSMutableAttributedString *caseNoString = [cell.dateLabel setAttributeString:@"案        号：" withColor:kBlackColor andSecond:caseStr withColor:kLightGrayColor withFont:12];
                [cell.dateLabel setAttributedText:caseNoString];
                
                //处置类型
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
                
                //详情
                NSString *contentStr = [NSString getValidStringFromString:scheduleModel.content];
                NSMutableAttributedString *dealDeailString = [cell.addressLabel setAttributeString:@"详        情：" withColor:kBlackColor andSecond:contentStr withColor:kLightGrayColor withFont:12];
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
            identifier = @"processing32";
            BidOneCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[BidOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.oneButton setTitle:@"填写进度" forState:0];
            [cell.oneButton setImage:[UIImage imageNamed:@"more"] forState:0];
            cell.oneButton.userInteractionEnabled = NO;
            
            return cell;
        }
    }
    
    identifier = @"processing4";
    MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell.userNameButton setTitleColor:kBlueColor forState:0];
    [cell.userNameButton setTitle:@"|  申请延期" forState:0];
    cell.userActionButton.userInteractionEnabled = NO;
    
    DelayResponse *delayResponss;
    DelayModel *delayModel;
    PublishingModel *puModel;
    if (self.delayArray.count > 0) {
        delayResponss = self.delayArray[0];
        delayModel = delayResponss.delay;
        puModel = delayResponss.product;
    }
    
    //
//    if ([response.product.progress_status integerValue] == 2 && ![response.uidString isEqualToString:response.product.uidInner]) {
//        if ([response.product.applyclose integerValue] == 0)
    
    
    
    
    if (delayModel.is_agree == nil || [delayModel.is_agree isEqualToString:@""]) {
        if (![puModel.applyclose isEqualToString:@"4"]) {
            if ([delayModel.delays integerValue] <= 7) {
                [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
                [cell.userActionButton setTitle:@"立即申请" forState:0];
            }else{
                [cell.userActionButton setTitle:@"不能申请延期" forState:0];
                [self showHint:@"小于7天才可申请延期"];
                cell.userInteractionEnabled = NO;
            }
            
        }else{//由于双方申请了结案，故不能点击申请延期
            [cell.userActionButton setTitle:@"不能申请延期" forState:0];
            cell.userInteractionEnabled = NO;
        }
    }else{
        [cell.userActionButton setTitle:@"已申请" forState:0];
        [cell.userActionButton setTitleColor:kBlackColor forState:0];
        cell.userInteractionEnabled = NO;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section > 3) {
        return 60;
    }
    return kBigPadding;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 4) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
        footerView.backgroundColor = kBackColor;
        
        UIButton *applyButton = [UIButton newAutoLayoutView];
        applyButton.titleLabel.font = kTabBarFont;
        [applyButton setTitleColor:kGrayColor forState:0];
        
        DelayResponse *delayResponss;
        DelayModel *delayModel;
        PublishingModel *puModel;
        if (self.delayArray.count > 0) {
            delayResponss = self.delayArray[0];
            delayModel = delayResponss.delay;
            puModel = delayResponss.product;
        }
        
        if (delayModel.is_agree == nil || [delayModel.is_agree isEqualToString:@""]) {
            if (![puModel.applyclose isEqualToString:@"4"]) {
                if ([delayModel.delays integerValue] <= 7) {
                    //未申请
                    [applyButton setImage:[UIImage imageNamed:@"conserve_tip_icon"] forState:0];
                   NSString *delay = [delayModel.delays integerValue]>=0?delayModel.delays:@"0";
                    NSString *de = [NSString stringWithFormat:@"  距离案件处理结束日期还有%@天，可提前7天申请延期，只可申请一次",delay];
                    [applyButton setTitle:de forState:0];

                }
            }else{
                [applyButton setTitle:@"  结案申请中，不能申请延期" forState:0];
            }
        }else{
            [applyButton setImage:[UIImage imageNamed:@"conserve_wait_icon"] forState:0];
            
            //已申请：0申请中,1同意，2拒绝，3作废，
            if ([delayModel.is_agree intValue] == 0) {
                [applyButton setTitle:@"  申请中" forState:0];
            }else if ([delayModel.is_agree intValue] == 1){
                [applyButton setTitle:@"  申请成功，等待发布确认" forState:0];
            }else if ([delayModel.is_agree intValue] == 2){
                [applyButton setTitle:@"  发布方已拒绝" forState:0];
            }else if ([delayModel.is_agree intValue] == 3){
                [applyButton setTitle:@"  作废" forState:0];
            }
        }
    
        [footerView addSubview:applyButton];
        [applyButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [applyButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5];
        
        return footerView;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 5) {//补充信息
        AdditionMessageViewController *additionalMessageVC = [[AdditionMessageViewController alloc] init];
        additionalMessageVC.idString = self.idString;
        additionalMessageVC.categoryString = self.categaryString;
        [self.navigationController pushViewController:additionalMessageVC animated:YES];
        
    }else if (indexPath.section == 2) {//协议
        AgreementViewController *agreementVc = [[AgreementViewController alloc] init];
        agreementVc.idString = self.idString;
        agreementVc.categoryString = self.categaryString;
        [self.navigationController pushViewController:agreementVc animated:YES];
    }else if (indexPath.section == 3) {
        if (indexPath.row == 0) {//进度
            PaceViewController *paceVC = [[PaceViewController alloc] init];
            paceVC.idString = self.idString;
            paceVC.categoryString = self.categaryString;
            [self.navigationController pushViewController:paceVC animated:YES];
            
        }else if (indexPath.row ==2){//填写进度
            MyScheduleViewController *myScheduleVC = [[MyScheduleViewController alloc] init];
            myScheduleVC.idString = self.idString;
            myScheduleVC.categoryString = self.categaryString;
            [self.navigationController pushViewController:myScheduleVC animated:YES];
        }
        
    }else if (indexPath.section == 4) {//申请延期
        DelayRequestsViewController *delayRequestVC = [[DelayRequestsViewController alloc] init];
        delayRequestVC.idString = self.idString;
        delayRequestVC.categoryString = self.categaryString;
        [self.navigationController pushViewController:delayRequestVC animated:YES];
    }
}

#pragma mark - method
- (void)checkProcessingDetail
{
    CheckDetailPublishViewController *checkDetailPublishVC = [[CheckDetailPublishViewController alloc] init];
    checkDetailPublishVC.idString = self.idString;
    checkDetailPublishVC.categoryString = self.categaryString;
    checkDetailPublishVC.pidString = self.pidString;
    checkDetailPublishVC.typeString = @"发布方";
    checkDetailPublishVC.typeDegreeString = @"处理中";
    [self.navigationController pushViewController:checkDetailPublishVC animated:YES];
}

- (void)getDetailMessageOfProcessing
{
    NSString *detailString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyReleaseDetailString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"id" : self.idString,
                             @"category" : self.categaryString
                             };
    [self requestDataPostWithString:detailString params:params successBlock:^(id responseObject){
        
        PublishingResponse *response = [PublishingResponse objectWithKeyValues:responseObject];
        [self.processArray addObject:response];
        [self.myProcessingTableView reloadData];
        
        if ([response.product.progress_status integerValue] == 2 && ![response.uidString isEqualToString:response.product.uidInner]) {
            if ([response.product.applyclose integerValue] == 0) {
                [self.processingCommitButton setTitle:@"申请结案" forState:0];
                [self.processingCommitButton addTarget:self action:@selector(endProduct) forControlEvents:UIControlEventTouchUpInside];
                
            }else if ([response.product.applyclose integerValue] == 4 && [response.product.applyclosefrom isEqualToString:response.product.uidInner]){
                [self.processingCommitButton setTitle:@"申请同意结案" forState:0];
                [self.processingCommitButton addTarget:self action:@selector(endProduct) forControlEvents:UIControlEventTouchUpInside];
            }else{
                [self.processingCommitButton setTitle:@"结案申请中" forState:0];
                [self.processingCommitButton setBackgroundColor:kSelectedColor];
                self.processingCommitButton.userInteractionEnabled = NO;
            }
        }
        
        [self lookUpProcessingSchedule];
        
    } andFailBlock:^(NSError *error){
        
    }];
}

//进度
- (void)lookUpProcessingSchedule
{
    NSString *scheduleString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kLookUpScheduleString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"id" : self.idString,
                             @"category" : self.categaryString
                             };
    [self requestDataPostWithString:scheduleString params:params successBlock:^(id responseObject) {
        ScheduleResponse *scheduleResponse = [ScheduleResponse objectWithKeyValues:responseObject];
        
        for (ScheduleModel *scheduleModel in scheduleResponse.disposing) {
            [self.scheduleOrderProArray addObject:scheduleModel];
        }
        [self.myProcessingTableView reloadData];
        [self delayRequest];
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

//申请延期状态
- (void)delayRequest
{
    NSString *deString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kIsDelayRequestString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"id" : self.idString,
                             @"category" : self.categaryString
                             };
    [self requestDataPostWithString:deString params:params successBlock:^(id responseObject) {
        DelayResponse *response = [DelayResponse objectWithKeyValues:responseObject];
        [self.delayArray addObject:response];
        [self.myProcessingTableView reloadData];
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

//申请结案
- (void)endProduct//status:3为终止。4为结案。
{
    NSString *endpString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyreleaseDealingEndString];
    NSDictionary *params = @{@"id" : self.idString,
                             @"category" : self.categaryString,
                             @"token" : [self getValidateToken],
                             @"status" : @"4"
                             };
    [self requestDataPostWithString:endpString params:params successBlock:^(id responseObject) {
        BaseModel *sModel = [BaseModel objectWithKeyValues:responseObject];
         [self showHint:sModel.msg];
        
        if ([sModel.code isEqualToString:@"0000"]) {//成功
            [self.processingCommitButton setBackgroundColor:kSelectedColor];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
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
