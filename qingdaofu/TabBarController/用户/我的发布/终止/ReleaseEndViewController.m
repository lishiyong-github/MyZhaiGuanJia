//
//  ReleaseEndViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/31.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ReleaseEndViewController.h"

#import "CheckDetailPublishViewController.h"  //查看发布方
#import "AdditionMessageViewController.h" //查看更多
#import "AgreementViewController.h"   //服务协议
#import "PaceViewController.h"

#import "MineUserCell.h"
#import "BidMessageCell.h"
#import "BidOneCell.h"

#import "BaseCommitButton.h"

#import "PublishingResponse.h"
#import "PublishingModel.h"

//查看进度
#import "ScheduleResponse.h"
#import "ScheduleModel.h"


@interface ReleaseEndViewController ()
<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *releaseEndTableView;
@property (nonatomic,strong) BaseCommitButton *releaseEndCommitButton;

@property (nonatomic,strong) NSMutableArray *endArray;
@property (nonatomic,strong) NSMutableArray *scheduleReleaseEndArray;

@end

@implementation ReleaseEndViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"产品详情";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    if (self.pidString) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"查看接单方" style:UIBarButtonItemStylePlain target:self action:@selector(checkReleaseDetails)];
    }
    
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:kBigFont,NSForegroundColorAttributeName:kBlueColor} forState:0];
    
    [self.view addSubview:self.releaseEndTableView];
    [self.view addSubview:self.releaseEndCommitButton];
    
    [self.view setNeedsUpdateConstraints];
    
    [self getEndMessages];
    [self getScheduleDetails];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.releaseEndTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.releaseEndTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kTabBarHeight];
        
        [self.releaseEndCommitButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.releaseEndCommitButton autoSetDimension:ALDimensionHeight toSize:kTabBarHeight];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)releaseEndTableView
{
    if (!_releaseEndTableView) {
//        _releaseEndTableView = [UITableView newAutoLayoutView];
        _releaseEndTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _releaseEndTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        _releaseEndTableView.delegate = self;
        _releaseEndTableView.dataSource = self;
    }
    return _releaseEndTableView;
}

- (BaseCommitButton *)releaseEndCommitButton
{
    if (!_releaseEndCommitButton) {
        _releaseEndCommitButton = [BaseCommitButton newAutoLayoutView];
        _releaseEndCommitButton.backgroundColor = kSelectedColor;
        [_releaseEndCommitButton setTitle:@"已终止" forState:0];
    }
    return _releaseEndCommitButton;
}

- (NSMutableArray *)endArray
{
    if (!_endArray) {
        _endArray = [NSMutableArray array];
    }
    return _endArray;
}

- (NSMutableArray *)scheduleReleaseEndArray
{
    if (!_scheduleReleaseEndArray) {
        _scheduleReleaseEndArray = [NSMutableArray array];
    }
    return _scheduleReleaseEndArray;
}

