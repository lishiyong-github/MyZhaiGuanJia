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
#import "UIViewController+BlurView.h"

#import "AgentCell.h"
#import "EditDebtAddressCell.h"
#import "SuitBaseCell.h"

@interface ReportSuitViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *suitTableView;
@property (nonatomic,strong) ReportFootView *repSuitFootButton;
@property (nonatomic,strong) UIButton *suitRightButton;

@property (nonatomic,strong) NSMutableArray *suitDataList;  //收起展开
@property (nonatomic,strong) NSMutableArray *sTextArray;
@property (nonatomic,strong) NSMutableArray *sHolderArray;

//参数
@property (nonatomic,strong) NSMutableDictionary *suitDataDictionary;
@property (nonatomic,strong) NSString *rowString;    //债权类型
@property (nonatomic,strong) NSString *number;//1.抵押物地址，2.应收帐款，3.机动车抵押，4.无抵押
@property (nonatomic,strong) NSMutableArray *creditorInfos;
@property (nonatomic,strong) NSMutableArray *borrowinginfos;
@property (nonatomic,strong) NSMutableDictionary *creditorfiles;

@end

@implementation ReportSuitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.categoryString integerValue] == 2) {
        self.navigationItem.title = @"发布清收";
    }else{
        self.navigationItem.title = @"发布诉讼";
    }
    
    self.navigationItem.leftBarButtonItem = self.leftItemAnother;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.suitRightButton];
    
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
            _number = [NSString stringWithFormat:@"%ld",(long)[suModel.loan_type integerValue]];
        }
        [self.suitDataDictionary setValue:_number forKey:@"loan_type"];
    }else{
        self.rowString = @"6";
        _number = @"1";
        [self.suitDataDictionary setValue:_number forKey:@"loan_type"];
    }
    
    [self.view addSubview:self.suitTableView];
    [self.view setNeedsUpdateConstraints];
    
//    [self addKeyboardObserver];
}

- (void)dealloc
{
    [self removeKeyboardObserver];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.suitTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)suitTableView
{
    if (!_suitTableView) {
        _suitTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _suitTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _suitTableView.backgroundColor = kBackColor;
        _suitTableView.separatorColor = kSeparateColor;
        _suitTableView.delegate = self;
        _suitTableView.dataSource = self;
        _suitTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 90)];
        [_suitTableView.tableFooterView addSubview:self.repSuitFootButton];
        _suitTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSmallPadding)];
    }
    return _suitTableView;
}

