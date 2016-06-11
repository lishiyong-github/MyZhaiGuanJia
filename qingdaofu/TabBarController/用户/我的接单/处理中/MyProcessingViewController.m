//
//  MyProcessingViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/4.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MyProcessingViewController.h"
#import "DelayRequestViewController.h"  //申请延期
#import "CheckDetailPublishViewController.h"//查看发布方
#import "MyScheduleViewController.h"   //填写进度
#import "AdditionMessageViewController.h"  //查看更多
#import "AgreementViewController.h"   //服务协议
#import "PaceViewController.h"

#import "BaseCommitButton.h"

#import "MineUserCell.h"
#import "BidMessageCell.h"
#import "BidOneCell.h"

@interface MyProcessingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *myProcessingTableView;
@property (nonatomic,strong) BaseCommitButton *processingCommitButton;

@end

@implementation MyProcessingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"产品详情";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"查看发布方" style:UIBarButtonItemStylePlain target:self action:@selector(checkProcessingDetail)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:kBigFont,NSForegroundColorAttributeName:kBlueColor} forState:0];
    
    [self.view addSubview:self.myProcessingTableView];
    [self.view addSubview:self.processingCommitButton];
    [self.view setNeedsUpdateConstraints];
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
        [_processingCommitButton setTitle:@"申请结案" forState:0];
    }
    return _processingCommitButton;
}

