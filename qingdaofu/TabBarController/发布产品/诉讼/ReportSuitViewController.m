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
#import "PowerCourtView.h"
#import "ReportDatePickerView.h"

#import "AgentCell.h"
#import "EditDebtAddressCell.h"
#import "SuitBaseCell.h"

@interface ReportSuitViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *suitTableView;
@property (nonatomic,strong) ReportFootView *repSuitFootButton;
@property (nonatomic,strong) UIButton *suitRightButton;
@property (nonatomic,strong) PowerCourtView *reportPickerView;
@property (nonatomic,strong) ReportDatePickerView *datePickerView;

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
//省市区
@property (nonatomic,strong) NSDictionary *provinceDictionary;
@property (nonatomic,strong) NSDictionary *cityDcitionary;
@property (nonatomic,strong) NSDictionary *districtDictionary;
@property (nonatomic,strong) NSString *cateString; //1-抵押物地址，2-合同履行地
@property (nonatomic,strong) NSMutableDictionary *addressTestDict;//临时保存抵押物地址


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
        self.rowString = @"4";
        _number = @"0";
//        [self.suitDataDictionary setValue:_number forKey:@"loan_type"];
    }
    
    [self.view addSubview:self.suitTableView];
    [self.view addSubview:self.reportPickerView];
    [self.reportPickerView setHidden:YES];
    [self.view addSubview:self.datePickerView];
    [self.datePickerView setHidden:YES];
    
    [self.view setNeedsUpdateConstraints];
    
    [self addKeyboardObserver];
}

