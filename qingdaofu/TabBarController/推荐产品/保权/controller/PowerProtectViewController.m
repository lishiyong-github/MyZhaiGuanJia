//
//  PowerProtectViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/1.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "PowerProtectViewController.h"
#import "ApplicationSuccessViewController.h"  //提交成功
#import "PowerProtectPictureViewController.h"  //选择材料
#import "ApplicationCourtViewController.h" //选择法院
#import "HouseChooseViewController.h" //收获地址

#import "BaseCommitView.h"
#import "AgentCell.h"
#import "SuitBaseCell.h" //取函方式
#import "PowerCourtView.h"

#import "UIViewController+BlurView.h"


#import "CourtProvinceResponse.h"
#import "CourtProvinceModel.h"

@interface PowerProtectViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *powerTableView;
@property (nonatomic,strong) BaseCommitView *powerCommitView;
@property (nonatomic,strong) PowerCourtView *powerPickerView;
@property (nonatomic,assign) BOOL didSetupConstraints;

@property (nonatomic,strong) NSMutableDictionary *powerDic;
@property (nonatomic,strong) NSMutableArray *powerCourtList;

@property (nonatomic,strong) NSString *courtProString;
@property (nonatomic,strong) NSString *courtCityString;

@end

@implementation PowerProtectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"申请保全";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self setupForDismissKeyboard];
    
    [self.view addSubview:self.powerTableView];
    [self.view addSubview:self.powerCommitView];
    [self.view addSubview:self.powerPickerView];
    [self.powerPickerView setHidden:YES];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.powerTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.powerTableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.powerCommitView];
        
        [self.powerCommitView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.powerCommitView autoSetDimension:ALDimensionHeight toSize:60];
        
        [self.powerPickerView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.powerPickerView autoSetDimension:ALDimensionHeight toSize:200];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

#pragma mark - setter and getter
- (UITableView *)powerTableView
{
    if (!_powerTableView) {
        _powerTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _powerTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _powerTableView.delegate = self;
        _powerTableView.dataSource = self;
        _powerTableView.separatorColor = kSeparateColor;
    }
    return _powerTableView;
}

- (UIView *)powerCommitView
{
    if (!_powerCommitView) {
        _powerCommitView = [BaseCommitView newAutoLayoutView];
        
        [_powerCommitView.button setTitle:@"点击申请" forState:0];
        QDFWeakSelf;
        [_powerCommitView.button addAction:^(UIButton *btn) {
            ApplicationSuccessViewController *applicationSuccessVC = [[ApplicationSuccessViewController alloc] init];
            applicationSuccessVC.successType = @"2";
            [weakself.navigationController pushViewController:applicationSuccessVC animated:YES];
        }];
    }
    return _powerCommitView;
}

