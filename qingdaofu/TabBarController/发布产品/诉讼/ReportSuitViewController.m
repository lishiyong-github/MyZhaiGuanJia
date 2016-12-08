//
//  ReportSuitViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/10.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ReportSuitViewController.h"

#import "SuitBaseCell.h" //费用类型
#import "SuitNewCell.h" //债权类型，委托事项
#import "AgentCell.h"
#import "PowerCourtView.h"//合同履行地

#import "PublishingResponse.h"
#import "RowsModel.h"

#import "CourtProvinceResponse.h"
#import "CourtProvinceModel.h"

@interface ReportSuitViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *reportTableView;
@property (nonatomic,strong) PowerCourtView *reportPickerView; //省市区

//json
@property (nonatomic,strong) NSMutableArray *reportDataArray;//详情
@property (nonatomic,strong) NSMutableDictionary *reportDictionary;//请求参数
@property (nonatomic,strong) NSMutableDictionary *addressTestDict;//临时保存抵押物地址

@property (nonatomic,strong) NSMutableDictionary *categoryDic; //临时保存债权类型
@property (nonatomic,strong) NSMutableDictionary *entrustDic;//临时保存委托事项

@end

@implementation ReportSuitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.productid) {
        self.title = @"发布债权";
    }

    self.navigationItem.leftBarButtonItem = self.leftItemAnother;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    [self.rightButton setTitle:@"发布" forState:0];
    
    [self setupForDismissKeyboard];
    
    [self.view addSubview:self.reportTableView];
    [self.view addSubview:self.reportPickerView];
    [self.reportPickerView setHidden:YES];
    
    [self.view setNeedsUpdateConstraints];
    
    if (self.productid) {
        [self getDetailsOfReportMessage];
    }
}

- (void)dealloc
{
    [self removeKeyboardObserver];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.reportTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        [self.reportPickerView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)reportTableView
{
    if (!_reportTableView) {
        _reportTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _reportTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _reportTableView.backgroundColor = kBackColor;
        _reportTableView.separatorColor = kSeparateColor;
        _reportTableView.delegate = self;
        _reportTableView.dataSource = self;
        _reportTableView.tableFooterView = [[UIView alloc] init];
    }
    return _reportTableView;
}

- (PowerCourtView *)reportPickerView
{
    if (!_reportPickerView) {
        _reportPickerView = [PowerCourtView newAutoLayoutView];

        QDFWeakSelf;
        [_reportPickerView setDidSelectdRow:^(NSInteger component, NSInteger row,CourtProvinceModel *model) {
            if (component == 0) {//省
                [weakself.addressTestDict setObject:model.name forKey:@"proName"];
                [weakself.addressTestDict setObject:model.idString forKey:@"proID"];
                
                [weakself getCityListWithProvinceID:model.idString];
            }else if (component == 1){//市
                [weakself.addressTestDict setObject:model.name forKey:@"cityName"];
                [weakself.addressTestDict setObject:model.idString forKey:@"cityID"];
                [weakself getDistrictListWithCityID:model.idString];
            }else if (component == 2){//区
                [weakself.addressTestDict setObject:model.name forKey:@"districtName"];
                [weakself.addressTestDict setObject:model.idString forKey:@"districtID"];
                
            }else if (component == 3){
                if (weakself.addressTestDict[@"proName"] && weakself.addressTestDict[@"cityName"] && weakself.addressTestDict[@"districtName"]) {//都选择
                        AgentCell *cell = [weakself.reportTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:4]];
                        cell.agentTextField.text = [NSString stringWithFormat:@"%@%@%@",weakself.addressTestDict[@"proName"],weakself.addressTestDict[@"cityName"],weakself.addressTestDict[@"districtName"]];
    
                        [weakself.reportDictionary setValue:weakself.addressTestDict[@"proID"] forKey:@"province_id"];
                        [weakself.reportDictionary setValue:weakself.addressTestDict[@"cityID"] forKey:@"city_id"];
                        [weakself.reportDictionary setValue:weakself.addressTestDict[@"districtID"] forKey:@"district_id"];
                        [weakself.reportDictionary setValue:cell.agentTextField.text forKey:@"address"];
                    }
                
            }
        }];
    }
    return _reportPickerView;
}

