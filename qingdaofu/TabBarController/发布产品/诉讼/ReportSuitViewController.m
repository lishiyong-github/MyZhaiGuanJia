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
#import "BrandsViewController.h"  //车牌
#import "GuarantyViewController.h"  //抵押物地址

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

//参数
@property (nonatomic,strong) NSMutableDictionary *suitDataDictionary;
@property (nonatomic,strong) NSMutableDictionary *suitImageDictionary;
@property (nonatomic,strong) NSString *rowString;    //债权类型
@property (nonatomic,strong) NSString *number;
@property (nonatomic,strong) NSMutableArray *creditorInfos;
@property (nonatomic,strong) NSMutableArray *borrowinginfos;

@end

@implementation ReportSuitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.categoryString integerValue] == 2) {
        self.navigationItem.title = @"发布清收";
    }else{
        self.navigationItem.title = @"发布诉讼";
    }
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self setupForDismissKeyboard];
    
    PublishingModel *suModel = self.suResponse.product;
    if (suModel) {
        if (suModel.loan_type) {
            if ([suModel.loan_type integerValue] == 1) {
                self.rowString = @"6";
                [self.sTextArray[0] replaceObjectAtIndex:4 withObject:@"抵押物地址"];
                [self.sHolderArray[0] replaceObjectAtIndex:4 withObject:@"选择抵押物地址"];
            }else if([suModel.loan_type integerValue] == 3){
                self.rowString = @"5";
                [self.sTextArray[0] replaceObjectAtIndex:4 withObject:@"机动车"];
                [self.sHolderArray[0] replaceObjectAtIndex:4 withObject:@"选择机动车品牌"];
            }else if ([suModel.loan_type integerValue] == 2){
                self.rowString = @"5";
                [self.sTextArray[0] replaceObjectAtIndex:4 withObject:@""];
                [self.sHolderArray[0] replaceObjectAtIndex:4 withObject:@"应收帐款"];
            }else if ([suModel.loan_type integerValue] == 4){
                self.rowString = @"4";
                [self.sTextArray[0] replaceObjectAtIndex:4 withObject:@"无抵押"];
                [self.sHolderArray[0] replaceObjectAtIndex:4 withObject:@"无抵押"];
            }
            _number = [NSString stringWithFormat:@"%d",[suModel.loan_type integerValue]];
        }
        [self.suitDataDictionary setValue:_number forKey:@"loan_type"];
    }else{
        self.rowString = @"6";
        _number = @"1";
        [self.suitDataDictionary setValue:_number forKey:@"loan_type"];
    }
    
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
        _repSuitSwitchView.layer.borderColor = kSeparateColor.CGColor;
        _repSuitSwitchView.layer.borderWidth = kLineWidth;
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

- (NSMutableDictionary *)suitImageDictionary
{
    if (!_suitImageDictionary) {
        _suitImageDictionary = [NSMutableDictionary dictionary];
    }
    return _suitImageDictionary;
}

- (NSMutableArray *)sTextArray
{
    if (!_sTextArray) {
        NSMutableArray *s1 = [NSMutableArray arrayWithArray:@[@"",@"借款本金",@"代理费用",@"",@"抵押物地址",@""]];
        NSMutableArray *s2 = [NSMutableArray arrayWithArray:@[@"|  补充信息(选填)",@"借款利率(%)",@"借款期限",@"还款方式",@"债务人主体",@"委托事项",@"委托代理期限(月)",@"已付本金",@"已付利息",@"",@"债权文件",@"债权人信息",@"债务人信息"]];
        _sTextArray = [NSMutableArray arrayWithObjects:s1,s2, nil];
    }
    return _sTextArray;
}

- (NSMutableArray *)sHolderArray
{
    if (!_sHolderArray) {
        NSMutableArray *w1 = [NSMutableArray arrayWithArray:@[@"",@"填写借款本金",@"填写代理费用",@"",@"填写抵押物地址",@""]];
        NSMutableArray *w2 = [NSMutableArray arrayWithArray:@[@"",@"能够给到融资方的利息",@"输入借款期限",@"",@"",@"",@"",@"填写已付本金",@"填写已付利息",@"",@"",@"",@"",@""]];
        _sHolderArray = [NSMutableArray arrayWithObjects:w1,w2, nil];
    }
    return _sHolderArray;
}