- (PowerCourtView *)powerPickerView
{
    if (!_powerPickerView) {
        _powerPickerView = [PowerCourtView newAutoLayoutView];
        _powerPickerView.backgroundColor = kBackColor;
        
        QDFWeakSelf;
        [_powerPickerView setDidSelectdRow:^(NSInteger component, NSInteger row,CourtProvinceModel *model) {
            if (component == 0) {//省
                [weakself.powerDic setObject:model.idString forKey:@"area_pid"];
                weakself.courtProString = model.name;
                [weakself getCourtOfCityWithProvinceID:model.idString];
            }else if (component == 1){//市
                [weakself.powerDic setObject:model.idString forKey:@"area_id"];
                weakself.courtCityString = model.name;
            }else if (component == 2){//完成
                [weakself.powerPickerView setHidden:YES];
                
                AgentCell *cell = [weakself.powerTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                cell.agentTextField.text = [NSString stringWithFormat:@"%@%@",weakself.courtProString,weakself.courtCityString];
            }
        }];
    }
    return _powerPickerView;
}

-(NSMutableDictionary *)powerDic
{
    if (!_powerDic) {
        _powerDic = [NSMutableDictionary dictionary];
    }
    return _powerDic;
}

- (NSMutableArray *)powerCourtList
{
    if (!_powerCourtList) {
        _powerCourtList = [NSMutableArray array];
    }
    return _powerCourtList;
}

#pragma mark -tableview delegate and datasoyrce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
    }
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    if (indexPath.section == 0) {//选择区域,选择法院，案件类型
        if (indexPath.row < 3) {
            identifier = @"power00";
            AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.agentTextField.userInteractionEnabled = NO;
            cell.agentButton.userInteractionEnabled = NO;
            
            NSArray *powerArr = @[@"选择区域",@"选择法院",@"案件类型"];
            cell.agentLabel.text = powerArr[indexPath.row];
            cell.agentTextField.placeholder = @"请选择";
            [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
            
            return cell;
        }else{//电话，金额
            identifier = @"power01";
            AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.agentTextField.keyboardType = UIKeyboardTypeNumberPad;

            NSArray *powerArr = @[@"联系方式",@"保全金额"];
            NSArray *powerDetailArr = @[@"请输入电话号码",@"请输入保全金额"];
            cell.agentLabel.text = powerArr[indexPath.row-3];
            cell.agentTextField.placeholder = powerDetailArr[indexPath.row-3];
            
            QDFWeakSelf;
            if (indexPath.row == 3){//联系方式
                [cell.agentButton setHidden:YES];
                cell.agentTextField.text = [weakself getValidateMobile];
                
                [cell setDidEndEditing:^(NSString *text) {
                    [weakself.powerDic setObject:text forKey:@""];
                }];
                
            }else if (indexPath.row == 4){//保全金额
                [cell.agentButton setHidden:NO];
                [cell.agentButton setTitle:@"万元" forState:0];
                
                [cell setDidEndEditing:^(NSString *text) {
                    [weakself.powerDic setObject:text forKey:@""];
                }];
            }
            
            return cell;
        }
    }
    
    //section==1
    if (indexPath.row == 0) {//取函方式
        identifier = @"application10";
        SuitBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[SuitBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.label.text = @"取函方式";
        [self.powerDic setObject:@"1" forKey:@"address"]; //默认选择快递
        
        QDFWeakSelf;
        QDFWeak(cell);
        [cell setDidSelectedSeg:^(NSInteger segTag) {
            if (segTag == 0) {//快递
                AgentCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
                cell.agentTextField.userInteractionEnabled = NO;
                cell.agentButton.userInteractionEnabled = NO;
                [self.powerDic setObject:@"1" forKey:@"address"]; //默认选择快递

                cell.agentLabel.text = @"收货地址";
                cell.agentTextField.placeholder = @"请选择";
                cell.agentTextField.text = @"";
                [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
            }else if (segTag == 1){//自取
                if (weakself.powerDic[@"court"]) {
                    AgentCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
                    cell.agentTextField.userInteractionEnabled = NO;
                    cell.agentButton.userInteractionEnabled = NO;
                    [self.powerDic setObject:@"2" forKey:@"address"]; //默认选择快递

                    cell.agentLabel.text = @"取函地址";
                    cell.agentTextField.text = weakself.powerDic[@"court"];
                    [cell.agentButton setImage:[UIImage imageNamed:@""] forState:0];

                }else{
                    weakcell.segment.selectedSegmentIndex = 0;
                    [weakself showHint:@"请先选择法院"];
                }
            }
        }];
        
        return cell;
    }
    
    identifier = @"application11";
    AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.agentTextField.userInteractionEnabled = NO;
    cell.agentButton.userInteractionEnabled = NO;
    
    cell.agentLabel.text = @"收货地址";
    cell.agentTextField.placeholder = @"请选择";
    [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kBigPadding;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return kBigPadding;
    }
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self getCourtOfProvince];
            
        }else if (indexPath.row == 1){
            
        }else if(indexPath.row == 2){
            NSArray *array11 = @[@"借贷纠纷",@"房产土地",@"劳动纠纷",@"婚姻家庭",@" 合同纠纷",@"公司治理",@"知识产权",@"其他民事纠纷"];
            
            [self showBlurInView:self.view withArray:array11 andTitle:@"选择案件类型" finishBlock:^(NSString *text, NSInteger row) {
                AgentCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                cell.agentTextField.text = text;
            }];
        }
    }else{
        if (indexPath.row == 1) {
            if ([self.powerDic[@"address"] isEqualToString:@"1"]) {//快递
                HouseChooseViewController *houseChooseVC = [[HouseChooseViewController alloc] init];
                [self.navigationController pushViewController:houseChooseVC animated:YES];
                
                [houseChooseVC setDidSelectedRow:^(NSString *text) {
                    AgentCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                    cell.agentTextField.text = text;
                }];
            }
        }
    }
}

#pragma mark - method
//省份
- (void)getCourtOfProvince
{
    NSString *brandString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kGuaranteeCourtProvince];
    NSDictionary *param = @{@"token" : [self getValidateToken]};
    
    QDFWeakSelf;
    [self requestDataPostWithString:brandString params:param successBlock:^(id responseObject) {
        
        [weakself.powerPickerView.component1 removeAllObjects];
        
        CourtProvinceResponse * courtResponse = [CourtProvinceResponse objectWithKeyValues:responseObject];
        
        for (CourtProvinceModel *proModel in courtResponse.data) {
            [weakself.powerPickerView.component1 addObject:proModel];
        }
        
        [weakself.powerPickerView setHidden:NO];
        [weakself.powerPickerView.pickerViews reloadAllComponents];
        
    } andFailBlock:^(NSError *error) {
        
    }];
}
//市
- (void)getCourtOfCityWithProvinceID:(NSString *)areaPid
{
    NSString *cityString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kGuaranteeCourtCity];
    NSDictionary *param = @{@"token" : [self getValidateToken],
                            @"depdrop_parents" : areaPid};
    
    QDFWeakSelf;
    [self requestDataPostWithString:cityString params:param successBlock:^(id responseObject) {
        
        [weakself.powerPickerView.component2 removeAllObjects];

        CourtProvinceResponse * courtResponse = [CourtProvinceResponse objectWithKeyValues:responseObject];
        
        for (CourtProvinceModel *cityModel in courtResponse.data) {
            [weakself.powerPickerView.component2 addObject:cityModel];
        }
        
        weakself.powerPickerView.typeComponent = @"2";
        [weakself.powerPickerView.pickerViews reloadAllComponents];
        
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
