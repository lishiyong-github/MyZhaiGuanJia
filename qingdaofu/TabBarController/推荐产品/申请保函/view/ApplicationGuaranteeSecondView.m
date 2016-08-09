//
//  ApplicationGuaranteeSecondView.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/9.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ApplicationGuaranteeSecondView.h"
#import "BaseCommitView.h"

#import "AgentCell.h"
#import "SuitBaseCell.h"

@interface ApplicationGuaranteeSecondView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableViewa;
@property (nonatomic,strong) BaseCommitView *nextButton;

@end

@implementation ApplicationGuaranteeSecondView


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
        
        //        [self.tableViewa autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        //        [self.tableViewa autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.nextButton];
        
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
    }
    return _tableViewa;
}

- (BaseCommitView *)nextButton
{
    if (!_nextButton) {
        _nextButton = [BaseCommitView newAutoLayoutView];
        [_nextButton.button setTitle:@"下一步" forState:0];
        
        QDFWeakSelf;
        [_nextButton.button addAction:^(UIButton *btn) {
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
    if (indexPath.section == 0) {
        if (indexPath.row < 2) {//选择法院,案件类型
            identifier = @"application00";
            AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.agentTextField.userInteractionEnabled = NO;
            cell.agentButton.userInteractionEnabled = NO;
            
            NSArray *arr = @[@"选择法院",@"案件类型"];
            cell.agentLabel.text = arr[indexPath.row];
            cell.agentTextField.placeholder = @"请选择";
            [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
            
            return cell;
        }else{
            identifier = @"application01";
            AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NSArray *arr = @[@[@"案号",@"联系方式",@"保函金额"],@[@"案号形式",@"请输入手机号码",@"请输入保函金额"]];
            cell.agentLabel.text = arr[0][indexPath.row-2];
            cell.agentTextField.placeholder = arr[1][indexPath.row-2];
            
            if (indexPath.row == 2) {
                [cell.agentButton setHidden:YES];
            }else if (indexPath.row == 3){
                [cell.agentButton setHidden:YES];
            }else if(indexPath.row == 4){
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
        /*
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
         */
        
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


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
