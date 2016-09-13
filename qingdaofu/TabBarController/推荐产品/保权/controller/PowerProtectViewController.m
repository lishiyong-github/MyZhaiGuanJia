//
//  PowerProtectViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/1.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "PowerProtectViewController.h"
#import "PowerProtectPictureViewController.h"  //选择材料
#import "ApplicationCourtViewController.h" //选择法院
#import "HouseChooseViewController.h" //收获地址
#import "ReceiptAddressViewController.h"
#import "PowerProtectListViewController.h" //我的保全


#import "BaseCommitView.h"
#import "AgentCell.h"
#import "SuitBaseCell.h" //取函方式
#import "PowerAddressCell.h"
#import "PowerCourtView.h"

#import "UIViewController+BlurView.h"


#import "CourtProvinceResponse.h"
#import "CourtProvinceModel.h"

@interface PowerProtectViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *powerTableView;
@property (nonatomic,strong) BaseCommitView *powerCommitView;
@property (nonatomic,strong) PowerCourtView *powerPickerView;
@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,assign) BOOL chooseFlag; //改变收货地址cell的变量

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
    
    [self addKeyboardObserver];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.powerTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.powerTableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.powerCommitView];
        
        [self.powerCommitView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.powerCommitView autoSetDimension:ALDimensionHeight toSize:60];
        
        [self.powerPickerView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
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
        _powerTableView.backgroundColor = kBackColor;
    }
    return _powerTableView;
}

- (UIView *)powerCommitView
{
    if (!_powerCommitView) {
        _powerCommitView = [BaseCommitView newAutoLayoutView];
        
        [_powerCommitView.button setTitle:@"点击申请" forState:0];
        [_powerCommitView addTarget:self action:@selector(goToPowerApply) forControlEvents:UIControlEventTouchUpInside];
    }
    return _powerCommitView;
}

- (PowerCourtView *)powerPickerView
{
    if (!_powerPickerView) {
        _powerPickerView = [PowerCourtView newAutoLayoutView];
        
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
                
                if (weakself.powerPickerView.component2.count > 0) {
                    AgentCell *cell = [weakself.powerTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                    cell.agentTextField.text = [NSString stringWithFormat:@"%@%@",weakself.courtProString,weakself.courtCityString];
                }
            }
        }];
    }
    return _powerPickerView;
}

