//
//  ReportFinanceViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/9.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ReportFinanceViewController.h"

#import "ReportFiSucViewController.h"   //发布成功
#import "MySaveViewController.h"   //我的保存
#import "GuarantyViewController.h"  //小区

#import "AgentCell.h"
#import "EditDebtAddressCell.h"
#import "ReportFootView.h"
#import "EvaTopSwitchView.h"
#import "FinanCell.h"

#import "UIViewController+BlurView.h"

@interface ReportFinanceViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *reportFinanceTableView;
@property (nonatomic,strong) ReportFootView *financeFooterView;
@property (nonatomic,strong) EvaTopSwitchView *repFiSwitchView;
@property (nonatomic,strong) NSMutableArray *dataArray;  //收起展开数组

/* 单元格内容 */
@property (nonatomic,strong) NSMutableArray *finanTextArray;
@property (nonatomic,strong) NSMutableArray *financeholderArray;

//租金
@property (nonatomic,strong) NSString *stateString;

@property (nonatomic,strong) NSMutableDictionary *dataDictionary;

@end

@implementation ReportFinanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"发布融资";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self setupForDismissKeyboard];
    
    [self.view addSubview:self.reportFinanceTableView];
    [self.view addSubview:self.repFiSwitchView];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.reportFinanceTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.reportFinanceTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kTabBarHeight];
        
        [self.repFiSwitchView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.repFiSwitchView autoSetDimension:ALDimensionHeight toSize:kTabBarHeight];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)reportFinanceTableView
{
    if (!_reportFinanceTableView) {
        _reportFinanceTableView.translatesAutoresizingMaskIntoConstraints = NO;
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
            
            [weakself tokenIsValid];
            [weakself setDidTokenValid:^(TokenModel *model) {
                if ([model.code isEqualToString:@"0000"]) {
                    if (tag == 33) {// 保存
                        [weakself reportFinanceActionWithType:@"0"];
                    }else{//发布
                        [weakself reportFinanceActionWithType:@"1"];
                    }
                }else{
                    [weakself showHint:model.msg];
                }
            }];
            
        }];
    }
    return _repFiSwitchView;
}

- (NSMutableArray *)finanTextArray
{
    if (!_finanTextArray) {
        NSMutableArray *a1 = [NSMutableArray arrayWithArray:@[@"|  基本信息",@"金额",@"返点",@"借款利率",@"抵押物地址",@""]];
        NSMutableArray *a2;
        
        if ([self.fiModel.status integerValue] == 2) {//出租
            a2 = [NSMutableArray arrayWithObjects:@"|  补充信息",@"借款期限",@"抵押物类型",@"抵押物状态",@"租金",@"抵押物面积",@"借款人年龄",@"权利人年龄", nil];
        }else{
            a2 = [NSMutableArray arrayWithObjects:@"|  补充信息",@"借款期限",@"抵押物类型",@"抵押物状态",@"抵押物面积",@"借款人年龄",@"权利人年龄", nil];
        }
        
//        = [NSMutableArray arrayWithObjects:@"|  补充信息",@"借款期限",@"抵押物类型",@"抵押物状态",@"抵押物面积",@"借款人年龄",@"权利人年龄", nil];
        _finanTextArray = [NSMutableArray arrayWithArray:@[a1,a2]];
        
    }
    return _finanTextArray;
}

- (NSMutableArray *)financeholderArray
{
    if (!_financeholderArray) {
        NSMutableArray *a1 = [NSMutableArray arrayWithObjects:@"",@"填写您希望融资的金额",@"能够给到中介的返点，如没有请输入0",@"能够给到融资方的利息(%)",@"小区/写字楼/商铺等",@"", nil];
        NSMutableArray *a2;
        if ([self.fiModel.status integerValue] == 2) {
            a2 = [NSMutableArray arrayWithObjects:@"",@"输入借款期限",@"",@"",@"填写租金",@"输入抵押物面积",@"请输入年龄，只能输入数字",@"",nil];
        }else{
            a2 = [NSMutableArray arrayWithObjects:@"",@"输入借款期限",@"",@"",@"输入抵押物面积",@"请输入年龄，只能输入数字",@"",nil];
        }
//        = [NSMutableArray arrayWithObjects:@"",@"输入借款期限",@"",@"",@"输入抵押物面积",@"请输入年龄，只能输入数字",@"",nil];
        _financeholderArray = [NSMutableArray arrayWithArray:@[a1,a2]];
    }
    return _financeholderArray;
}

