//
//  ReportSuitViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/10.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ReportSuitViewController.h"

#import "ReportFiSucViewController.h"  //发布成功
#import "MySaveViewController.h"  //我的保存

#import "UploadFilesViewController.h"  //债权文件
#import "DebtCreditMessageViewController.h"  //债权人信息
#import "BrandViewController.h"

#import "ReportFootView.h"
#import "EvaTopSwitchView.h"
#import "UIViewController+BlurView.h"

#import "AgentCell.h"
#import "EditDebtAddressCell.h"
#import "SuitBaseCell.h"

@interface ReportSuitViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *suitTableView;

@property (nonatomic,strong) ReportFootView *repSuitFootButton;
@property (nonatomic,strong) EvaTopSwitchView *repSuitSwitchView;

@property (nonatomic,strong) NSMutableArray *suitDataList;  //收起展开
@property (nonatomic,strong) NSMutableArray *sTextArray;
@property (nonatomic,strong) NSMutableArray *sHolderArray;

@property (nonatomic,strong) NSMutableDictionary *suitDataDictionary;  //参数
@property (nonatomic,strong) NSString *rowString;    //债权类型
@property (nonatomic,strong) NSString *number;
@end

@implementation ReportSuitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发布诉讼";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self setupForDismissKeyboard];
    
    self.rowString = @"6";
    _number = @"1";
    [self.suitDataDictionary setValue:_number forKey:@"loan_type"];
    
    [self.view addSubview:self.suitTableView];
    [self.view addSubview:self.repSuitSwitchView];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.suitTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.suitTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kTabBarHeight];
        
        [self.repSuitSwitchView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.repSuitSwitchView autoSetDimension:ALDimensionHeight toSize:kTabBarHeight];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)suitTableView
{
    if (!_suitTableView) {
        _suitTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _suitTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        _suitTableView.backgroundColor = kBackColor;
        _suitTableView.delegate = self;
        _suitTableView.dataSource = self;
        _suitTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 90)];
        [_suitTableView.tableFooterView addSubview:self.repSuitFootButton];
        _suitTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSmallPadding)];
    }
    return _suitTableView;
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
        [_repSuitSwitchView setDidSelectedButton:^(NSInteger tag) {
            
            [weakself tokenIsValid];
            [weakself setDidTokenValid:^(TokenModel *model) {
                if ([model.code isEqualToString:@"0000"]) {
                    if (tag == 33) {//保存
                        [weakself reportSuitActionWithTypeString:@"0"];
                    }else{
                        [weakself reportSuitActionWithTypeString:@"1"];
                    }
                }else{//发布
                    [weakself showHint:model.msg];
                }
            }];
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

- (NSMutableDictionary *)suitDataDictionary
{
    if (!_suitDataDictionary) {
        _suitDataDictionary = [NSMutableDictionary dictionary];
    }
    return _suitDataDictionary;
}

- (NSMutableArray *)sTextArray
{
    if (!_sTextArray) {
        NSArray *sTextArray1 = @[@"",@"借款本金",@"代理费用",@"",@"抵押物地址",@""];
        _sTextArray = [NSMutableArray arrayWithArray:sTextArray1];
    }
    return _sTextArray;
}

- (NSMutableArray *)sHolderArray
{
    if (!_sHolderArray) {
        NSArray *sHolderArray1 = @[@"",@"填写借款本金",@"填写代理费用",@"",@"填写抵押物地址",@""];
        _sHolderArray = [NSMutableArray arrayWithArray:sHolderArray1];
    }
    return _sHolderArray;
}

#pragma mark - tableView delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.suitDataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        
        return [self.rowString intValue];
    }

    return 13;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.section == 0) && (indexPath.row == 5)) {
        return 62;
    }else if ((indexPath.section == 1) && (indexPath.row == 9)){
        return 62;
    }
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    if (indexPath.section == 0) {//债权类型
        if (indexPath.row == 3) {
            identifier = @"suitSect03";
            SuitBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[SuitBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.label.text = @"债权类型";
            
            [cell setDidSelectedSeg:^(NSInteger selectedTag) {
                
                if (selectedTag == 0) {//房产抵押
                    self.rowString = @"6";
                    [self.sTextArray replaceObjectAtIndex:4 withObject:@"抵押物地址"];
                    [self.sHolderArray replaceObjectAtIndex:4 withObject:@"选择抵押物地址"];
                    _number = @"1";
                }else if (selectedTag == 1){//机动车
                    self.rowString = @"5";
                    [self.sTextArray replaceObjectAtIndex:4 withObject:@"机动车品牌"];
                    [self.sHolderArray replaceObjectAtIndex:4 withObject:@"选择机动车品牌"];
                    _number = @"3";
                }else if (selectedTag == 2){//应收帐款
                    self.rowString = @"5";
                    [self.sTextArray replaceObjectAtIndex:4 withObject:@""];
                    [self.sHolderArray replaceObjectAtIndex:4 withObject:@"应收帐款"];
                    _number = @"2";
                }else{//无抵押
                    self.rowString = @"4";
                    [self.sTextArray replaceObjectAtIndex:4 withObject:@"无抵押"];
                    [self.sHolderArray replaceObjectAtIndex:4 withObject:@"无抵押"];
                    _number = @"4";
                }
                
                [self.suitDataDictionary setValue:_number forKey:@"loan_type"];
                
                [self.suitTableView reloadData];
            }];
            return cell;
        }else if (indexPath.row == 5){//具体
            identifier = @"suitSect05";
            EditDebtAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[EditDebtAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.leftTextViewConstraints.constant = 100;
            cell.ediTextView.placeholder = @"详细地址";
            
            [cell setDidEndEditing:^(NSString *text) {
                [self.suitDataDictionary setValue:text forKey:@"seatmortgage"];
            }];
            
            return cell;
        }
        //section=0其他
        identifier = @"suitSect0";
        
        AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftdAgentContraints.constant = 105;
        cell.agentButton.tag = 7*indexPath.section + indexPath.row;
        
        cell.agentLabel.text = self.sTextArray[indexPath.row];
        cell.agentTextField.placeholder = self.sHolderArray[indexPath.row];
        
        if (indexPath.row == 0) {//基本信息
            NSMutableAttributedString *dddd = [cell.agentLabel setAttributeString:@"|  基本信息" withColor:kBlueColor andSecond:@"(必填)" withColor:kBlackColor withFont:12];
            [cell.agentLabel setAttributedText:dddd];
            [cell.agentTextField setHidden:YES];
            [cell.agentButton setHidden:YES];
        }else if (indexPath.row == 1){//借款本金
            [cell.agentButton setTitle:@"万元" forState:0];
            [cell setDidEndEditing:^(NSString *text) {
                [self.suitDataDictionary setValue:text forKey:@"money"];
            }];
            
        }else if (indexPath.row == 2){//代理费用
            [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
            [cell.agentButton setTitle:@"请选择" forState:0];
            [cell setDidEndEditing:^(NSString *text) {
                [self.suitDataDictionary setValue:text forKey:@"agencycommission"];
            }];
            [cell.agentButton addTarget:self action:@selector(showTitleOfUpwardView:) forControlEvents:UIControlEventTouchUpInside];
        }else if (indexPath.row == 4){//抵押物地址
            
//                if ([_number intValue] == 1) {//房产抵押
//                    [self.suitDataDictionary setValue:text forKey:@"mortorage_community"];
//                    weakcell.agentTextField.userInteractionEnabled = NO;
//                    [weakcell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
//                    [weakcell.agentButton setTitle:@"请选择" forState:0];
//                    
//                }else if ([_number intValue] == 3){//机动车抵押
//                    [self.suitDataDictionary setValue:text forKey:@"carbrand"];
//                    [self.suitDataDictionary setValue:text forKey:@"audi"];
//                    
//                }else
            
            if ([_number intValue] == 1) {//抵押物地址
                cell.agentTextField.userInteractionEnabled = NO;
                [cell.agentButton setHidden:NO];
                [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
                [cell.agentButton setTitle:@"请选择" forState:0];
                [cell.agentButton addAction:^(UIButton *btn) {
                    NSLog(@"选择小区名");
                }];
                
            }else if ([_number intValue] == 3){//机动车抵押
                cell.agentTextField.userInteractionEnabled = NO;
                [cell.agentButton setHidden:NO];
                [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
                [cell.agentButton setTitle:@"请选择" forState:0];
                [cell.agentButton addAction:^(UIButton *btn) {
                    NSLog(@"选择机动车品牌");
                    BrandViewController *brandVC = [[BrandViewController alloc] init];
                    [self.navigationController pushViewController:brandVC animated:YES];
                }];
            }else if ([_number intValue] == 2) {//应收帐款
                cell.agentTextField.userInteractionEnabled = YES;
                [cell.agentButton setHidden:YES];
                [cell setDidEndEditing:^(NSString *text) {
                    [self.suitDataDictionary setValue:text forKey:@"accountr"];
                }];
            }
            
        }
        return cell;
    }
    //section=1
    if (indexPath.row == 9) {//合同履行地
        identifier = @"suitSect19";
        
        EditDebtAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[EditDebtAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftTextViewConstraints.constant = 100;
        cell.ediLabel.text = @"合同履行地";
        cell.ediTextView.placeholder = @"填写合同履行地";
        
        [cell setDidEndEditing:^(NSString *text) {
            [self.suitDataDictionary setValue:text forKey:@"performancecontract"];
        }];
        return cell;
    }
    
    identifier = @"suitSect1";
    
    AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.leftdAgentContraints.constant = 105;
    cell.agentButton.tag = 7*indexPath.section + indexPath.row;
    
    NSArray *sTextArray = @[@"|  补充信息(选填)",@"借款利率(%)",@"借款期限",@"还款方式",@"债务人主体",@"委托事项",@"委托代理期限(月)",@"已付本金",@"已付利息",@"",@"债权文件",@"债权人信息",@"债务人信息"];
    NSArray *suitHolderArray = @[@"",@"能够给到融资方的利息",@"输入借款期限",@"",@"",@"",@"",@"填写已付本金",@"填写已付利息",@"",@"",@"",@"",@""];
    NSArray *suitActArray = @[@"",@"请选择",@"请选择",@"请选择",@"请选择",@"请选择",@"请选择",@"元",@"元",@"",@"上传",@"完善",@"完善"];
    
    cell.agentLabel.text = sTextArray[indexPath.row];
    cell.agentTextField.placeholder = suitHolderArray[indexPath.row];
    [cell.agentButton setTitle:suitActArray[indexPath.row] forState:0];
   
    if (indexPath.row == 0) {
        NSMutableAttributedString *ffff = [cell.agentLabel setAttributeString:@"|  补充信息" withColor:kBlueColor andSecond:@"(选填)" withColor:kBlackColor withFont:12];
        [cell.agentLabel setAttributedText:ffff];
        [cell.agentTextField setHidden:YES];
        [cell.agentButton setHidden:YES];
    }else if (indexPath.row == 1){//借款利率
        [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        [cell setDidEndEditing:^(NSString *text) {
            [self.suitDataDictionary setValue:text forKey:@"rate"];
        }];
        [cell.agentButton addTarget:self action:@selector(showTitleOfUpwardView:) forControlEvents:UIControlEventTouchUpInside];
    }else if (indexPath.row == 2){//借款期限
        [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        [cell setDidEndEditing:^(NSString *text) {
            [self.suitDataDictionary setValue:text forKey:@"term"];
        }];
        [cell.agentButton addTarget:self action:@selector(showTitleOfUpwardView:) forControlEvents:UIControlEventTouchUpInside];
    }else if ((indexPath.row > 2) && (indexPath.row < 7)){
        [cell.agentTextField setHidden:YES];
        [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        [cell.agentButton addTarget:self action:@selector(showTitleOfUpwardView:) forControlEvents:UIControlEventTouchUpInside];
    }else if (indexPath.row == 7){//已付本金
        [cell setDidEndEditing:^(NSString *text) {
            [self.suitDataDictionary setValue:text forKey:@"paidmoney"];
        }];
    }else if (indexPath.row == 8){//已付利息
        [cell setDidEndEditing:^(NSString *text) {
            [self.suitDataDictionary setValue:text forKey:@"interestpaid"];
        }];
    }else if(indexPath.row > 9){
        [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        [cell.agentButton addTarget:self action:@selector(showTitleOfUpwardView:) forControlEvents:UIControlEventTouchUpInside];
    }
    
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
        [self.suitTableView insertSections:set withRowAnimation:UITableViewRowAnimationFade];
    }else{
        [self.suitDataList removeObjectAtIndex:1];
        NSIndexSet *set = [[NSIndexSet alloc] initWithIndex:1];
        [self.suitTableView deleteSections:set withRowAnimation:UITableViewRowAnimationFade];
    }
    [self.suitTableView reloadData];
}

- (void)showTitleOfUpwardView:(UIButton *)btn
{
    NSArray *arr2 = @[@"固定费用(万)",@"代理费率(%)"];
    NSArray *arr8 = @[@"天",@"月"];
    NSArray *arr10 = @[@"一次性到期还本付息",@"按月付息，到期还本"];
    NSArray *arr11 = @[@"自然人",@"法人",@"其他"];
    NSArray *arr12 = @[@"代理诉讼",@"代理仲裁",@"代理执行"];
    NSArray *arr13 = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
    
    switch (btn.tag) {
        case 2:{//代理费用
            
            [self showBlurInView:self.view withArray:arr2 andTitle:@"选择代理费用类型" finishBlock:^(NSString *text, NSInteger row) {
                [btn setTitle:text forState:0];
                
                NSString *value = [NSString stringWithFormat:@"%d",row];
                [self.suitDataDictionary setValue:value forKey:@"agencycommissiontype"];
            }];
        }
            break;
        case 8:{//借款利率
            [self showBlurInView:self.view withArray:arr8 andTitle:@"选择借款利率类型" finishBlock:^(NSString *text,NSInteger row) {
                [btn setTitle:text forState:0];
                NSString *value = [NSString stringWithFormat:@"%d",row];
                [self.suitDataDictionary setValue:value forKey:@"rate_cat"];
                UIButton *elseBtn = [self.suitTableView viewWithTag:9];
                [elseBtn setTitle:text forState:0];
                
            }];
        }
            break;
        case 9:{//借款期限
            [self showBlurInView:self.view withArray:arr8 andTitle:@"选择借款期限类型" finishBlock:^(NSString *text,NSInteger row) {
                [btn setTitle:text forState:0];
                
                NSString *value = [NSString stringWithFormat:@"%d",row];
                [self.suitDataDictionary setValue:value forKey:@"term"];
                
                UIButton *elseBtn = [self.suitTableView viewWithTag:8];
                [elseBtn setTitle:text forState:0];
            }];
        }
            break;
        case 10:{//还款方式
            [self showBlurInView:self.view withArray:arr10 andTitle:@"选择还款方式" finishBlock:^(NSString *text,NSInteger row) {
                [btn setTitle:text forState:0];
                
                NSString *value = [NSString stringWithFormat:@"%d",row];
                [self.suitDataDictionary setValue:value forKey:@"repaymethod"];
            }];
        }
            break;
        case 11:{//债务人主体
            [self showBlurInView:self.view withArray:arr11 andTitle:@"选择债务人主体" finishBlock:^(NSString *text,NSInteger row) {
                [btn setTitle:text forState:0];
                
                NSString *value = [NSString stringWithFormat:@"%d",row];
                [self.suitDataDictionary setValue:value forKey:@"obligor"];
            }];
        }
            break;
        case 12:{//委托事项
            [self showBlurInView:self.view withArray:arr12 andTitle:@"选择委托事项" finishBlock:^(NSString *text,NSInteger row) {
                [btn setTitle:text forState:0];
                
                NSString *value = [NSString stringWithFormat:@"%d",row];
                [self.suitDataDictionary setValue:value forKey:@"commitment"];
            }];
        }
            break;
        case 13:{//委托代理期限
            [self showBlurInView:self.view withArray:arr13 andTitle:@"选择委托代理期限" finishBlock:^(NSString *text,NSInteger row) {
                [btn setTitle:text forState:0];
                
                NSString *value = [NSString stringWithFormat:@"%d",row];
                [self.suitDataDictionary setValue:value forKey:@"commissionperiod"];
                
            }];
        }
            break;
        default:
            break;
    }
}

#pragma mark - method
- (void)reportSuitActionWithTypeString:(NSString *)typeString
{
    [self.view endEditing:YES];
    NSString *reFinanceString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kPublishCollection];
    
    /* 参数 */
    self.suitDataDictionary[@"money"] = self.suitDataDictionary[@"money"]?self.suitDataDictionary[@"money"]:@""; //融资金额，万为单位
    self.suitDataDictionary[@"agencycommission"] = self.suitDataDictionary[@"agencycommission"]?self.suitDataDictionary[@"agencycommission"]:@"";
    self.suitDataDictionary[@"loan_type"] = self.suitDataDictionary[@"loan_type"]?self.suitDataDictionary[@"loan_type"]:@"";
    self.suitDataDictionary[@"mortorage_community"] = self.suitDataDictionary[@"mortorage_community"]?self.suitDataDictionary[@"mortorage_community"]:@"";
    self.suitDataDictionary[@"seatmortgage"] = self.suitDataDictionary[@"seatmortgage"]?self.suitDataDictionary[@"seatmortgage"]:@"";
    self.suitDataDictionary[@"carbrand"] = self.suitDataDictionary[@"carbrand"]?self.suitDataDictionary[@"carbrand"]:@"";   //车品牌
    self.suitDataDictionary[@"audi"] = self.suitDataDictionary[@"audi"]?self.suitDataDictionary[@"audi"]:@"";  //车系
    self.suitDataDictionary[@"accountr"] = self.suitDataDictionary[@"accountr"]?self.suitDataDictionary[@"accountr"]:@""; //应收帐款
    self.suitDataDictionary[@"rate"] = self.suitDataDictionary[@"rate"]?self.suitDataDictionary[@"rate"]:@"";
    self.suitDataDictionary[@"rate_cat"] = self.suitDataDictionary[@"rate_cat"]?self.suitDataDictionary[@"rate_cat"]:@"";
    self.suitDataDictionary[@"term"] = self.suitDataDictionary[@"term"]?self.suitDataDictionary[@"term"]:@"";
    self.suitDataDictionary[@"repaymethod"] = self.suitDataDictionary[@"repaymethod"]?self.suitDataDictionary[@"repaymethod"]:@"";
    self.suitDataDictionary[@"obligor"] = self.suitDataDictionary[@"obligor"]?self.suitDataDictionary[@"obligor"]:@"";
    self.suitDataDictionary[@"commitment"] = self.suitDataDictionary[@"commitment"]?self.suitDataDictionary[@"commitment"]:@"";
    self.suitDataDictionary[@"commissionperiod"] = self.suitDataDictionary[@"commissionperiod"]?self.suitDataDictionary[@"commissionperiod"]:@"";
    self.suitDataDictionary[@"paidmoney"] = self.suitDataDictionary[@"paidmoney"]?self.suitDataDictionary[@"paidmoney"]:@"";
    self.suitDataDictionary[@"interestpaid"] = self.suitDataDictionary[@"interestpaid"]?self.suitDataDictionary[@"interestpaid"]:@"";
    self.suitDataDictionary[@"performancecontract"] = self.suitDataDictionary[@"performancecontract"]?self.suitDataDictionary[@"performancecontract"]:@"";
    //债权人文件，债务人文件，债务人信息
    
    [self.suitDataDictionary setValue:@"3" forKey:@"category"];
    [self.suitDataDictionary setValue:typeString forKey:@"progress_status"];
    [self.suitDataDictionary setValue:[self getValidateToken] forKey:@"token"];
    
    NSDictionary *params = self.suitDataDictionary;
    
    [self requestDataPostWithString:reFinanceString params:params successBlock:^(id responseObject){
        
        BaseModel *suitModel = [BaseModel objectWithKeyValues:responseObject];
        
        [self showHint:suitModel.msg];
        
        if ([suitModel.code isEqualToString:@"0000"]) {
            if ([typeString intValue] == 0) {//保存
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
