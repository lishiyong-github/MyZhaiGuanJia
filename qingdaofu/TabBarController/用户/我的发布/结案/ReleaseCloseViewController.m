//
//  ReleaseCloseViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/31.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ReleaseCloseViewController.h"

#import "UIImageView+WebCache.h"

#import "CheckDetailPublishViewController.h"  //查看发布方
#import "AdditionalEvaluateViewController.h"  //追加评价
#import "AdditionMessagesViewController.h"     //补充信息
#import "AgreementViewController.h"            //服务协议
#import "PaceViewController.h"
#import "EvaluateListsViewController.h" //查看评价

#import "MineUserCell.h"
#import "OrderPublishCell.h"
#import "EvaTopSwitchView.h"


#import "UIButton+WebCache.h"

//详细信息
#import "PublishingResponse.h"
#import "PublishingModel.h"
#import "UserNameModel.h"

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
@property (nonatomic,strong) EvaTopSwitchView *releaseCloseSwitchButton;


@property (nonatomic,strong) NSMutableArray *releaseArray;
@property (nonatomic,strong) NSMutableArray *scheduleReleaseCloArray;
@property (nonatomic,strong) NSMutableArray *evaluateResponseArray;
@property (nonatomic,strong) NSMutableArray *evaluateArray;

@property (nonatomic,strong) NSString *loanTypeString1;  //债权类型
@property (nonatomic,strong) NSString *loanTypeString2;  //债权类型内容
@property (nonatomic,strong) NSString *loanTypeImage;//债权类型图片

@end

@implementation ReleaseCloseViewController
- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getEvaluateDetails) name:@"evaluate" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"产品详情";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.ReleaseCloseTableView];
    [self.view addSubview:self.releaseCloseSwitchButton];
    
    [self.view setNeedsUpdateConstraints];
    
    [self getCloseMessages];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.ReleaseCloseTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.ReleaseCloseTableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.releaseCloseSwitchButton];
        
        [self.releaseCloseSwitchButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.releaseCloseSwitchButton autoSetDimension:ALDimensionHeight toSize:kTabBarHeight];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

#pragma mark - setter and getter
- (UITableView *)ReleaseCloseTableView
{
    if (!_ReleaseCloseTableView) {
        _ReleaseCloseTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _ReleaseCloseTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _ReleaseCloseTableView.delegate = self;
        _ReleaseCloseTableView.dataSource = self;
        _ReleaseCloseTableView.separatorColor = kSeparateColor;
        _ReleaseCloseTableView.backgroundColor = kBackColor;
    }
    return _ReleaseCloseTableView;
}

