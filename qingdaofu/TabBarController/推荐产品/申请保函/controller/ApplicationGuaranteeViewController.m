//
//  ApplicationGuaranteeViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/7/29.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ApplicationGuaranteeViewController.h"
#import "ApplicationSuccessViewController.h"
#import "ApplicationCourtViewController.h"

#import "BaseCommitButton.h"

#import "AgentCell.h"
#import "MineUserCell.h"

@interface ApplicationGuaranteeViewController ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong) UITableView *applicationTableView;
@property (nonatomic,strong) BaseCommitButton *applicationFooterButton;
@property (nonatomic,strong) UIPickerView *applicationPickerView;
@property (nonatomic,assign) BOOL didSetupConstraints;

@property (nonatomic,strong) NSMutableDictionary *applicationDic;

@end

@implementation ApplicationGuaranteeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"申请保函";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self setupForDismissKeyboard];
    
    [self.view addSubview:self.applicationTableView];
    [self.view addSubview:self.applicationPickerView];
    [self.applicationPickerView setHidden:YES];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.applicationTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        [self.applicationPickerView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.applicationPickerView autoSetDimension:ALDimensionHeight toSize:200];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)applicationTableView
{
    if (!_applicationTableView) {
        _applicationTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _applicationTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _applicationTableView.delegate = self;
        _applicationTableView.dataSource = self;
        _applicationTableView.separatorColor = kSeparateColor;
    }
    return _applicationTableView;
}

- (BaseCommitButton *)applicationFooterButton
{
    if (!_applicationFooterButton) {
        _applicationFooterButton = [BaseCommitButton newAutoLayoutView];
        [_applicationFooterButton setTitle:@"立即申请" forState:0];
        
        QDFWeakSelf;
        [_applicationFooterButton addAction:^(UIButton *btn) {
            ApplicationSuccessViewController *applicationSuccessVC = [[ApplicationSuccessViewController alloc] init];
            [weakself.navigationController pushViewController:applicationSuccessVC animated:YES];
        }];
    }
    return _applicationFooterButton;
}

- (UIPickerView *)applicationPickerView
{
    if (!_applicationPickerView) {
        _applicationPickerView = [UIPickerView newAutoLayoutView];
        _applicationPickerView.delegate = self;
        _applicationPickerView.dataSource = self;
        _applicationPickerView.layer.borderWidth = kLineWidth;
        _applicationPickerView.layer.borderColor = kLightGrayColor.CGColor;
    }
    return _applicationPickerView;
}

- (NSMutableDictionary *)applicationDic
{
    if (!_applicationDic) {
        _applicationDic = [NSMutableDictionary dictionary];
    }
    return _applicationDic;
}

#pragma mark -tableview delegate and datasoyrce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    if (indexPath.row < 2) {//选择区域，法院
        identifier = @"application01";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.userNameButton.userInteractionEnabled = NO;
        cell.userActionButton.userInteractionEnabled = NO;
        
        NSArray *nameArr = @[@"选择区域",@"选择法院"];
        [cell.userNameButton setTitle:nameArr[indexPath.row] forState:0];
        [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        [cell.userActionButton setTitle:@"请选择" forState:0];
        
        return cell;
    }
    
    //申请人，手机号，金额
    
    identifier = @"application234";
    AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *personArr = @[@"申请人",@"手机号码",@"保全金额"];
    NSArray *personArr1 = @[@"请输入申请人姓名",@"请输入手机号码",@"请输入保全金额"];
    cell.agentLabel.text = personArr[indexPath.row-2];
    cell.agentTextField.placeholder = personArr1[indexPath.row-2];
    
    if (indexPath.row == 2) {
        [cell.agentButton setHidden:YES];
    }else if(indexPath.row == 3){
        [cell.agentButton setHidden:YES];
        cell.agentTextField.text = [self getValidateMobile];
        cell.agentTextField.keyboardType = UIKeyboardTypeNumberPad;
    }else{
        [cell.agentButton setHidden:NO];
        [cell.agentButton setTitle:@"万元" forState:0];
        cell.agentTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kBigPadding;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] init];
    [footerView addSubview:self.applicationFooterButton];
    
    [self.applicationFooterButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:30];
    [self.applicationFooterButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
    [self.applicationFooterButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
    [self.applicationFooterButton autoSetDimension:ALDimensionHeight toSize:40];
    
    return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {//选择区域
        [self.applicationPickerView setHidden:NO];
    }else if(indexPath.row == 1){//选择法院
        MineUserCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        if ([cell.userActionButton.titleLabel.text isEqualToString:@"请选择"]) {
            [self showHint:@"先确定区域才能选择法院"];
        }else{
            ApplicationCourtViewController *applicationCourtVC = [[ApplicationCourtViewController alloc] init];
            [self.navigationController pushViewController:applicationCourtVC animated:YES];
            
            [applicationCourtVC setDidSelectedRow:^(NSString *courtString) {
                MineUserCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
                [cell.userActionButton setTitle:courtString forState:0];
            }];
        }
    }
}

#pragma mark - pickerView delegate and datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 10;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return @"省市区";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
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
