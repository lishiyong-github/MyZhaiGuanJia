//
//  ReportSuitViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/10.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ReportSuitViewController.h"

#import "ReportFiSucViewController.h"  //发布成功
#import "UploadFilesViewController.h"  //债权文件
#import "DebtCreditMessageViewController.h"  //债权人信息
#import "MySaveViewController.h"  //我的保存

#import "ReportFootView.h"
#import "EvaTopSwitchView.h"

#import "ReportSuitCell.h"
#import "ReportSuitSeCell.h"

@interface ReportSuitViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *repCoTableView;

@property (nonatomic,strong) ReportFootView *repSuitFootButton;
@property (nonatomic,strong) EvaTopSwitchView *repSuitSwitchView;

@property (nonatomic,strong) NSMutableArray *suitDataList;
@property (nonatomic,strong) NSString *suitString;

@end

@implementation ReportSuitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发布诉讼";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self setupForDismissKeyboard];
    
    [self.view addSubview:self.repCoTableView];
    [self.view addSubview:self.repSuitSwitchView];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.repCoTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.repCoTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kTabBarHeight];
        
        [self.repSuitSwitchView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.repSuitSwitchView autoSetDimension:ALDimensionHeight toSize:kTabBarHeight];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)repCoTableView
{
    if (!_repCoTableView) {
        _repCoTableView = [UITableView newAutoLayoutView];
        _repCoTableView.translatesAutoresizingMaskIntoConstraints = YES;
        _repCoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        _repCoTableView.backgroundColor = kBackColor;
        _repCoTableView.delegate = self;
        _repCoTableView.dataSource = self;
        _repCoTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 90)];
        [_repCoTableView.tableFooterView addSubview:self.repSuitFootButton];
        _repCoTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSmallPadding)];
    }
    return _repCoTableView;
}

- (EvaTopSwitchView *)repSuitSwitchView
{
    if (!_repSuitSwitchView) {
        _repSuitSwitchView = [EvaTopSwitchView newAutoLayoutView];
        _repSuitSwitchView.heightConstraint.constant = kTabBarHeight;
        _repSuitSwitchView.backgroundColor = kNavColor;
        [_repSuitSwitchView.blueLabel setHidden:YES];
        
        [_repSuitSwitchView.getbutton setTitle:@"  保存" forState:0];
        [_repSuitSwitchView.getbutton setImage:[UIImage imageNamed:@"save"] forState:0];
        [_repSuitSwitchView.getbutton setTitleColor:kBlueColor forState:0];
        
        [_repSuitSwitchView.sendButton setTitle:@"  立即发布" forState:0];
        [_repSuitSwitchView.sendButton setImage:[UIImage imageNamed:@"publish"] forState:0];
        [_repSuitSwitchView.sendButton setTitleColor:kBlueColor forState:0];
        
        QDFWeakSelf;
        [_repSuitSwitchView.getbutton addAction:^(UIButton *btn) {//保存
            weakself.suitString = @"0";
            [weakself reportSuitAction];
        }];
        [_repSuitSwitchView.sendButton addAction:^(UIButton *btn) {
            weakself.suitString = @"1";
            [weakself reportSuitAction];
            
        }];
    }
    return _repSuitSwitchView;
}

