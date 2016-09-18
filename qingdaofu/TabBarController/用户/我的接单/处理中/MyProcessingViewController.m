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
#import "AgreementViewController.h"   //服务协议
#import "PaceViewController.h" //进度

#import "BaseCommitButton.h"
#import "BaseRemindButton.h"

#import "MineUserCell.h"
#import "OrderPublishCell.h"

//详细信息
#import "PublishingResponse.h"
#import "PublishingModel.h"
#import "UserNameModel.h"

//申请延期
#import "DelayResponse.h"
#import "DelayModel.h"

@interface MyProcessingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *myProcessingTableView;
@property (nonatomic,strong) BaseCommitButton *processinCommitButton;
@property (nonatomic,strong) BaseRemindButton *processRemindButton;

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
    [self getDetailMessageOfProcessing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"产品详情";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
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
        _processinCommitButton.layer.borderColor = kBorderColor.CGColor;
        _processinCommitButton.layer.borderWidth = kLineWidth;
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
        if (section == 2) {
            PublishingResponse *response = self.processArray[0];
            if ([response.product.loan_type isEqualToString:@"4"]) {
                return 5;
            }
            return 6;
        }
        return 1;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 40;
    }else if (indexPath.section == 1){//112
        return 56;
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
        
        NSString *nameStrss;
        if ([processModel.category integerValue] == 2) {
            nameStrss = @"清收";
        }else if ([processModel.category integerValue] == 3){
            nameStrss = @"诉讼";
        }
        NSString *nameStr = [NSString stringWithFormat:@"%@%@",nameStrss,processModel.codeString];
        NSString *timeStr = [NSString stringWithFormat:@" (截止%@)",self.deadLine];
        NSString *allStr = [NSString stringWithFormat:@"%@%@",nameStr,timeStr];
        NSMutableAttributedString *allAttribute = [[NSMutableAttributedString alloc] initWithString:allStr];
        [allAttribute setAttributes:@{NSFontAttributeName:kFourFont,NSForegroundColorAttributeName:kLightWhiteColor} range:NSMakeRange(0, nameStr.length)];
        [allAttribute setAttributes:@{NSFontAttributeName:kTabBarFont,NSForegroundColorAttributeName:kLightWhiteColor} range:NSMakeRange(nameStr.length, timeStr.length)];
        [cell.userNameButton setAttributedTitle:allAttribute forState:0];
        
        [cell.userActionButton setTitle:@"处理中" forState:0];
        [cell.userActionButton setTitleColor:kNavColor forState:0];
        cell.userActionButton.titleLabel.font = kBigFont;
        
        return cell;
        
    }else if (indexPath.section == 1){//联系发布方
        identifier = @"processing1";
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
        
    }else if(indexPath.section == 2){//详情
        if (indexPath.row == 0) {
            identifier = @"processing20";
            MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!cell) {
                cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.userNameButton.userInteractionEnabled = NO;
            cell.userActionButton.userInteractionEnabled = NO;
            
            [cell.userNameButton setTitle:@"产品信息" forState:0];
            [cell.userActionButton setTitle:@"查看全部  " forState:0];
            [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
            
            return cell;
        }
        //详情
        identifier = @"processing21";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.userNameButton setTitleColor:kLightGrayColor forState:0];
        cell.userNameButton.titleLabel.font = kFirstFont;
        [cell.userActionButton setTitleColor:kGrayColor forState:0];
        cell.userActionButton.titleLabel.font = kFirstFont;
        
        NSString *rowString1 = @"借款本金";
        NSString *rowString11 = [NSString stringWithFormat:@"%@万",processModel.money];//具体借款本金
        NSString *rowString2 = @"费用类型";
        NSString *rowString3;//具体费用类型
        NSString *rowString33;//费用
        if ([processModel.category integerValue] == 2) {
            if ([processModel.agencycommissiontype integerValue] == 1) {
                rowString3 = @"服务佣金";
                rowString33 = [NSString stringWithFormat:@"%@%@",processModel.agencycommission,@"%"];
            }else{
                rowString3 = @"固定费用";
                rowString33 = [NSString stringWithFormat:@"%@万",processModel.agencycommission];
            }
        }else if ([processModel.category integerValue] == 3){
            if ([processModel.agencycommissiontype integerValue] == 1) {
                rowString3 = @"固定费用";
                rowString33 = [NSString stringWithFormat:@"%@万",processModel.agencycommission];
            }else{
                rowString3 = @"代理费率";
                rowString33 = [NSString stringWithFormat:@"%@%@",processModel.agencycommission,@"%"];
            }
        }
        
        NSString *rowString4 = @"债权类型";
        NSString *rowString44; //具体债权类型
        NSString *rowString5;
        NSString *rowString55;
        if ([processModel.loan_type integerValue] == 1) {
            rowString44 = @"房产抵押";
            rowString5 = @"抵押物地址";
            rowString55 = processModel.seatmortgage;
        }else if ([processModel.loan_type integerValue] == 2) {
            rowString44 = @"应收帐款";
            rowString5 = @"应收帐款";
            rowString55 = [NSString stringWithFormat:@"%@万",processModel.accountr];
        }else if ([processModel.loan_type integerValue] == 3) {
            rowString44 = @"机动车抵押";
            rowString5 = @"机动车抵押";
            rowString55 = response.car;
        }else if ([processModel.loan_type integerValue] == 4) {
            rowString44 = @"无抵押";
            rowString5 = @"1";
            rowString55 = @"1";
        }
        
        NSArray *rowLeftArray = @[rowString1,rowString2,rowString3,rowString4,rowString5];
        NSArray *rowRightArray = @[rowString11,rowString3,rowString33,rowString44,rowString55];
        
        [cell.userNameButton setTitle:rowLeftArray[indexPath.row-1] forState:0];
        [cell.userActionButton setTitle:rowRightArray[indexPath.row-1] forState:0];
        
        return cell;
    }else if (indexPath.section == 3){//服务协议
        identifier = @"processing3";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.userNameButton.userInteractionEnabled = NO;
        cell.userActionButton.userInteractionEnabled = NO;
        
        [cell.userNameButton setTitle:@"服务协议" forState:0];
        [cell.userActionButton setTitle:@"点击查看  " forState:0];
        [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        
        return cell;
        
    }else{//处理进度
        identifier = @"processing4";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.userNameButton.userInteractionEnabled = NO;
        cell.userActionButton.userInteractionEnabled = NO;
        
        [cell.userNameButton setTitle:@"处理进度" forState:0];
        [cell.userActionButton setTitle:@"填写进度  " forState:0];
        [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        
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
