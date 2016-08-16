//
//  HouseAssessViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/7/29.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "HouseAssessViewController.h"
#import "HouseChooseViewController.h"
#import "AssessSuccessViewController.h"

#import "MineUserCell.h"
#import "AssessCell.h"
#import "AgentCell.h"
#import "EditDebtAddressCell.h"
#import "BaseCommitButton.h"

@interface HouseAssessViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *houseAssessTableView;
@property (nonatomic,strong) BaseCommitButton *assessFooterButton;
@property (nonatomic,assign) BOOL didSetupConstraints;

@property (nonatomic,strong) NSMutableDictionary *assessDic;

@end

@implementation HouseAssessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"房产评估";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self setupForDismissKeyboard];
    
    [self.view addSubview:self.houseAssessTableView];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.houseAssessTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)houseAssessTableView
{
    if (!_houseAssessTableView) {
        _houseAssessTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _houseAssessTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _houseAssessTableView.delegate = self;
        _houseAssessTableView.dataSource = self;
        _houseAssessTableView.separatorColor = kSeparateColor;
    }
    return _houseAssessTableView;
}

- (BaseCommitButton *)assessFooterButton
{
    if (!_assessFooterButton) {
        _assessFooterButton = [BaseCommitButton newAutoLayoutView];
        [_assessFooterButton setTitle:@"立即评估" forState:0];
        
        QDFWeakSelf;
        [_assessFooterButton addAction:^(UIButton *btn) {
            [weakself goToAssess];
        }];
    }
    return _assessFooterButton;
}

- (NSMutableDictionary *)assessDic
{
    if (!_assessDic) {
        _assessDic = [NSMutableDictionary dictionary];
    }
    return _assessDic;
}

#pragma mark - delegate and datasoyrce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    return 3;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 1) {
        return 60;
    }
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {//选择区域
            identifier = @"assess00";
            AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.agentButton.userInteractionEnabled = NO;
            cell.agentTextField.userInteractionEnabled = NO;
            cell.agentLabel.text = @"选择区域";
            cell.agentTextField.placeholder = @"请选择";
            [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
            
            return cell;
        }
        //小区
        identifier = @"assess01";
        EditDebtAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[EditDebtAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.ediLabel.text = @"小区/地址";
        cell.ediTextView.placeholder = @"请输入小区名称或地址";
        
        QDFWeakSelf;
        [cell setDidEndEditing:^(NSString *text) {
            [weakself.assessDic setObject:text forKey:@"address"];
        }];
        
        return cell;
    }
    
    //section ＝＝ 1
    if (indexPath.row == 0) {//面积
        identifier = @"assess10";
        AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.agentLabel.text = @"面        积";
        cell.agentTextField.placeholder = @"请输入面积";
        [cell.agentButton setTitle:@"平米" forState:0];
        
        QDFWeakSelf;
        [cell setDidEndEditing:^(NSString *text) {
            [weakself.assessDic setObject:text forKey:@"size"];
        }];
        
        return cell;
    }else if (indexPath.row == 1){//楼栋
        identifier = @"assess11";
        AssessCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AssessCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.label1.text = @"楼        栋";
        cell.textField1.placeholder = @"请输入号    ";
        cell.label2.text = @"号";
        cell.textField2.placeholder = @"请输入室";
        cell.label3.text = @"室";
        
        QDFWeakSelf;
        [cell setDidEndEditing:^(NSString *text, NSInteger tag) {
            if (tag == 11) {//号
                [weakself.assessDic setObject:text forKey:@"buildingNumber"];
            }else{//室
                [weakself.assessDic setObject:text forKey:@"unitNumber"];
            }
        }];
        
        return cell;
    }else{//楼层
        identifier = @"assess12";
        AssessCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AssessCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.label1.text = @"楼        层";
        cell.textField1.placeholder = @"请输入楼层";
        cell.label2.text = @"层";
        cell.textField2.placeholder = @"请输入共几层";
        cell.label3.text = @"层";
        
        QDFWeakSelf;
        [cell setDidEndEditing:^(NSString *text, NSInteger tag) {
            if (tag == 11) {//层
                [weakself.assessDic setObject:text forKey:@"floor"];
            }else{//总共层
                [weakself.assessDic setObject:text forKey:@"maxFloor"];
            }
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
    if (section == 0) {
        return 0.1f;
    }
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *footerView = [[UIView alloc] init];
        [footerView addSubview:self.assessFooterButton];
        
        [self.assessFooterButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:30];
        [self.assessFooterButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.assessFooterButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.assessFooterButton autoSetDimension:ALDimensionHeight toSize:40];
        
        return footerView;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        HouseChooseViewController *houseChooseVC = [[HouseChooseViewController alloc] init];
        [self.navigationController pushViewController:houseChooseVC animated:YES];
        
        QDFWeakSelf;
        [houseChooseVC setDidSelectedRow:^(NSString *placeString) {
            AgentCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            cell.agentTextField.text = placeString;
            [weakself.assessDic setObject:placeString forKey:@"district"];
        }];
    }
}

#pragma mark - method
- (void)goToAssess
{
    NSString *assessString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kHouseAssessString];
    
    self.assessDic[@"district"] = [self.assessDic[@"district"] getValidStringFromString:self.assessDic[@""] toString:@""];
    
    
//    AssessSuccessViewController *assessSuccessVC = [[AssessSuccessViewController alloc] init];
//    assessSuccessVC.fromType = @"1";
//    [weakself.navigationController pushViewController:assessSuccessVC animated:YES];
}


- (void)dealloc
{
   [self removeKeyboardObserver];
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
