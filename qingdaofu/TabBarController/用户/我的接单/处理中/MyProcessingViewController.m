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
#import "AdditionMessagesViewController.h"  //查看更多
#import "PaceViewController.h" //进度

#import "RequestEndViewController.h"  //申请终止
#import "RequestCloseViewController.h" //申请结案
#import "AgreementViewController.h"   //居间协议
#import "AgreementViewController.h"  //居间协议
#import "SignProtocolViewController.h"  //签约协议

#import "BaseCommitView.h"
#import "BaseRemindButton.h"

#import "MineUserCell.h"
#import "OrderPublishCell.h"
#import "NewPublishDetailsCell.h"

//详细信息
#import "PublishingResponse.h"
#import "PublishingModel.h"
#import "UserNameModel.h"

//申请延期
#import "DelayResponse.h"
#import "DelayModel.h"

@interface MyProcessingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UIButton *proRightButton;
@property (nonatomic,strong) UITableView *myProcessingTableView;
@property (nonatomic,strong) BaseCommitView *processinCommitButton;
@property (nonatomic,strong) BaseRemindButton *processRemindButton;

//json
@property (nonatomic,strong) NSMutableArray *processArray;
@property (nonatomic,strong) NSArray *sectionArray;
//@property (nonatomic,strong) NSMutableArray *scheduleOrderProArray;
//@property (nonatomic,strong) NSMutableArray *delayArray;


//@property (nonatomic,strong) NSString *loanTypeString1;  //债权类型
//@property (nonatomic,strong) NSString *loanTypeString2;  //债权类型内容
//@property (nonatomic,strong) NSString *loanTypeImage;//债权类型图片

@end

@implementation MyProcessingViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self getDetailMessageOfProcessing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"产品详情";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.proRightButton];
    
    self.sectionArray = @[@"",@"",@""];
    
    [self.view addSubview:self.myProcessingTableView];
    [self.view addSubview:self.processinCommitButton];
    [self.view addSubview:self.processRemindButton];
    [self.processRemindButton setHidden:YES];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.myProcessingTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.myProcessingTableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.processinCommitButton];
        
        [self.processRemindButton autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.processRemindButton autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.processRemindButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.processinCommitButton];
        [self.processRemindButton autoSetDimension:ALDimensionHeight toSize:kRemindHeight];
        
        [self.processinCommitButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.processinCommitButton autoSetDimension:ALDimensionHeight toSize:kCellHeight4];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