- (ReportFootView *)repSuitFootButton
{
    if (!_repSuitFootButton) {
        _repSuitFootButton = [[ReportFootView alloc] initWithFrame:CGRectMake(kBigPadding, 0, kScreenWidth-kBigPadding*2, 70)];
        _repSuitFootButton.backgroundColor = kBlueColor;
        [_repSuitFootButton addTarget:self action:@selector(openAndCloses:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _repSuitFootButton;
}
- (UIButton *)suitRightButton
{
    if (!_suitRightButton) {
        _suitRightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
        [_suitRightButton setTitle:@"发布" forState:0];
        _suitRightButton.titleLabel.font = kFirstFont;
        [_suitRightButton setTitleColor:kBlueColor forState:0];
        
        QDFWeakSelf;
        [_suitRightButton addAction:^(UIButton *btn) {
            [weakself reportSuitActionWithTypeString:@"1"];
        }];
    }
    return _suitRightButton;
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
        NSMutableArray *s1 = [NSMutableArray arrayWithArray:@[@"",@"借款本金",@"代理费用",@"债券类型",@"抵押物地址",@""]];
        NSMutableArray *s2 = [NSMutableArray arrayWithArray:@[@"|  选填信息(选填)",@"借款利率",@"借款期限",@"还款方式",@"债务人主体",@"委托代理期限",@"已付本金",@"已付利息",@"",@"债权文件",@"债权人信息",@"债务人信息"]];
        _sTextArray = [NSMutableArray arrayWithObjects:s1,s2, nil];
    }
    return _sTextArray;
}

- (NSMutableArray *)sHolderArray
{
    if (!_sHolderArray) {
        NSMutableArray *w1 = [NSMutableArray arrayWithArray:@[@"",@"填写借款本金",@"请填写代理费用",@"",@"",@""]];
        NSMutableArray *w2 = [NSMutableArray arrayWithArray:@[@"",@"能够给到融资方的利息",@"输入借款期限",@"",@"",@"",@"填写已付本金",@"填写已付利息",@"",@"",@"",@"",@""]];
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

- (NSMutableDictionary *)creditorfiles
{
    if (!_creditorfiles) {
        _creditorfiles = [NSMutableDictionary dictionary];
        
        if (self.suResponse.creditorfiles.imgnotarization) {
            [_creditorfiles setObject:self.suResponse.creditorfiles.imgnotarization forKey:@"imgnotarization"];
        }
        if (self.suResponse.creditorfiles.imgcontract) {
            [_creditorfiles setObject:self.suResponse.creditorfiles.imgcontract forKey:@"imgcontract"];
        }
        if (self.suResponse.creditorfiles.imgcreditor) {
            [_creditorfiles setObject:self.suResponse.creditorfiles.imgcreditor forKey:@"imgcreditor"];
        }
        if (self.suResponse.creditorfiles.imgpick) {
            [_creditorfiles setObject:self.suResponse.creditorfiles.imgpick forKey:@"imgpick"];
        }
        if (self.suResponse.creditorfiles.imgshouju) {
            [_creditorfiles setObject:self.suResponse.creditorfiles.imgbenjin forKey:@"imgshouju"];
        }
        if (self.suResponse.creditorfiles.imgbenjin) {
            [_creditorfiles setObject:self.suResponse.creditorfiles.imgshouju forKey:@"imgbenjin"];
        }
    }
    return _creditorfiles;
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
    return 12;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.section == 0) && (indexPath.row == 5)) {
        return 62;
    }else if ((indexPath.section == 1) && (indexPath.row == 8)){
        return 62;
    }
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    
    PublishingModel *suModel = self.suResponse.product;
    QDFWeakSelf;
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
            NSMutableAttributedString *dddd = [cell.agentLabel setAttributeString:@"|  基本信息" withColor:kBlueColor andSecond:@"（必填）" withColor:kBlackColor withFont:12];
            [cell.agentLabel setAttributedText:dddd];

            return cell;
        }else if (indexPath.row == 1){//借款本金
            identifier = @"suitSect01";
            
            AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.leftdAgentContraints.constant = 110;
            cell.agentTextField.keyboardType = UIKeyboardTypeNumberPad;
            
            [cell setTouchBeginPoint:^(CGPoint point) {
                weakself.touchPoint = point;
            }];
            
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
        }else if (indexPath.row == 2){//代理费用类型
            identifier = @"suitSect02";
            AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.leftdAgentContraints.constant = 110;
            cell.agentTextField.keyboardType = UIKeyboardTypeNumberPad;

            [cell setTouchBeginPoint:^(CGPoint point) {
                weakself.touchPoint = point;
            }];
            
            cell.agentLabel.text = self.sTextArray[0][indexPath.row];
            cell.agentTextField.placeholder = self.sHolderArray[0][indexPath.row];
            if (self.suitDataDictionary[@"agencycommission"]) {
                cell.agentTextField.text = self.suitDataDictionary[@"agencycommission"];
            }else{
                cell.agentTextField.text = suModel.agencycommission?suModel.agencycommission:@"";
            }
            
            //代理费用
            [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
            NSArray *dede;
            if ([self.categoryString integerValue] == 2) {
                dede = @[@"服务佣金(%)",@"固定费用(万元)"];
            }else{
                dede = @[@"固定费用(万元)",@"代理费率(%)"];
            }
            
            if (suModel.agencycommissiontype) {
                [cell.agentButton setTitle:dede[[suModel.agencycommissiontype integerValue] - 1] forState:0];
            }else{
                NSString *eeee = self.suitDataDictionary[@"agencycommissiontype_str"]?self.suitDataDictionary[@"agencycommissiontype_str"]:@"请选择";
                [cell.agentButton setTitle:eeee forState:0];
            }
            
            [cell setDidEndEditing:^(NSString *text) {
                [self.suitDataDictionary setValue:text forKey:@"agencycommission"];
            }];
            
            if ([self.categoryString integerValue] == 2) {
                cell.agentButton.tag = 22;
            }else{
                cell.agentButton.tag = 2;
            }
            [cell.agentButton addTarget:self action:@selector(showTitleOfUpwardViews:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
        }else if (indexPath.row == 3){//债权类型
            identifier = @"suitSect03";
            
            AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.agentLabel.text = @"债权类型";
            cell.agentTextField.userInteractionEnabled = NO;
            [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        
            if ([_number integerValue] == 1) {
                [cell.agentButton setTitle:@"房产抵押" forState:0];
            }else if([_number integerValue] == 2){
                [cell.agentButton setTitle:@"应收账款" forState:0];
            }else if ([_number integerValue] == 3){
                [cell.agentButton setTitle:@"机动车抵押" forState:0];
            }else if ([_number integerValue] == 4){
                [cell.agentButton setTitle:@"无抵押" forState:0];
            }else{
                [cell.agentButton setTitle:@"请选择" forState:0];
            }
            
            cell.agentButton.tag = 3;
            [cell.agentButton addTarget:self action:@selector(showTitleOfUpwardViews:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
        }else if (indexPath.row == 4){//抵押物地址
            identifier = @"suitSect04";
            AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.leftdAgentContraints.constant = 110;
            cell.agentLabel.text = self.sTextArray[0][indexPath.row];
            cell.agentTextField.placeholder = self.sHolderArray[0][indexPath.row];
            [cell setTouchBeginPoint:^(CGPoint point) {
                weakself.touchPoint = point;
            }];

            if ([_number intValue] == 1) {//抵押物地址
                cell.agentTextField.userInteractionEnabled = NO;
                cell.agentTextField.text = suModel.mortorage_community?suModel.mortorage_community:self.suitDataDictionary[@"mortorage_community"];
                
                [cell.agentButton setHidden:NO];
                cell.agentButton.userInteractionEnabled = YES;
                [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
                [cell.agentButton setTitle:@"请选择区域" forState:0];
                
                [cell.agentButton addAction:^(UIButton *btn) {
                    GuarantyViewController *guarantyVC = [[GuarantyViewController alloc] init];
                    [weakself.navigationController pushViewController:guarantyVC animated:YES];
                    [guarantyVC setDidSelectedArea:^(NSString *mortorage_community, NSString *seatmortgage) {
                        
                        [weakself.suitDataDictionary setValue:mortorage_community forKey:@"mortorage_community"];
                        [weakself.suitDataDictionary setValue:seatmortgage forKey:@"seatmortgage"];
                        [weakself.suitTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:4 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                        [weakself.suitTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:5 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                    }];
                    
                }];
                
            }else if ([_number intValue] == 3){//机动车抵押
                cell.agentTextField.userInteractionEnabled = NO;
                NSString *carbr = @"";
                if (self.suitDataDictionary[@"carbrandstr"]) {
                    carbr = [NSString stringWithFormat:@"%@%@%@",self.suitDataDictionary[@"carbrandstr"],self.suitDataDictionary[@"audistr"],self.suitDataDictionary[@"licenseplatestr"]];
                }
                
                NSString *carLisenceStr;
                if (self.suResponse.car && self.suResponse.license) {
                    carLisenceStr = [NSString stringWithFormat:@"%@%@",self.suResponse.car,self.suResponse.license];
                }
                cell.agentTextField.text = carLisenceStr?carLisenceStr:carbr;

                [cell.agentButton setHidden:NO];
                [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
                [cell.agentButton setTitle:@"请选择" forState:0];
                cell.agentButton.userInteractionEnabled = YES;

                QDFWeak(cell);
                [cell.agentButton addAction:^(UIButton *btn) {
                    BrandsViewController *brandVC = [[BrandsViewController alloc] init];
                    [brandVC setDidSelectedRow:^(NSString *brandNo,NSString *brand, NSString *audiNo,NSString *audi,NSString *licenseNo,NSString *license) {
                        [self.suitDataDictionary setValue:brandNo forKey:@"carbrand"];
                        [self.suitDataDictionary setValue:audiNo forKey:@"audi"];
                        [self.suitDataDictionary setValue:licenseNo forKey:@"licenseplate"];
                        [self.suitDataDictionary setValue:brand forKey:@"carbrandstr"];
                        [self.suitDataDictionary setValue:audi forKey:@"audistr"];
                        [self.suitDataDictionary setValue:license forKey:@"licenseplatestr"];
                        
                        weakcell.agentTextField.text = [NSString stringWithFormat:@"%@  %@ %@",brand,audi,license];
                    }];
                    
                    [self.navigationController pushViewController:brandVC animated:YES];
                }];
            }else if ([_number intValue] == 2) {//应收帐款
                cell.agentTextField.userInteractionEnabled = YES;
                cell.agentTextField.text = suModel.accountr?suModel.accountr:self.suitDataDictionary[@"accountr"];
                
                [cell.agentButton setHidden:NO];
                [cell.agentButton setTitle:@"万元" forState:0];
                [cell.agentButton setImage:[UIImage imageNamed:@""] forState:0];
                cell.agentButton.userInteractionEnabled = NO;

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
            cell.leftTextViewConstraints.constant = 105;
            [cell setTouchBeginPoint:^(CGPoint point) {
                weakself.touchPoint = point;
            }];
            
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
        cell.leftdAgentContraints.constant = 110;
        [cell.agentTextField setHidden:YES];
        [cell.agentButton setHidden:YES];
        
        NSMutableAttributedString *ffff = [cell.agentLabel setAttributeString:@"|  补充信息" withColor:kBlueColor andSecond:@"（选填）" withColor:kBlackColor withFont:12];
        [cell.agentLabel setAttributedText:ffff];
        
        return cell;
    }else if (indexPath.row == 1){//借款利率
        identifier = @"suitSect1";
        
        AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftdAgentContraints.constant = 110;
        cell.agentTextField.keyboardType = UIKeyboardTypeNumberPad;

        cell.agentLabel.text = self.sTextArray[1][indexPath.row];
        cell.agentTextField.placeholder = self.sHolderArray[1][indexPath.row];
        [cell setTouchBeginPoint:^(CGPoint point) {
            weakself.touchPoint = point;
        }];
        
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
        [cell.agentButton addTarget:self action:@selector(showTitleOfUpwardViews:) forControlEvents:UIControlEventTouchUpInside];
        
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
        cell.leftdAgentContraints.constant = 110;
        cell.agentTextField.keyboardType = UIKeyboardTypeNumberPad;

        cell.agentLabel.text = self.sTextArray[1][indexPath.row];
        cell.agentTextField.placeholder = self.sHolderArray[1][indexPath.row];
        [cell setTouchBeginPoint:^(CGPoint point) {
            weakself.touchPoint = point;
        }];
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
        [cell.agentButton addTarget:self action:@selector(showTitleOfUpwardViews:) forControlEvents:UIControlEventTouchUpInside];
        
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
        cell.leftdAgentContraints.constant = 110;
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
        [cell.agentButton addTarget:self action:@selector(showTitleOfUpwardViews:) forControlEvents:UIControlEventTouchUpInside];

        return cell;
    }else if (indexPath.row == 4){//债务人主体
        identifier = @"suitSect1";
        
        AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftdAgentContraints.constant = 110;
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
        [cell.agentButton addTarget:self action:@selector(showTitleOfUpwardViews:) forControlEvents:UIControlEventTouchUpInside];

        return cell;
    }else if (indexPath.row == 5){//委托代理期限
        identifier = @"suitSect1";
        
        AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftdAgentContraints.constant = 110;
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
        [cell.agentButton addTarget:self action:@selector(showTitleOfUpwardViews:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }else if (indexPath.row == 6){//已付本金
        identifier = @"suitSect1";
        
        AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftdAgentContraints.constant = 110;
        cell.agentTextField.keyboardType = UIKeyboardTypeNumberPad;

        [cell setTouchBeginPoint:^(CGPoint point) {
            weakself.touchPoint = point;
        }];
        
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
    }else if (indexPath.row == 7){//已付利息
        identifier = @"suitSect1";
        
        AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftdAgentContraints.constant = 110;
        cell.agentTextField.keyboardType = UIKeyboardTypeNumberPad;

        cell.agentLabel.text = self.sTextArray[1][indexPath.row];
        cell.agentTextField.placeholder = self.sHolderArray[1][indexPath.row];
        [cell setTouchBeginPoint:^(CGPoint point) {
            weakself.touchPoint = point;
        }];
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
    }else if (indexPath.row == 8){//合同履行地
        identifier = @"suitSect19";
        
        EditDebtAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[EditDebtAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftTextViewConstraints.constant = 105;
        cell.ediLabel.text = @"合同履行地";
        cell.ediTextView.placeholder = @"填写合同履行地";
        [cell setTouchBeginPoint:^(CGPoint point) {
            weakself.touchPoint = point;
        }];
        if (self.suitDataDictionary[@"performancecontract"]) {
            cell.ediTextView.text = self.suitDataDictionary[@"performancecontract"];
        }else{
            cell.ediTextView.text = suModel.performancecontract?suModel.performancecontract:@"";
        }
        [cell setDidEndEditing:^(NSString *text) {
            [self.suitDataDictionary setValue:text forKey:@"performancecontract"];
        }];
        
        return cell;
    }else if (indexPath.row == 9){//债权文件
        identifier = @"suitSect110";
        
        AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftdAgentContraints.constant = 110;
        
        cell.agentLabel.text = self.sTextArray[1][indexPath.row];
        [cell.agentTextField setHidden:YES];
        [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        [cell.agentButton setTitle:@"上传" forState:0];
        cell.agentButton.userInteractionEnabled = NO;
        return cell;
    }else if (indexPath.row == 10){//债权人信息
        identifier = @"suitSect111";
        
        AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftdAgentContraints.constant = 110;
        [cell.agentTextField setHidden:YES];
        
        cell.agentLabel.text = self.sTextArray[1][indexPath.row];
        [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        [cell.agentButton setTitle:@"完善" forState:0];
        cell.agentButton.userInteractionEnabled = NO;
        return cell;
    }else if (indexPath.row == 11){//债务人信息
        identifier = @"suitSect112";
        
        AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftdAgentContraints.constant = 110;
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
    QDFWeakSelf;
    if (indexPath.section == 0) {//基本信息
        if (indexPath.row == 2) {//代理费用类型
            
        }
        
    }else if (indexPath.section == 1) {
        if (indexPath.row == 10) {//债权文件
            UploadFilesViewController *uploadFilesVC = [[UploadFilesViewController alloc] init];
            uploadFilesVC.filesDic = self.creditorfiles;
            uploadFilesVC.tagString = self.tagString;
            [self.navigationController pushViewController:uploadFilesVC animated:YES];
            
            [uploadFilesVC setChooseImages:^(NSDictionary *imageDic) {
                weakself.suitDataDictionary = [NSMutableDictionary dictionaryWithDictionary:imageDic];
                weakself.creditorfiles = [NSMutableDictionary dictionaryWithDictionary:imageDic];
            }];
            
        }else if (indexPath.row == 11){//债权人信息
            DebtCreditMessageViewController *debtCreditMessageVC = [[DebtCreditMessageViewController alloc] init];
            debtCreditMessageVC.categoryString = @"1";
            debtCreditMessageVC.debtArray = self.creditorInfos;
            debtCreditMessageVC.tagString = self.tagString;
            [self.navigationController pushViewController:debtCreditMessageVC animated:YES];
            
            [debtCreditMessageVC setDidEndEditting:^(NSArray *arrays) {
                //参数拼接
                NSString *qqq = @"";
                NSString *endStr = @"";
                for (NSInteger i=0; i<arrays.count; i++) {
                    DebtModel *model = arrays[i];
                    qqq = [NSString stringWithFormat:@"creditorname-%ld=%@,creditormobile-%ld=%@,creditorcardcode-%ld=%@,creditoraddress-%ld=%@,creditorcardimage-%ld=%@",(long)i,model.creditorname,(long)i,model.creditormobile,(long)i,model.creditorcardcode,(long)i,model.creditoraddress,(long)i,model.creditorcardimages];
                    
                    endStr = [NSString stringWithFormat:@"%@,%@",endStr,qqq];
                }

                weakself.creditorInfos = [NSMutableArray arrayWithArray:arrays];
                [weakself.suitDataDictionary setValue:endStr forKey:@"creditorinfos"];
            }];
            
        }else if (indexPath.row == 12){//债务人信息
            DebtCreditMessageViewController *debtCreditMessageVC = [[DebtCreditMessageViewController alloc] init];
            debtCreditMessageVC.categoryString = @"2";
            debtCreditMessageVC.debtArray = self.borrowinginfos;
            debtCreditMessageVC.tagString = self.tagString;
            [self.navigationController pushViewController:debtCreditMessageVC animated:YES];

            [debtCreditMessageVC setDidEndEditting:^(NSArray *arrays) {
                NSString *ppp = @"";
                NSString *endStr = @"";
                for (NSInteger i=0; i<arrays.count; i++) {
                    DebtModel *model = arrays[i];
                    ppp = [NSString stringWithFormat:@"borrowingname-%ld=%@,borrowingmobile-%ld=%@,borrowingaddress-%ld=%@,borrowingcardcode-%ld=%@,borrowingcardimage-%ld=%@",(long)i,model.borrowingname,(long)i,model.borrowingmobile,(long)i,model.borrowingaddress,(long)i,model.borrowingcardcode,(long)i,model.borrowingcardimages];
                    endStr = [NSString stringWithFormat:@"%@,%@",endStr,ppp];
                }
                weakself.borrowinginfos = [NSMutableArray arrayWithArray:arrays];
                [weakself.suitDataDictionary setValue:endStr forKey:@"borrowinginfos"];
            }];
        }
    }
     
}

#pragma mark - method
- (void)openAndCloses:(ReportFootView *)btn
{
    btn.selected = !btn.selected;
    if (btn.selected) {
        NSMutableAttributedString *aStr2 = [[NSMutableAttributedString alloc] initWithString:@"收回补充信息(选填)"];
        [aStr2 addAttributes:@{NSFontAttributeName:kBigFont,NSForegroundColorAttributeName:kNavColor} range:NSMakeRange(0, aStr2.length)];
        [btn.footButton setAttributedTitle:aStr2 forState:0];
        [btn.footButton setImage:[UIImage imageNamed:@"open"] forState:0];
        
        [self.suitDataList insertObject:@"大喊大叫" atIndex:1];
        NSIndexSet *set = [[NSIndexSet alloc] initWithIndex:1];
        [self.suitTableView insertSections:set withRowAnimation:UITableViewRowAnimationFade];
    }else{
        
        NSMutableAttributedString *aStr1 = [[NSMutableAttributedString alloc] initWithString:@"展开补充信息(选填)"];
        [aStr1 addAttributes:@{NSFontAttributeName:kBigFont,NSForegroundColorAttributeName:kNavColor} range:NSMakeRange(0, aStr1.length)];
        [btn.footButton setAttributedTitle:aStr1 forState:0];
        [btn.footButton setImage:[UIImage imageNamed:@"withdraw"] forState:0];
        
        [self.suitDataList removeObjectAtIndex:1];
        NSIndexSet *set = [[NSIndexSet alloc] initWithIndex:1];
        [self.suitTableView deleteSections:set withRowAnimation:UITableViewRowAnimationFade];
    }
    [self.suitTableView reloadData];
}

- (void)showTitleOfUpwardViews:(UIButton *)btn
{
    [self.view endEditing:YES];
    NSArray *arr2 = @[@"固定费用(万元)",@"代理费率(%)"];
    NSArray *arr22 = @[@"服务佣金(%)",@"固定费用(万元)"];
    NSArray *arr3 = @[@"房产抵押",@"应收帐款",@"机动车抵押",@"无抵押"];
    NSArray *arr8 = @[@"%/天",@"%/月"];
    NSArray *arr10 = @[@"一次性到期还本付息",@"按月付息，到期还本",@"其他"];
    NSArray *arr11 = @[@"自然人",@"法人",@"其他"];
    NSArray *arr13 = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
    
    QDFWeakSelf;
    switch (btn.tag) {
        case 2:{//代理费用(诉讼)
            [self showBlurInView:self.view withArray:arr2 andTitle:@"选择代理费用类型" finishBlock:^(NSString *text, NSInteger row) {
                [btn setTitle:text forState:0];
                
                NSString *value = [NSString stringWithFormat:@"%ld",(long)row];
                [weakself.suitDataDictionary setValue:value forKey:@"agencycommissiontype"];
                [weakself.suitDataDictionary setValue:text forKey:@"agencycommissiontype_str"];
            }];
        }
            break;
        case 3:{//债权类型
            [self showBlurInView:self.view withArray:arr3 andTitle:@"选择债权类型" finishBlock:^(NSString *text, NSInteger row) {
                
                AgentCell *cell = [weakself.suitTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
                cell.agentTextField.text = @"";
                [self.view endEditing:YES];
                
                [btn setTitle:text forState:0];
                NSString *value = [NSString stringWithFormat:@"%ld",(long)row];
                [weakself.suitDataDictionary setValue:value forKey:@"loan_type"];
                [weakself.suitTableView reloadData];
                
                if (row == 1) {//房产抵押
                    self.rowString = @"6";
                    [self.sTextArray[0] replaceObjectAtIndex:4 withObject:@"抵押物地址"];
                    [self.sHolderArray[0] replaceObjectAtIndex:4 withObject:@""];
                    _number = @"1";
                    
                }else if (row == 3){//机动车
                    [cell.agentButton setHidden:NO];
                    self.rowString = @"5";
                    [self.sTextArray[0] replaceObjectAtIndex:4 withObject:@"机动车"];
                    [self.sHolderArray[0] replaceObjectAtIndex:4 withObject:@""];
                    _number = @"3";
                }else if (row == 2){//应收帐款
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
                [weakself.suitTableView reloadData];
                
            }];
        }
            break;
        case 22:{//代理费用（清收）
            [self showBlurInView:self.view withArray:arr22 andTitle:@"选择代理费用类型" finishBlock:^(NSString *text, NSInteger row) {
                [btn setTitle:text forState:0];
                NSString *value = [NSString stringWithFormat:@"%ld",(long)row];
                [weakself.suitDataDictionary setValue:value forKey:@"agencycommissiontype"];
                [weakself.suitDataDictionary setValue:text forKey:@"agencycommissiontype_str"];
            }];
        }
            break;
        case 8:{//借款利率
            [self showBlurInView:self.view withArray:arr8 andTitle:@"选择借款利率类型" finishBlock:^(NSString *text,NSInteger row) {
                [btn setTitle:text forState:0];
                NSString *value = [NSString stringWithFormat:@"%ld",(long)row];
                [weakself.suitDataDictionary setValue:value forKey:@"rate_cat"];
                [weakself.suitDataDictionary setValue:text forKey:@"rate_cat_str"];

                UIButton *elseBtn = [self.suitTableView viewWithTag:9];
                [elseBtn setTitle:text forState:0];
                
            }];
        }
            break;
        case 9:{//借款期限
            [self showBlurInView:self.view withArray:arr8 andTitle:@"选择借款期限类型" finishBlock:^(NSString *text,NSInteger row) {
                [btn setTitle:text forState:0];
                
                NSString *value = [NSString stringWithFormat:@"%ld",(long)row];
                [weakself.suitDataDictionary setValue:value forKey:@"rate_cat"];
                [weakself.suitDataDictionary setValue:text forKey:@"rate_cat_str"];

                UIButton *elseBtn = [self.suitTableView viewWithTag:8];
                [elseBtn setTitle:text forState:0];
            }];
        }
            break;
        case 10:{//还款方式
            [self showBlurInView:self.view withArray:arr10 andTitle:@"选择还款方式" finishBlock:^(NSString *text,NSInteger row) {
                [btn setTitle:text forState:0];
                
                NSString *value = [NSString stringWithFormat:@"%ld",(long)row];
                [weakself.suitDataDictionary setValue:value forKey:@"repaymethod"];
                [weakself.suitDataDictionary setValue:text forKey:@"repaymethod_str"];

            }];
        }
            break;
        case 11:{//债务人主体
            [self showBlurInView:self.view withArray:arr11 andTitle:@"选择债务人主体" finishBlock:^(NSString *text,NSInteger row) {
                [btn setTitle:text forState:0];
                
                NSString *value = [NSString stringWithFormat:@"%ld",(long)row];
                [weakself.suitDataDictionary setValue:value forKey:@"obligor"];
                [weakself.suitDataDictionary setValue:text forKey:@"obligor_str"];

            }];
        }
            break;
        case 12:{//委托代理期限
            [self showBlurInView:self.view withArray:arr13 andTitle:@"选择委托代理期限" finishBlock:^(NSString *text,NSInteger row) {
                [btn setTitle:text forState:0];
                
                NSString *value = [NSString stringWithFormat:@"%ld",(long)row];
                [weakself.suitDataDictionary setValue:value forKey:@"commissionperiod"];
                [weakself.suitDataDictionary setValue:text forKey:@"commissionperiod_str"];
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
    self.suitDataDictionary[@"money"] = [NSString getValidStringFromString:self.suitDataDictionary[@"money"] toString:self.suResponse.product.money];
    self.suitDataDictionary[@"agencycommission"] = [NSString getValidStringFromString:self.suitDataDictionary[@"agencycommission"] toString:self.suResponse.product.agencycommission];
    self.suitDataDictionary[@"loan_type"] = [NSString getValidStringFromString:self.suitDataDictionary[@"loan_type"] toString:self.suResponse.product.loan_type];
    self.suitDataDictionary[@"mortorage_community"] = self.suitDataDictionary[@"mortorage_community"]?self.suitDataDictionary[@"mortorage_community"]:self.suResponse.product.mortorage_community;//抵押物地址
    self.suitDataDictionary[@"seatmortgage"] = self.suitDataDictionary[@"seatmortgage"]?self.suitDataDictionary[@"seatmortgage"]:self.suResponse.product.seatmortgage; //详细地址
    self.suitDataDictionary[@"province_id"] = @"0";
    self.suitDataDictionary[@"city_id"] = @"0";
    self.suitDataDictionary[@"district_id"] = @"0";
    self.suitDataDictionary[@"carbrand"] = self.suitDataDictionary[@"carbrand"]?self.suitDataDictionary[@"carbrand"]:self.suResponse.product.carbrand;   //车品牌
    self.suitDataDictionary[@"audi"] = self.suitDataDictionary[@"audi"]?self.suitDataDictionary[@"audi"]:self.suResponse.product.audi;  //车系
    self.suitDataDictionary[@"licenseplate"] = self.suitDataDictionary[@"licenseplate"]?self.suitDataDictionary[@"licenseplate"]:self.suResponse.product.licenseplate;  //车系
    
    self.suitDataDictionary[@"accountr"] = self.suitDataDictionary[@"accountr"]?self.suitDataDictionary[@"accountr"]:self.suResponse.product.accountr; //应收帐款
    self.suitDataDictionary[@"rate"] = self.suitDataDictionary[@"rate"]?self.suitDataDictionary[@"rate"]:self.suResponse.product.rate;  //借款利率
    self.suitDataDictionary[@"rate_cat"] = self.suitDataDictionary[@"rate_cat"]?self.suitDataDictionary[@"rate_cat"]:self.suResponse.product.rate_cat;//借款利率单位
    self.suitDataDictionary[@"term"] = self.suitDataDictionary[@"term"]?self.suitDataDictionary[@"term"]:self.suResponse.product.term;//借款期限
    self.suitDataDictionary[@"repaymethod"] = self.suitDataDictionary[@"repaymethod"]?self.suitDataDictionary[@"repaymethod"]:self.suResponse.product.repaymethod;//付款方式
    self.suitDataDictionary[@"obligor"] = self.suitDataDictionary[@"obligor"]?self.suitDataDictionary[@"obligor"]:self.suResponse.product.obligor;//债务人主体
    self.suitDataDictionary[@"commissionperiod"] = self.suitDataDictionary[@"commissionperiod"]?self.suitDataDictionary[@"commissionperiod"]:self.suResponse.product.commissionperiod;  //委托代理期限
    self.suitDataDictionary[@"paidmoney"] = self.suitDataDictionary[@"paidmoney"]?self.suitDataDictionary[@"paidmoney"]:self.suResponse.product.paidmoney;//已付本金
    self.suitDataDictionary[@"interestpaid"] = self.suitDataDictionary[@"interestpaid"]?self.suitDataDictionary[@"interestpaid"]:self.suResponse.product.interestpaid; //已付利息
    self.suitDataDictionary[@"performancecontract"] = self.suitDataDictionary[@"performancecontract"]?self.suitDataDictionary[@"performancecontract"]:self.suResponse.product.performancecontract; //合同履行地
    
    //债权文件
    //债权人信息
    //债务人信息
    
    [self.suitDataDictionary setValue:self.categoryString forKey:@"category"];
    [self.suitDataDictionary setValue:typeString forKey:@"progress_status"];
    [self.suitDataDictionary setValue:[self getValidateToken] forKey:@"token"];
    
    NSString *idStr = self.suResponse.product.idString?self.suResponse.product.idString:@"";
    [self.suitDataDictionary setValue:idStr forKey:@"id"];
    
    NSDictionary *params = self.suitDataDictionary;
    
    QDFWeakSelf;
    [self requestDataPostWithString:reFinanceString params:params andImages:nil successBlock:^(id responseObject) {
        
        BaseModel *suitModel = [BaseModel objectWithKeyValues:responseObject];
        
        [weakself showHint:suitModel.msg];
        
        if ([suitModel.code isEqualToString:@"0000"]) {
            if ([typeString intValue] == 0) {//保存
                if (self.suResponse) {
                    ReportFiSucViewController *reportFiSucVC = [[ReportFiSucViewController alloc] init];
                    if ([weakself.categoryString integerValue] == 1) {
                        reportFiSucVC.reportType = @"清收";
                    }else{
                        reportFiSucVC.reportType = @"诉讼";
                    }
                    [weakself.navigationController pushViewController:reportFiSucVC animated:YES];
                }else{
                    UINavigationController *nav = weakself.navigationController;
                    [nav popViewControllerAnimated:NO];
                    
                    MySaveViewController *mySaveVC = [[MySaveViewController alloc] init];
                    mySaveVC.hidesBottomBarWhenPushed = YES;
                    [nav pushViewController:mySaveVC animated:NO];
                }
            }else{
                ReportFiSucViewController *reportFiSucVC = [[ReportFiSucViewController alloc] init];
                if ([weakself.categoryString integerValue] == 1) {
                    reportFiSucVC.reportType = @"清收";
                }else{
                    reportFiSucVC.reportType = @"诉讼";
                }
                [weakself.navigationController pushViewController:reportFiSucVC animated:YES];
            }
        }
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)back
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"是否保存" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"保存" otherButtonTitles:@"不保存", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    
    [actionSheet showInView:self.view];
}

#pragma mark - actionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {//保存
        NSLog(@"0");
        [self reportSuitActionWithTypeString:@"0"];
    }else if (buttonIndex == 1){//不保存
        NSLog(@"1");
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if (buttonIndex == 2){//取消
        NSLog(@"2");
    }
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