- (void)dealloc
{
    [self removeKeyboardObserver];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.suitTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        [self.reportPickerView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        [self.datePickerView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
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

- (PowerCourtView *)reportPickerView
{
    if (!_reportPickerView) {
        _reportPickerView = [PowerCourtView newAutoLayoutView];
        _reportPickerView.publishStr = @"3";
        

        QDFWeakSelf;
        [_reportPickerView setDidSelectedComponent:^(NSInteger component, NSInteger row, NSString *idString, NSString *nameString) {
            
            if (component == 0) {
                
                [weakself.addressTestDict setObject:nameString forKey:@"proName"];
                [weakself.addressTestDict setObject:idString forKey:@"proID"];

                [weakself getCityListWithProvinceID:idString];
                
            }else if (component == 1){
                
                [weakself.addressTestDict setObject:nameString forKey:@"cityName"];
                [weakself.addressTestDict setObject:idString forKey:@"cityID"];
                [weakself getDistrictListWithCityID:idString];
                
            }else if (component == 2){
                
                [weakself.addressTestDict setObject:nameString forKey:@"districtName"];
                [weakself.addressTestDict setObject:idString forKey:@"districtID"];
                
            }else if (component == 3){
                
                if (weakself.addressTestDict[@"proName"] && weakself.addressTestDict[@"cityName"] && weakself.addressTestDict[@"districtName"]) {//都选择
                    
                    if ([weakself.cateString integerValue] == 1) {
                        
                        //显示
                        AgentCell *cell = [weakself.suitTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
                        cell.agentTextField.text = [NSString stringWithFormat:@"%@%@%@",weakself.addressTestDict[@"proName"],weakself.addressTestDict[@"cityName"],weakself.addressTestDict[@"districtName"]];

                        //保存参数
                        [weakself.suitDataDictionary setObject:weakself.addressTestDict[@"proID"] forKey:@"province_id"];
                        [weakself.suitDataDictionary setObject:weakself.addressTestDict[@"cityID"] forKey:@"city_id"];
                        [weakself.suitDataDictionary setObject:weakself.addressTestDict[@"districtID"] forKey:@"district_id"];
                        
                    }else if ([weakself.cateString integerValue] == 2){
                        
                        //显示
                        AgentCell *cell = [weakself.suitTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:9 inSection:1]];
                        cell.agentTextField.text = [NSString stringWithFormat:@"%@%@%@",weakself.addressTestDict[@"proName"],weakself.addressTestDict[@"cityName"],weakself.addressTestDict[@"districtName"]];
                        
                        [weakself.suitDataDictionary setObject:weakself.addressTestDict[@"proID"] forKey:@"place_province_id"];
                        [weakself.suitDataDictionary setObject:weakself.addressTestDict[@"cityID"] forKey:@"place_city_id"];
                        [weakself.suitDataDictionary setObject:weakself.addressTestDict[@"districtID"] forKey:@"place_district_id"];
                    }
                }
            }
        }];
    }
    return _reportPickerView;
}

- (ReportDatePickerView *)datePickerView
{
    if (!_datePickerView) {
        _datePickerView = [ReportDatePickerView newAutoLayoutView];
        
        QDFWeakSelf;
        [_datePickerView setDidSelectedDate:^(NSDate *date) {
            
            NSString *guDateString = [NSString stringWithFormat:@"%@",date];
            NSString *huhu = [guDateString substringToIndex:10];
            
            AgentCell *cell = [weakself.suitTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:1]];
            cell.agentTextField.text = [NSString stringWithFormat:huhu,date];
        }];
    }
    return _datePickerView;
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
        NSMutableArray *s1 = [NSMutableArray arrayWithArray:@[@"",@"借款本金",@"代理费用",@"债权类型",@"抵押物地址",@""]];
        NSMutableArray *s2 = [NSMutableArray arrayWithArray:@[@"|  选填信息(选填)",@"借款利率",@"借款期限",@"还款方式",@"债务人主体",@"逾期开始日期",@"委托代理期限",@"已付本金",@"已付利息",@"",@"债权文件",@"债权人信息",@"债务人信息"]];
        _sTextArray = [NSMutableArray arrayWithObjects:s1,s2, nil];
    }
    return _sTextArray;
}

- (NSMutableArray *)sHolderArray
{
    if (!_sHolderArray) {
        NSMutableArray *w1 = [NSMutableArray arrayWithArray:@[@"",@"填写借款本金",@"请填写代理费用",@"请选择",@"请选择",@"请选择"]];
        NSMutableArray *w2 = [NSMutableArray arrayWithArray:@[@"",@"能够给到融资方的利息",@"输入借款期限",@"请选择还款方式",@"请选择债务人主体",@"请选择逾期日期",@"请选择代理期限",@"填写已付本金",@"填写已付利息",@"",@"",@"",@"",@""]];
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

- (NSMutableDictionary *)addressTestDict
{
    if (!_addressTestDict) {
        _addressTestDict = [NSMutableDictionary dictionary];
    }
    return _addressTestDict;
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
            cell.leftdAgentContraints.constant = 115;
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
            cell.leftdAgentContraints.constant = 115;
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
            cell.agentTextField.userInteractionEnabled = NO;
            cell.agentButton.userInteractionEnabled = NO;
            cell.leftdAgentContraints.constant = 115;
            cell.agentTextField.placeholder = self.sHolderArray[0][indexPath.row];
            [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
            cell.agentLabel.text = self.sTextArray[0][indexPath.row];
        
            if ([_number integerValue] == 1) {
                cell.agentTextField.text = @"房产抵押";
            }else if([_number integerValue] == 2){
                cell.agentTextField.text = @"应收账款";
            }else if ([_number integerValue] == 3){
                cell.agentTextField.text = @"机动车抵押";
            }else if ([_number integerValue] == 4){
                cell.agentTextField.text = @"无抵押";
            }else{
                cell.agentTextField.text = @"";
            }
            
            return cell;
            
        }else if (indexPath.row == 4){//抵押物地址
            identifier = @"suitSect04";
            AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.leftdAgentContraints.constant = 115;
            cell.agentLabel.text = self.sTextArray[0][indexPath.row];
            cell.agentTextField.placeholder = self.sHolderArray[0][indexPath.row];
            cell.agentButton.userInteractionEnabled = NO;

            [cell setTouchBeginPoint:^(CGPoint point) {
                weakself.touchPoint = point;
            }];

            if ([_number intValue] == 1) {//抵押物地址
                cell.agentTextField.userInteractionEnabled = NO;
                cell.agentTextField.placeholder = @"请选择";
                cell.agentTextField.text = suModel.mortorage_community?suModel.mortorage_community:self.suitDataDictionary[@"mortorage_community"];
                
                [cell.agentButton setHidden:NO];
                [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
                
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
                
            }else if ([_number intValue] == 2) {//应收帐款
                cell.agentTextField.userInteractionEnabled = YES;
                cell.agentTextField.text = suModel.accountr?suModel.accountr:self.suitDataDictionary[@"accountr"];
                
                [cell.agentButton setHidden:NO];
                [cell.agentButton setTitle:@"万元" forState:0];
                [cell.agentButton setImage:[UIImage imageNamed:@""] forState:0];

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
            cell.leftTextViewConstraints.constant = 110;
            cell.ediLabel.text = @"详细地址";
            
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
        cell.leftdAgentContraints.constant = 115;
        [cell.agentTextField setHidden:YES];
        [cell.agentButton setHidden:YES];
        
        NSMutableAttributedString *ffff = [cell.agentLabel setAttributeString:@"|  补充信息" withColor:kBlueColor andSecond:@"（选填）" withColor:kBlackColor withFont:12];
        [cell.agentLabel setAttributedText:ffff];
        
        return cell;
    }else if (indexPath.row == 1){//借款利率
        identifier = @"suitSect11";
        
        AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftdAgentContraints.constant = 115;
//        cell.agentTextField.keyboardType = UIKeyboardTypeNumberPad;
        [cell.agentButton setTitle:@"%/月" forState:0];

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
        
        [cell setDidEndEditing:^(NSString *text) {
            [self.suitDataDictionary setValue:text forKey:@"rate"];
        }];
        
        return cell;
    }else if (indexPath.row == 2){//借款期限
        identifier = @"suitSect12";
        
        AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftdAgentContraints.constant = 115;
        cell.agentTextField.keyboardType = UIKeyboardTypeNumberPad;
        [cell.agentButton setTitle:@"月" forState:0];

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
        
        [cell setDidEndEditing:^(NSString *text) {
            [self.suitDataDictionary setValue:text forKey:@"term"];
        }];
        
        return cell;
        
    }else if (indexPath.row == 3){//还款方式
        identifier = @"suitSect13";
        
        AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.agentTextField.userInteractionEnabled = NO;
        cell.agentButton.userInteractionEnabled = NO;
        cell.leftdAgentContraints.constant = 115;
        cell.agentLabel.text = self.sTextArray[1][indexPath.row];
        cell.agentTextField.placeholder = self.sHolderArray[1][indexPath.row];
        [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        
        
        if (suModel.repaymethod) {
            NSArray *ffff = @[@"一次性到期还本付息",@"按月付息，到期还本"];
            cell.agentTextField.text = ffff[[suModel.repaymethod integerValue] -1];
        }else{
            cell.agentTextField.text = self.suitDataDictionary[@"repaymethod_str"];
        }

        return cell;
        
    }else if (indexPath.row == 4){//债务人主体
        identifier = @"suitSect14";
        
        AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.agentTextField.userInteractionEnabled = NO;
        cell.agentButton.userInteractionEnabled = NO;
        cell.leftdAgentContraints.constant = 115;
        cell.agentLabel.text = self.sTextArray[1][indexPath.row];
        cell.agentTextField.placeholder = self.sHolderArray[1][indexPath.row];
        [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        
        if (suModel.obligor) {
            NSArray *ffff = @[@"自然人",@"法人",@"其他"];
            cell.agentTextField.text = ffff[[suModel.obligor integerValue] - 1];
        }else{
            cell.agentTextField.text = self.suitDataDictionary[@"obligor_str"];
        }
        cell.agentButton.tag = 11;
        [cell.agentButton addTarget:self action:@selector(showTitleOfUpwardViews:) forControlEvents:UIControlEventTouchUpInside];

        return cell;
    }else if (indexPath.row == 5){//逾期开始日期
        identifier = @"suitSect15";
        
        AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.agentTextField.userInteractionEnabled = NO;
        cell.agentButton.userInteractionEnabled = NO;
        cell.leftdAgentContraints.constant = 115;
        cell.agentLabel.text = self.sTextArray[1][indexPath.row];
        cell.agentTextField.placeholder = self.sHolderArray[1][indexPath.row];
        [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        
        return cell;
        
    }else if (indexPath.row == 6){//委托代理期限
        identifier = @"suitSect16";
        
        AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.agentTextField.userInteractionEnabled = NO;
        cell.agentButton.userInteractionEnabled = NO;
        cell.leftdAgentContraints.constant = 115;
        cell.agentLabel.text = self.sTextArray[1][indexPath.row];
        cell.agentTextField.placeholder = self.sHolderArray[1][indexPath.row];
        [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        [cell.agentButton setTitle:@"月" forState:0];
        
        if (suModel.commissionperiod) {
            [cell.agentButton setTitle:suModel.commissionperiod forState:0];
            cell.agentTextField.text = suModel.commissionperiod;
        }else{
//            NSString *eeee = self.suitDataDictionary[@"commissionperiod_str"]?self.suitDataDictionary[@"commissionperiod_str"]:@"请选择";
//            [cell.agentButton setTitle:eeee forState:0];
            cell.agentTextField.text = self.suitDataDictionary[@"commissionperiod_str"];
        }
        
//        cell.agentButton.tag = 14;
//        [cell.agentButton addTarget:self action:@selector(showTitleOfUpwardViews:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }else if (indexPath.row == 7){//已付本金
        identifier = @"suitSect17";
        
        AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftdAgentContraints.constant = 115;
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
    }else if (indexPath.row == 8){//已付利息
        identifier = @"suitSect18";
        
        AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftdAgentContraints.constant = 115;
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
    }else if (indexPath.row == 9){//合同履行地
        identifier = @"suitSect19";
        
        AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftdAgentContraints.constant = 115;
        cell.agentTextField.userInteractionEnabled = NO;
        cell.agentButton.userInteractionEnabled = NO;
        cell.agentLabel.text = @"合同履行地";
        cell.agentTextField.placeholder = @"请选择";
        [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        
        if (self.suitDataDictionary[@"performancecontract"]) {
            cell.agentTextField.text = self.suitDataDictionary[@"performancecontract"];
        }else{
            cell.agentTextField.text = suModel.performancecontract?suModel.performancecontract:@"";
        }
        
        return cell;
        
    }else if (indexPath.row == 10){//债权文件
        identifier = @"suitSect110";
        
        AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftdAgentContraints.constant = 115;
        
        cell.agentLabel.text = self.sTextArray[1][indexPath.row];
        [cell.agentTextField setHidden:YES];
        [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        [cell.agentButton setTitle:@"上传" forState:0];
        cell.agentButton.userInteractionEnabled = NO;
        return cell;
    }else if (indexPath.row == 11){//债权人信息
        identifier = @"suitSect111";
        
        AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftdAgentContraints.constant = 115;
        [cell.agentTextField setHidden:YES];
        
        cell.agentLabel.text = self.sTextArray[1][indexPath.row];
        [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        [cell.agentButton setTitle:@"完善" forState:0];
        cell.agentButton.userInteractionEnabled = NO;
        return cell;
    }else if (indexPath.row == 12){//债务人信息
        identifier = @"suitSect112";
        
        AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftdAgentContraints.constant = 115;
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
    return kBigPadding;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {//基本信息
        if (indexPath.row == 3) {//债权类型
            [self showTitleOfUpwardView:@"3"];
        }else if (indexPath.row == 4){
            if ([_number intValue] == 3){//机动车抵押
                BrandsViewController *brandVC = [[BrandsViewController alloc] init];
                [self.navigationController pushViewController:brandVC animated:YES];
                
                QDFWeakSelf;
                [brandVC setDidSelectedRow:^(NSString *brandNo,NSString *brand, NSString *audiNo,NSString *audi,NSString *licenseNo,NSString *license) {
                    [weakself.suitDataDictionary setValue:brandNo forKey:@"carbrand"];
                    [weakself.suitDataDictionary setValue:audiNo forKey:@"audi"];
                    [weakself.suitDataDictionary setValue:licenseNo forKey:@"licenseplate"];
                    [weakself.suitDataDictionary setValue:brand forKey:@"carbrandstr"];
                    [weakself.suitDataDictionary setValue:audi forKey:@"audistr"];
                    [weakself.suitDataDictionary setValue:license forKey:@"licenseplatestr"];
                    
                    AgentCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                    cell.agentTextField.text = [NSString stringWithFormat:@"%@%@%@",brand,audi,license];
                }];
            }else if ([_number intValue] == 1){//房产抵押
                [self.reportPickerView setHidden:NO];
                
                self.cateString = @"1";
                
                if (self.reportPickerView.componentDic1.allKeys.count == 0) {
                    [self getProvinceList];
                }else{
                    [self.reportPickerView.pickerViews reloadAllComponents];
                }
            }
        }
        
    }else if (indexPath.section == 1) {//补充信息
        switch (indexPath.row) {
            case 3:{//还款方式
                [self showTitleOfUpwardView:@"10"];
            }
                break;
            case 4:{//债务人主体
                [self showTitleOfUpwardView:@"11"];
            }
                break;
            case 5:{//逾期
                [self.datePickerView setHidden:NO];
            }
                break;
            case 6:{//委托期限
                [self showTitleOfUpwardView:@"13"];
            }
                break;
            case 9:{
                [self.reportPickerView setHidden:NO];
                
                self.cateString = @"2";
                
                if (self.reportPickerView.componentDic1.allKeys.count == 0) {
                    [self getProvinceList];
                }else{
                    [self.reportPickerView.pickerViews reloadAllComponents];
                }
            }
                break;
            case 10:{//债权文件
                UploadFilesViewController *uploadFilesVC = [[UploadFilesViewController alloc] init];
                uploadFilesVC.filesDic = self.creditorfiles;
                uploadFilesVC.tagString = self.tagString;
                [self.navigationController pushViewController:uploadFilesVC animated:YES];
                
                QDFWeakSelf;
                [uploadFilesVC setChooseImages:^(NSDictionary *imageDic) {
                    weakself.suitDataDictionary = [NSMutableDictionary dictionaryWithDictionary:imageDic];
                    weakself.creditorfiles = [NSMutableDictionary dictionaryWithDictionary:imageDic];
                }];
            }
                break;
            case 11:{//债权人信息
                DebtCreditMessageViewController *debtCreditMessageVC = [[DebtCreditMessageViewController alloc] init];
                debtCreditMessageVC.categoryString = @"1";
                debtCreditMessageVC.debtArray = self.creditorInfos;
                debtCreditMessageVC.tagString = self.tagString;
                [self.navigationController pushViewController:debtCreditMessageVC animated:YES];
                
                QDFWeakSelf;
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
            }
                break;
            case 12:{//债务人信息
                DebtCreditMessageViewController *debtCreditMessageVC = [[DebtCreditMessageViewController alloc] init];
                debtCreditMessageVC.categoryString = @"2";
                debtCreditMessageVC.debtArray = self.borrowinginfos;
                debtCreditMessageVC.tagString = self.tagString;
                [self.navigationController pushViewController:debtCreditMessageVC animated:YES];
                
                QDFWeakSelf;
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
                break;
            default:
                break;
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

- (void)showTitleOfUpwardView:(NSString *)tagString
{
    [self.view endEditing:YES];
//    NSArray *arr2 = @[@"固定费用(万元)",@"代理费率(%)"];
//    NSArray *arr22 = @[@"服务佣金(%)",@"固定费用(万元)"];
    NSArray *arr3 = @[@"房产抵押",@"应收帐款",@"机动车抵押",@"无抵押"];
    NSArray *arr10 = @[@"一次性到期还本付息",@"按月付息，到期还本",@"其他"];
    NSArray *arr11 = @[@"自然人",@"法人",@"其他"];
    NSArray *arr13 = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
    
    NSInteger tag = [tagString integerValue];
    
    QDFWeakSelf;
    switch (tag) {
        case 3:{//债权类型
            [self showBlurInView:self.view withArray:arr3 andTitle:@"选择债权类型" finishBlock:^(NSString *text, NSInteger row) {
                
                AgentCell *cell3 = [weakself.suitTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
                cell3.agentTextField.text = text;

                NSString *value = [NSString stringWithFormat:@"%ld",(long)row];
                [weakself.suitDataDictionary setValue:value forKey:@"loan_type"];
                [weakself.suitTableView reloadData];
                
                AgentCell *cell4 = [weakself.suitTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
                if (row == 1) {//房产抵押
                    [cell4.agentButton setHidden:NO];
                    [cell4.agentButton setTitle:@"" forState:0];
                    [cell4.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
                    
                    self.rowString = @"6";
                    [self.sTextArray[0] replaceObjectAtIndex:4 withObject:@"抵押物地址"];
                    [self.sHolderArray[0] replaceObjectAtIndex:4 withObject:@""];
                    _number = @"1";
                    
                }else if (row == 3){//机动车
                    [cell4.agentButton setHidden:NO];
                    [cell4.agentButton setTitle:@"" forState:0];
                    [cell4.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
                    
                    self.rowString = @"5";
                    [self.sTextArray[0] replaceObjectAtIndex:4 withObject:@"机动车"];
                    [self.sHolderArray[0] replaceObjectAtIndex:4 withObject:@""];
                    _number = @"3";
                }else if (row == 2){//应收帐款
                    [cell4.agentButton setTitle:@"万元" forState:0];
                    [cell4.agentButton setImage:[UIImage imageNamed:@""] forState:0];
                    
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
        case 10:{//还款方式
            [self showBlurInView:self.view withArray:arr10 andTitle:@"选择还款方式" finishBlock:^(NSString *text,NSInteger row) {
                AgentCell *cell = [weakself.suitTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:1]];
                cell.agentTextField.text = text;
                
                NSString *value = [NSString stringWithFormat:@"%ld",(long)row];
                [weakself.suitDataDictionary setValue:value forKey:@"repaymethod"];
                [weakself.suitDataDictionary setValue:text forKey:@"repaymethod_str"];
                
            }];
        }
            break;
        case 11:{//债务人主体
            [self showBlurInView:self.view withArray:arr11 andTitle:@"选择债务人主体" finishBlock:^(NSString *text,NSInteger row) {
                AgentCell *cell = [weakself.suitTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:1]];
                cell.agentTextField.text = text;
                
                NSString *value = [NSString stringWithFormat:@"%ld",(long)row];
                [weakself.suitDataDictionary setValue:value forKey:@"obligor"];
                [weakself.suitDataDictionary setValue:text forKey:@"obligor_str"];
                
            }];
        }
            break;
//        case 12:{//逾期
//            [self showBlurInView:self.view withArray:arr11 andTitle:@"选择债务人主体" finishBlock:^(NSString *text,NSInteger row) {
//                AgentCell *cell = [weakself.suitTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:1]];
//                cell.agentTextField.text = text;
//                
//                NSString *value = [NSString stringWithFormat:@"%ld",(long)row];
//                [weakself.suitDataDictionary setValue:value forKey:@"obligor"];
//                [weakself.suitDataDictionary setValue:text forKey:@"obligor_str"];
//                
//            }];
//        }
//            break;
        case 13:{//委托代理期限
            [self showBlurInView:self.view withArray:arr13 andTitle:@"选择委托代理期限" finishBlock:^(NSString *text,NSInteger row) {
                AgentCell *cell = [weakself.suitTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:1]];
                cell.agentTextField.text = text;
                
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

- (void)showTitleOfUpwardViews:(UIButton *)btn
{
    [self.view endEditing:YES];
    NSArray *arr2 = @[@"固定费用(万元)",@"代理费率(%)"];
    NSArray *arr22 = @[@"服务佣金(%)",@"固定费用(万元)"];
    
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
        case 22:{//代理费用（清收）
            [self showBlurInView:self.view withArray:arr22 andTitle:@"选择代理费用类型" finishBlock:^(NSString *text, NSInteger row) {
                [btn setTitle:text forState:0];
                NSString *value = [NSString stringWithFormat:@"%ld",(long)row];
                [weakself.suitDataDictionary setValue:value forKey:@"agencycommissiontype"];
                [weakself.suitDataDictionary setValue:text forKey:@"agencycommissiontype_str"];
            }];
        }
            break;
        default:
            break;
    }
}

#pragma mark - get province city and dictrict
- (void)getProvinceList
{
    NSString *provinceString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kProvinceString];
    QDFWeakSelf;
    [self requestDataPostWithString:provinceString params:nil successBlock:^(id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        weakself.reportPickerView.componentDic1 = dic;
        [weakself.reportPickerView.pickerViews reloadAllComponents];
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)getCityListWithProvinceID:(NSString *)provinceId
{
    NSString *cityString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kCityString];
    NSDictionary *params = @{@"fatherID" : provinceId};
    
    QDFWeakSelf;
    [self requestDataPostWithString:cityString params:params successBlock:^(id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        weakself.reportPickerView.componentDic2 = dic[provinceId];
        if (weakself.reportPickerView.componentDic3.allKeys.count > 0) {
            weakself.reportPickerView.typeComponent = @"3";
        }else{
            weakself.reportPickerView.typeComponent = @"2";
        }
        [weakself.reportPickerView.pickerViews reloadAllComponents];
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)getDistrictListWithCityID:(NSString *)cityId
{
    NSString *districtString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kDistrictString];
    NSDictionary *params = @{@"fatherID" : cityId};
    
    QDFWeakSelf;
    [self requestDataPostWithString:districtString params:params successBlock:^(id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        weakself.reportPickerView.componentDic3 = dic[cityId];
        weakself.reportPickerView.typeComponent = @"3";
        [weakself.reportPickerView.pickerViews reloadAllComponents];
        
    } andFailBlock:^(NSError *error) {
        
    }];
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
    
//    self.suitDataDictionary[@"province_id"] = @"31000";//默认上海
//    self.suitDataDictionary[@"city_id"] = @"310100";
//    self.suitDataDictionary[@"district_id"] = @"310115";
    
    self.suitDataDictionary[@"province_id"] = self.suitDataDictionary[@"province_id"]?self.suitDataDictionary[@"province_id"]:self.suResponse.product.province_id;//@"310000";
    self.suitDataDictionary[@"city_id"] = self.suitDataDictionary[@"city_id"]?self.suitDataDictionary[@"city_id"]:self.suResponse.product.city_id;//@"310100";
    self.suitDataDictionary[@"district_id"] = self.suitDataDictionary[@"district_id"]?self.suitDataDictionary[@"district_id"]:self.suResponse.product.district_id;
    
    
    self.suitDataDictionary[@"carbrand"] = self.suitDataDictionary[@"carbrand"]?self.suitDataDictionary[@"carbrand"]:self.suResponse.product.carbrand;   //车品牌
    self.suitDataDictionary[@"audi"] = self.suitDataDictionary[@"audi"]?self.suitDataDictionary[@"audi"]:self.suResponse.product.audi;  //车系
    self.suitDataDictionary[@"licenseplate"] = self.suitDataDictionary[@"licenseplate"]?self.suitDataDictionary[@"licenseplate"]:self.suResponse.product.licenseplate;  //车系
    
    self.suitDataDictionary[@"accountr"] = self.suitDataDictionary[@"accountr"]?self.suitDataDictionary[@"accountr"]:self.suResponse.product.accountr; //应收帐款
    self.suitDataDictionary[@"rate"] = self.suitDataDictionary[@"rate"]?self.suitDataDictionary[@"rate"]:self.suResponse.product.rate;  //借款利率
    self.suitDataDictionary[@"rate_cat"] = @"2";
//    self.suitDataDictionary[@"rate_cat"]?self.suitDataDictionary[@"rate_cat"]:self.suResponse.product.rate_cat;//借款利率单位
    self.suitDataDictionary[@"term"] = self.suitDataDictionary[@"term"]?self.suitDataDictionary[@"term"]:self.suResponse.product.term;//借款期限
    self.suitDataDictionary[@"repaymethod"] = self.suitDataDictionary[@"repaymethod"]?self.suitDataDictionary[@"repaymethod"]:self.suResponse.product.repaymethod;//付款方式
    self.suitDataDictionary[@"obligor"] = self.suitDataDictionary[@"obligor"]?self.suitDataDictionary[@"obligor"]:self.suResponse.product.obligor;//债务人主体
    self.suitDataDictionary[@"commissionperiod"] = self.suitDataDictionary[@"commissionperiod"]?self.suitDataDictionary[@"commissionperiod"]:self.suResponse.product.commissionperiod;  //委托代理期限
    self.suitDataDictionary[@"paidmoney"] = self.suitDataDictionary[@"paidmoney"]?self.suitDataDictionary[@"paidmoney"]:self.suResponse.product.paidmoney;//已付本金
    self.suitDataDictionary[@"interestpaid"] = self.suitDataDictionary[@"interestpaid"]?self.suitDataDictionary[@"interestpaid"]:self.suResponse.product.interestpaid; //已付利息
//    self.suitDataDictionary[@"performancecontract"] = self.suitDataDictionary[@"performancecontract"]?self.suitDataDictionary[@"performancecontract"]:self.suResponse.product.performancecontract; //合同履行地
    
    self.suitDataDictionary[@"place_province_id"] = self.suitDataDictionary[@"place_province_id"]?self.suitDataDictionary[@"place_province_id"]:self.suResponse.product.place_province_id;//@"310000";
    self.suitDataDictionary[@"place_city_id"] = self.suitDataDictionary[@"place_city_id"]?self.suitDataDictionary[@"place_city_id"]:self.suResponse.product.place_city_id;//@"310100";
    self.suitDataDictionary[@"place_district_id"] = self.suitDataDictionary[@"place_district_id"]?self.suitDataDictionary[@"place_district_id"]:self.suResponse.product.place_district_id;//@"310115";
    
    
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
    [self requestDataPostWithString:reFinanceString params:params successBlock:^(id responseObject) {
        
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
                UINavigationController *jijij = [[UINavigationController alloc] initWithRootViewController:reportFiSucVC];
                [jijij popViewControllerAnimated:NO];
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