- (NSMutableArray *)reportDataArray
{
    if (!_reportDataArray) {
        _reportDataArray = [NSMutableArray array];
    }
    return _reportDataArray;
}

- (NSMutableDictionary *)reportDictionary
{
    if (!_reportDictionary) {
        _reportDictionary = [NSMutableDictionary dictionary];
    }
    return _reportDictionary;
}

- (NSMutableDictionary *)addressTestDict
{
    if (!_addressTestDict) {
        _addressTestDict = [NSMutableDictionary dictionary];
    }
    return _addressTestDict;
}

- (NSMutableDictionary *)categoryDic
{
    if (!_categoryDic) {
        _categoryDic = [NSMutableDictionary dictionary];
    }
    return _categoryDic;
}

- (NSMutableDictionary *)entrustDic
{
    if (!_entrustDic) {
        _entrustDic = [NSMutableDictionary dictionary];
    }
    return _entrustDic;
}

#pragma mark - tableView delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.productid) {
        if (self.reportDataArray.count > 0) {
            return 5;
        }
        return 0;
    }
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        return 3;
    }
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < 2) {
        return 102;
    }
    
    return kCellHeight3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    
    RowsModel *rowModel;
    if (self.reportDataArray.count > 0) {
        rowModel = self.reportDataArray[0];
    }
    
    if (indexPath.section == 0) {//债权类型
        identifier = @"newSuit0";
        SuitNewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[SuitNewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSString *ddd1 = @"债权类型";
        NSString *ddd2 = @"（多选）";
        NSString *ddd = [NSString stringWithFormat:@"%@\n%@",ddd1,ddd2];
        NSMutableAttributedString *attributeDD = [[NSMutableAttributedString alloc] initWithString:ddd];
        [attributeDD addAttributes:@{NSFontAttributeName:kBigFont,NSForegroundColorAttributeName:kBlackColor} range:NSMakeRange(0, ddd1.length)];
        [attributeDD addAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kTextColor} range:NSMakeRange(ddd1.length+1, ddd2.length)];
        NSMutableParagraphStyle *aiai = [[NSMutableParagraphStyle alloc] init];
        [aiai setLineSpacing:4];
        [attributeDD addAttribute:NSParagraphStyleAttributeName value:aiai range:NSMakeRange(0, ddd.length)];
        [cell.cateLabel setAttributedText:attributeDD];
        
        [cell.optionButton1 setTitle:@"房产抵押" forState:0];
        [cell.optionButton2 setTitle:@"机动车抵押" forState:0];
        [cell.optionButton3 setTitle:@"合同纠纷" forState:0];
        [cell.optionButton4 setTitle:@"其他" forState:0];
        cell.optionTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSpacePadding, 0)];
        cell.optionTextField.leftViewMode = UITextFieldViewModeAlways;
        
        [self.reportDictionary setValue:@"" forKey:@"category_other"];
        
        if ([self.reportDictionary[@"category"] containsString:@"1"]) {
            cell.optionButton1.selected = YES;
        }
        if ([self.reportDictionary[@"category"] containsString:@"2"]){
            cell.optionButton2.selected = YES;
        }
        if ([self.reportDictionary[@"category"] containsString:@"3"]){
            cell.optionButton3.selected = YES;
        }
        if ([self.reportDictionary[@"category"] containsString:@"4"]) {
            cell.optionButton4.selected = YES;
            cell.optionTextField.text = self.reportDictionary[@"category_other"];
        }
        
        QDFWeakSelf;
        QDFWeak(cell);
        [cell setDidBeginEditting:^(NSString *text) {
            if (text.length > 0) {
                weakcell.optionButton4.selected = YES;
                [weakself.categoryDic setObject:@"4" forKey:@"4"];
            }else{
                weakcell.optionButton4.selected = NO;
                [weakself.categoryDic removeObjectForKey:@"4"];
            }
        }];
        [cell setDidEndEditting:^(NSString *text) {
            [weakself.reportDictionary setValue:text forKey:@"category_other"];
        }];
        
        [cell setDidSelectedButton:^(UIButton *btn) {
            btn.selected = !btn.selected;
            switch (btn.tag) {
                case 101:{//1
                    if (btn.selected) {
                        [weakself.categoryDic setObject:@"1" forKey:@"1"];
                    }else{
                        [weakself.categoryDic removeObjectForKey:@"1"];
                    }
                }
                    break;
                case 102:{//2
                    if (btn.selected) {
                        [weakself.categoryDic setObject:@"2" forKey:@"2"];
                    }else{
                        [weakself.categoryDic removeObjectForKey:@"2"];
                    }
                }
                    break;
                case 103:{//3
                    if (btn.selected) {
                        [weakself.categoryDic setObject:@"3" forKey:@"3"];
                    }else{
                        [weakself.categoryDic removeObjectForKey:@"3"];
                    }
                }
                    break;
                case 104:{//4
                    if (btn.selected) {
                        [weakcell.optionTextField becomeFirstResponder];
                        weakcell.optionTextField.text = weakself.reportDictionary[@"category_other"];
//                        if (![weakself.categoryArray containsObject:@"4"]) {
//                            [weakself.categoryArray addObject:@"4"];
//                        }
                        [weakself.categoryDic setObject:@"4" forKey:@"4"];
                    }
                }
                    break;
                default:
                    break;
            }
        }];
        
        return cell;
    }else if (indexPath.section == 1){//委托事项
        
        identifier = @"newSuit1";
        SuitNewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[SuitNewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSString *ddd1 = @"委托事项";
        NSString *ddd2 = @"（多选）";
        NSString *ddd = [NSString stringWithFormat:@"%@\n%@",ddd1,ddd2];
        NSMutableAttributedString *attributeDD = [[NSMutableAttributedString alloc] initWithString:ddd];
        [attributeDD addAttributes:@{NSFontAttributeName:kBigFont,NSForegroundColorAttributeName:kBlackColor} range:NSMakeRange(0, ddd1.length)];
        [attributeDD addAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kTextColor} range:NSMakeRange(ddd1.length+1, ddd2.length)];
        NSMutableParagraphStyle *aiai = [[NSMutableParagraphStyle alloc] init];
        [aiai setLineSpacing:4];
        [attributeDD addAttribute:NSParagraphStyleAttributeName value:aiai range:NSMakeRange(0, ddd.length)];
        [cell.cateLabel setAttributedText:attributeDD];
        
        [cell.optionButton1 setTitle:@"清收" forState:0];
        [cell.optionButton2 setTitle:@"诉讼" forState:0];
        [cell.optionButton3 setTitle:@"债权转让" forState:0];
        [cell.optionButton4 setTitle:@"其他" forState:0];
        cell.optionTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSpacePadding, 0)];
        cell.optionTextField.leftViewMode = UITextFieldViewModeAlways;
        [self.reportDictionary setValue:@"" forKey:@"entrust_other"];

        
        if ([self.reportDictionary[@"entrust"] containsString:@"1"]) {
            cell.optionButton1.selected = YES;
        }
        if ([self.reportDictionary[@"entrust"] containsString:@"2"]){
            cell.optionButton2.selected = YES;
        }
        if ([self.reportDictionary[@"entrust"] containsString:@"3"]){
            cell.optionButton3.selected = YES;
        }
        if ([self.reportDictionary[@"entrust"] containsString:@"4"]) {
            cell.optionButton4.selected = YES;
            cell.optionTextField.text = self.reportDictionary[@"entrust_other"];
        }
        
        
        QDFWeakSelf;
        QDFWeak(cell);
        [cell setDidBeginEditting:^(NSString *text) {
            if (text.length > 0) {
                weakcell.optionButton4.selected = YES;
//                if (![weakself.entrustArray containsObject:@"4"]) {
//                    [weakself.entrustArray addObject:@"4"];
//                }
                [weakself.entrustDic setObject:@"4" forKey:@"4"];
            }
        }];
        [cell setDidEndEditting:^(NSString *text) {
            [weakself.reportDictionary setValue:text forKey:@"entrust_other"];
        }];
        
        [cell setDidSelectedButton:^(UIButton *btn) {
            btn.selected = !btn.selected;
            switch (btn.tag) {
                case 101:{//1
                    if (btn.selected) {
                        [weakself.entrustDic setObject:@"1" forKey:@"1"];
                       
                    }else{
                        [weakself.entrustDic removeObjectForKey:@"1"];
                    }
                }
                    break;
                case 102:{//2
                    if (btn.selected) {
                        [weakself.entrustDic setObject:@"2" forKey:@"2"];
                        
                    }else{
                        [weakself.entrustDic removeObjectForKey:@"2"];
                    }
                }
                    break;
                case 103:{//3
                    if (btn.selected) {
                        [weakself.entrustDic setObject:@"3" forKey:@"3"];
                        
                    }else{
                        [weakself.entrustDic removeObjectForKey:@"3"];
                    }
                }
                    break;
                case 104:{//4
                    
                    if (btn.selected) {
                        [weakcell.optionTextField becomeFirstResponder];
                         weakcell.optionTextField.text = weakself.reportDictionary[@"entrust_other"];
                        [weakself.entrustDic setObject:@"4" forKey:@"4"];
                    }else{
                        [weakcell.optionTextField resignFirstResponder];
                        weakcell.optionTextField.text = @"";
                        [weakself.reportDictionary removeObjectForKey:@"entrust_other"];
                        [weakself.entrustDic removeObjectForKey:@"4"];
                    }
                }
                    break;
                default:
                    break;
            }
        }];
        
        return cell;
        
    }else if (indexPath.section == 2){//基本信息
        if (indexPath.row == 0) {//委托金额
            identifier = @"newSuit20";
            AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.leftdAgentContraints.constant = 100;
            cell.agentLabel.text = @"委托金额";
            cell.agentTextField.placeholder = @"请输入";
            [cell.agentButton setTitle:@"万" forState:0];
            cell.agentTextField.text = self.reportDictionary[@"account"];
            
            QDFWeakSelf;
            [cell setDidEndEditing:^(NSString *text) {
                [weakself.reportDictionary setValue:text forKey:@"account"];
            }];
            
            return cell;
        }else if (indexPath.row == 1){//费用类型
            identifier = @"newSuit21";
            SuitBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[SuitBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            cell.label.text = @"费用类型";
            [cell.segment setTitle:@"固定费用" forSegmentAtIndex:0];
            [cell.segment setTitle:@"风险费率" forSegmentAtIndex:1];
            if (!self.reportDictionary[@"type"]) {
                [self.reportDictionary setValue:@"1" forKey:@"type"];
            }
            
            if ([self.reportDictionary[@"type"] integerValue] == 1) {
                cell.segment.selectedSegmentIndex = 0;
            }else if ([self.reportDictionary[@"type"] integerValue] == 2){
                cell.segment.selectedSegmentIndex = 1;
            }
            
            QDFWeakSelf;
            [cell setDidSelectedSeg:^(NSInteger segTag) {
                if (segTag == 0) {//固定费用
                    AgentCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:2]];
                    cell.agentLabel.text = @"固定费用";
                    cell.agentTextField.text = weakself.reportDictionary[@"typenum"];
                    [cell.agentButton setTitle:@"万" forState:0];
                    
                }else{//风险费率
                    AgentCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:2]];
                    cell.agentLabel.text = @"风险费率";
                    cell.agentTextField.text = weakself.reportDictionary[@"typenum"];
                    [cell.agentButton setTitle:@"％" forState:0];
                }
                
                NSString *ssss = [NSString stringWithFormat:@"%ld",segTag+1];
                [weakself.reportDictionary setValue:ssss forKey:@"type"];
            }];
            
            return cell;
        }else if(indexPath.row == 2){
            identifier = @"newSuit22";
            AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.leftdAgentContraints.constant = 100;
            
            cell.agentLabel.text = @"固定费用";
            cell.agentTextField.placeholder = @"请输入";
            [cell.agentButton setTitle:@"万" forState:0];
            
            if ([self.reportDictionary[@"type"] integerValue] == 1) {
                cell.agentLabel.text = @"固定费用";
                cell.agentTextField.text = self.reportDictionary[@"typenum"];
                [cell.agentButton setTitle:@"万" forState:0];
            }else if ([self.reportDictionary[@"type"] integerValue] == 2){
                cell.agentLabel.text = @"风险费率";
                cell.agentTextField.text = self.reportDictionary[@"typenum"];
                [cell.agentButton setTitle:@"%" forState:0];
            }

            QDFWeakSelf;
            [cell setDidEndEditing:^(NSString *text) {
                [weakself.reportDictionary setValue:text forKey:@"typenum"];
            }];
            
            return cell;
        }
    }else if (indexPath.section == 3){//违约期限
        identifier = @"newSuit3";
        AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftdAgentContraints.constant = 100;

        cell.agentLabel.text = @"违约期限";
        cell.agentTextField.placeholder = @"请输入";
        [cell.agentButton setTitle:@"个月" forState:0];
        
        cell.agentTextField.text = self.reportDictionary[@"overdue"];
        
        QDFWeakSelf;
        [cell setDidEndEditing:^(NSString *text) {
            [weakself.reportDictionary setValue:text forKey:@"overdue"];
        }];
        
        return cell;
    }else{//合同履行地
        identifier = @"newSuit4";
        AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftdAgentContraints.constant = 100;
        [cell.agentButton setHidden:YES];
        cell.agentTextField.userInteractionEnabled = NO;
        
        cell.agentLabel.text = @"合同履行地";
        cell.agentTextField.placeholder = @"请选择";
        
        cell.agentTextField.text = self.reportDictionary[@"address"];
        
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 4) {
        [self getProvinceList];
    }
}