- (NSMutableDictionary *)dataDictionary
{
    if (!_dataDictionary) {
        _dataDictionary = [NSMutableDictionary dictionary];
    }
    return _dataDictionary;
}

#pragma mark - delagate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 6;
    }
    return [self.finanTextArray[1] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.section == 0) && (indexPath.row == 5)) {
        return 62;
    }else if ((indexPath.section == 1) && (indexPath.row == 3)){
        return 44;
    }
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {//基本信息
            identifier = @"finance00";
            AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.leftdAgentContraints.constant = 100;
            [cell.agentTextField setHidden:YES];
            [cell.agentButton setHidden:YES];
            
            NSMutableAttributedString *dddd = [cell.agentLabel setAttributeString:@"|  基本信息" withColor:kBlueColor andSecond:@"(必填)" withColor:kBlackColor withFont:12];
            [cell.agentLabel setAttributedText:dddd];
            
            return cell;
        }else if (indexPath.row == 1){//金额
            identifier = @"finance01";
            AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.leftdAgentContraints.constant = 100;
            
            cell.agentLabel.text = self.finanTextArray[indexPath.section][indexPath.row];
            cell.agentTextField.placeholder = self.financeholderArray[indexPath.section][indexPath.row];
            if (self.dataDictionary[@"money"]) {
                cell.agentTextField.text = self.dataDictionary[@"money"];
            }else{
                cell.agentTextField.text = self.fiModel.money?self.fiModel.money:@"";
            }
            [cell.agentButton setTitle:@"万元" forState:0];
            
            [cell setDidEndEditing:^(NSString *text) {
                [self.dataDictionary setValue:text forKey:@"money"];
            }];
            
            return cell;
        }else if (indexPath.row == 2){//返点
            identifier = @"finance02";
            AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.leftdAgentContraints.constant = 100;
            
            cell.agentLabel.text = self.finanTextArray[indexPath.section][indexPath.row];
            cell.agentTextField.placeholder = self.financeholderArray[indexPath.section][indexPath.row];
            if (self.dataDictionary[@"rebate"]) {
                cell.agentTextField.text = self.dataDictionary[@"rebate"];
            }else{
                cell.agentTextField.text = self.fiModel.rebate?self.fiModel.rebate:@"";
            }
            [cell.agentButton setTitle:@"%" forState:0];
            
            [cell setDidEndEditing:^(NSString *text) {
                [self.dataDictionary setValue:text forKey:@"rebate"];
            }];
            
            return cell;
        }else if (indexPath.row == 3){//借款利率
            identifier = @"finance03";
            AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.leftdAgentContraints.constant = 100;
            
            cell.agentLabel.text = self.finanTextArray[indexPath.section][indexPath.row];
            cell.agentTextField.placeholder = self.financeholderArray[indexPath.section][indexPath.row];
            if (self.dataDictionary[@"rate"]) {
                cell.agentTextField.text = self.dataDictionary[@"rate"];
            }else{
                cell.agentTextField.text = self.fiModel.rate?self.fiModel.rate:@"";
            }
            
            [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
            if (self.fiModel.rate_cat) {
                NSArray *dddd = @[@"天(%)",@"月(%)"];
                [cell.agentButton setTitle:dddd[[self.fiModel.rate_cat integerValue]-1] forState:0];
            }else{
                NSString *rate_cat = self.dataDictionary[@"rate_cat_str"]?self.dataDictionary[@"rate_cat_str"]:@"请选择";
                [cell.agentButton setTitle:rate_cat forState:0];
            }
            
            cell.agentButton.tag = 3;
            [cell.agentButton addTarget:self action:@selector(showTextOfUpwardView:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell setDidEndEditing:^(NSString *text) {
                [self.dataDictionary setValue:text forKey:@"rate"];
            }];

            return cell;
        }else if (indexPath.row == 4){//抵押物地址
            identifier = @"finance04";
            AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.leftdAgentContraints.constant = 100;
            cell.agentTextField.userInteractionEnabled = NO;
            
            cell.agentLabel.text = self.finanTextArray[indexPath.section][indexPath.row];
            cell.agentTextField.placeholder = self.financeholderArray[indexPath.section][indexPath.row];
            
            if (self.dataDictionary[@"mortorage_community"]) {
                cell.agentTextField.text = self.dataDictionary[@"mortorage_community"];
            }else{
                cell.agentTextField.text = self.fiModel.seatmortgage?self.fiModel.seatmortgage:@"";
            }
            
            [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
            [cell.agentButton setTitle:@"请选择" forState:0];
            
            cell.agentButton.tag = 4;
            [cell.agentButton addTarget:self action:@selector(showTextOfUpwardView:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
        }else if (indexPath.row == 5){//详细地址
            identifier = @"finance05";
            EditDebtAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[EditDebtAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.leftTextViewConstraints.constant = 95;
            cell.ediTextView.placeholder = @"详细地址";
            
            if (self.dataDictionary[@"seatmortgage"]) {
                cell.ediTextView.text = self.dataDictionary[@"seatmortgage"];
            }else{
                cell.ediTextView.text = self.fiModel.seatmortgage?self.fiModel.seatmortgage:@"";
            }
            [cell setDidEndEditing:^(NSString *text) {
                [self.dataDictionary setValue:text forKey:@"seatmortgage"];
            }];
            
            return cell;
        }
    }
    
    //section == 1
    if (indexPath.row == 0) {//补充信息
        identifier = @"finance10";
        AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftdAgentContraints.constant = 100;
        [cell.agentTextField setHidden:YES];
        [cell.agentButton setHidden:YES];
        
        NSMutableAttributedString *dddd = [cell.agentLabel setAttributeString:@"|  补充信息" withColor:kBlueColor andSecond:@"(选填)" withColor:kBlackColor withFont:12];
        [cell.agentLabel setAttributedText:dddd];
        
        return cell;
    }else if (indexPath.row == 1){//借款期限
        identifier = @"finance11";
        AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftdAgentContraints.constant = 100;
        
        cell.agentLabel.text = self.finanTextArray[indexPath.section][indexPath.row];
        cell.agentTextField.placeholder = self.financeholderArray[indexPath.section][indexPath.row];
        [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        if (self.dataDictionary[@"term"]) {
            cell.agentTextField.text = self.dataDictionary[@"term"];
        }else{
            cell.agentTextField.text = self.fiModel.term?self.fiModel.term:@"";
        }
        
        if (self.fiModel.rate_cat) {
            NSArray *dddd = @[@"天(%)",@"月(%)"];
            [cell.agentButton setTitle:dddd[[self.fiModel.rate_cat integerValue]-1] forState:0];
        }else{
            NSString *rate_cat = self.dataDictionary[@"rate_cat_str"]?self.dataDictionary[@"rate_cat_str"]:@"请选择";
            [cell.agentButton setTitle:rate_cat forState:0];
        }
        
        cell.agentButton.tag = 8;
        [cell.agentButton addTarget:self action:@selector(showTextOfUpwardView:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell setDidEndEditing:^(NSString *text) {
            [self.dataDictionary setValue:text forKey:@"term"];
        }];
        
        return cell;
    }else if (indexPath.row == 2){//抵押物类型
        identifier = @"finance12";
        AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftdAgentContraints.constant = 100;
        [cell.agentTextField setHidden:YES];
        
        cell.agentLabel.text = self.finanTextArray[indexPath.section][indexPath.row];
        [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        
        if (self.fiModel.mortgagecategory) {
            NSArray *dddd = @[@"住宅",@"商户",@"办公楼"];
            [cell.agentButton setTitle:dddd[[self.fiModel.mortgagecategory integerValue]-1] forState:0];
        }else{
            NSString *rate_cat = self.dataDictionary[@"mortgagecategory_str"]?self.dataDictionary[@"mortgagecategory_str"]:@"请选择";
            [cell.agentButton setTitle:rate_cat forState:0];
        }
        
        cell.agentButton.tag = 9;
        [cell.agentButton addTarget:self action:@selector(showTextOfUpwardView:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }else if (indexPath.row == 3){//抵押物状态
        identifier = @"finance13";
        AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftdAgentContraints.constant = 100;
        [cell.agentTextField setHidden:YES];
        
        cell.agentLabel.text = self.finanTextArray[indexPath.section][indexPath.row];
        [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        
        if (self.fiModel.status) {
            NSArray *dddd = @[@"自住",@"出租"];
            [cell.agentButton setTitle:dddd[[self.fiModel.status integerValue]-1] forState:0];
        }else{
            NSString *rate_cat = self.dataDictionary[@"status_str"]?self.dataDictionary[@"status_str"]:@"请选择";
            [cell.agentButton setTitle:rate_cat forState:0];
        }
        
        cell.agentButton.tag = 10;
        [cell.agentButton addTarget:self action:@selector(showTextOfUpwardView:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }else if (indexPath.row == [self.finanTextArray[1]count]-3){//抵押物面积
        identifier = @"finance15";
        AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftdAgentContraints.constant = 100;
        
        cell.agentLabel.text = self.finanTextArray[indexPath.section][indexPath.row];
        cell.agentTextField.placeholder = self.financeholderArray[indexPath.section][indexPath.row];
        if (self.dataDictionary[@"mortgagearea"]) {
            cell.agentTextField.text = self.dataDictionary[@"mortgagearea"];
        }else{
            cell.agentTextField.text = self.fiModel.mortgagearea?self.fiModel.mortgagearea:@"";
        }
        [cell.agentButton setTitle:@"m²" forState:0];
        
        [cell setDidEndEditing:^(NSString *text) {
            [self.dataDictionary setValue:text forKey:@"mortgagearea"];
        }];

        return cell;

    }else if (indexPath.row == [self.finanTextArray[1]count]-2){//借款人年龄
        identifier = @"finance16";
        AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftdAgentContraints.constant = 100;
        
        cell.agentLabel.text = self.finanTextArray[indexPath.section][indexPath.row];
        cell.agentTextField.placeholder = self.financeholderArray[indexPath.section][indexPath.row];
        if (self.dataDictionary[@"loanyear"]) {
            cell.agentTextField.text = self.dataDictionary[@"loanyear"];
        }else{
            cell.agentTextField.text = self.fiModel.loanyear?self.fiModel.loanyear:@"";
        }
        [cell.agentButton setTitle:@"岁" forState:0];
        
        [cell setDidEndEditing:^(NSString *text) {
            [self.dataDictionary setValue:text forKey:@"loanyear"];
        }];
        
        return cell;
    }else if(indexPath.row == [self.finanTextArray[1]count]-1){//权利人年龄
        identifier = @"finance17";
        AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftdAgentContraints.constant = 100;
        [cell.agentTextField setHidden:YES];
        
        cell.agentLabel.text = self.finanTextArray[indexPath.section][indexPath.row];
        [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        if (self.fiModel.obligeeyear) {
            NSArray *dddd = @[@"65岁以下",@"65岁以上"];
            [cell.agentButton setTitle:dddd[[self.fiModel.obligeeyear integerValue]-1] forState:0];
        }else{
            NSString *sss = self.dataDictionary[@"obligeeyear_str"]?self.dataDictionary[@"obligeeyear_str"]:@"请选择";
            [cell.agentButton setTitle:sss forState:0];
        }
        
        cell.agentButton.tag = 6+[self.finanTextArray[1] count];
        [cell.agentButton addTarget:self action:@selector(showTextOfUpwardView:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }else{//租金
        identifier = @"finance14";
        AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftdAgentContraints.constant = 100;
        
        cell.agentLabel.text = self.finanTextArray[indexPath.section][indexPath.row];
        cell.agentTextField.placeholder = self.financeholderArray[indexPath.section][indexPath.row];
        cell.agentTextField.text = self.fiModel.rentmoney?self.fiModel.rentmoney:@"";
        [cell.agentButton setTitle:@"元" forState:0];
        
        if ([self.finanTextArray[1] count] == 8) {
            [cell setDidEndEditing:^(NSString *text) {
                [self.dataDictionary setValue:text forKey:@"rentmoney"];
            }];
        }
        
        return cell;
    }
    return nil;
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

- (void)showTextOfUpwardView:(UIButton *)btn
{
    [self.view endEditing:YES];
    NSArray *arr3 = @[@"天(%)",@"月(%)"];
    NSArray *arr9 = @[@"住宅",@"商户",@"办公楼"];
    NSArray *arr10 = @[@"自住",@"出租"];
    NSArray *arr13 = @[@"65岁以下",@"65岁以上"];
    
    switch (btn.tag) {
        case 3:{//借款利率
            [self showBlurInView:self.view withArray:arr3 andTitle:@"选择借款利率类型" finishBlock:^(NSString *text,NSInteger row) {
                [btn setTitle:text forState:0];
                
                NSString *value = [NSString stringWithFormat:@"%d",row];
                [self.dataDictionary setValue:value forKey:@"rate_cat"];
                [self.dataDictionary setValue:text forKey:@"rate_cat_str"];
                
                //借款期限
                UIButton *elseBtn = [self.reportFinanceTableView viewWithTag:8];
                [elseBtn setTitle:text forState:0];
            }];
        }
            break;
        case 4:{//抵押物小区
            
            GuarantyViewController *guarantyVC =[[GuarantyViewController alloc] init];
            [guarantyVC setDidSelectedArea:^(NSString *mortorage_community,NSString *seatmortgage) {//小区名，详细地址
                [self.dataDictionary setValue:mortorage_community forKey:@"mortorage_community"];
                [self.dataDictionary setValue:seatmortgage forKey:@"seatmortgage"];
                [self.reportFinanceTableView reloadData];
                
                //小区名
                AgentCell *cell = [self.reportFinanceTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
                cell.agentTextField.text = [NSString stringWithFormat:@"%@",mortorage_community];
            }];
            [self.navigationController pushViewController:guarantyVC animated:YES];
        }
            break;
        case 8:{//借款期限
            [self showBlurInView:self.view withArray:arr3 andTitle:@"选择借款期限类型" finishBlock:^(NSString *text,NSInteger row) {
                [btn setTitle:text forState:0];
                
                NSString *value = [NSString stringWithFormat:@"%d",row];
                [self.dataDictionary setValue:value forKey:@"rate_cat"];
                [self.dataDictionary setValue:text forKey:@"rate_cat_str"];
               
                UIButton *elseBtn = [self.reportFinanceTableView viewWithTag:3];
                [elseBtn setTitle:text forState:0];
            }];
        }
            break;
        case 9:{//抵押物类型
            [self showBlurInView:self.view withArray:arr9 andTitle:@"选择抵押物类型" finishBlock:^(NSString *text,NSInteger row) {
                [btn setTitle:text forState:0];
                
                NSString *value = [NSString stringWithFormat:@"%d",row];
                [self.dataDictionary setValue:value forKey:@"mortgagecategory"];
                [self.dataDictionary setValue:text forKey:@"mortgagecategory_str"];
            }];
        }
            break;
        case 10:{//抵押物状态
            [self showBlurInView:self.view withArray:arr10 andTitle:@"选择抵押物状态" finishBlock:^(NSString *text,NSInteger row) {
                [btn setTitle:text forState:0];
                
                NSString *value = [NSString stringWithFormat:@"%d",row];
                [self.dataDictionary setValue:value forKey:@"status"];
                [self.dataDictionary setValue:text forKey:@"status_str"];
                
                if ([text isEqualToString:@"出租"]) {
                    if ([self.finanTextArray[1] count] == 7) {
                        [self.finanTextArray[1] insertObject:@"租金" atIndex:4];
                        [self.financeholderArray[1] insertObject:@"请填写租金" atIndex:4];
                        [self.reportFinanceTableView reloadData];
                    }
                }else{
                    if ([self.finanTextArray[1] count] == 8) {
                        [self.finanTextArray[1] removeObjectAtIndex:4];
                        [self.financeholderArray[1] removeObjectAtIndex:4];
                        [self.reportFinanceTableView reloadData];
                    }
                }
            }];
        }
            break;
        case 13:{//权利人年龄
            if ([self.finanTextArray[1] count] == 7) {
                [self showBlurInView:self.view withArray:arr13 andTitle:@"选择权利人年龄" finishBlock:^(NSString *text,NSInteger row) {
                    [btn setTitle:text forState:0];
                    
                    NSString *value = [NSString stringWithFormat:@"%d",row];
                    [self.dataDictionary setValue:value forKey:@"obligeeyear"];
                    [self.dataDictionary setValue:text forKey:@"obligeeyear_str"];
                    
                }];
            }
            
        }
            break;
        case 14:{
            if ([self.finanTextArray[1] count] == 8) {
                [self showBlurInView:self.view withArray:arr13 andTitle:@"选择权利人年龄" finishBlock:^(NSString *text,NSInteger row) {
                    [btn setTitle:text forState:0];
                    
                    NSString *value = [NSString stringWithFormat:@"%d",row];
                    [self.dataDictionary setValue:value forKey:@"obligeeyear"];
                    [self.dataDictionary setValue:text forKey:@"obligeeyear_str"];
                    
                }];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - method
- (void)reportFinanceActionWithType:(NSString *)type
{
    [self.view endEditing:YES];
    NSString *reFinanceString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kPublishFinanceString];
    
    /* 参数 */
    self.dataDictionary[@"money"] = self.dataDictionary[@"money"]?self.dataDictionary[@"money"]:self.fiModel.money;//融资金额，万为单位
    self.dataDictionary[@"rebate"] = self.dataDictionary[@"rebate"]?self.dataDictionary[@"rebate"]:self.fiModel.rebate;//返点，实数
    self.dataDictionary[@"rate"] = self.dataDictionary[@"rate"]?self.dataDictionary[@"rate"]:self.fiModel.rate;//利率
    self.dataDictionary[@"rate_cat"] = self.dataDictionary[@"rate_cat"]?self.dataDictionary[@"rate_cat"]:self.fiModel.rate_cat;//利率单位 1-天  2-月
    self.dataDictionary[@"mortorage_community"] = self.dataDictionary[@"mortorage_community"]?self.dataDictionary[@"mortorage_community"]:self.fiModel.mortorage_community;//小区名
    self.dataDictionary[@"seatmortgage"] = self.dataDictionary[@"seatmortgage"]?self.dataDictionary[@"seatmortgage"]:self.fiModel.seatmortgage;//详细地址
    self.dataDictionary[@"province_id"] = @"0";
    self.dataDictionary[@"city_id"] = @"0";
    self.dataDictionary[@"district_id"] = @"0";
    self.dataDictionary[@"term"] = self.dataDictionary[@"term"]?self.dataDictionary[@"term"]:self.fiModel.term;//借款期限
    self.dataDictionary[@"mortgagecategory"] = self.dataDictionary[@"mortgagecategory"]?self.dataDictionary[@"mortgagecategory"]:self.fiModel.mortgagecategory;//抵押物类型1=>'住宅', 2=>'商户',3=>'办公楼'
    self.dataDictionary[@"status"] = self.dataDictionary[@"status"]?self.dataDictionary[@"status"]:self.fiModel.status;//房子状态   1=>'自住',2=>'出租',
    self.dataDictionary[@"rentmoney"] = self.dataDictionary[@"rentmoney"]?self.dataDictionary[@"rentmoney"]:self.fiModel.rentmoney;//租金
    self.dataDictionary[@"mortgagearea"] = self.dataDictionary[@"mortgagearea"]?self.dataDictionary[@"mortgagearea"]:self.fiModel.mortgagearea;//房子面积
    self.dataDictionary[@"loanyear"] = self.dataDictionary[@"loanyear"]?self.dataDictionary[@"loanyear"]:self.fiModel.loanyear;//借款人年龄
    self.dataDictionary[@"obligeeyear"] = self.dataDictionary[@"obligeeyear"]?self.dataDictionary[@"obligeeyear"]:self.fiModel.obligeeyear;//权利人年龄 1=>'65岁以下',2=>'65岁以上'
    
    [self.dataDictionary setValue:@"1" forKey:@"category"];
    [self.dataDictionary setValue:type forKey:@"progress_status"];//0为保存 1为发布
    [self.dataDictionary setValue:[self getValidateToken] forKey:@"token"];
    
    NSDictionary *params = self.dataDictionary;

    [self requestDataPostWithString:reFinanceString params:params successBlock:^(id responseObject){
        BaseModel *model = [BaseModel objectWithKeyValues:responseObject];
        [self showHint:model.msg];
        
        if ([model.code isEqualToString:@"0000"]) {
            if ([type intValue] == 0) {//保存
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
        
    } andFailBlock:^(NSError *error){
        
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