#pragma mark - getter
- (UIButton *)proRightButton
{
    if (!_proRightButton) {
        _proRightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
        [_proRightButton setTitle:@"申请终止" forState:0];
        [_proRightButton setTitleColor:kWhiteColor forState:0];
        _proRightButton.titleLabel.font = kFirstFont;
        
        QDFWeakSelf;
        [_proRightButton addAction:^(UIButton *btn) {
            [weakself showHint:@"申请终止"];
        }];
    }
    return _proRightButton;
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
- (BaseCommitView *)processinCommitButton
{
    if (!_processinCommitButton) {
        _processinCommitButton = [BaseCommitView newAutoLayoutView];
        [_processinCommitButton.button setTitle:@"上传居间协议" forState:0];
        
        //上传居间协议，，上传签约协议，申请结案
        
        QDFWeakSelf;
        [_processinCommitButton addAction:^(UIButton *btn) {
            
            if (weakself.sectionArray.count == 3) {
                AgreementViewController *agreementVC = [[AgreementViewController alloc] init];
                agreementVC.navTitleString = @"居间协议";
                agreementVC.idString = weakself.idString;
                agreementVC.categoryString = weakself.categaryString;
                agreementVC.pidString = weakself.pidString;
                agreementVC.flagString = @"1";
                [weakself.navigationController pushViewController:agreementVC animated:YES];
                
            }else if (weakself.sectionArray.count == 4){//签约协议
                SignProtocolViewController *signProtocolVC = [[SignProtocolViewController alloc] init];
                [weakself.navigationController pushViewController:signProtocolVC animated:YES];
                
            }else if (weakself.sectionArray.count == 6){//申请结案
                RequestCloseViewController *requestCloseVC = [[RequestCloseViewController alloc] init];
                [weakself.navigationController pushViewController:requestCloseVC animated:YES];
            }
            
            
        }];
    }
    return _processinCommitButton;
}

- (BaseRemindButton *)processRemindButton
{
    if (!_processRemindButton) {
        _processRemindButton = [BaseRemindButton newAutoLayoutView];
    }
    return _processRemindButton;
}

- (NSMutableArray *)processArray
{
    if (!_processArray) {
        _processArray = [NSMutableArray array];
    }
    return _processArray;
}
//
//- (NSMutableArray *)scheduleOrderProArray
//{
//    if (!_scheduleOrderProArray) {
//        _scheduleOrderProArray = [NSMutableArray array];
//    }
//    return _scheduleOrderProArray;
//}

#pragma mark - 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.processArray.count > 0) {
        return self.sectionArray.count;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.processArray.count > 0) {
        if (section == 0) {
            return 2;
        }else if (section == 1){
            return 4;
        }
        return 1;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 72;
        }else{
            return kCellHeight3;
        }
    }else if (indexPath.section == 1){//112
        return kCellHeight;
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
        if (indexPath.row == 0) {//状态
            identifier = @"processing00";
            NewPublishDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[NewPublishDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = kBackColor;
            [cell.progress1 setText:@"申请中"];
            [cell.point2 setImage:[UIImage imageNamed:@"succee"] forState:0];
            [cell.progress2 setTextColor:kTextColor];
            [cell.line2 setBackgroundColor:kButtonColor];
            [cell.point3 setImage:[UIImage imageNamed:@"succee"] forState:0];
            [cell.progress3 setTextColor:kTextColor];
            [cell.line3 setBackgroundColor:kButtonColor];
            
            return cell;
        }else{//查看发布发
            identifier = @"processing01";
            
            OrderPublishCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!cell) {
                cell = [[OrderPublishCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UserNameModel *userNameModel = response.username;
            
            NSString *nameStr = [NSString getValidStringFromString:userNameModel.username toString:@"未认证"];
            NSString *checkStr = [NSString stringWithFormat:@"发布方：%@",nameStr];
            [cell.checkButton setTitle:checkStr forState:0];
            [cell.contactButton setTitle:@" 联系他" forState:0];
            [cell.contactButton setImage:[UIImage imageNamed:@"phone_blue"] forState:0];
            
            //接单方详情
            QDFWeakSelf;
            [cell.checkButton addAction:^(UIButton *btn) {
                if ([userNameModel.username isEqualToString:@""] || userNameModel.username == nil || !userNameModel.username) {
                    [self showHint:@"发布方未认证，不能查看相关信息"];
                }else{
                    CheckDetailPublishViewController *checkDetailPublishVC = [[CheckDetailPublishViewController alloc] init];
                    checkDetailPublishVC.typeString = @"发布方";
                    checkDetailPublishVC.idString = weakself.idString;
                    checkDetailPublishVC.categoryString = weakself.categaryString;
                    checkDetailPublishVC.pidString = weakself.pidString;
                    [weakself.navigationController pushViewController:checkDetailPublishVC animated:YES];
                }
            }];
            
            //电话
            [cell.contactButton addAction:^(UIButton *btn) {
                if ([userNameModel.username isEqualToString:@""] || userNameModel.username == nil || !userNameModel.username) {
                    [self showHint:@"发布方未认证，不能打电话"];
                }else{
                    NSMutableString *phoneStr = [NSMutableString stringWithFormat:@"telprompt://%@",userNameModel.mobile];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr]];
                }
            }];
            
            return cell;
        }
    }else if (indexPath.section == 1){//产品信息
        identifier = @"processing1";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSArray *textArr = @[@"产品详情",@"债权类型",@"委托费用",@"委托金额"];
        [cell.userNameButton setTitle:textArr[indexPath.row] forState:0];
        
        if (indexPath.row == 0) {
            [cell.userNameButton setTitleColor:kBlackColor forState:0];
            cell.userNameButton.titleLabel.font = kBigFont;
            
            [cell.userActionButton setTitleColor:kLightGrayColor forState:0];
            cell.userActionButton.titleLabel.font = kSecondFont;
            [cell.userActionButton setTitle:@"更多信息" forState:0];
            [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        }else if (indexPath.row == 1){
            [cell.userNameButton setTitleColor:kLightGrayColor forState:0];
            cell.userNameButton.titleLabel.font = kFirstFont;
            
            [cell.userActionButton setTitleColor:kGrayColor forState:0];
            cell.userActionButton.titleLabel.font = kBigFont;
            [cell.userActionButton setTitle:@"债权类型" forState:0];
            [cell.userActionButton setImage:[UIImage imageNamed:@""] forState:0];
        }else if (indexPath.row == 2){
            [cell.userNameButton setTitleColor:kLightGrayColor forState:0];
            cell.userNameButton.titleLabel.font = kFirstFont;
            
            [cell.userActionButton setTitleColor:kGrayColor forState:0];
            cell.userActionButton.titleLabel.font = kBigFont;
            [cell.userActionButton setTitle:@"委托费用" forState:0];
            [cell.userActionButton setImage:[UIImage imageNamed:@""] forState:0];
        }else if (indexPath.row == 3){
            [cell.userNameButton setTitleColor:kLightGrayColor forState:0];
            cell.userNameButton.titleLabel.font = kFirstFont;
            
            [cell.userActionButton setTitleColor:kGrayColor forState:0];
            cell.userActionButton.titleLabel.font = kBigFont;
            [cell.userActionButton setTitle:@"委托金额" forState:0];
            [cell.userActionButton setImage:[UIImage imageNamed:@""] forState:0];
        }
        
        return cell;
        
    }else if(indexPath.section == self.sectionArray.count -1){//详情
        if (indexPath.row == 0) {
            identifier = @"processing20";
            MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!cell) {
                cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell.userNameButton setTitle:@"尽职调查" forState:0];
            
            if (self.sectionArray.count == 6) {
                [cell.userActionButton setHidden:NO];
                cell.userActionButton.userInteractionEnabled = YES;
                [cell.userActionButton setTitle:@"  添加进度  " forState:0];
                [cell.userActionButton setTitleColor:kTextColor forState:0];
                cell.userActionButton.layer.borderWidth = kLineWidth;
                cell.userActionButton.layer.borderColor = kButtonColor.CGColor;
                [cell.userActionButton setContentHorizontalAlignment:0];
                QDFWeakSelf;
                [cell.userActionButton addAction:^(UIButton *btn) {
                    [weakself showHint:@"添加进度"];
                    PaceViewController *paceVC = [[PaceViewController alloc] init];
                    paceVC.idString = weakself.idString;
                    paceVC.categoryString = self.categaryString;
                    paceVC.existence = @"2";
                    [weakself.navigationController pushViewController:paceVC animated:YES];
                }];
                
            }else{
                [cell.userActionButton setHidden:YES];
            }
            
            return cell;
        }
    }else if (indexPath.section == 2){//居间协议
        identifier = @"processing222";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.userNameButton setTitle:@"居间协议" forState:0];
        [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        [cell.userActionButton setTitle:@"查看" forState:0];
        
        return cell;
    }else if (indexPath.section == 3){//签约协议
        identifier = @"processing333";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.userNameButton setTitle:@"签约协议" forState:0];
        [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        [cell.userActionButton setTitle:@"查看" forState:0];
        
        return cell;
    }else if (indexPath.section == 4){//经办人
        identifier = @"processing444";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.userNameButton setTitle:@"经办人" forState:0];
        [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        [cell.userActionButton setTitle:@"添加" forState:0];
        
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
    if (indexPath.section == 1 && indexPath.row == 0) {
        [self showHint:@"查看更多"];
    }else{
        if (self.sectionArray.count == 4) {
            if (indexPath.section == 2) {
                //居间协议
                [self showHint:@"居间协议"];
                AgreementViewController *agreementVc = [[AgreementViewController alloc] init];
                agreementVc.idString = self.idString;
                agreementVc.categoryString = self.categaryString;
                agreementVc.pidString = self.pidString;
                agreementVc.navTitleString = @"居间协议";
                agreementVc.flagString = @"0";
                [self.navigationController pushViewController:agreementVc animated:YES];
            }
        }else if (self.sectionArray.count == 6){
            if (indexPath.section == 2) {//居间协议
                [self showHint:@"居间协议"];
                AgreementViewController *agreementVc = [[AgreementViewController alloc] init];
                agreementVc.idString = self.idString;
                agreementVc.categoryString = self.categaryString;
                agreementVc.pidString = self.pidString;
                agreementVc.navTitleString = @"居间协议";
                agreementVc.flagString = @"0";
                [self.navigationController pushViewController:agreementVc animated:YES];
            }else if (indexPath.section == 3){//签约协议
                [self showHint:@"签约协议"];
                SignProtocolViewController *signProtocolVC = [[SignProtocolViewController alloc] init];
                [self.navigationController pushViewController:signProtocolVC animated:YES];
            }else if (indexPath.section == 4){//经办人
                [self showHint:@"经办人协议"];
            }
        }
    }
    /*
    if (indexPath.section == 2 && indexPath.row == 0) {
        AdditionMessagesViewController *additionMessageVC = [[AdditionMessagesViewController alloc] init];
        additionMessageVC.idString = self.idString;
        additionMessageVC.categoryString = self.categaryString;
        [self.navigationController pushViewController:additionMessageVC animated:YES];
    }else if (indexPath.section == 3) {//协议
        AgreementViewController *agreementVc = [[AgreementViewController alloc] init];
        agreementVc.idString = self.idString;
        agreementVc.categoryString = self.categaryString;
        [self.navigationController pushViewController:agreementVc animated:YES];
    }else if (indexPath.section == 4) {
        PaceViewController *paceVC = [[PaceViewController alloc] init];
        paceVC.idString = self.idString;
        paceVC.categoryString = self.categaryString;
        paceVC.existence = @"2";
        [self.navigationController pushViewController:paceVC animated:YES];
    }
     */
}

#pragma mark - method
- (void)getDetailMessageOfProcessing
{
    NSString *detailString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyReleaseDetailString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"id" : self.idString,
                             @"category" : self.categaryString
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:detailString params:params successBlock:^(id responseObject){
                
        PublishingResponse *response = [PublishingResponse objectWithKeyValues:responseObject];
        [weakself.processArray addObject:response];
        [weakself.myProcessingTableView reloadData];
        
        //根据上传协议的状态，调整section数目
        weakself.sectionArray = @[@"",@"",@"",@"",@"",@""];
        if (weakself.sectionArray.count == 3) {
            [weakself.processinCommitButton.button setTitle:@"签订居间协议" forState:0];
        }else if (weakself.sectionArray.count == 4){
            [weakself.processinCommitButton.button setTitle:@"上传签约协议" forState:0];
        }else if (weakself.sectionArray.count == 6){
            [weakself.processinCommitButton.button setTitle:@"申请结案" forState:0];
        }
        
        if ([response.product.progress_status integerValue] == 2 && ![response.uidString isEqualToString:response.product.uidInner]) {
            if ([response.product.applyclose integerValue] == 0) {
                [weakself.processinCommitButton setBackgroundColor:kNavColor];
                [weakself.processinCommitButton setTitleColor:kBlackColor forState:0];
                [weakself.processinCommitButton setImage:[UIImage imageNamed:@"end"] forState:0];
                [weakself.processinCommitButton setTitle:@" 申请结案" forState:0];
                [weakself.processinCommitButton addTarget:self action:@selector(endProduct) forControlEvents:UIControlEventTouchUpInside];
                
                //延期申请状态
                [weakself delayRequest];
                
            }else if ([response.product.applyclose integerValue] == 4 && [response.product.applyclosefrom isEqualToString:response.product.uidInner]){
                [weakself.processinCommitButton setBackgroundColor:kBlueColor];
                [weakself.processinCommitButton setTitle:@"同意结案" forState:0];
                [weakself.processinCommitButton addTarget:self action:@selector(endProduct) forControlEvents:UIControlEventTouchUpInside];
            }else{
                [weakself.processinCommitButton setTitle:@"已申请结案，等待对方确认中" forState:0];
                [weakself.processinCommitButton setBackgroundColor:kBorderColor];
            }
        }
        
        [weakself.myProcessingTableView reloadData];
        
    } andFailBlock:^(NSError *error){
        
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
        
        DelayModel *delayModel = response.delay;
        PublishingModel *puModel = response.product;
        
        if (delayModel.is_agree == nil || [delayModel.is_agree isEqualToString:@""]) {
            if (![puModel.applyclose isEqualToString:@"4"]) {
                if ([delayModel.delays integerValue] <= 7 && [delayModel.delays integerValue] > 0) {
                    [weakself.processRemindButton setHidden:NO];
                    NSString *delayS = [NSString stringWithFormat:@"还有%@天就要到达约定结案日期，点击申请延期 ",delayModel.delays];
                    [weakself.processRemindButton setTitle:delayS forState:0];
                    [weakself.processRemindButton setImage:[UIImage imageNamed:@"more_white"] forState:0];
                    [weakself.processRemindButton addAction:^(UIButton *btn) {
                        DelayRequestsViewController *delayRequetsVC = [[DelayRequestsViewController alloc] init];
                        delayRequetsVC.idString = weakself.idString;
                        delayRequetsVC.categoryString = weakself.categaryString;
                        [weakself.navigationController pushViewController:delayRequetsVC animated:YES];
                    }];
                }
            }else{
                NSLog(@"结案申请中，不能申请延期");
                [weakself.processRemindButton setHidden:YES];
            }
        }else{
            //已申请：0申请中,1同意，2拒绝，3作废，
            if ([delayModel.is_agree integerValue] == 0) {
                [weakself.processRemindButton setHidden:NO];
                [weakself.processRemindButton setTitle:@"延期申请中，请等待  " forState:0];
                [weakself.processRemindButton setImage:[UIImage imageNamed:@"closed"] forState:0];
            }else if ([delayModel.is_agree integerValue] == 1){
                [weakself.processRemindButton setHidden:NO];
                [weakself.processRemindButton setTitle:@"对方已同意延期  " forState:0];
                [weakself.processRemindButton setImage:[UIImage imageNamed:@"closed"] forState:0];
            }else if ([delayModel.is_agree integerValue] == 2){
                [weakself.processRemindButton setHidden:NO];
                [weakself.processRemindButton setTitle:@"对方已拒绝延期，请抓紧处理  " forState:0];
                [weakself.processRemindButton setImage:[UIImage imageNamed:@"closed"] forState:0];
            }else if ([delayModel.is_agree integerValue] == 3){
                [weakself.processRemindButton setHidden:NO];
                [weakself.processRemindButton setTitle:@"延期申请失败，请抓紧处理  " forState:0];
                [weakself.processRemindButton setImage:[UIImage imageNamed:@"closed"] forState:0];
            }
            
            [weakself.processRemindButton addAction:^(UIButton *btn) {
                [btn setHidden:YES];
            }];
            
        }
        
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
            [weakself.navigationController popViewControllerAnimated:YES];        }
        
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
