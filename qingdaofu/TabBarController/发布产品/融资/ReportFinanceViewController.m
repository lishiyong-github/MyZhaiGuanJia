//
//  ReportFinanceViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/9.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ReportFinanceViewController.h"
#import "ReportFiSucViewController.h"   //发布成功
#import "MySaveViewController.h"

#import "AgentCell.h"
#import "EditDebtAddressCell.h"

#import "ReportFootView.h"
#import "EvaTopSwitchView.h"

#import "UpwardTableView.h"

@interface ReportFinanceViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *reportFinanceTableView;
@property (nonatomic,strong) ReportFootView *financeFooterView;
@property (nonatomic,strong) EvaTopSwitchView *repFiSwitchView;
@property (nonatomic,strong) UpwardTableView *financeProView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSString *financeString;

@end

@implementation ReportFinanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"发布融资";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self setupForDismissKeyboard];
    
    [self.view addSubview:self.reportFinanceTableView];
    [self.view addSubview:self.repFiSwitchView];
    [self.view addSubview:self.financeProView];
    [self.financeProView setHidden:YES];
    
    self.financeProView.heightTableConstraints = [self.financeProView autoSetDimension:ALDimensionHeight toSize:80];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.reportFinanceTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.reportFinanceTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kTabBarHeight];
        
        [self.repFiSwitchView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.repFiSwitchView autoSetDimension:ALDimensionHeight toSize:kTabBarHeight];
        
        [self.financeProView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)reportFinanceTableView
{
    if (!_reportFinanceTableView) {
        _reportFinanceTableView = [UITableView newAutoLayoutView];
        _reportFinanceTableView.translatesAutoresizingMaskIntoConstraints = YES;
        _reportFinanceTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        _reportFinanceTableView.delegate = self;
        _reportFinanceTableView.dataSource = self;
        _reportFinanceTableView.backgroundColor = kBackColor;
        _reportFinanceTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
        [_reportFinanceTableView.tableFooterView addSubview:self.financeFooterView];
        _reportFinanceTableView.separatorColor = kSeparateColor;
    }
    return _reportFinanceTableView;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] initWithObjects:@"德国队后", nil];
    }
    return _dataArray;
}