- (EvaTopSwitchView *)releaseCloseSwitchButton
{
    if (!_releaseCloseSwitchButton) {
        _releaseCloseSwitchButton = [EvaTopSwitchView newAutoLayoutView];
        _releaseCloseSwitchButton.layer.borderWidth = kLineWidth;
        _releaseCloseSwitchButton.layer.borderColor = kBorderColor.CGColor;
        _releaseCloseSwitchButton.backgroundColor = kNavColor;
        [_releaseCloseSwitchButton.blueLabel setHidden:YES];
        
        [_releaseCloseSwitchButton.getbutton setTitleColor:kBlackColor forState:0];
        [_releaseCloseSwitchButton.getbutton setTitle:@" 删除产品" forState:0];
        [_releaseCloseSwitchButton.getbutton setImage:[UIImage imageNamed:@"delete"] forState:0];
        [_releaseCloseSwitchButton.getbutton addTarget:self action:@selector(deleteTheProducOfReleaseClose) forControlEvents:UIControlEventTouchUpInside];
    }
    return _releaseCloseSwitchButton;
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
        if (section == 2) {
            PublishingResponse *response = self.releaseArray[0];
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
    
    PublishingResponse *releaseResponse;
    PublishingModel *releaseModel;
    if (self.releaseArray.count > 0) {
      releaseResponse = self.releaseArray[0];
      releaseModel = releaseResponse.product;
    }
    
    static NSString *identifier;
    
    if (indexPath.section == 0) {
        identifier = @"releaseing0";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = UIColorFromRGB(0x42566d);
        
        NSString *nameStrss;
        if ([releaseModel.category integerValue] == 2) {
            nameStrss = @"清收";
        }else if ([releaseModel.category integerValue] == 3){
            nameStrss = @"诉讼";
        }
        NSString *nameStr = [NSString stringWithFormat:@"%@%@",nameStrss,releaseModel.codeString];
        [cell.userNameButton setTitle:nameStr forState:0];
        [cell.userNameButton setTitleColor:kLightWhiteColor forState:0];
        cell.userNameButton.titleLabel.font = kFourFont;
        [cell.userActionButton setTitle:@"已结案" forState:0];
        [cell.userActionButton setTitleColor:kNavColor forState:0];
        cell.userActionButton.titleLabel.font = kFirstFont;
        
        return cell;
        
    }else if (indexPath.section == 1){//联系发布方
        identifier = @"releaseing1";
        OrderPublishCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[OrderPublishCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UserNameModel *userNameModel = releaseResponse.username;
        
        NSString *nameStr = [NSString getValidStringFromString:userNameModel.jusername toString:@"未认证"];
        NSString *checkStr = [NSString stringWithFormat:@"接单方：%@",nameStr];
        [cell.checkButton setTitle:checkStr forState:0];
        [cell.contactButton setTitle:@" 联系他" forState:0];
        [cell.contactButton setImage:[UIImage imageNamed:@"phone_blue"] forState:0];
        
        //接单方详情
        //接单方详情
        QDFWeakSelf;
        [cell.checkButton addAction:^(UIButton *btn) {
            if ([userNameModel.jusername isEqualToString:@""] || userNameModel.jusername == nil || !userNameModel.jusername) {
                [weakself showHint:@"发布方未认证，不能查看相关信息"];
            }else{
                CheckDetailPublishViewController *checkDetailPublishVC = [[CheckDetailPublishViewController alloc] init];
                checkDetailPublishVC.idString = weakself.idString;
                checkDetailPublishVC.categoryString = weakself.categaryString;
                checkDetailPublishVC.pidString = weakself.pidString;
                checkDetailPublishVC.typeString = @"接单方";
                [weakself.navigationController pushViewController:checkDetailPublishVC animated:YES];
            }
        }];
        
        //电话
        [cell.contactButton addAction:^(UIButton *btn) {
            if ([userNameModel.jusername isEqualToString:@""] || userNameModel.jusername == nil || !userNameModel.jusername) {
                [self showHint:@"接单方未认证，不能打电话"];
            }else{
                NSMutableString *phoneStr = [NSMutableString stringWithFormat:@"telprompt://%@",userNameModel.jmobile];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr]];
            }
        }];
        
        return cell;
        
    }else if(indexPath.section == 2){//详情
        if (indexPath.row == 0) {
            identifier = @"releaseing20";
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
        identifier = @"releaseing21";
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
        NSString *rowString11 = [NSString stringWithFormat:@"%@万",releaseModel.money];//具体借款本金
        NSString *rowString2 = @"费用类型";
        NSString *rowString3;//具体费用类型
        NSString *rowString33;//费用
        if ([releaseModel.category integerValue] == 2) {
            if ([releaseModel.agencycommissiontype integerValue] == 1) {
                rowString3 = @"服务佣金";
                rowString33 = [NSString stringWithFormat:@"%@%@",releaseModel.agencycommission,@"%"];
            }else{
                rowString3 = @"固定费用";
                rowString33 = [NSString stringWithFormat:@"%@万",releaseModel.agencycommission];
            }
        }else if ([releaseModel.category integerValue] == 3){
            if ([releaseModel.agencycommissiontype integerValue] == 1) {
                rowString3 = @"固定费用";
                rowString33 = [NSString stringWithFormat:@"%@万",releaseModel.agencycommission];
            }else{
                rowString3 = @"代理费率";
                rowString33 = [NSString stringWithFormat:@"%@%@",releaseModel.agencycommission,@"%"];
            }
        }
        
        NSString *rowString4 = @"债权类型";
        NSString *rowString44; //具体债权类型
        NSString *rowString5;
        NSString *rowString55;
        if ([releaseModel.loan_type integerValue] == 1) {
            rowString44 = @"房产抵押";
            rowString5 = @"抵押物地址";
            rowString55 = releaseModel.seatmortgage;
        }else if ([releaseModel.loan_type integerValue] == 2) {
            rowString44 = @"应收帐款";
            rowString5 = @"应收帐款";
            rowString55 = [NSString stringWithFormat:@"%@万",releaseModel.accountr];
        }else if ([releaseModel.loan_type integerValue] == 3) {
            rowString44 = @"机动车抵押";
            rowString5 = @"机动车抵押";
            rowString55 = releaseResponse.car;
        }else if ([releaseModel.loan_type integerValue] == 4) {
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
        identifier = @"releaseing3";
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
        identifier = @"releaseing4";
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
- (void)getCloseMessages
{
    NSString *releaseString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyReleaseDetailString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"id" : self.idString,
                             @"category" : self.categaryString
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:releaseString params:params successBlock:^(id responseObject){
        PublishingResponse *response = [PublishingResponse objectWithKeyValues:responseObject];
        [weakself.releaseArray addObject:response];
        [weakself.ReleaseCloseTableView reloadData];
        
        [weakself getEvaluateDetails];
        
    } andFailBlock:^(NSError *error){
        
    }];
}

//评价
- (void)getEvaluateDetails
{
    NSString *evaluateString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyEvaluateString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"id" : self.idString,
                             @"category" : self.categaryString
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
        
        if ([response.evalua integerValue] == 0) {
            
            [weakself.releaseCloseSwitchButton.sendButton setTitle:@" 评价接单方" forState:0];
            [weakself.releaseCloseSwitchButton.sendButton setImage:[UIImage imageNamed:@"evaluate"] forState:0];
            
            [weakself.releaseCloseSwitchButton.sendButton addAction:^(UIButton *btn) {
                AdditionalEvaluateViewController *additionalEvaluateVC = [[AdditionalEvaluateViewController alloc] init];
                additionalEvaluateVC.typeString = @"发布方";
                additionalEvaluateVC.evaString = weakself.evaString;
                additionalEvaluateVC.idString = weakself.idString;
                additionalEvaluateVC.categoryString = weakself.categaryString;                
                UINavigationController *nass = [[UINavigationController alloc] initWithRootViewController:additionalEvaluateVC];
                [self presentViewController:nass animated:YES completion:nil];
            }];
        }else{
            
            [weakself.releaseCloseSwitchButton.sendButton setTitle:@" 查看评价" forState:0];
            [weakself.releaseCloseSwitchButton.sendButton setImage:[UIImage imageNamed:@"look"] forState:0];
            
            [weakself.releaseCloseSwitchButton.sendButton addAction:^(UIButton *btn) {
                EvaluateListsViewController *evaluateListVC = [[EvaluateListsViewController alloc] init];
                evaluateListVC.idString = weakself.idString;
                evaluateListVC.categoryString = weakself.categaryString;
                evaluateListVC.typeString = @"发布方";
                [weakself.navigationController pushViewController:evaluateListVC animated:YES];
            }];
        }
        
        [weakself.ReleaseCloseTableView reloadData];
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)deleteTheProducOfReleaseClose
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
