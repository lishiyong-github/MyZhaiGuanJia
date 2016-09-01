//
//  ApplicationGuaranteeFirstView.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/9.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ApplicationGuaranteeFirstView.h"
#import "BaseCommitView.h"

#import "AgentCell.h"
#import "SuitBaseCell.h"
#import "PowerAddressCell.h"

@interface ApplicationGuaranteeFirstView ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong) BaseCommitView *nextButton;

@end

@implementation ApplicationGuaranteeFirstView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kBackColor;
        
        [self addSubview:self.tableViewa];
        [self addSubview:self.nextButton];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSrtupConstraints) {
     
        [self.tableViewa autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.tableViewa autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.nextButton];
        
        [self.nextButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.nextButton autoSetDimension:ALDimensionHeight toSize:kCellHeight1];
        
        self.didSrtupConstraints = YES;
    }
    [super updateConstraints];
}

- (UITableView *)tableViewa
{
    if (!_tableViewa) {
        _tableViewa.translatesAutoresizingMaskIntoConstraints = NO;
        _tableViewa = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableViewa.delegate = self;
        _tableViewa.dataSource = self;
        _tableViewa.backgroundColor = kBackColor;
        _tableViewa.separatorColor = kSeparateColor;
    }
    return _tableViewa;
}

- (BaseCommitView *)nextButton
{
    if (!_nextButton) {
        _nextButton = [BaseCommitView newAutoLayoutView];
        [_nextButton.button setTitle:@"下一步" forState:0];
        
        QDFWeakSelf;
        [_nextButton addAction:^(UIButton *btn) {
            if (weakself.didSelectedRow) {
                weakself.didSelectedRow(10);
            }
        }];
    }
    return _nextButton;
}

#pragma mark - delegate datasource
#pragma mark -tableview delegate and datasoyrce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 6;
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
        if (_chooseTag) {
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
    if (indexPath.section == 0) {
        if (indexPath.row < 3) {//选择区域,选择法院,案件类型
            identifier = @"application01";
            AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.agentTextField.userInteractionEnabled = NO;
            cell.agentButton.userInteractionEnabled = NO;
            
            NSArray *arr = @[@"选择区域",@"选择法院",@"案件类型"];
            cell.agentLabel.text = arr[indexPath.row];
            cell.agentTextField.placeholder = @"请选择";
            [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
            
            return cell;
        }else{
            identifier = @"application02";
            AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NSArray *arr = @[@[@"案        号",@"联系方式",@"保函金额"],@[@"如：(2016)沪108执00211号",@"请输入手机号码",@"请输入保函金额"]];
            cell.agentLabel.text = arr[0][indexPath.row-3];
            cell.agentTextField.placeholder = arr[1][indexPath.row-3];
            cell.agentTextField.delegate = self;
            cell.agentTextField.tag = 6*indexPath.section + indexPath.row;
            
            if (indexPath.row == 3) {
                [cell.agentButton setHidden:YES];
            }else if (indexPath.row == 4){
                [cell.agentButton setHidden:YES];
            }else if(indexPath.row == 5){
                [cell.agentButton setHidden:NO];
                [cell.agentButton setTitle:@"万元" forState:0];
            }

            return cell;
        }
    }
    
    //section==1
    if (indexPath.row == 0) {//SuitBaseCell.h
        identifier = @"application10";
        SuitBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[SuitBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.label.text = @"取函方式";
        
        QDFWeakSelf;
        [cell setDidSelectedSeg:^(NSInteger segTag) {
            if (segTag == 0) {//快递
                
                if (weakself.didSelectedRow) {
                    weakself.didSelectedRow(11);
                }
            }else if (segTag == 1){//自取
                
                if (weakself.didSelectedRow) {
                    weakself.didSelectedRow(12);
                }
            }
        }];
        
        return cell;
    }else{
        
        if (_chooseTag) {//收货地址
            identifier = @"application112";
            PowerAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[PowerAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.actButton.userInteractionEnabled = NO;
            [cell.actButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
            
            return cell;

        }else{
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

/*
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
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.didSelectedRow) {
        self.didSelectedRow(indexPath.section * 6 + indexPath.row);
    }
    
    /*
    if (indexPath.row == 0) {//选择区域
        [self.pickerChooseView setHidden:NO];
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
     */
}

#pragma mark - textField delegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.didEndEditting) {
        self.didEndEditting(textField.text,textField.tag);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
