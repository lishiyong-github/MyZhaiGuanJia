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
@property (nonatomic,strong) BaseCommitButton *processinCommitButton;

@property (nonatomic,strong) NSMutableArray *processArray;
@property (nonatomic,strong) NSMutableArray *scheduleOrderProArray;
@property (nonatomic,strong) NSMutableArray *delayArray;


@property (nonatomic,strong) NSString *loanTypeString1;  //债权类型
@property (nonatomic,strong) NSString *loanTypeString2;  //债权类型内容
@property (nonatomic,strong) NSString *loanTypeImage;//债权类型图片

@end

@implementation MyProcessingViewController

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lookUpProcessingSchedule) name:@"schedule" object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"schedule" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"产品详情";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    if (self.pidString) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"查看发布方" style:UIBarButtonItemStylePlain target:self action:@selector(checkProcessingDetail)];
    }
    
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:kBigFont,NSForegroundColorAttributeName:kBlueColor} forState:0];
    
    [self.view addSubview:self.myProcessingTableView];
    [self.view addSubview:self.processinCommitButton];
    [self.view setNeedsUpdateConstraints];
    
    [self getDetailMessageOfProcessing];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.myProcessingTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.myProcessingTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kTabBarHeight];
        
        [self.processinCommitButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.processinCommitButton autoSetDimension:ALDimensionHeight toSize:kTabBarHeight];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)myProcessingTableView
{
    if (!_myProcessingTableView) {
        _myProcessingTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _myProcessingTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _myProcessingTableView.delegate = self;
        _myProcessingTableView.dataSource = self;
        _myProcessingTableView.separatorColor = kSeparateColor;
        _myProcessingTableView.backgroundColor = kBackColor;
    }
    return _myProcessingTableView;
}
- (BaseCommitButton *)processinCommitButton
{
    if (!_processinCommitButton) {
        _processinCommitButton = [BaseCommitButton newAutoLayoutView];
    }
    return _processinCommitButton;
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
            PublishingResponse *response = self.processArray[0];
            if ([response.product.loan_type isEqualToString:@"4"]) {
                return 6;
            }
            return 7;
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
        [cell.userActionButton setTitle:@"处理中" forState:0];
        
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
                    string3 = @"  借款利率(%/天)";
                }else{
                    string3 = @"  借款利率(%/月)";
                }
                imageString3 = @"conserve_interest_icon";
                string33 = [NSString getValidStringFromString:processModel.rate toString:@"0"];
                string4 = @"  返点(%)";
                imageString4 = @"conserve_rebate_icon";
                string44 = [NSString getValidStringFromString:processModel.rebate toString:@"0"];
                
                _loanTypeString1 = @"  抵押物地址";
                NSString *seatmortgageS1 = [NSString getValidStringFromString:processModel.seatmortgage toString:@"无抵押物地址"];
                _loanTypeString2 = [NSString stringWithFormat:@"%@",seatmortgageS1];
                _loanTypeImage = @"conserve_seat_icon";
                
            }else if ([processModel.category intValue] == 2){//清收
                string22 = @"清收";
                if ([processModel.agencycommissiontype intValue] == 1) {
                    string3 = @"  服务佣金(%)";
                    imageString3 =  @"conserve_rights_icon";
                }else{
                    string3 = @"  固定费用(万元)";
                    imageString3 =  @"conserve_fixed_icons";
                }
                string33 = [NSString getValidStringFromString:processModel.agencycommission toString:@"0"];
                string4 = @"  债权类型";
                imageString4 = @"conserve_loantype_icon";
                if ([processModel.loan_type intValue] == 1) {
                    string44 = @"房产抵押";
                    _loanTypeString1 = [NSString stringWithFormat:@"  %@",string44];
                    NSString *seatmortgageS2 = [NSString getValidStringFromString:processModel.seatmortgage toString:@"无抵押物地址"];
                    _loanTypeString2 = [NSString stringWithFormat:@"%@",seatmortgageS2];
                    _loanTypeImage = @"conserve_seat_icon";
                    
                }else if ([processModel.loan_type intValue] == 2){
                    string44 = @"应收账款";
                    _loanTypeString1 = [NSString stringWithFormat:@"  %@(万元)",string44];
                    _loanTypeString2 = [NSString getValidStringFromString:processModel.accountr toString:@"0"];
                    _loanTypeImage = @"conserve_account_icon";
                }else if ([processModel.loan_type intValue] == 3){
                    string44 = @"机动车抵押";
                    _loanTypeString1 = [NSString stringWithFormat:@"  %@",string44];
                    NSString *carS2 = [NSString getValidStringFromString:response.car];
                    NSString *licenseS2 = [NSString getValidStringFromString:response.license];
                    _loanTypeString2 = [NSString stringWithFormat:@"%@/%@",carS2,licenseS2];
                    _loanTypeImage = @"conserve_car_icon";
                }else{
                    string44 = @"无抵押";
                }
            }else if ([processModel.category intValue] == 3){//诉讼
                string22 = @"诉讼";
                if ([processModel.agencycommissiontype intValue] == 1) {
                    string3 = @"  固定费用(万元)";
                    imageString3 =  @"conserve_fixed_icons";
                }else if ([processModel.agencycommissiontype intValue] == 2){
                    string3 = @"  风险费率(%)";
                    imageString3 =  @"conserve_fixed_icon";
                }
                imageString3 = @"conserve_fixed_icon";
                string33 = [NSString getValidStringFromString:processModel.agencycommission toString:@"0"];
                string4 = @"  债权类型";
                imageString4 = @"conserve_loantype_icon";
                if ([processModel.loan_type intValue] == 1) {
                    string44 = @"房产抵押";
                    _loanTypeString1 = [NSString stringWithFormat:@"  %@",string44];
                    NSString *seatmortgageS3 = [NSString getValidStringFromString:processModel.seatmortgage toString:@"无抵押物地址"];
                    _loanTypeString2 = [NSString stringWithFormat:@"%@",seatmortgageS3];
                    _loanTypeImage = @"conserve_seat_icon";
                }else if ([processModel.loan_type intValue] == 2){
                    string44 = @"应收账款";
                    _loanTypeString1 = [NSString stringWithFormat:@"  %@(万元)",string44];
                    _loanTypeString2 = [NSString getValidStringFromString:processModel.accountr toString:@"0"];
                    _loanTypeImage = @"conserve_account_icon";
                }else if ([processModel.loan_type intValue] == 3){
                    string44 = @"机动车抵押";
                    _loanTypeString1 = [NSString stringWithFormat:@"  %@",string44];
                    NSString *carS3 = [NSString getValidStringFromString:response.car];
                    NSString *licenseS3 = [NSString getValidStringFromString:response.license];
                    _loanTypeString2 = [NSString stringWithFormat:@"%@/%@",carS3,licenseS3];
                    _loanTypeImage = @"conserve_car_icon";
                }else{
                    string44 = @"无抵押";
                }
            }
            
            NSString *moneyS1 = [NSString getValidStringFromString:processModel.money toString:@"0"];
            NSArray *dataArray = @[@"|  基本信息",@"  产品类型",@"  借款本金(万元)",string3,string4];
            NSArray *imageArray = @[@"",@"conserve_investment_icon",@"conserve_loan_icon",imageString3,imageString4];
            NSArray *detailArray = @[@"",string22,moneyS1,string33,string44];
            
            [cell.userNameButton setTitle:dataArray[indexPath.row] forState:0];
            [cell.userNameButton setImage:[UIImage imageNamed:imageArray[indexPath.row]] forState:0];
            [cell.userActionButton setTitle:detailArray[indexPath.row] forState:0];
            
            if (indexPath.row == 0) {
                [cell.userNameButton setTitleColor:kBlueColor forState:0];
            }
            
            return cell;
        }
        
        if ([processModel.loan_type isEqualToString:@"4"]) {//无抵押
            //补充信息
            identifier = @"detailSave4";
            BidOneCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!cell) {
                cell = [[BidOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell.oneButton setTitle:@"查看补充信息" forState:0];
            [cell.oneButton setImage:[UIImage imageNamed:@"more"] forState:0];
            cell.oneButton.userInteractionEnabled = NO;
            
            return cell;
        }else{
            if (indexPath.row == 5) {
                identifier = @"detailSave2";
                MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                
                if (!cell) {
                    cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.userActionButton.titleLabel.font = kSecondFont;
                [cell.userActionButton autoSetDimension:ALDimensionWidth toSize:kScreenWidth-150];

                [cell.userNameButton setTitle:_loanTypeString1 forState:0];
                [cell.userNameButton setImage:[UIImage imageNamed:_loanTypeImage] forState:0];
                [cell.userActionButton setTitle:_loanTypeString2 forState:0];
                
                return cell;
            }else{
                //补充信息
                identifier = @"detailSave3";
                BidOneCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                
                if (!cell) {
                    cell = [[BidOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                [cell.oneButton setTitle:@"查看补充信息" forState:0];
                [cell.oneButton setImage:[UIImage imageNamed:@"more"] forState:0];
                cell.oneButton.userInteractionEnabled = NO;
                
                return cell;
            }
            
        }
        
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
                NSMutableAttributedString *caseTypestring = [cell.deadlineLabel setAttributeString:@"案号类型：" withColor:kBlackColor andSecond:auditStr withColor:kLightGrayColor withFont:14];
                [cell.deadlineLabel setAttributedText:caseTypestring];
                
                //时间
                cell.timeLabel.text = [NSDate getYMDhmFormatterTime:scheduleModel.create_time];
                
                //案号
                NSString *caseStr = [NSString getValidStringFromString:scheduleModel.caseString];
                NSMutableAttributedString *caseNoString = [cell.dateLabel setAttributeString:@"案        号：" withColor:kBlackColor andSecond:caseStr withColor:kLightGrayColor withFont:14];
                [cell.dateLabel setAttributedText:caseNoString];
                
                //处置类型
                NSArray *suitArr3 = @[@"债权人上传处置资产",@"律师接单",@"双方洽谈",@"向法院起诉(财产保全)",@"整理诉讼材料",@"法院立案",@"向当事人发出开庭传票",@"开庭前调解",@"开庭",@"判决",@"二次开庭",@"二次判决",@"移交执行局申请执行",@"执行中提供借款人的财产线索",@"调查(公告)",@"拍卖",@"流拍",@"拍卖成功",@"付费"];
                NSArray *suitArray1 = @[@"尽职调查",@"公证",@"抵押",@"放款",@"返点(%)",@"其他"];
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
                NSMutableAttributedString *dealTypeString = [cell.areaLabel setAttributeString:@"处置类型：" withColor: kBlackColor andSecond:dealTypeStr withColor:kLightGrayColor withFont:14];
                [cell.areaLabel setAttributedText:dealTypeString];
                
                //详情
                NSString *contentStr = [NSString getValidStringFromString:scheduleModel.content];
                NSMutableAttributedString *dealDeailString = [cell.addressLabel setAttributeString:@"详        情：" withColor:kBlackColor andSecond:contentStr withColor:kLightGrayColor withFont:14];
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
        
    if (delayModel.is_agree == nil || [delayModel.is_agree isEqualToString:@""]) {
        if (![puModel.applyclose isEqualToString:@"4"]) {
            if ([delayModel.delays integerValue] <= 7) {
                [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
                [cell.userActionButton setTitle:@"立即申请" forState:0];
            }else{
                [cell.userActionButton setTitle:@"不能申请延期" forState:0];
//                [self showHint:@"小于7天才可申请延期"];
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
    if (indexPath.section == 1) {
        PublishingResponse *resModel = self.processArray[0];
        PublishingModel *dealModel = resModel.product;

        if ([dealModel.loan_type isEqualToString:@"4"]) {
            if (indexPath.row == 5) {
                AdditionMessageViewController *additionMessageVC = [[AdditionMessageViewController alloc] init];
                additionMessageVC.idString = dealModel.idString;
                additionMessageVC.categoryString = dealModel.category;
                [self.navigationController pushViewController:additionMessageVC animated:YES];
            }
        }else{
            if (indexPath.row == 6) {
                AdditionMessageViewController *additionMessageVC = [[AdditionMessageViewController alloc] init];
                additionMessageVC.idString = dealModel.idString;
                additionMessageVC.categoryString = dealModel.category;
                [self.navigationController pushViewController:additionMessageVC animated:YES];
            }
        }
    }else if (indexPath.section == 2) {//协议
        AgreementViewController *agreementVc = [[AgreementViewController alloc] init];
        agreementVc.idString = self.idString;
        agreementVc.categoryString = self.categaryString;
        [self.navigationController pushViewController:agreementVc animated:YES];
    }else if (indexPath.section == 3) {
        if (indexPath.row == 0) {//进度
            
            if (self.scheduleOrderProArray.count > 0) {
                PaceViewController *paceVC = [[PaceViewController alloc] init];
                paceVC.idString = self.idString;
                paceVC.categoryString = self.categaryString;
                [self.navigationController pushViewController:paceVC animated:YES];
            }
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
    PublishingResponse *responde;
    if (self.processArray.count > 0) {
        responde = self.processArray[0];
    }
    
    if ([responde.state isEqualToString:@"1"]) {
        CheckDetailPublishViewController *checkDetailPublishVC = [[CheckDetailPublishViewController alloc] init];
        checkDetailPublishVC.idString = self.idString;
        checkDetailPublishVC.categoryString = self.categaryString;
        checkDetailPublishVC.pidString = self.pidString;
        checkDetailPublishVC.typeString = @"发布方";
        checkDetailPublishVC.typeDegreeString = @"处理中";
        [self.navigationController pushViewController:checkDetailPublishVC animated:YES];
    }else{
        [self showHint:@"发布方未认证，不能查看相关信息"];
    }
}

- (void)getDetailMessageOfProcessing
{
    NSString *detailString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kProdutsDetailString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"id" : self.idString,
                             @"category" : self.categaryString
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:detailString params:params successBlock:^(id responseObject){
        
        PublishingResponse *response = [PublishingResponse objectWithKeyValues:responseObject];
        [weakself.processArray addObject:response];
        [weakself.myProcessingTableView reloadData];
        
        if ([response.product.progress_status integerValue] == 2 && ![response.uidString isEqualToString:response.product.uidInner]) {
            if ([response.product.applyclose integerValue] == 0) {
                [weakself.processinCommitButton setTitle:@"申请结案" forState:0];
                [weakself.processinCommitButton addTarget:self action:@selector(endProduct) forControlEvents:UIControlEventTouchUpInside];
            }else if ([response.product.applyclose integerValue] == 4 && [response.product.applyclosefrom isEqualToString:response.product.uidInner]){
                [weakself.processinCommitButton setTitle:@"申请同意结案" forState:0];
                [weakself.processinCommitButton addTarget:self action:@selector(endProduct) forControlEvents:UIControlEventTouchUpInside];
            }else{
                [weakself.processinCommitButton setTitle:@"结案申请中" forState:0];
                [weakself.processinCommitButton setBackgroundColor:kSelectedColor];
                [weakself.processinCommitButton setTitleColor:kBlackColor forState:0];
                weakself.processinCommitButton.userInteractionEnabled = NO;
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
                             @"category" : self.categaryString,
                             @"page" : @"1"
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:scheduleString params:params successBlock:^(id responseObject) {
        ScheduleResponse *scheduleResponse = [ScheduleResponse objectWithKeyValues:responseObject];
        
        for (ScheduleModel *scheduleModel in scheduleResponse.disposing) {
            [weakself.scheduleOrderProArray addObject:scheduleModel];
        }
        [weakself.myProcessingTableView reloadData];
        [weakself delayRequest];
        
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
    QDFWeakSelf;
    [self requestDataPostWithString:deString params:params successBlock:^(id responseObject) {
        DelayResponse *response = [DelayResponse objectWithKeyValues:responseObject];
        [weakself.delayArray addObject:response];
        [weakself.myProcessingTableView reloadData];
        
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
    QDFWeakSelf;
    [self requestDataPostWithString:endpString params:params successBlock:^(id responseObject) {
        BaseModel *sModel = [BaseModel objectWithKeyValues:responseObject];
         [weakself showHint:sModel.msg];
        
        if ([sModel.code isEqualToString:@"0000"]) {//成功
            [weakself.processinCommitButton setBackgroundColor:kSelectedColor];
            [weakself.navigationController popViewControllerAnimated:YES];
        }
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)showAlertControllerWithTitle:(NSString *)title
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:title preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *alertAct1 = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *alertAct2 = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:alertAct1];
    [alertController addAction:alertAct2];
    [self presentViewController:alertController animated:YES completion:nil];
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