- (ReportFootView *)repSuitFootButton
{
    if (!_repSuitFootButton) {
        _repSuitFootButton = [[ReportFootView alloc] initWithFrame:CGRectMake(kBigPadding, 0, kScreenWidth-kBigPadding*2, 70)];
        _repSuitFootButton.backgroundColor = kBlueColor;
        [_repSuitFootButton.footButton addTarget:self action:@selector(openAndClose:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _repSuitFootButton;
}

- (NSMutableArray *)suitDataList
{
    if (!_suitDataList) {
        _suitDataList = [[NSMutableArray alloc] initWithObjects:@"老大旅", nil];
    }
    return _suitDataList;
}

#pragma mark - tableView delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.suitDataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 5*kCellHeight+5*kLineWidth+62;
    }
    return kCellHeight*13+kLineWidth*13+62;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    if (indexPath.section == 0) {
        identifier = @"suitSect0";
        ReportSuitCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[ReportSuitCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    identifier = @"suitSect1";
    
    ReportSuitSeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ReportSuitSeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    QDFWeakSelf;
    [cell setDidSelectedIndex:^(NSInteger row) {
        switch (row) {
            case 80:{//债权文件
                UploadFilesViewController *uploadFilesVC = [[UploadFilesViewController alloc] init];
                [weakself.navigationController pushViewController:uploadFilesVC animated:YES];
            }
                break;
            case 81:{//债权人信息
                DebtCreditMessageViewController *debtCreditVc = [[DebtCreditMessageViewController alloc] init];
                [weakself.navigationController pushViewController:debtCreditVc animated:YES];
            }
                break;
            case 82:{//债务人信息
                
            }
                break;
            default:
                break;
        }
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = kBackColor;
        return view;
    }
    
    return nil;
}

#pragma mark - method
- (void)openAndClose:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (btn.selected) {
        [self.suitDataList insertObject:@"大喊大叫" atIndex:1];
        NSIndexSet *set = [[NSIndexSet alloc] initWithIndex:1];
        [self.repCoTableView insertSections:set withRowAnimation:UITableViewRowAnimationFade];
    }else{
        [self.suitDataList removeObjectAtIndex:1];
        NSIndexSet *set = [[NSIndexSet alloc] initWithIndex:1];
        [self.repCoTableView deleteSections:set withRowAnimation:UITableViewRowAnimationFade];
    }
    [self.repCoTableView reloadData];
}

#pragma mark - method
- (void)reportSuitAction
{
    NSString *reFinanceString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kPublishCollection];
    NSDictionary *params = @{@"category" : @"3",
                             @"money" : @"888",   //融资金额，万为单位
                             @"progress_status" : self.suitString,//1为保存 0为发布
                             @"province_id" : @"",//省份接口返回数据
                             @"city_id" : @"",//市接口返回数据
                             @"district_id" : @"",//地区接口返回数据
                             @"agencycommissiontype" : @"2", //代理费用类型 1为天。2为月
                             @"agencycommission" : @"9", //代理费用
                             @"loan_type" : @"2",  //债权类型  1民间借贷  2应收账款
                             @"mortorage_has" : @"0",//0为无 1为有(抵押物地址)
                             @"mortorage_community" : @"华益小区",  //小区名
                             @"seatmortgage" : @"浦东新区孙环路177弄",  //详细地址
                             @"paymethod" : @"",  //付款方式 1=>'分期',2=>'一次性付清',
                             @"rate" : @"23", //利率
                             @"rate_cat" : @"1",  //利率单位 1-天  2-月
                             @"term" : @"",  //借款周期
                             @"repaymethod" : @"", //还款方式 1=>'一次性到期还本付息',2=>'按月付息,到期还本'
                             @"obligor" : @"",   //借款人主体  1=>'自然人', 2=>'法人',3=>'其他(未成年,外籍等)'
                             @"commitment" : @"",  //委托事项 1=>'65岁以下',2=>'65岁以上',
                             @"commissionperiod" : @"",  //委托代理期限(月)  1-12
                             @"paidmoney" : @"",  //已付本金
                             @"interestpaid" : @"", //已付利息
                             @"performancecontract" : @"",  //合同履行地
                             @"creditorfile" : @"",  //债权人文件
                             @"creditorinfo" : @"",  //债权人信息
                             @"borrowinginfo" : @"", //债务人信息
                             @"token" : [self getValidateToken]
                             };
    
    [self requestDataPostWithString:reFinanceString params:params successBlock:^(AFHTTPRequestOperation *operation, id responseObject){
        
        BaseModel *suitModel = [BaseModel objectWithKeyValues:responseObject];
        
        [self showHint:suitModel.msg];
        
        if ([suitModel.code isEqualToString:@"0000"]) {
            
            if ([self.suitString intValue] == 0) {//保存
                UINavigationController *nav = self.navigationController;
                [nav popViewControllerAnimated:NO];
                
                MySaveViewController *mySaveVC = [[MySaveViewController alloc] init];
                mySaveVC.hidesBottomBarWhenPushed = YES;
                [nav pushViewController:mySaveVC animated:NO];
            }else{
                ReportFiSucViewController *reportFiSucVC = [[ReportFiSucViewController alloc] init];
                reportFiSucVC.reportType = @"诉讼";
                [self.navigationController pushViewController:reportFiSucVC animated:YES];
            }
            
            
        }
    } andFailBlock:^{
        
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