- (NSMutableArray *)creditorInfos
{
    if (!_creditorInfos) {
        _creditorInfos = [NSMutableArray array];
        for (DebtModel *model in self.suResponse.creditorinfos) {
            [_creditorInfos addObject:model];
        }
    }
    return _creditorInfos;
}

- (NSMutableArray *)borrowinginfos
{
    if (!_borrowinginfos) {
        _borrowinginfos = [NSMutableArray array];
        for (DebtModel *model in self.suResponse.borrowinginfos) {
            [_borrowinginfos addObject:model];
        }
    }
    return _borrowinginfos;
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
    
    PublishingModel *suModel = self.suResponse.product;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {//基本信息
            identifier = @"suitSect00";
            AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.agentTextField setHidden:YES];
            [cell.agentButton setHidden:YES];
            NSMutableAttributedString *dddd = [cell.agentLabel setAttributeString:@"|  基本信息" withColor:kBlueColor andSecond:@"(必填)" withColor:kBlackColor withFont:12];
            [cell.agentLabel setAttributedText:dddd];

            return cell;
        }else if (indexPath.row == 1){//借款本金
            identifier = @"suitSect01";
            
            AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.leftdAgentContraints.constant = 105;
            
            cell.agentLabel.text = self.sTextArray[0][indexPath.row];
            cell.agentTextField.placeholder = self.sHolderArray[0][indexPath.row];
            if (self.suitDataDictionary[@"money"]) {
                cell.agentTextField.text = self.suitDataDictionary[@"money"];
            }else{
                cell.agentTextField.text = suModel.money?suModel.money:@"";
            }
            [cell.agentButton setTitle:@"万元" forState:0];
            [cell setDidEndEditing:^(NSString *text) {
                [self.suitDataDictionary setValue:text forKey:@"money"];
            }];

            return cell;
        }else if (indexPath.row == 2){//代理费用
            identifier = @"suitSect02";
            AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.leftdAgentContraints.constant = 105;
            
            cell.agentLabel.text = self.sTextArray[0][indexPath.row];
            cell.agentTextField.placeholder = self.sHolderArray[0][indexPath.row];
            if (self.suitDataDictionary[@"agencycommission"]) {
                cell.agentTextField.text = self.suitDataDictionary[@"agencycommission"];
            }else{
                cell.agentTextField.text = suModel.agencycommission?suModel.agencycommission:@"";
            }
            if ([self.categoryString integerValue] == 2) {
                [cell.agentButton setTitle:@"%" forState:0];
                [cell setDidEndEditing:^(NSString *text) {
                    [self.suitDataDictionary setValue:text forKey:@"agencycommission"];
                }];
            }else{
                [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
                
                if (suModel.agencycommissiontype) {
                    NSArray *ffff = @[@"固定费用(万)",@"代理费率(%)"];
                    [cell.agentButton setTitle:ffff[[suModel.agencycommissiontype integerValue] - 1] forState:0];
                }else{
                    NSString *eeee = self.suitDataDictionary[@"agencycommissiontype_str"]?self.suitDataDictionary[@"agencycommissiontype_str"]:@"请选择";
                    [cell.agentButton setTitle:eeee forState:0];
                }
                
                cell.agentButton.tag = 2;
                [cell.agentButton addTarget:self action:@selector(showTitleOfUpwardView:) forControlEvents:UIControlEventTouchUpInside];
                
                [cell setDidEndEditing:^(NSString *text) {
                    [self.suitDataDictionary setValue:text forKey:@"agencycommission"];
                }];
            }
            
            return cell;
        }else if (indexPath.row == 3){//债权类型
            identifier = @"suitSect03";
            SuitBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[SuitBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.label.text = @"债权类型";
            if ([_number integerValue] == 1 || [_number integerValue] == 4) {
                cell.segment.selectedSegmentIndex = [_number integerValue]-1;
            }else if ([_number integerValue] == 3){
                cell.segment.selectedSegmentIndex = 1;
            }else{
                cell.segment.selectedSegmentIndex = 2;
            }
            
            //segment block
            [cell setDidSelectedSeg:^(NSInteger selectedTag) {
                AgentCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
                cell.agentTextField.text = @"";
                
                if (selectedTag == 0) {//房产抵押
                    self.rowString = @"6";
                    [self.sTextArray[0] replaceObjectAtIndex:4 withObject:@"抵押物地址"];
                    [self.sHolderArray[0] replaceObjectAtIndex:4 withObject:@"选择抵押物地址"];
                    _number = @"1";
                    
                }else if (selectedTag == 1){//机动车
                    [cell.agentButton setHidden:NO];
                    self.rowString = @"5";
                    [self.sTextArray[0] replaceObjectAtIndex:4 withObject:@"机动车"];
                    [self.sHolderArray[0] replaceObjectAtIndex:4 withObject:@"选择机动车品牌"];
                    _number = @"3";
                }else if (selectedTag == 2){//应收帐款
                    self.rowString = @"5";
                    [self.sTextArray[0] replaceObjectAtIndex:4 withObject:@""];
                    [self.sHolderArray[0] replaceObjectAtIndex:4 withObject:@"应收帐款"];
                    _number = @"2";
                    
                }else{//无抵押
                    self.rowString = @"4";
                    [self.sTextArray[0] replaceObjectAtIndex:4 withObject:@"无抵押"];
                    [self.sHolderArray[0] replaceObjectAtIndex:4 withObject:@"无抵押"];
                    _number = @"4";
                }
                
                [self.suitDataDictionary setValue:_number forKey:@"loan_type"];
                
                [self.suitTableView reloadData];
            }];
            
            return cell;
        }else if (indexPath.row == 4){//抵押物地址
            identifier = @"suitSect04";
            AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.leftdAgentContraints.constant = 105;
            cell.agentLabel.text = self.sTextArray[0][indexPath.row];
            cell.agentTextField.placeholder = self.sHolderArray[0][indexPath.row];

            if ([_number intValue] == 1) {//抵押物地址
                cell.agentTextField.userInteractionEnabled = NO;
                cell.agentTextField.text = suModel.mortorage_community?suModel.mortorage_community:self.suitDataDictionary[@"mortorage_community"];
                [cell.agentButton setHidden:NO];
                [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
                [cell.agentButton setTitle:@"请选择" forState:0];                
                QDFWeakSelf;
                QDFWeak(cell);
                [cell.agentButton addAction:^(UIButton *btn) {
                    GuarantyViewController *guarantyVC = [[GuarantyViewController alloc] init];
                    [guarantyVC setDidSelectedArea:^(NSString *mortorage_community, NSString *seatmortgage) {
                        
                        [weakself.suitDataDictionary setValue:mortorage_community forKey:@"mortorage_community"];
                        [weakself.suitDataDictionary setValue:seatmortgage forKey:@"seatmortgage"];
                        [weakself.suitTableView reloadData];
                    }];
                    
                    [weakself.navigationController pushViewController:guarantyVC animated:YES];
                }];
                
            }else if ([_number intValue] == 3){//机动车抵押
                cell.agentTextField.userInteractionEnabled = NO;
                if (suModel.carbrand) {
                    NSString *fff = [NSString stringWithFormat:@"%@ %@ %@",suModel.carbrand,suModel.audi,suModel.licenseplate];
                    cell.agentTextField.text = fff;
                }
                
                [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
                if (suModel.carbrand) {
                    [cell.agentButton setTitle:@"已选择" forState:0];
                }else{
                    [cell.agentButton setTitle:@"请选择" forState:0];
                }
                
                QDFWeak(cell);
                [cell.agentButton addAction:^(UIButton *btn) {
                    BrandsViewController *brandVC = [[BrandsViewController alloc] init];
                    
                    [brandVC setDidSelectedRow:^(NSString *brandNo,NSString *brand, NSString *audiNo,NSString *audi,NSString *licenseNo,NSString *license) {
                        [self.suitDataDictionary setValue:brandNo forKey:@"carbrand"];
                        [self.suitDataDictionary setValue:audiNo forKey:@"audi"];
                        [self.suitDataDictionary setValue:licenseNo forKey:@"licenseplate"];
                        
                        weakcell.agentTextField.text = [NSString stringWithFormat:@"%@  %@ %@",brand,audi,license];
//                        [weakcell.agentButton setTitle:@"已选择" forState:0];
                    }];
                    
                    [self.navigationController pushViewController:brandVC animated:YES];
                }];
            }else if ([_number intValue] == 2) {//应收帐款
                [cell.agentButton setHidden:YES];
                cell.agentTextField.text = suModel.accountr?suModel.accountr:@"";
                [cell setDidEndEditing:^(NSString *text) {
                    [self.suitDataDictionary setValue:text forKey:@"accountr"];
                }];
            }
            
        return cell;
        }else if (indexPath.row == 5){//详细地址
            identifier = @"suitSect05";
            EditDebtAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[EditDebtAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.leftTextViewConstraints.constant = 100;
            
            cell.ediTextView.placeholder = @"详细地址";
            if (self.suitDataDictionary[@"seatmortgage"]) {
                cell.ediTextView.text = self.suitDataDictionary[@"seatmortgage"];
            }else{
                cell.ediTextView.text = suModel.seatmortgage?suModel.seatmortgage:@"";
            }
            
            [cell setDidEndEditing:^(NSString *text) {
                [self.suitDataDictionary setValue:text forKey:@"seatmortgage"];
            }];
            
            return cell;
        }
    }
    
    //section ＝ 1
    if (indexPath.row == 0) {//补充信息
        identifier = @"suitSect10";
        
        AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftdAgentContraints.constant = 105;
        [cell.agentTextField setHidden:YES];
        [cell.agentButton setHidden:YES];
        
        NSMutableAttributedString *ffff = [cell.agentLabel setAttributeString:@"|  补充信息" withColor:kBlueColor andSecond:@"(选填)" withColor:kBlackColor withFont:12];
        [cell.agentLabel setAttributedText:ffff];
        
        return cell;
    }else if (indexPath.row == 1){//借款利率
        identifier = @"suitSect1";
        
        AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftdAgentContraints.constant = 105;
        cell.agentLabel.text = self.sTextArray[1][indexPath.row];
        cell.agentTextField.placeholder = self.sHolderArray[1][indexPath.row];
        if (self.suitDataDictionary[@"rate"]) {
            cell.agentTextField.text = self.suitDataDictionary[@"rate"];
        }else{
            cell.agentTextField.text = suModel.rate?suModel.rate:@"";
        }
        [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        
        if (suModel.rate_cat) {
            NSArray *ffff = @[@"天(%)",@"月(%)"];
            [cell.agentButton setTitle:ffff[[suModel.rate_cat integerValue] -1] forState:0];
        }else{
            NSString *eeee = self.suitDataDictionary[@"rate_cat_str"]?self.suitDataDictionary[@"rate_cat_str"]:@"请选择";
            [cell.agentButton setTitle:eeee forState:0];
        }
        
        cell.agentButton.tag = 8;
        [cell.agentButton addTarget:self action:@selector(showTitleOfUpwardView:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell setDidEndEditing:^(NSString *text) {
            [self.suitDataDictionary setValue:text forKey:@"rate"];
        }];
        
        return cell;
    }else if (indexPath.row == 2){//借款期限
        identifier = @"suitSect1";
        
        AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftdAgentContraints.constant = 105;
        cell.agentLabel.text = self.sTextArray[1][indexPath.row];
        cell.agentTextField.placeholder = self.sHolderArray[1][indexPath.row];
        if (self.suitDataDictionary[@"term"]) {
            cell.agentTextField.text = self.suitDataDictionary[@"term"];
        }else{
            cell.agentTextField.text = suModel.term?suModel.term:@"";
        }
        [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        if (suModel.rate_cat) {
            NSArray *ffff = @[@"天",@"月"];
            [cell.agentButton setTitle:ffff[[suModel.rate_cat integerValue] - 1] forState:0];
        }else{
            NSString *eeee = self.suitDataDictionary[@"rate_cat_str"]?self.suitDataDictionary[@"rate_cat_str"]:@"请选择";
            [cell.agentButton setTitle:eeee forState:0];
        }
        
        cell.agentButton.tag = 9;
        [cell.agentButton addTarget:self action:@selector(showTitleOfUpwardView:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell setDidEndEditing:^(NSString *text) {
            [self.suitDataDictionary setValue:text forKey:@"term"];
        }];
        
        return cell;
    }else if (indexPath.row == 3){//还款方式
        identifier = @"suitSect1";
        
        AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftdAgentContraints.constant = 105;
        [cell.agentTextField setHidden:YES];
        
        cell.agentLabel.text = self.sTextArray[1][indexPath.row];
        [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        if (suModel.repaymethod) {
            NSArray *ffff = @[@"一次性到期还本付息",@"按月付息，到期还本"];
            [cell.agentButton setTitle:ffff[[suModel.repaymethod integerValue] -1] forState:0];
        }else{
            NSString *eeee = self.suitDataDictionary[@"repaymethod_str"]?self.suitDataDictionary[@"repaymethod_str"]:@"请选择";
            [cell.agentButton setTitle:eeee forState:0];
        }
        
        cell.agentButton.tag = 10;
        [cell.agentButton addTarget:self action:@selector(showTitleOfUpwardView:) forControlEvents:UIControlEventTouchUpInside];

        return cell;
    }else if (indexPath.row == 4){//债务人主体
        identifier = @"suitSect1";
        
        AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftdAgentContraints.constant = 105;
        [cell.agentTextField setHidden:YES];
        
        cell.agentLabel.text = self.sTextArray[1][indexPath.row];

        [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        if (suModel.obligor) {
            NSArray *ffff = @[@"自然人",@"法人",@"其他"];
            [cell.agentButton setTitle:ffff[[suModel.obligor integerValue] - 1] forState:0];
        }else{
            NSString *eeee = self.suitDataDictionary[@"obligor_str"]?self.suitDataDictionary[@"obligor_str"]:@"请选择";
            [cell.agentButton setTitle:eeee forState:0];
        }
        cell.agentButton.tag = 11;
        [cell.agentButton addTarget:self action:@selector(showTitleOfUpwardView:) forControlEvents:UIControlEventTouchUpInside];

        return cell;
    }else if (indexPath.row == 5){//委托事项
        identifier = @"suitSect1";
        
        AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftdAgentContraints.constant = 105;
        [cell.agentTextField setHidden:YES];
        
        cell.agentLabel.text = self.sTextArray[1][indexPath.row];
        [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        if (suModel.commitment) {
            NSArray *ffff = @[@"代理诉讼",@"代理仲裁",@"代理执行"];
            [cell.agentButton setTitle:ffff[[suModel.commitment integerValue] -1] forState:0];
        }else{
            NSString *eeee = self.suitDataDictionary[@"commitment_str"]?self.suitDataDictionary[@"commitment_str"]:@"请选择";
            [cell.agentButton setTitle:eeee forState:0];
        }
        
        cell.agentButton.tag = 12;
        [cell.agentButton addTarget:self action:@selector(showTitleOfUpwardView:) forControlEvents:UIControlEventTouchUpInside];

        return cell;
    }else if (indexPath.row == 6){//委托代理期限
        identifier = @"suitSect1";
        
        AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftdAgentContraints.constant = 105;
        [cell.agentTextField setHidden:YES];
        
        cell.agentLabel.text = self.sTextArray[1][indexPath.row];
        [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        if (suModel.commissionperiod) {
            [cell.agentButton setTitle:suModel.commissionperiod forState:0];
        }else{
            NSString *eeee = self.suitDataDictionary[@"commissionperiod_str"]?self.suitDataDictionary[@"commissionperiod_str"]:@"请选择";
            [cell.agentButton setTitle:eeee forState:0];
        }
        
        cell.agentButton.tag = 13;
        [cell.agentButton addTarget:self action:@selector(showTitleOfUpwardView:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }else if (indexPath.row == 7){//已付本金
        identifier = @"suitSect1";
        
        AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftdAgentContraints.constant = 105;
        
        cell.agentLabel.text = self.sTextArray[1][indexPath.row];
        cell.agentTextField.placeholder = self.sHolderArray[1][indexPath.row];
        if (self.suitDataDictionary[@"paidmoney"]) {
            cell.agentTextField.text = self.suitDataDictionary[@"paidmoney"];
        }else{
            cell.agentTextField.text = suModel.paidmoney?suModel.paidmoney:@"";
        }
        [cell.agentButton setTitle:@"元" forState:0];
        
        [cell setDidEndEditing:^(NSString *text) {
            [self.suitDataDictionary setValue:text forKey:@"paidmoney"];
        }];

        return cell;
    }else if (indexPath.row == 8){//已付利息
        identifier = @"suitSect1";
        
        AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftdAgentContraints.constant = 105;
        cell.agentLabel.text = self.sTextArray[1][indexPath.row];
        cell.agentTextField.placeholder = self.sHolderArray[1][indexPath.row];
        if (self.suitDataDictionary[@"interestpaid"]) {
            cell.agentTextField.text = self.suitDataDictionary[@"interestpaid"];
        }else{
            cell.agentTextField.text = suModel.interestpaid?suModel.interestpaid:@"";
        }
        [cell.agentButton setTitle:@"元" forState:0];
        
        [cell setDidEndEditing:^(NSString *text) {
            [self.suitDataDictionary setValue:text forKey:@"interestpaid"];
        }];

        return cell;
    }else if (indexPath.row == 9){//合同履行地
        identifier = @"suitSect19";
        
        EditDebtAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[EditDebtAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftTextViewConstraints.constant = 100;
        cell.ediLabel.text = @"合同履行地";
        cell.ediTextView.placeholder = @"填写合同履行地";
        if (self.suitDataDictionary[@"performancecontract"]) {
            cell.ediTextView.text = self.suitDataDictionary[@"performancecontract"];
        }else{
            cell.ediTextView.text = suModel.performancecontract?suModel.performancecontract:@"";
        }
        [cell setDidEndEditing:^(NSString *text) {
            [self.suitDataDictionary setValue:text forKey:@"performancecontract"];
        }];
        
        return cell;
    }else if (indexPath.row == 10){//债权文件
        identifier = @"suitSect110";
        
        AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftdAgentContraints.constant = 105;
        
        cell.agentLabel.text = self.sTextArray[1][indexPath.row];
        [cell.agentTextField setHidden:YES];
        [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        [cell.agentButton setTitle:@"上传" forState:0];
        cell.agentButton.userInteractionEnabled = NO;
        return cell;
    }else if (indexPath.row == 11){//债权人信息
        identifier = @"suitSect1";
        
        AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftdAgentContraints.constant = 105;
        [cell.agentTextField setHidden:YES];
        
        cell.agentLabel.text = self.sTextArray[1][indexPath.row];
        [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        [cell.agentButton setTitle:@"完善" forState:0];
        cell.agentButton.userInteractionEnabled = NO;
        return cell;
    }else if (indexPath.row == 12){//债务人信息
        identifier = @"suitSect1";
        
        AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftdAgentContraints.constant = 105;
        [cell.agentTextField setHidden:YES];
        
        cell.agentLabel.text = self.sTextArray[1][indexPath.row];
        [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        [cell.agentButton setTitle:@"完善" forState:0];
        cell.agentButton.userInteractionEnabled = NO;
        return cell;
    }
    
    return nil;
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (indexPath.row == 10) {//债权文件
            UploadFilesViewController *uploadFilesVC = [[UploadFilesViewController alloc] init];
            
            QDFWeakSelf;
            [uploadFilesVC setChooseImages:^(NSDictionary *imageDic) {                weakself.suitImageDictionary = [NSMutableDictionary dictionaryWithDictionary:imageDic];
            }];
            
            [self.navigationController pushViewController:uploadFilesVC animated:YES];
        }else if (indexPath.row == 11){//债权人信息
            DebtCreditMessageViewController *debtCreditMessageVC = [[DebtCreditMessageViewController alloc] init];
            debtCreditMessageVC.categoryString = @"1";
            debtCreditMessageVC.debtArray = self.creditorInfos;
            [debtCreditMessageVC setDidEndEditting:^(NSArray *arrays) {
                NSString *qqq = @"";
                NSString *endStr = @"";
                for (NSInteger i=0; i<arrays.count; i++) {
                    DebtModel *model = arrays[i];

                    qqq = [NSString stringWithFormat:@"creditorname-%d=%@,creditormobile-%d=%@,creditorcardcode-%d=%@,creditoraddress-%d=%@",i,model.creditorname,i,model.creditormobile,i,model.creditorcardcode,i,model.creditoraddress];
                    
                    endStr = [NSString stringWithFormat:@"%@,%@",endStr,qqq];
                }
//
                self.creditorInfos = [NSMutableArray arrayWithArray:arrays];
                [self.suitDataDictionary setValue:endStr forKey:@"creditorinfo"];
            }];
            [self.navigationController pushViewController:debtCreditMessageVC animated:YES];
            
        }else if (indexPath.row == 12){//债务人信息
            DebtCreditMessageViewController *debtCreditMessageVC = [[DebtCreditMessageViewController alloc] init];
            debtCreditMessageVC.categoryString = @"2";
            debtCreditMessageVC.debtArray = self.borrowinginfos;
            [debtCreditMessageVC setDidEndEditting:^(NSArray *arrays) {
                NSString *ppp = @"";
                NSString *endStr = @"";
                for (NSInteger i=0; i<arrays.count; i++) {
                    DebtModel *model = arrays[i];
                    ppp = [NSString stringWithFormat:@"borrowingname-%d=%@,borrowingmobile-%d=%@,borrowingaddress-%d=%@,borrowingcardcode-%d=%@",i,model.borrowingname,i,model.borrowingmobile,i,model.borrowingaddress,i,model.borrowingcardcode];
                    
                    endStr = [NSString stringWithFormat:@"%@,%@",endStr,ppp];
                }
                self.borrowinginfos = [NSMutableArray arrayWithArray:arrays];
                [self.suitDataDictionary setValue:endStr forKey:@"borrowinginfo"];
            }];
                [self.navigationController pushViewController:debtCreditMessageVC animated:YES];
        }
    }
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
    [self.view endEditing:YES];
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
                [self.suitDataDictionary setValue:text forKey:@"agencycommissiontype_str"];
            }];
        }
            break;
        case 8:{//借款利率
            [self showBlurInView:self.view withArray:arr8 andTitle:@"选择借款利率类型" finishBlock:^(NSString *text,NSInteger row) {
                [btn setTitle:text forState:0];
                NSString *value = [NSString stringWithFormat:@"%d",row];
                [self.suitDataDictionary setValue:value forKey:@"rate_cat"];
                [self.suitDataDictionary setValue:text forKey:@"rate_cat_str"];

                UIButton *elseBtn = [self.suitTableView viewWithTag:9];
                [elseBtn setTitle:text forState:0];
                
            }];
        }
            break;
        case 9:{//借款期限
            [self showBlurInView:self.view withArray:arr8 andTitle:@"选择借款期限类型" finishBlock:^(NSString *text,NSInteger row) {
                [btn setTitle:text forState:0];
                
                NSString *value = [NSString stringWithFormat:@"%d",row];
                [self.suitDataDictionary setValue:value forKey:@"rate_cat"];
                [self.suitDataDictionary setValue:text forKey:@"rate_cat_str"];

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
                [self.suitDataDictionary setValue:text forKey:@"repaymethod_str"];

            }];
        }
            break;
        case 11:{//债务人主体
            [self showBlurInView:self.view withArray:arr11 andTitle:@"选择债务人主体" finishBlock:^(NSString *text,NSInteger row) {
                [btn setTitle:text forState:0];
                
                NSString *value = [NSString stringWithFormat:@"%d",row];
                [self.suitDataDictionary setValue:value forKey:@"obligor"];
                [self.suitDataDictionary setValue:text forKey:@"obligor_str"];

            }];
        }
            break;
        case 12:{//委托事项
            [self showBlurInView:self.view withArray:arr12 andTitle:@"选择委托事项" finishBlock:^(NSString *text,NSInteger row) {
                [btn setTitle:text forState:0];
                
                NSString *value = [NSString stringWithFormat:@"%d",row];
                [self.suitDataDictionary setValue:value forKey:@"commitment"];
                [self.suitDataDictionary setValue:text forKey:@"commitment_str"];

            }];
        }
            break;
        case 13:{//委托代理期限
            [self showBlurInView:self.view withArray:arr13 andTitle:@"选择委托代理期限" finishBlock:^(NSString *text,NSInteger row) {
                [btn setTitle:text forState:0];
                
                NSString *value = [NSString stringWithFormat:@"%d",row];
                [self.suitDataDictionary setValue:value forKey:@"commissionperiod"];
                [self.suitDataDictionary setValue:text forKey:@"commissionperiod_str"];
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
    self.suitDataDictionary[@"money"] = self.suitDataDictionary[@"money"]?self.suitDataDictionary[@"money"]:self.suResponse.product.money; //融资金额，万为单位
    self.suitDataDictionary[@"agencycommission"] = self.suitDataDictionary[@"agencycommission"]?self.suitDataDictionary[@"agencycommission"]:self.suResponse.product.agencycommission;
    self.suitDataDictionary[@"loan_type"] = self.suitDataDictionary[@"loan_type"]?self.suitDataDictionary[@"loan_type"]:self.suResponse.product.loan_type;
    self.suitDataDictionary[@"mortorage_community"] = self.suitDataDictionary[@"mortorage_community"]?self.suitDataDictionary[@"mortorage_community"]:self.suResponse.product.mortorage_community;//抵押物地址
    self.suitDataDictionary[@"seatmortgage"] = self.suitDataDictionary[@"seatmortgage"]?self.suitDataDictionary[@"seatmortgage"]:self.suResponse.product.seatmortgage; //详细地址
    self.suitDataDictionary[@"province_id"] = @"0";
    self.suitDataDictionary[@"city_id"] = @"0";
    self.suitDataDictionary[@"district_id"] = @"0";
    self.suitDataDictionary[@"carbrand"] = self.suitDataDictionary[@"carbrand"]?self.suitDataDictionary[@"carbrand"]:self.suResponse.product.carbrand;   //车品牌
    self.suitDataDictionary[@"audi"] = self.suitDataDictionary[@"audi"]?self.suitDataDictionary[@"audi"]:self.suResponse.product.audi;  //车系
    self.suitDataDictionary[@"accountr"] = self.suitDataDictionary[@"accountr"]?self.suitDataDictionary[@"accountr"]:self.suResponse.product.accountr; //应收帐款
    self.suitDataDictionary[@"rate"] = self.suitDataDictionary[@"rate"]?self.suitDataDictionary[@"rate"]:self.suResponse.product.rate;  //借款利率
    self.suitDataDictionary[@"rate_cat"] = self.suitDataDictionary[@"rate_cat"]?self.suitDataDictionary[@"rate_cat"]:self.suResponse.product.rate_cat;//借款利率单位
    self.suitDataDictionary[@"term"] = self.suitDataDictionary[@"term"]?self.suitDataDictionary[@"term"]:self.suResponse.product.term;//借款期限
    self.suitDataDictionary[@"repaymethod"] = self.suitDataDictionary[@"repaymethod"]?self.suitDataDictionary[@"repaymethod"]:self.suResponse.product.repaymethod;//付款方式
    self.suitDataDictionary[@"obligor"] = self.suitDataDictionary[@"obligor"]?self.suitDataDictionary[@"obligor"]:self.suResponse.product.obligor;//债务人主体
    self.suitDataDictionary[@"commitment"] = self.suitDataDictionary[@"commitment"]?self.suitDataDictionary[@"commitment"]:self.suResponse.product.commitment;//委托事项
    self.suitDataDictionary[@"commissionperiod"] = self.suitDataDictionary[@"commissionperiod"]?self.suitDataDictionary[@"commissionperiod"]:self.suResponse.product.commissionperiod;  //委托代理期限
    self.suitDataDictionary[@"paidmoney"] = self.suitDataDictionary[@"paidmoney"]?self.suitDataDictionary[@"paidmoney"]:self.suResponse.product.paidmoney;//已付本金
    self.suitDataDictionary[@"interestpaid"] = self.suitDataDictionary[@"interestpaid"]?self.suitDataDictionary[@"interestpaid"]:self.suResponse.product.interestpaid; //已付利息
    self.suitDataDictionary[@"performancecontract"] = self.suitDataDictionary[@"performancecontract"]?self.suitDataDictionary[@"performancecontract"]:self.suResponse.product.performancecontract; //合同履行地
       
    [self.suitDataDictionary setValue:self.categoryString forKey:@"category"];
    [self.suitDataDictionary setValue:typeString forKey:@"progress_status"];
    [self.suitDataDictionary setValue:[self getValidateToken] forKey:@"token"];
    
    NSString *idStr = self.suResponse.product.idString?self.suResponse.product.idString:@"";
    [self.suitDataDictionary setValue:idStr forKey:@"id"];
    
    NSDictionary *params = self.suitDataDictionary;
    
    [self requestDataPostWithString:reFinanceString params:params andImages:self.suitImageDictionary successBlock:^(id responseObject) {
        
        NSDictionary *ssss = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"sssssss %@",ssss);
        
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
                if ([self.categoryString integerValue] == 1) {
                    reportFiSucVC.reportType = @"清收";
                }else{
                    reportFiSucVC.reportType = @"诉讼";
                }
                [self.navigationController pushViewController:reportFiSucVC animated:YES];
            }
        }
        
    } andFailBlock:^(NSError *error) {
        
    }];
    
    
    
    /*
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
                if ([self.categoryString integerValue] == 1) {
                    reportFiSucVC.reportType = @"清收";
                }else{
                    reportFiSucVC.reportType = @"诉讼";
                }
                [self.navigationController pushViewController:reportFiSucVC animated:YES];
            }
        }
    } andFailBlock:^(NSError *error){
        
    }];
    */
}

/*
- (void)reportSuitActionWithTypeString1:(NSString *)typeString
{
    NSString *rrrString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMySavePublishEditString];
    NSDictionary *params = @{@"id":self.suResponse.product.idString,
                             @"category" : self.suResponse.product.category,
                             @"token" : [self getValidateToken]
                             };
    [self requestDataPostWithString:rrrString params:params successBlock:^(id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"******** %@",dic);
        
    } andFailBlock:^(NSError *error) {
        
    }];
}
 */

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