- (ReportFootView *)financeFooterView
{
    if (!_financeFooterView) {
        _financeFooterView = [[ReportFootView alloc] initWithFrame:CGRectMake(kBigPadding, kBigPadding, kScreenWidth-kBigPadding*2, 70)];
        _financeFooterView.backgroundColor = kBlueColor;
        [_financeFooterView.footButton addTarget:self action:@selector(openAndClose:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _financeFooterView;
}

- (EvaTopSwitchView *)repFiSwitchView
{
    if (!_repFiSwitchView) {
        _repFiSwitchView = [EvaTopSwitchView newAutoLayoutView];
        _repFiSwitchView.heightConstraint.constant = kTabBarHeight;
        _repFiSwitchView.backgroundColor = kNavColor;
        [_repFiSwitchView.blueLabel setHidden:YES];
        
        [_repFiSwitchView.getbutton setTitle:@"  保存" forState:0];
        [_repFiSwitchView.getbutton setImage:[UIImage imageNamed:@"save"] forState:0];
        [_repFiSwitchView.getbutton setTitleColor:kBlueColor forState:0];
        
        [_repFiSwitchView.sendButton setTitle:@"  立即发布" forState:0];
        [_repFiSwitchView.sendButton setImage:[UIImage imageNamed:@"publish"] forState:0];
        [_repFiSwitchView.sendButton setTitleColor:kBlueColor forState:0];
        
        QDFWeakSelf;
        [_repFiSwitchView setDidSelectedButton:^(NSInteger tag) {
            if (tag == 33) {// 保存
                weakself.financeString = @"0";
                [weakself reportFinanceAction];
            }else{//发布
                weakself.financeString = @"1";
                [weakself reportFinanceAction];
            }
        }];
    }
    return _repFiSwitchView;
}

- (UpwardTableView *)financeProView
{
    if (!_financeProView) {
        _financeProView = [UpwardTableView newAutoLayoutView];
        QDFWeakSelf;
        [_financeProView setDidSelectedButton:^(NSInteger buttonTag) {
            if (buttonTag == 90) {//取消
            [weakself.financeProView setHidden:YES];
            }
        }];
        [_financeProView setDidSelectedRow:^(NSString *text) {
            [weakself.financeProView setHidden:YES];
            
            AgentCell *cell = [weakself.reportFinanceTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
            [cell.agentButton setTitle:text forState:0];
            
        }];
    }
    return _financeProView;
}

#pragma mark - 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 6;
    }
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.section == 0) && (indexPath.row == 5)) {
        return 62;
    }
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    
    if ((indexPath.section == 0) && (indexPath.row == 5)) {
        identifier = @"finance0";
        EditDebtAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[EditDebtAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.ediTextView.placeholder = @"详细地址";
        cell.leftTextViewConstraints.constant = 95;
        return cell;
    }
    
    identifier = @"finance1";
    AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.leftdAgentContraints.constant = 100;
    
    NSArray *finanTextArray = @[@[@"|  基本信息",@"金额",@"返点(%)",@"借款利率(%)",@"抵押物地址",@""],@[@"|  补充信息",@"借款期限",@"抵押物类型",@"抵押物状态",@"抵押物面积",@"借款人年龄",@"权利人年龄"]];
    NSArray *financeholderArray = @[@[@"",@"填写您希望融资的金额",@"能够给到中介的返点，如没有请输入0",@"能够给到融资方的利息(%)",@"小区/写字楼/商铺等",@""],@[@"",@"输入借款期限",@"",@"",@"输入抵押物面积",@"请输入年龄，只能输入数字",@""]];
    NSArray *finanActArray = @[@[@"",@"万元",@"",@"月",@"",@""],@[@"",@"月",@"出租",@"请选择",@"m²",@"岁",@"65岁以上"]];
    
    cell.agentLabel.text = finanTextArray[indexPath.section][indexPath.row];
    cell.agentTextField.placeholder = financeholderArray[indexPath.section][indexPath.row];
    [cell.agentButton setTitle:finanActArray[indexPath.section][indexPath.row] forState:0];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NSMutableAttributedString *dddd = [cell.agentLabel setAttributeString:@"|  基本信息" withColor:kBlueColor andSecond:@"(必填)" withColor:kBlackColor withFont:12];
            [cell.agentLabel setAttributedText:dddd];
            cell.agentTextField.userInteractionEnabled = NO;
        }else if (indexPath.row == 3) {//利息
            [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        }
    }else{
        if (indexPath.row == 0) {
            NSMutableAttributedString *ffff = [cell.agentLabel setAttributeString:@"|  补充信息" withColor:kBlueColor andSecond:@"(选填)" withColor:kBlackColor withFont:12];
            [cell.agentLabel setAttributedText:ffff];
            cell.agentTextField.userInteractionEnabled = NO;
        }if (((indexPath.row > 0) && (indexPath.row < 4)) || indexPath.row > 5) {
            [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
            if (indexPath.row > 1) {
                cell.agentTextField.userInteractionEnabled = NO;
            }
        }
    }
    
    cell.agentButton.tag = 5*indexPath.section + indexPath.row;
    [cell.agentButton addTarget:self action:@selector(showUpwardTableView:) forControlEvents:UIControlEventTouchUpInside];
    
//    NSArray *finanTextArray = @[@[@"|  基本信息",@"金额",@"返点(%)",@"有无抵押物",@"抵押物地址",@""],@[@"|  补充信息",@"借款利率(%)",@"借款期限",@"选择还款方式",@"债务人主体",@"委托事项",@"委托代理期限(月)",@"已付本金",@"已付利息",@"",@"付款方式",@"债权文件",@"债权人信息",@"债务人信息"]];
//    NSArray *financeholderArray = @[@[@"",@"填写您希望融资的金额",@"能够给到中介的返点，如没有请输入0",@"小区/写字楼/商铺等",@"抵押物地址",@""],@[@"",@"能够给到融资方的利息",@"填写借款期限",@"",@"",@"",@"请填写期限",@"填写已付本金",@"填写已付利息",@"",@"",@"",@"",@""]];
//    NSArray *financeActArray = @[@[@"",@"万元",@"能够给到中介的返点，如没有请输入0",@"小区/写字楼/商铺等",@"抵押物地址",@""],@[@"",@"能够给到融资方的利息",@"填写借款期限",@"",@"",@"",@"请填写期限",@"填写已付本金",@"填写已付利息",@"",@"",@"",@"",@""]];
    
//    NSArray *finanTextArray = @[@"|  基本信息",@"金额",@"返点(%)",@"有无抵押物",@"抵押物地址"];
//    NSArray *financeholderArray = @[@"",@"填写您希望融资的金额",@"能够给到中介的返点，如没有请输入0",@"小区/写字楼/商铺等",@"抵押物地址"];
//    cell.agentLabel.text = finanTextArray[indexPath.row];
//    cell.agentTextField.placeholder = financeholderArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kBigPadding;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

#pragma mark - method
//展开收起
- (void)openAndClose:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (btn.selected) {
        [self.dataArray insertObject:@"大喊大叫" atIndex:1];
        NSIndexSet *set = [[NSIndexSet alloc] initWithIndex:1];
        [self.reportFinanceTableView insertSections:set withRowAnimation:UITableViewRowAnimationFade];
    }else{
        [self.dataArray removeObjectAtIndex:1];
        NSIndexSet *set = [[NSIndexSet alloc] initWithIndex:1];
        [self.reportFinanceTableView deleteSections:set withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [self.reportFinanceTableView reloadData];
}

//算法 2*section + row*7
- (void)showUpwardTableView:(UIButton *)btn
{
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        [self.financeProView setHidden:NO];
    }else{
        [self.financeProView setHidden:YES];
    }
    
    switch (btn.tag) {
        case 3:{//借款利率
            self.financeProView.upwardDataList = @[@"天",@"月"];
            self.financeProView.upwardTitleString = @"选择借款利率";
        }
            break;
        case 6:{//借款期限
            /*
             天，月（与借款利率一致）
             */
            self.financeProView.upwardTitleString = @"选择借款期限";
        }
            break;
        case 7:{//抵押物类型
            self.financeProView.upwardTitleString = @"选择抵押物类型";
            self.financeProView.upwardDataList = @[@"住宅",@"商户",@"办公楼"];
        }
            break;
        case 8:{//抵押物状态
            self.financeProView.upwardTitleString = @"选择抵押物状态";
            self.financeProView.upwardDataList = @[@"自住",@"出租"];
        }
            break;
        case 11:{//权利人年龄
            self.financeProView.upwardTitleString = @"选择权利人年龄";
            self.financeProView.upwardDataList = @[@"65岁以下",@"65岁以上"];
        }
            break;
        default:
            break;
    }
    
    self.financeProView.heightTableConstraints.constant = (self.financeProView.upwardDataList.count + 1)*40;
    [self.financeProView reloadData];
    
    [btn setTitle:@"选择后的结果" forState:0];
}

#pragma mark - method
- (void)reportFinanceAction
{
    NSString *reFinanceString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kPublishFinanceString];
    NSDictionary *params = @{@"category" : @"1",
                             @"money" : @"888",   //融资金额，万为单位
                             @"rebate" : @"2",  //返点，实数
                             @"rate" : @"23", //利率
                             @"rate_cat" : @"1",  //利率单位 1-天  2-月
                             @"mortorage_has" : @"0",//0为无 1为有(抵押物地址)
                             @"mortorage_community" : @"华益小区",  //小区名
                             @"seatmortgage" : @"浦东新区孙环路177弄",  //详细地址
                             @"progress_status" : self.financeString,//0为保存 1为发布
                             @"province_id" : @"",//省份接口返回数据
                             @"city_id" : @"",//市接口返回数据
                             @"district_id" : @"",//地区接口返回数据
                             @"mortgagecategory" : @"",//抵押物类型1=>'住宅', 2=>'商户',3=>'办公楼',
                             @"status" : @"", //房子状态   1=>'自住',2=>'出租',
                             @"rentmoney" : @"1000", //租金
                             @"mortgagearea" : @"56",  //房子面积
                             @"loanyear" : @"55",  //借款人年龄
                             @"obligeeyear" : @"1",  //权利人年龄 1=>'65岁以下',2=>'65岁以上'
                             @"token" : [self getValidateToken]
                             };
    
    [self requestDataPostWithString:reFinanceString params:params successBlock:^(AFHTTPRequestOperation *operation, id responseObject){
        
        BaseModel *model = [BaseModel objectWithKeyValues:responseObject];
        [self showHint:model.msg];
        
        if ([model.code isEqualToString:@"0000"]) {
            
            if ([self.financeString intValue] == 0) {//保存
                UINavigationController *nav = self.navigationController;
                [nav popViewControllerAnimated:NO];
                
                MySaveViewController *mySaveVC = [[MySaveViewController alloc] init];
                mySaveVC.hidesBottomBarWhenPushed = YES;
                [nav pushViewController:mySaveVC animated:NO];
            }else{
                ReportFiSucViewController *reportFiSucVC = [[ReportFiSucViewController alloc] init];
                reportFiSucVC.reportType = @"融资";
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
