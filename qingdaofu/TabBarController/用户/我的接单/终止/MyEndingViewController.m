//
//  MyEndingViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/4.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MyEndingViewController.h"
#import "CheckDetailPublishViewController.h"  //查看发布方
#import "MyScheduleViewController.h"    //填写进度
#import "AdditionMessageViewController.h" //查看更多
#import "PaceViewController.h"
#import "AgreementViewController.h"

#import "MineUserCell.h"
#import "BidMessageCell.h"
#import "BidOneCell.h"

#import "BaseCommitButton.h"

#import "PublishingResponse.h"
#import "PublishingModel.h"

#import "ScheduleResponse.h"
#import "ScheduleModel.h"

@interface MyEndingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *myEndingTableView;
@property (nonatomic,strong) BaseCommitButton *endingCommitButton;

@property (nonatomic,strong) NSMutableArray *endArray;
@property (nonatomic,strong) NSMutableArray *scheduleOrderEndArray;


@property (nonatomic,strong) NSString *loanTypeString1;  //债权类型
@property (nonatomic,strong) NSString *loanTypeString2;  //债权类型内容
@property (nonatomic,strong) NSString *loanTypeImage;//债权类型图片

@end

@implementation MyEndingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"产品详情";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    if (self.pidString) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"查看发布方" style:UIBarButtonItemStylePlain target:self action:@selector(checkOrderEndDetails)];
    }
    
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:kBigFont,NSForegroundColorAttributeName:kBlueColor} forState:0];
    
    [self.view addSubview:self.myEndingTableView];
    [self.view addSubview:self.endingCommitButton];
    [self.view setNeedsUpdateConstraints];
    
    [self getDetailMessageOfEnding];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.myEndingTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.myEndingTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kTabBarHeight];
        
        [self.endingCommitButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.endingCommitButton autoSetDimension:ALDimensionHeight toSize:kTabBarHeight];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)myEndingTableView
{
    if (!_myEndingTableView) {
        _myEndingTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _myEndingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        _myEndingTableView.delegate = self;
        _myEndingTableView.dataSource = self;
        _myEndingTableView.separatorColor = kSeparateColor;
        _myEndingTableView.backgroundColor = kBackColor;
    }
    return _myEndingTableView;
}

- (BaseCommitButton *)endingCommitButton
{
    if (!_endingCommitButton) {
        _endingCommitButton = [BaseCommitButton newAutoLayoutView];
        _endingCommitButton.backgroundColor = kSelectedColor;
        [_endingCommitButton setTitleColor:kBlackColor forState:0];
        [_endingCommitButton setTitle:@"已终止" forState:0];
    }
    return _endingCommitButton;
}

- (NSMutableArray *)endArray
{
    if (!_endArray) {
        _endArray = [NSMutableArray array];
    }
    return _endArray;
}