-(NSMutableDictionary *)powerDic
{
    if (!_powerDic) {
        _powerDic = [NSMutableDictionary dictionary];
        [_powerDic setObject:@"2" forKey:@"type"];
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
    if (indexPath.section == 1 && indexPath.row == 1) {
        if (_chooseFlag) {
            return 65;
        }else{
            return kCellHeight;
        }
    }
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
            
            [cell setTouchBeginPoint:^(CGPoint point) {
                weakself.touchPoint = point;
            }];
            
            if (indexPath.row == 3){//联系方式
                [cell.agentButton setHidden:YES];
                cell.agentTextField.text = [weakself getValidateMobile];
                
                [cell setDidEndEditing:^(NSString *text) {
                    [weakself.powerDic setObject:text forKey:@"phone"];
                }];
                
            }else if (indexPath.row == 4){//保全金额
                [cell.agentButton setHidden:NO];
                [cell.agentButton setTitle:@"万元" forState:0];
                
                [cell setDidEndEditing:^(NSString *text) {
                    [weakself.powerDic setObject:text forKey:@"account"];
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
        
        QDFWeakSelf;
        QDFWeak(cell);
        [cell setDidSelectedSeg:^(NSInteger segTag) {
            if (segTag == 0) {//快递
                AgentCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
//                cell.agentTextField.userInteractionEnabled = NO;
//                cell.agentButton.userInteractionEnabled = NO;
//                [self.powerDic setObject:@"2" forKey:@"type"]; //默认选择快递

//                cell.agentLabel.text = @"收货地址";
//                cell.agentTextField.placeholder = @"请选择";
//                cell.agentTextField.text = @"";
//                [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
                cell.agentTextField.userInteractionEnabled = YES;
                [cell.agentButton setHidden:YES];
                [self.powerDic setObject:@"2" forKey:@"type"]; //默认选择快递
                
                cell.agentLabel.text = @"收货地址";
                cell.agentTextField.placeholder = @"请输入收货地址";
                cell.agentTextField.text = weakself.powerDic[@"address"];
                
            }else if (segTag == 1){//自取
                if (weakself.powerDic[@"fayuan_id"]) {
                    
//                    _chooseFlag = NO;
//                    [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
                    
                    AgentCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
                    cell.agentTextField.userInteractionEnabled = NO;
                    cell.agentButton.userInteractionEnabled = NO;
                    [self.powerDic setObject:@"1" forKey:@"type"];
                    
                    cell.agentLabel.text = @"取函地址";
                    cell.agentTextField.text = weakself.powerDic[@"fayuan_name"];
                    [cell.agentButton setImage:[UIImage imageNamed:@""] forState:0];

                }else{
                    weakcell.segment.selectedSegmentIndex = 0;
                    [weakself showHint:@"请先选择法院"];
                }
            }
        }];
        
        return cell;
    }
    
    if (_chooseFlag) {
        identifier = @"application113";
        PowerAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[PowerAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.actButton.userInteractionEnabled = NO;
        [cell.actButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        
//        cell.agentTextField.userInteractionEnabled = NO;
//        cell.agentButton.userInteractionEnabled = NO;
//        
//        cell.agentLabel.text = @"收货地址";
//        cell.agentTextField.placeholder = @"请选择";
//        [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        
        return cell;
    }else{
        identifier = @"application11";
        AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.agentTextField.userInteractionEnabled = NO;
//        cell.agentButton.userInteractionEnabled = NO;
//        
//        cell.agentLabel.text = @"收货地址";
//        cell.agentTextField.placeholder = @"请选择";
//        [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        
        [cell.agentButton setHidden:YES];
        cell.agentLabel.text = @"收货地址";
        cell.agentTextField.placeholder = @"请输入收货地址";
        
        QDFWeakSelf;
        [cell setTouchBeginPoint:^(CGPoint point) {
            weakself.touchPoint = point;
        }];
        
        [cell setDidEndEditing:^(NSString *text) {
            [weakself.powerDic setObject:text forKey:@"address"];
        }];
        
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
    if (section == 1) {
        return kBigPadding;
    }
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if (self.powerPickerView.component1.count == 0) {
                [self getCourtOfProvince];
            }else{
                [self.powerPickerView setHidden:NO];
                [self.powerPickerView.pickerViews reloadAllComponents];
            }
            
        }else if (indexPath.row == 1){//法院
            if (self.powerDic[@"area_id"]) {
                ApplicationCourtViewController *applicationCourtVC = [[ApplicationCourtViewController alloc] init];
                applicationCourtVC.area_pidString = self.powerDic[@"area_pid"];
                applicationCourtVC.area_idString = self.powerDic[@"area_id"];
                [self.navigationController pushViewController:applicationCourtVC animated:YES];
                
                QDFWeakSelf;
                [applicationCourtVC setDidSelectedRow:^(NSString *nameString,NSString *idString) {
                    [weakself.powerDic setObject:idString forKey:@"fayuan_id"];
                    [weakself.powerDic setObject:nameString forKey:@"fayuan_name"];
                    [weakself.powerDic setObject:nameString forKey:@"fayuan_address"];

                    AgentCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                    cell.agentTextField.text = nameString;
                }];
            }else{
                [self showHint:@"请先选择区域"];
            }
        }else if(indexPath.row == 2){
            NSArray *array11 = @[@"借贷纠纷",@"房产土地",@"劳动纠纷",@"婚姻家庭",@" 合同纠纷",@"公司治理",@"知识产权",@"其他民事纠纷"];
            
            QDFWeakSelf;
            [self showBlurInView:self.view withArray:array11 andTitle:@"选择案件类型" finishBlock:^(NSString *text, NSInteger row) {
                AgentCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                cell.agentTextField.text = text;
                NSString *gygyg = [NSString stringWithFormat:@"%ld",(long)row];
                [weakself.powerDic setObject:gygyg forKey:@"category"];
            }];
        }
    }
//    else{//section == 1
//        if (indexPath.row == 1) {
//            if ([self.powerDic[@"type"] isEqualToString:@"2"]) {//快递
//                
//                ReceiptAddressViewController *receiptAddressVC = [[ReceiptAddressViewController alloc] init];
//                receiptAddressVC.cateString = @"1";
//                [self.navigationController pushViewController:receiptAddressVC animated:YES];
//                
//                QDFWeakSelf;
//                [receiptAddressVC setDidSelectedReceiptAddress:^(NSString *name, NSString *phone, NSString *address) {
//                    
//                    _chooseFlag = YES;
//                    [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
//                    
//                    PowerAddressCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//                    cell.nameLabel.text = name;
//                    cell.phoneLabel.text = phone;
//                    cell.addressLabel.text = address;
//                    [weakself.powerDic setObject:address forKey:@"address"];
//                }];
//                
//            }
//        }
//    }
}

#pragma mark - method
//省份
- (void)getCourtOfProvince
{
    NSString *brandString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kPowerCourtProvince];
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
    NSString *cityString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kPowerCourtCity];
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

- (void)goToPowerApply
{
    [self.view endEditing:YES];
    NSString *powerStrig = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kPowerString];
    
    self.powerDic[@"phone"] = self.powerDic[@"phone"]?self.powerDic[@"phone"]:[self getValidateMobile];
    
    [self.powerDic setObject:[self getValidateToken] forKey:@"token"];
    
    NSDictionary *params = self.powerDic;
    
    QDFWeakSelf;
    [self requestDataPostWithString:powerStrig params:params successBlock:^(id responseObject) {
        
        BaseModel *model = [BaseModel objectWithKeyValues:responseObject];
        
        if ([model.code isEqualToString:@"0000"]) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"申请成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *act = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                UINavigationController *nsdd = self.navigationController;
                [nsdd popViewControllerAnimated:NO];
                PowerProtectListViewController *powerProtectListVC = [[PowerProtectListViewController alloc] init];
                powerProtectListVC.hidesBottomBarWhenPushed = YES;
                [nsdd pushViewController:powerProtectListVC animated:NO];
                
            }];
            [alertController addAction:act];
            [weakself presentViewController:alertController animated:YES completion:nil];
        }else{
            [weakself showHint:model.msg];
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
