//
//  MyClosingViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/4.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MyClosingViewController.h"

#import "UIButton+WebCache.h"


#import "CheckDetailPublishViewController.h"  //查看发布方
#import "AdditionalEvaluateViewController.h"  //追加评价
#import "AdditionMessagesViewController.h"     //补充信息
#import "PaceViewController.h"   //进度
#import "AgreementViewController.h"
#import "EvaluateListsViewController.h"  //查看评价

#import "MineUserCell.h"
#import "OrderPublishCell.h"

#import "EvaTopSwitchView.h"

#import "PublishingResponse.h"
#import "PublishingModel.h"
#import "UserNameModel.h"

//查看进度
#import "ScheduleResponse.h"
#import "ScheduleModel.h"

//评价
#import "EvaluateResponse.h"
#import "LaunchEvaluateModel.h"

@interface MyClosingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *myClosingTableView;
@property (nonatomic,strong) EvaTopSwitchView *closingSwitchButton;

@property (nonatomic,assign) BOOL refresh;

//json解析
@property (nonatomic,strong) NSMutableArray *orderCloseArray; //详情response
@property (nonatomic,strong) NSMutableArray *scheduleOrderCloArray;//进度model

@property (nonatomic,strong) NSMutableArray *evaluateResponseArray; //评价response
@property (nonatomic,strong) NSMutableArray *evaluateArray; //评价model

@property (nonatomic,strong) NSString *loanTypeString1;  //债权类型
@property (nonatomic,strong) NSString *loanTypeString2;  //债权类型内容
@property (nonatomic,strong) NSString *loanTypeImage;//债权类型图片

@end

@implementation MyClosingViewController

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOrderEvaluateDetails) name:@"evaluate" object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"evaluate" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"产品详情";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.myClosingTableView];
    [self.view addSubview:self.closingSwitchButton];
    [self.view setNeedsUpdateConstraints];
    
    [self getDetailMessageOfClosing];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.myClosingTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.myClosingTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kTabBarHeight];
        
        [self.closingSwitchButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.closingSwitchButton autoSetDimension:ALDimensionHeight toSize:kTabBarHeight];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

#pragma mark - setter and getter
- (UITableView *)myClosingTableView
{
    if (!_myClosingTableView) {
        _myClosingTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _myClosingTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _myClosingTableView.delegate = self;
        _myClosingTableView.dataSource = self;
        _myClosingTableView.separatorColor = kSeparateColor;
        _myClosingTableView.backgroundColor = kBackColor;
    }
    return _myClosingTableView;
}

