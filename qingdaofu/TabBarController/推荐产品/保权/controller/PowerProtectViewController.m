//
//  PowerProtectViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/1.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "PowerProtectViewController.h"
#import "ApplicationSuccessViewController.h"  //提交成功

#import "BaseCommitButton.h"
#import "AgentCell.h"
#import "MineUserCell.h"

@interface PowerProtectViewController ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong) UITableView *powerTableView;
@property (nonatomic,strong) UIView *powerCommitView;
@property (nonatomic,strong) BaseCommitButton *powerCommitButton;
@property (nonatomic,assign) BOOL didSetupConstraints;

@property (nonatomic,strong) NSMutableDictionary *powerDic;

@end

@implementation PowerProtectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"申请保权";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self setupForDismissKeyboard];
    
    [self.view addSubview:self.powerTableView];
    [self.view addSubview:self.powerCommitView];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.powerTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.powerTableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.powerCommitView];
        
        [self.powerCommitView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.powerCommitView autoSetDimension:ALDimensionHeight toSize:60];
        
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
        _powerCommitView = [UIView newAutoLayoutView];
        _powerCommitView.backgroundColor = kNavColor;
        _powerCommitView.layer.borderWidth = kLineWidth;
        _powerCommitView.layer.borderColor = kSeparateColor.CGColor;
        [_powerCommitView addSubview:self.powerCommitButton];
        
        [self.powerCommitButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    }
    return _powerCommitView;
}

- (BaseCommitButton *)powerCommitButton
{
    if (!_powerCommitButton) {
        _powerCommitButton = [BaseCommitButton newAutoLayoutView];
        [_powerCommitButton setTitle:@"确认提交" forState:0];
        
        QDFWeakSelf;
        [_powerCommitButton addAction:^(UIButton *btn) {
            ApplicationSuccessViewController *applicationSuccessVC = [[ApplicationSuccessViewController alloc] init];
            applicationSuccessVC.successType = @"保权";
            [weakself.navigationController pushViewController:applicationSuccessVC animated:YES];
        }];
    }
    return _powerCommitButton;
}

-(NSMutableDictionary *)powerDic
{
    if (!_powerDic) {
        _powerDic = [NSMutableDictionary dictionary];
    }
    return _powerDic;
}

#pragma mark -tableview delegate and datasoyrce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
    }
    return 6;
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
    if (indexPath.section == 0) {//基本信息
        identifier = @"power00";
        AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSArray *powerArr = @[@"|  基本信息",@"姓名",@"身份证",@"联系方式",@"债权金额"];
        NSArray *powerDetailArr = @[@"",@"请输入申请人姓名",@"请输入身份证号码",@"请输入电话号码",@"请输入债权金额"];
        cell.agentLabel.text = powerArr[indexPath.row];
        cell.agentTextField.placeholder = powerDetailArr[indexPath.row];
        
        QDFWeakSelf;
        if (indexPath.row == 0) {//基本信息
            cell.agentLabel.textColor = kBlueColor;
            [cell.agentTextField setHidden:YES];
            [cell.agentButton setHidden:YES];
        }else if (indexPath.row == 1){//姓名
            cell.agentLabel.textColor = kBlackColor;
            [cell.agentTextField setHidden:NO];
            [cell.agentButton setHidden:YES];
            
            [cell setDidEndEditing:^(NSString *text) {
                [weakself.powerDic setObject:text forKey:@""];
            }];
            
        }else if (indexPath.row == 2){//身份证
            cell.agentLabel.textColor = kBlackColor;
            [cell.agentTextField setHidden:NO];
            [cell.agentButton setHidden:YES];
            
            [cell setDidEndEditing:^(NSString *text) {
                [weakself.powerDic setObject:text forKey:@""];
            }];
            
        }else if (indexPath.row == 3){//电话
            cell.agentLabel.textColor = kBlackColor;
            cell.agentTextField.keyboardType = UIKeyboardTypeNumberPad;
            [cell.agentTextField setHidden:NO];
            [cell.agentButton setHidden:YES];
            cell.agentTextField.text = [weakself getValidateMobile];
            
            
            [cell setDidEndEditing:^(NSString *text) {
                [weakself.powerDic setObject:text forKey:@""];
            }];
            
        }else if (indexPath.row == 4){//金额
            cell.agentLabel.textColor = kBlackColor;
            cell.agentTextField.keyboardType = UIKeyboardTypeNumberPad;
            [cell.agentButton setTitle:@"万元" forState:0];
            [cell.agentTextField setHidden:NO];
            [cell.agentButton setHidden:NO];
            
            [cell setDidEndEditing:^(NSString *text) {
                [weakself.powerDic setObject:text forKey:@""];
            }];
            
        }
        return cell;
    }
    
    //补充材料
    if (indexPath.row == 0) {
        identifier = @"application10";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSMutableAttributedString *title = [cell.userNameButton setAttributeString:@"|  补充信息" withColor:kBlueColor andSecond:@"（选填）" withColor:kBlackColor withFont:12];
        [cell.userNameButton setAttributedTitle:title forState:0];
        
        return cell;
    }
    
    identifier = @"application234";
    MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *additionArray = @[@"借条",@"银行转款凭证",@"担保合同",@"财产线索",@"其他线索"];
    [cell.userNameButton setTitle:additionArray[indexPath.row-1] forState:0];
    [cell.userActionButton setTitle:@"添加图片" forState:0];
    [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
    
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