#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.endArray.count > 0) {
        return 4;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.endArray.count > 0) {
        if (section == 1) {
            return 6;
        }else if (section == 3){
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
    }
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    if (self.endArray.count > 0) {
        PublishingResponse *reModel = self.endArray[0];
        PublishingModel *endModel = reModel.product;
        
        if (indexPath.section == 0) {
            identifier = @"releaseEnd0";
            MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!cell) {
                cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = UIColorFromRGB(0x42566d);
            
            NSString *code = [NSString stringWithFormat:@"产品编号:%@",endModel.codeString];
            [cell.userNameButton setTitle:code forState:0];
            [cell.userNameButton setTitleColor:UIColorFromRGB(0xcfd4e8) forState:0];
            
            /*0为待发布（保存未发布的）。 1为发布中（已发布的）。
             2为处理中（有人已接单发布方也已同意）。
             3为终止（只用发布方可以终止）。
             4为结案（双方都可以申请，一方申请一方同意*/
            if ([endModel.progress_status intValue] == 0) {
                [cell.userActionButton setTitle:@"待发布" forState:0];
            }else if ([endModel.progress_status intValue] == 1){
                [cell.userActionButton setTitle:@"发布中" forState:0];
            }else if ([endModel.progress_status intValue] == 2){
                [cell.userActionButton setTitle:@"处理中" forState:0];
            }else if ([endModel.progress_status intValue] == 3){
                [cell.userActionButton setTitle:@"终止" forState:0];
            }else if ([endModel.progress_status intValue] == 4){
                [cell.userActionButton setTitle:@"结案" forState:0];
            }
            [cell.userActionButton setTitleColor:kNavColor forState:0];
            cell.userActionButton.titleLabel.font = kBigFont;
            
            return cell;
            
        }else if (indexPath.section == 1){
            if (indexPath.row < 5) {
                identifier = @"releaseEnd11";
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
                if ([endModel.category intValue] == 1) {//融资
                    string22 = @"融资";
                    if ([endModel.rate_cat intValue] == 1) {
                        string3 = @"  借款利率(天)";
                    }else if ([endModel.rate_cat intValue] == 2){
                        string3 = @"  借款利率(月)";
                    }
                    imageString3 = @"conserve_interest_icon";
                    string33 = endModel.rate;
                    string4 = @"  返点";
                    imageString4 = @"conserve_rebate_icon";
                    string44 = endModel.rebate;
                }else if ([endModel.category intValue] == 2){//催收
                    string22 = @"催收";
                    string3 = @"  代理费用(万)";
                    imageString3 = @"conserve_fixed_icon";
                    string33 = endModel.agencycommission;
                    string4 = @"  债权类型";
                    imageString4 = @"conserve_rights_icon";
                    if ([endModel.loan_type intValue] == 1) {
                        string44 = @"房产抵押";
                    }else if ([endModel.loan_type intValue] == 2){
                        string44 = @"应收账款";
                    }else if ([endModel.loan_type intValue] == 3){
                        string44 = @"机动车抵押";
                    }else if ([endModel.loan_type intValue] == 4){
                        string44 = @"无抵押";
                    }
                }else if ([endModel.category intValue] == 3){//诉讼
                    string22 = @"诉讼";
                    if ([endModel.agencycommissiontype intValue] == 1) {
                        string3 = @"  固定费用(万)";
                    }else if ([endModel.agencycommissiontype intValue] == 2){
                        string3 = @"  风险费率(%)";
                    }
                    imageString3 = @"conserve_fixed_icon";
                    string33 = endModel.agencycommission;
                    string4 = @"  债权类型";
                    imageString4 = @"conserve_rights_icon";
                    if ([endModel.loan_type intValue] == 1) {
                        string44 = @"房产抵押";
                    }else if ([endModel.loan_type intValue] == 2){
                        string44 = @"应收账款";
                    }else if ([endModel.loan_type intValue] == 3){
                        string44 = @"机动车抵押";
                    }else if ([endModel.loan_type intValue] == 4){
                        string44 = @"无抵押";
                    }
                }
                
                NSArray *dataArray = @[@"|  基本信息",@"  投资类型",@"  借款本金(万)",string3,string4];
                NSArray *imageArray = @[@"",@"conserve_investment_icon",@"conserve_loan_icon",imageString3,imageString4];
                NSArray *detailArray = @[@"",string22,endModel.money,string33,string44];
                
                [cell.userNameButton setTitle:dataArray[indexPath.row] forState:0];
                [cell.userNameButton setImage:[UIImage imageNamed:imageArray[indexPath.row]] forState:0];
                [cell.userActionButton setTitle:detailArray[indexPath.row] forState:0];
                
                if (indexPath.row == 0) {
                    [cell.userNameButton setTitleColor:kBlueColor forState:0];
                }
                
                return cell;
                
            }
            identifier = @"releaseEnd12";
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
            identifier = @"releaseEnd2";
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
        }else{
            if (indexPath.row == 0) {
                identifier = @"releaseEnd30";
                MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!cell) {
                    cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                [cell.userNameButton setTitleColor:kBlueColor forState:0];
                [cell.userNameButton setTitle:@"|  进度详情" forState:0];
                cell.userActionButton.userInteractionEnabled = NO;
                
                if (self.scheduleReleaseEndArray.count > 0) {
                    [cell.userActionButton setTitle:@"查看更多" forState:0];
                    [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
                }else{
                    [cell.userActionButton setTitle:@"无" forState:0];
                }
                
                return cell;
                
            }
            identifier = @"releaseEnd41";
            BidMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[BidMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (self.scheduleReleaseEndArray.count > 0) {
                ScheduleModel *scheduleModel = self.scheduleReleaseEndArray[0];
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
    PublishingResponse *resModel = self.endArray[0];
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
        if (self.scheduleReleaseEndArray.count > 0) {
            PaceViewController *paceVC = [[PaceViewController alloc] init];
            paceVC.idString = dealModel.idString;
            paceVC.categoryString = dealModel.category;
            [self.navigationController pushViewController:paceVC animated:YES];
        }
    }
}

#pragma mark - method
- (void)checkReleaseDetails
{
    CheckDetailPublishViewController *checkDetailPublishVC = [[CheckDetailPublishViewController alloc] init];
    checkDetailPublishVC.idString = self.idString;
    checkDetailPublishVC.categoryString = self.categaryString;
    checkDetailPublishVC.pidString = self.pidString;
    checkDetailPublishVC.typeString = @"接单方";
    checkDetailPublishVC.evaTypeString = @"launchevaluation";
    [self.navigationController pushViewController:checkDetailPublishVC animated:YES];
}

- (void)getEndMessages
{
    NSString *releaseString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyReleaseDetailString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"id" : self.idString,
                             @"category" : self.categaryString
                             };
    [self requestDataPostWithString:releaseString params:params successBlock:^(id responseObject){
        PublishingResponse *response = [PublishingResponse objectWithKeyValues:responseObject];
        [self.endArray addObject:response];
        [self.releaseEndTableView reloadData];
        
    } andFailBlock:^(NSError *error){
        
    }];
}

- (void)getScheduleDetails
{
    NSString *scheduleString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kLookUpScheduleString];
    NSDictionary *params = @{@"id" : self.idString,
                             @"category" : self.categaryString,
                             @"token" : [self getValidateToken]
                             };
    [self requestDataPostWithString:scheduleString params:params successBlock:^(id responseObject) {
        ScheduleResponse *scheduleResponse = [ScheduleResponse objectWithKeyValues:responseObject];
        
        for (ScheduleModel *scheduleModel in scheduleResponse.disposing) {
            [self.scheduleReleaseEndArray addObject:scheduleModel];
        }
        [self.releaseEndTableView reloadData];
        
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