#pragma mark - get province city and dictrict
- (void)getProvinceList
{
    NSString *provinceString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kPublishproductOfProvince];
    
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"type" : @"app"};
    
    QDFWeakSelf;
    [self requestDataPostWithString:provinceString params:params successBlock:^(id responseObject) {
        
        [weakself.reportPickerView.component1 removeAllObjects];
        
        CourtProvinceResponse *courtResponse = [CourtProvinceResponse objectWithKeyValues:responseObject];
        
        for (CourtProvinceModel *proModel in courtResponse.data) {
            [weakself.reportPickerView.component1 addObject:proModel];
        }
        
        [weakself.reportPickerView setHidden:NO];
        weakself.reportPickerView.typeComponent = @"1";
        [weakself.reportPickerView.pickerViews reloadAllComponents];
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)getCityListWithProvinceID:(NSString *)provinceId
{
    NSString *cityString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kPublishproductOfCity];
    NSDictionary *params = @{@"province_id" : provinceId,
                             @"token" : [self getValidateToken],
                             @"type" : @"app"};
    
    QDFWeakSelf;
    [self requestDataPostWithString:cityString params:params successBlock:^(id responseObject) {
        
        [weakself.reportPickerView.component2 removeAllObjects];
        
        CourtProvinceResponse *courtResponse = [CourtProvinceResponse objectWithKeyValues:responseObject];
        
        for (CourtProvinceModel *cityModel in courtResponse.data) {
            [weakself.reportPickerView.component2 addObject:cityModel];
        }
        
        weakself.reportPickerView.typeComponent = @"2";
        [weakself.reportPickerView.pickerViews reloadAllComponents];
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)getDistrictListWithCityID:(NSString *)cityId
{
    NSString *districtString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kPublishproductOfArea];
    NSDictionary *params = @{@"city" : cityId,
                             @"token" : [self getValidateToken],
                             @"type" : @"app"};
    
    QDFWeakSelf;
    [self requestDataPostWithString:districtString params:params successBlock:^(id responseObject) {
        [weakself.reportPickerView.component3 removeAllObjects];
        
        CourtProvinceResponse *courtResponse = [CourtProvinceResponse objectWithKeyValues:responseObject];
        
        for (CourtProvinceModel *districtModel in courtResponse.data) {
            [weakself.reportPickerView.component3 addObject:districtModel];
        }
        
        weakself.reportPickerView.typeComponent = @"3";
        [weakself.reportPickerView.pickerViews reloadAllComponents];
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

#pragma mark - method
- (void)getDetailsOfReportMessage
{
    NSString *reportMessageString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kReportDetailsString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"productid" : self.productid};
    
    QDFWeakSelf;
    [self requestDataPostWithString:reportMessageString params:params successBlock:^(id responseObject) {
        PublishingResponse *respnse = [PublishingResponse objectWithKeyValues:responseObject];
        if ([respnse.code isEqualToString:@"0000"]) {
            RowsModel *rowModel = respnse.data;
            [weakself.reportDataArray addObject:rowModel];
            
            //保存参数
            [weakself.reportDictionary setValue:rowModel.category forKey:@"category"];
            [weakself.reportDictionary setValue:rowModel.category_other forKey:@"category_other"];
            [weakself.reportDictionary setValue:rowModel.entrust forKey:@"entrust"];
            [weakself.reportDictionary setValue:rowModel.entrust_other forKey:@"entrust_other"];
            [weakself.reportDictionary setValue:rowModel.accountLabel forKey:@"account"];
            [weakself.reportDictionary setValue:rowModel.type forKey:@"type"];
            [weakself.reportDictionary setValue:rowModel.typenumLabel forKey:@"typenum"];
            [weakself.reportDictionary setValue:rowModel.overdue forKey:@"overdue"];
            [weakself.reportDictionary setValue:rowModel.province_id forKey:@"province_id"];
            [weakself.reportDictionary setValue:rowModel.city_id forKey:@"city_id"];
            [weakself.reportDictionary setValue:rowModel.district_id forKey:@"district_id"];
            [weakself.reportDictionary setValue:rowModel.addressLabel forKey:@"address"];
            
            NSArray *a1 = [rowModel.category componentsSeparatedByString:@","];
            for (int i=0; i<a1.count; i++) {
                [weakself.categoryDic setObject:a1[i] forKey:a1[i]];
            }
            [weakself.categoryDic removeObjectForKey:@""];
            
            NSArray *a2 = [rowModel.entrust componentsSeparatedByString:@","];
            for (int j=0; j<a2.count; j++) {
                [weakself.entrustDic setObject:a2[j] forKey:a2[j]];
            }
            [weakself.entrustDic removeObjectForKey:@""];
        }
        
        [weakself.reportTableView reloadData];
    } andFailBlock:^(NSError *error) {
        
    }];
}

//发布
- (void)rightItemAction
{
    [self.view endEditing:YES];
    
    if (self.categoryDic.allKeys.count > 0) {//债权类型
        NSString *soso = @"";
        for (int i=0; i<self.categoryDic.allKeys.count; i++) {
            soso = [NSString stringWithFormat:@"%@,%@",self.categoryDic.allKeys[i],soso];
        }
        soso = [soso substringWithRange:NSMakeRange(0, soso.length-1)];
        [self.reportDictionary setValue:soso forKey:@"category"];
    }
    
    if (self.entrustDic.allKeys.count > 0) {//委托事项
        NSString *wowo = @"";
        for (int i=0; i<self.entrustDic.allKeys.count; i++) {
            wowo = [NSString stringWithFormat:@"%@,%@",self.entrustDic.allKeys[i],wowo];
        }
        wowo = [wowo substringWithRange:NSMakeRange(0, wowo.length-1)];
        [self.reportDictionary setValue:wowo forKey:@"entrust"];
    }
    
    [self.reportDictionary setValue:[self getValidateToken] forKey:@"token"];
    
    NSString *reFinanceString;//url
    if ([self.tagString integerValue] == 1) {//新增发布
        reFinanceString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kPublishProduct];
    }else{//保存再发布，发布再发布
        [self.reportDictionary setValue:self.productid forKey:@"productid"];
        reFinanceString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kPublishProductTwice];
    }
    NSDictionary *params = self.reportDictionary;
    
    QDFWeakSelf;
    [self requestDataPostWithString:reFinanceString params:params successBlock:^(id responseObject) {
        
        BaseModel *baseModel = [BaseModel objectWithKeyValues:responseObject];
        [weakself showHint:baseModel.msg];
        
        if ([baseModel.code isEqualToString:@"0000"]) {
            [weakself dismissViewControllerAnimated:YES completion:nil];
        }
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)saveDraftAction
{
    [self.view endEditing:YES];
    
    if (self.categoryDic.allKeys.count > 0) {//债权类型
        NSString *soso = @"";
        for (int i=0; i<self.categoryDic.allKeys.count; i++) {
            soso = [NSString stringWithFormat:@"%@,%@",self.categoryDic.allKeys[i],soso];
        }
        soso = [soso substringWithRange:NSMakeRange(0, soso.length-1)];
        [self.reportDictionary setValue:soso forKey:@"category"];
    }
    
    if (self.entrustDic.allKeys.count > 0) {//委托事项
        NSString *wowo = @"";
        for (int i=0; i<self.entrustDic.allKeys.count; i++) {
            wowo = [NSString stringWithFormat:@"%@,%@",self.entrustDic.allKeys[i],wowo];
        }
        wowo = [wowo substringWithRange:NSMakeRange(0, wowo.length-1)];
        [self.reportDictionary setValue:wowo forKey:@"entrust"];
    }
    
    NSString *saveDraft;
    if ([self.tagString integerValue] == 1) {//新增保存
        saveDraft = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kSaveDraftOfProduct];
    }else if ([self.tagString integerValue] == 2){//保存再保存
        saveDraft = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kSaveDraftOfProductTwice];
        [self.reportDictionary setValue:self.productid forKey:@"productid"];
    }
    
    [self.reportDictionary setValue:[self getValidateToken] forKey:@"token"];
    
    NSDictionary *params = self.reportDictionary;
    
    QDFWeakSelf;
    [self requestDataPostWithString:saveDraft params:params successBlock:^(id responseObject) {
        
        BaseModel *baseModel = [BaseModel objectWithKeyValues:responseObject];
        [weakself showHint:baseModel.msg];
        
        if ([baseModel.code isEqualToString:@"0000"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"headerRefresh" object:nil];
            [weakself dismissViewControllerAnimated:YES completion:nil];
        }
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)back
{
    if ([self.tagString integerValue] == 3) {//发布中编辑，不能保存
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"是否保存" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"保存" otherButtonTitles:@"不保存", nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
        
        [actionSheet showInView:self.view];
    }
}

#pragma mark - actionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {//保存
        [self saveDraftAction];
    }else if (buttonIndex == 1){//不保存
        [self dismissViewControllerAnimated:YES completion:nil];
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