#pragma mark - 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 5;
    }else if ((section == 2) || section == 4){
        return 3;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.section == 2) && (indexPath.row == 1)) {
        return 145;
    }else if ((indexPath.section == 4) && (indexPath.row == 1)){
        return 145;
    }
    
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    if (indexPath.section == 0) {
        identifier = @"processing0";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = UIColorFromRGB(0x42566d);
        
        [cell.userNameButton setTitleColor:UIColorFromRGB(0xcfd4e8) forState:0];
        [cell.userNameButton setTitle:@"产品编号：RZ201605030001" forState:0];
        cell.userNameButton.titleLabel.font = kFirstFont;
        
        [cell.userActionButton setTitle:@"处理中" forState:0];
        [cell.userActionButton setTitleColor:kNavColor forState:0];
        cell.userActionButton.titleLabel.font = kBigFont;
        
        return cell;
    }else if (indexPath.section == 1){
        identifier = @"processing1";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        NSArray *dataArray = @[@"|  基本信息",@"  投资类型",@"  借款金额",@"  风险费率",@"  债权类型"];
        NSArray *imageArray = @[@"",@"conserve_investment_icon",@"conserve_loan_icon",@"conserve_risk_icon",@"conserve_rights_icon"];
        [cell.userNameButton setTitle:dataArray[indexPath.row] forState:0];
        [cell.userNameButton setImage:[UIImage imageNamed:imageArray[indexPath.row]] forState:0];
        
        if (indexPath.row == 0) {
            [cell.userNameButton setTitleColor:kBlueColor forState:0];
        }
        
        return cell;
    }else if (indexPath.section == 2){
        
        if (indexPath.row == 0) {
            identifier = @"processing20";
            MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!cell) {
                cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell.userNameButton setTitle:@"|  补充信息" forState:0];
            [cell.userNameButton setTitleColor:kBlueColor forState:0];
            
            return cell;
            
        }else if (indexPath.row == 1){
            identifier = @"processing21";
            BidMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!cell) {
                cell = [[BidMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NSMutableAttributedString *deallineStr = [cell.deadlineLabel setAttributeString:@"还款方式：    " withColor:kBlackColor andSecond:@"按月付息，到期还本" withColor:kLightGrayColor withFont:12];
            [cell.deadlineLabel setAttributedText:deallineStr];
            
            NSMutableAttributedString *dateStr = [cell.dateLabel setAttributeString:@"资金到帐日：" withColor:kBlackColor andSecond:@"6个月" withColor:kLightGrayColor withFont:12];
            [cell.dateLabel setAttributedText:dateStr];
            
            NSMutableAttributedString *areaStr = [cell.areaLabel setAttributeString:@"抵押物面积：" withColor:kBlackColor andSecond:@"100m" withColor:kLightGrayColor withFont:12];
            [cell.areaLabel setAttributedText:areaStr];
            
            NSMutableAttributedString *addressStr = [cell.addressLabel setAttributeString:@"抵押物地址：" withColor:kBlackColor andSecond:@"上海市浦东新区浦东南路855号" withColor:kLightGrayColor withFont:12];
            [cell.addressLabel setAttributedText:addressStr];
            
            return cell;
        }else{
            identifier = @"processing22";
            BidOneCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!cell) {
                cell = [[BidOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell.oneButton setTitle:@"查看更多" forState:0];
            [cell.oneButton setImage:[UIImage imageNamed:@"more"] forState:0];
            QDFWeakSelf;
            [cell.oneButton addAction:^(UIButton *btn) {
                AdditionMessageViewController *additionMessageVC = [[AdditionMessageViewController alloc] init];
                [weakself.navigationController pushViewController:additionMessageVC animated:YES];
            }];
            
            return cell;
        }
    }else if (indexPath.section == 3){

        identifier = @"processing3";
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
    }else if (indexPath.section == 4){
        if (indexPath.row == 0) {
            identifier = @"processing40";
            MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.userNameButton setTitleColor:kBlueColor forState:0];
            [cell.userNameButton setTitle:@"|  进度详情" forState:0];
            [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
            [cell.userActionButton setTitle:@"查看更多" forState:0];
            cell.userInteractionEnabled = NO;
            
            return cell;
            
        }else if (indexPath.row == 1){
            identifier = @"processing41";
            BidMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[BidMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NSMutableAttributedString *caseTypestring = [cell.deadlineLabel setAttributeString:@"案号类型：" withColor:kBlackColor andSecond:@"二审" withColor:kLightGrayColor withFont:12];
            [cell.deadlineLabel setAttributedText:caseTypestring];
            
            cell.timeLabel.text = @"2016-05-30";
            
            NSMutableAttributedString *caseNoString = [cell.dateLabel setAttributeString:@"案        号：" withColor:kBlackColor andSecond:@"201605120001" withColor:kLightGrayColor withFont:12];
            [cell.dateLabel setAttributedText:caseNoString];
            
            NSMutableAttributedString *dealTypeString = [cell.areaLabel setAttributeString:@"处置类型：" withColor: kBlackColor andSecond:@"拍卖" withColor:kLightGrayColor withFont:12];
            [cell.areaLabel setAttributedText:dealTypeString];
            
            NSMutableAttributedString *dealDeailString = [cell.addressLabel setAttributeString:@"详        情：" withColor:kBlackColor andSecond:@"详情详情" withColor:kLightGrayColor withFont:12];
            [cell.addressLabel setAttributedText:dealDeailString];
            
            return cell;
            
        }else{
            identifier = @"processing42";
            BidOneCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[BidOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.oneButton setTitle:@"填写进度" forState:0];
            [cell.oneButton setImage:[UIImage imageNamed:@"more"] forState:0];
            
            QDFWeakSelf;
            [cell.oneButton addAction:^(UIButton *btn) {
                MyScheduleViewController *myScheduleVC = [[MyScheduleViewController alloc] init];
                [weakself.navigationController pushViewController:myScheduleVC animated:YES];
            }];
            
            return cell;
        }
    }
    
    identifier = @"processing5";
    MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.userNameButton setTitleColor:kBlueColor forState:0];
    [cell.userNameButton setTitle:@"|  申请延期" forState:0];
    
    [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
    [cell.userActionButton setTitle:@"立即申请" forState:0];
    [cell.userActionButton setTitleColor:kLightGrayColor forState:0];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section > 4) {
        return 60;
    }
    return kBigPadding;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 5) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
        footerView.backgroundColor = kBackColor;
        
        UIButton *applyButton = [UIButton newAutoLayoutView];
        applyButton.titleLabel.font = kTabBarFont;
        [applyButton setTitleColor:kGrayColor forState:0];
        [applyButton sizeToFit];

        //未申请
        [applyButton setImage:[UIImage imageNamed:@"conserve_tip_icon"] forState:0];
        [applyButton setTitle:@"距离案件处理结束日期还有20天，可提前7天申请延期，只可申请一次" forState:0];
        
        //已申请
        //        [applyButton setImage:[UIImage imageNamed:@"conserve_wait_icon"] forState:0];
//        [applyButton setTitle:@"申请成功，等待发布确认" forState:0];
        
        [footerView addSubview:applyButton];
        
        [applyButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [applyButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5];
        
        return footerView;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        AgreementViewController *agreementVc = [[AgreementViewController alloc] init];
        [self.navigationController pushViewController:agreementVc animated:YES];
    }else if ((indexPath.section == 4) && (indexPath.row == 0)) {
        PaceViewController *paceVC = [[PaceViewController alloc] init];
        [self.navigationController pushViewController:paceVC animated:YES];
        
    }else if (indexPath.section == 5) {
        DelayRequestViewController *delayRequestVC = [[DelayRequestViewController alloc] init];
        [self.navigationController pushViewController:delayRequestVC animated:YES];
    }
}

#pragma mark - method
- (void)checkProcessingDetail
{
    CheckDetailPublishViewController *checkDetailPublishVC = [[CheckDetailPublishViewController alloc] init];
    [self.navigationController pushViewController:checkDetailPublishVC animated:YES];
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