- (EvaTopSwitchView *)closingSwitchButton
{
    if (!_closingSwitchButton) {
        _closingSwitchButton = [EvaTopSwitchView newAutoLayoutView];
        _closingSwitchButton.layer.borderWidth = kLineWidth;
        _closingSwitchButton.layer.borderColor = kBorderColor.CGColor;
        _closingSwitchButton.backgroundColor = kNavColor;
        [_closingSwitchButton.blueLabel setHidden:YES];
        
        [_closingSwitchButton.getbutton setTitleColor:kBlackColor forState:0];
        [_closingSwitchButton.getbutton setTitle:@" 删除产品" forState:0];
        [_closingSwitchButton.getbutton setImage:[UIImage imageNamed:@"delete"] forState:0];
        [_closingSwitchButton.getbutton addTarget:self action:@selector(deleteTheProducOfOrderCloseing) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closingSwitchButton;
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

- (NSMutableArray *)evaluateResponseArray
{
    if (!_evaluateResponseArray) {
        _evaluateResponseArray = [NSMutableArray array];
    }
    return _evaluateResponseArray;
}

- (NSMutableArray *)evaluateArray
{
    if (!_evaluateArray) {
        _evaluateArray = [NSMutableArray array];
    }
    return _evaluateArray;
}

#pragma mark - delegate
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
        if (section == 2) {
            PublishingResponse *response = self.orderCloseArray[0];
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
    PublishingResponse *responde;
    PublishingModel *closeModel;
    if (self.orderCloseArray.count > 0) {
        responde = self.orderCloseArray[0];
        closeModel = responde.product;
    }
    
    static NSString *identifier;
    
    if (indexPath.section == 0) {
        identifier = @"closing0";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = UIColorFromRGB(0x42566d);
        
        NSString *nameStrss;
        if ([closeModel.category integerValue] == 2) {
            nameStrss = @"清收";
        }else if ([closeModel.category integerValue] == 3){
            nameStrss = @"诉讼";
        }
        NSString *nameStr = [NSString stringWithFormat:@"%@%@",nameStrss,closeModel.codeString];
        [cell.userNameButton setTitle:nameStr forState:0];
        [cell.userNameButton setTitleColor:kLightWhiteColor forState:0];
        cell.userNameButton.titleLabel.font = kFourFont;
        [cell.userActionButton setTitle:@"已结案" forState:0];
        [cell.userActionButton setTitleColor:kNavColor forState:0];
        cell.userActionButton.titleLabel.font = kFirstFont;
        
        return cell;
        
    }else if (indexPath.section == 1){//联系发布方
        identifier = @"closing1";
        OrderPublishCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[OrderPublishCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UserNameModel *userNameModel = responde.username;
        
        NSString *nameStr = [NSString getValidStringFromString:userNameModel.username toString:@"未认证"];
        NSString *checkStr = [NSString stringWithFormat:@"发布方：%@",nameStr];
        [cell.checkButton setTitle:checkStr forState:0];
        [cell.contactButton setTitle:@" 联系他" forState:0];
        [cell.contactButton setImage:[UIImage imageNamed:@"phone_blue"] forState:0];
        
        //接单方详情
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
            identifier = @"closing20";
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
        identifier = @"closing21";
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
        NSString *rowString11 = [NSString stringWithFormat:@"%@万",closeModel.money];//具体借款本金
        NSString *rowString2 = @"费用类型";
        NSString *rowString3;//具体费用类型
        NSString *rowString33;//费用
        if ([closeModel.category integerValue] == 2) {
            if ([closeModel.agencycommissiontype integerValue] == 1) {
                rowString3 = @"服务佣金";
                rowString33 = [NSString stringWithFormat:@"%@%@",closeModel.agencycommission,@"%"];
            }else{
                rowString3 = @"固定费用";
                rowString33 = [NSString stringWithFormat:@"%@万",closeModel.agencycommission];
            }
        }else if ([closeModel.category integerValue] == 3){
            if ([closeModel.agencycommissiontype integerValue] == 1) {
                rowString3 = @"固定费用";
                rowString33 = [NSString stringWithFormat:@"%@万",closeModel.agencycommission];
            }else{
                rowString3 = @"代理费率";
                rowString33 = [NSString stringWithFormat:@"%@%@",closeModel.agencycommission,@"%"];
            }
        }
        
        NSString *rowString4 = @"债权类型";
        NSString *rowString44; //具体债权类型
        NSString *rowString5;
        NSString *rowString55;
        if ([closeModel.loan_type integerValue] == 1) {
            rowString44 = @"房产抵押";
            rowString5 = @"抵押物地址";
            rowString55 = closeModel.seatmortgage;
        }else if ([closeModel.loan_type integerValue] == 2) {
            rowString44 = @"应收帐款";
            rowString5 = @"应收帐款";
            rowString55 = [NSString stringWithFormat:@"%@万",closeModel.accountr];;
        }else if ([closeModel.loan_type integerValue] == 3) {
            rowString44 = @"机动车抵押";
            rowString5 = @"机动车抵押";
            rowString55 = responde.car;
        }else if ([closeModel.loan_type integerValue] == 4) {
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
        identifier = @"closing3";
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
        
    }else if(indexPath.section == 4){//处理进度
        identifier = @"closing4";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.userNameButton.userInteractionEnabled = NO;
        cell.userActionButton.userInteractionEnabled = NO;
        
        [cell.userNameButton setTitle:@"处理进度" forState:0];
        [cell.userActionButton setTitle:@"点击查看  " forState:0];
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
    }else if (indexPath.section == 3) {//服务协议
        AgreementViewController *agreementVC = [[AgreementViewController alloc] init];
        agreementVC.idString = self.idString;
        agreementVC.categoryString = self.categaryString;
        [self.navigationController pushViewController:agreementVC animated:YES];
    }else if (indexPath.section == 4) {//处理进度
        PaceViewController *paceVC = [[PaceViewController alloc] init];
        paceVC.idString = self.idString;
        paceVC.categoryString = self.categaryString;
        [self.navigationController pushViewController:paceVC animated:YES];
    }
}

#pragma mark - method
//详情
- (void)getDetailMessageOfClosing
{
    NSString *detailString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyReleaseDetailString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"id" : self.idString,
                             @"category" : self.categaryString
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:detailString params:params successBlock:^(id responseObject){
        
        PublishingResponse *response = [PublishingResponse objectWithKeyValues:responseObject];
        [weakself.orderCloseArray addObject:response];
        [weakself.myClosingTableView reloadData];
        
         [weakself getOrderEvaluateDetails];
        
    } andFailBlock:^(NSError *error){
        
    }];
}

////进度
//- (void)lookUpSchedule
//{
//    NSString *schedule = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kLookUpScheduleString];
//    NSDictionary *params = @{@"token" : [self getValidateToken],
//                             @"id" : self.idString,
//                             @"category" : self.categaryString
//                             };
//    QDFWeakSelf;
//    [self requestDataPostWithString:schedule params:params successBlock:^(id responseObject) {
//        ScheduleResponse *scheduleResponse = [ScheduleResponse objectWithKeyValues:responseObject];
//        
//        for (ScheduleModel *scheduleModel in scheduleResponse.disposing) {
//            [weakself.scheduleOrderCloArray addObject:scheduleModel];
//        }
//        [weakself.myClosingTableView reloadData];
//        [weakself getOrderEvaluateDetails];
//    } andFailBlock:^(NSError *error) {
//        
//    }];
//}

//评价
- (void)getOrderEvaluateDetails
{
    NSString *evaluateString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyEvaluateString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"id" : self.idString,
                             @"category" : self.categaryString,
                             @"page" : @"0"
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:evaluateString params:params successBlock:^(id responseObject) {
        
        [weakself.evaluateResponseArray removeAllObjects];
        [weakself.evaluateArray removeAllObjects];
        
        EvaluateResponse *response = [EvaluateResponse objectWithKeyValues:responseObject];
        [weakself.evaluateResponseArray addObject:response];
        
        for (LaunchEvaluateModel *launchModel in response.launchevaluation) {
            [weakself.evaluateArray addObject:launchModel];
        }
        
        if ([response.evalua integerValue] == 0) {//未评价过
            [weakself.closingSwitchButton.sendButton setTitle:@" 评价发布方" forState:0];
            [weakself.closingSwitchButton.sendButton setImage:[UIImage imageNamed:@"evaluate"] forState:0];
            
            [weakself.closingSwitchButton.sendButton addAction:^(UIButton *btn) {
                AdditionalEvaluateViewController *additionalEvaluateVC = [[AdditionalEvaluateViewController alloc] init];
                additionalEvaluateVC.typeString = @"接单方";
                additionalEvaluateVC.evaString = response.evalua;
                additionalEvaluateVC.idString = weakself.idString;
                additionalEvaluateVC.categoryString = weakself.categaryString;
        
                UINavigationController *nass = [[UINavigationController alloc] initWithRootViewController:additionalEvaluateVC];
                [self presentViewController:nass animated:YES completion:nil];
            }];
            
        }else{
            [weakself.closingSwitchButton.sendButton setTitle:@" 查看评价" forState:0];
            [weakself.closingSwitchButton.sendButton setImage:[UIImage imageNamed:@"look"] forState:0];
            
            [weakself.closingSwitchButton.sendButton addAction:^(UIButton *btn) {
                EvaluateListsViewController *evaluateListVC = [[EvaluateListsViewController alloc] init];
                evaluateListVC.idString = weakself.idString;
                evaluateListVC.categoryString = weakself.categaryString;
                evaluateListVC.typeString = @"接单方";
//                allEvaluationVC.evaTypeString = @"launchevaluation";
                [weakself.navigationController pushViewController:evaluateListVC animated:YES];
            }];
        }

        [weakself.myClosingTableView reloadData];
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)deleteTheProducOfOrderCloseing
{
    NSString *deletePubString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kDeleteProductOfMyReleaseString];
    NSDictionary *params = @{@"id" : self.idString,
                             @"category" : self.categaryString,
                             @"token" : [self getValidateToken]
                             };
    
    QDFWeakSelf;
    [self requestDataPostWithString:deletePubString params:params successBlock:^(id responseObject) {
        
        BaseModel *baModel = [BaseModel objectWithKeyValues:responseObject];
        [weakself showHint:baModel.msg];
        if ([baModel.code isEqualToString:@"0000"]) {
            [weakself.navigationController popViewControllerAnimated:YES];
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