- (NSMutableArray *)scheduleOrderEndArray
{
    if (!_scheduleOrderEndArray) {
        _scheduleOrderEndArray = [NSMutableArray array];
    }
    return _scheduleOrderEndArray;
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
    if (self.endArray.count > 0){
        if (section == 1) {
            PublishingResponse *response = self.endArray[0];
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
    static NSString *identifier;
    PublishingResponse *responce = self.endArray[0];
    PublishingModel *endModel = responce.product;
    
    if (indexPath.section == 0) {
        identifier = @"ending0";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = UIColorFromRGB(0x42566d);
        
        NSString *codeStr = [NSString stringWithFormat:@"产品编号：%@",endModel.codeString];
        [cell.userNameButton setTitle:codeStr forState:0];
        [cell.userNameButton setTitleColor:UIColorFromRGB(0xcfd4e8) forState:0];
        cell.userNameButton.titleLabel.font = kFirstFont;
        
        /*0为待发布（保存未发布的）。 1为发布中（已发布的）。
         2为处理中（有人已接单发布方也已同意）。
         3为终止（只用发布方可以终止）。
         4为结案（双方都可以申请，一方申请一方同意*/
        [cell.userActionButton setTitle:@"终止" forState:0];
        [cell.userActionButton setTitleColor:kNavColor forState:0];
        cell.userActionButton.titleLabel.font = kBigFont;
        
        return cell;
        
    }else if (indexPath.section == 1){
        if (indexPath.row < 5) {
            identifier = @"ending1";
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
                    string3 = @"  借款利率(%/天)";
                }else if ([endModel.rate_cat intValue] == 2){
                    string3 = @"  借款利率(%/月)";
                }
                imageString3 = @"conserve_interest_icon";
                string33 = [NSString getValidStringFromString:endModel.rate toString:@"0"];
                string4 = @"  返点(%)";
                imageString4 = @"conserve_rebate_icon";
                string44 = [NSString getValidStringFromString:endModel.rebate toString:@"0"];
                
                _loanTypeString1 = @"  抵押物地址";
                NSString *seatmortgageS1 = [NSString getValidStringFromString:endModel.seatmortgage toString:@"无抵押物地址"];
                _loanTypeString2 = [NSString stringWithFormat:@"%@",seatmortgageS1];
                _loanTypeImage = @"conserve_seat_icon";
                
            }else if ([endModel.category intValue] == 2){//清收
                string22 = @"清收";
                if ([endModel.agencycommissiontype intValue] == 1) {
                    string3 = @"  服务佣金(%)";
                    imageString3 =  @"conserve_rights_icon";

                }else if ([endModel.agencycommissiontype intValue] == 2){
                    string3 = @"  固定费用(万元)";
                    imageString3 =  @"conserve_fixed_icons";

                }
                string33 = [NSString getValidStringFromString:endModel.agencycommission toString:@"0"];
                string4 = @"  债权类型";
                imageString4 = @"conserve_loantype_icon";
                if ([endModel.loan_type intValue] == 1) {
                    string44 = @"房产抵押";
                    _loanTypeString1 = [NSString stringWithFormat:@"  %@",string44];
                    _loanTypeString2 = [NSString getValidStringFromString:endModel.seatmortgage toString:@"无抵押物地址"];
                    _loanTypeImage = @"conserve_seat_icon";

                }else if ([endModel.loan_type intValue] == 2){
                    string44 = @"应收账款";
                    _loanTypeString1 = [NSString stringWithFormat:@"  %@(万元)",string44];
                    _loanTypeString2 = [NSString getValidStringFromString:endModel.accountr toString:@"0"];
                    _loanTypeImage = @"conserve_account_icon";
                    
                }else if ([endModel.loan_type intValue] == 3){
                    string44 = @"机动车抵押";
                    _loanTypeString1 = [NSString stringWithFormat:@"  %@",string44];
                    NSString *carS2 = [NSString getValidStringFromString:responce.car];
                    NSString *licenseS2 = [NSString getValidStringFromString:responce.license];
                    _loanTypeString2 = [NSString stringWithFormat:@"%@/%@",carS2,licenseS2];
                    _loanTypeImage = @"conserve_car_icon";
                    
                }else{
                    string44 = @"无抵押";
                }
            }else if ([endModel.category intValue] == 3){//诉讼
                string22 = @"诉讼";
                if ([endModel.agencycommissiontype intValue] == 1) {
                    string3 = @"  固定费用(万元)";
                    imageString3 =  @"conserve_fixed_icons";
                }else if ([endModel.agencycommissiontype intValue] == 2){
                    string3 = @"  风险费率(%)";
                    imageString3 =  @"conserve_fixed_icon";
                }
                string33 = [NSString getValidStringFromString:endModel.agencycommission toString:@"0"];
                string4 = @"  债权类型";
                imageString4 = @"conserve_loantype_icon";
                if ([endModel.loan_type intValue] == 1) {
                    string44 = @"房产抵押";
                    _loanTypeString1 = [NSString stringWithFormat:@"  %@",string44];
                    _loanTypeString2 = [NSString getValidStringFromString:endModel.seatmortgage toString:@"无抵押物地址"];
                    _loanTypeImage = @"conserve_seat_icon";

                }else if ([endModel.loan_type intValue] == 2){
                    string44 = @"应收账款";
                    _loanTypeString1 = [NSString stringWithFormat:@"  %@(万元)",string44];
                    _loanTypeString2 = [NSString getValidStringFromString:endModel.accountr toString:@"0"];
                    _loanTypeImage = @"conserve_account_icon";
                }else if ([endModel.loan_type intValue] == 3){
                    string44 = @"机动车抵押";
                    _loanTypeString1 = [NSString stringWithFormat:@"  %@",string44];
                    NSString *carS3 = [NSString getValidStringFromString:responce.car];
                    NSString *licenseS3 = [NSString getValidStringFromString:responce.license];
                    _loanTypeString2 = [NSString stringWithFormat:@"%@/%@",carS3,licenseS3];
                    _loanTypeImage = @"conserve_car_icon";
                }else{
                    string44 = @"无抵押";
                }
            }
            
            NSString *moneyS1 = [NSString getValidStringFromString:endModel.money toString:@"0"];
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
        
        if ([endModel.loan_type isEqualToString:@"4"]) {//无抵押
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
        identifier = @"ending2";
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

    }
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
        if (self.scheduleOrderEndArray.count > 0) {
            [cell.userActionButton setTitle:@"查看更多" forState:0];
            [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        }else{
            [cell.userActionButton setTitle:@"暂无" forState:0];
        }
        
        return cell;
        
    }else if (indexPath.row == 1){
        identifier = @"ending31";
        BidMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[BidMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (self.scheduleOrderEndArray.count > 0) {
            ScheduleModel *scheduleModel = self.scheduleOrderEndArray[0];
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
            NSMutableAttributedString *caseTypestring = [cell.deadlineLabel setAttributeString:@"案号类型：" withColor:kBlackColor andSecond:auditStr?auditStr:@"暂无" withColor:kLightGrayColor withFont:14];
            [cell.deadlineLabel setAttributedText:caseTypestring];
            
            //时间
            cell.timeLabel.text = [NSDate getYMDhmFormatterTime:scheduleModel.create_time];
            
            //案号
            NSString *caseNoStr = [NSString getValidStringFromString:scheduleModel.caseString];
            NSMutableAttributedString *caseNoString = [cell.dateLabel setAttributeString:@"案        号：" withColor:kBlackColor andSecond:caseNoStr withColor:kLightGrayColor withFont:14];
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
    
    if (indexPath.section == 1) {
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
    }else if (indexPath.section == 2) {
        AgreementViewController *agreementVC = [[AgreementViewController alloc] init];
        agreementVC.idString = dealModel.idString;
        agreementVC.categoryString = dealModel.category;
        [self.navigationController pushViewController:agreementVC animated:YES];
    }else if ((indexPath.section == 3) && (indexPath.row == 0)) {
        if (self.scheduleOrderEndArray.count > 0) {
            PaceViewController *paceVC = [[PaceViewController alloc] init];
            paceVC.idString = dealModel.idString;
            paceVC.categoryString = dealModel.category;
            [self.navigationController pushViewController:paceVC animated:YES];
        }
    }
}

#pragma mark - method
- (void)checkOrderEndDetails
{
    PublishingResponse *responde;
    if (self.endArray.count > 0) {
        responde = self.endArray[0];
    }
    
    if ([responde.state isEqualToString:@"1"]) {
        CheckDetailPublishViewController *checkDetailPublishVC = [[CheckDetailPublishViewController alloc] init];
        checkDetailPublishVC.idString = self.idString;
        checkDetailPublishVC.categoryString = self.categaryString;
        checkDetailPublishVC.pidString = self.pidString;
        checkDetailPublishVC.typeString = @"发布方";
        [self.navigationController pushViewController:checkDetailPublishVC animated:YES];
    }else{
        [self showHint:@"发布方未认证，不能查看相关信息"];
    }
}

- (void)getDetailMessageOfEnding
{
    NSString *detailString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kProdutsDetailString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"id" : self.idString,
                             @"category" : self.categaryString
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:detailString params:params successBlock:^(id responseObject){
        PublishingResponse *response = [PublishingResponse objectWithKeyValues:responseObject];
        [weakself.endArray addObject:response];
        [weakself.myEndingTableView reloadData];
        [weakself getScheduleDetails];
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
    QDFWeakSelf;
    [self requestDataPostWithString:scheduleString params:params successBlock:^(id responseObject) {
        
        ScheduleResponse *response = [ScheduleResponse objectWithKeyValues:responseObject];
        for (ScheduleModel *model in response.disposing) {
            [weakself.scheduleOrderEndArray addObject:model];
        }
        [weakself.myEndingTableView reloadData];
        
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
