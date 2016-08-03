//
//  HouseCopyViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/3.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "HouseCopyViewController.h"
#import "HouseChooseViewController.h"

#import "BaseCommitButton.h"

#import "MineUserCell.h"
#import "EditDebtAddressCell.h"
#import "AgentCell.h"

@interface HouseCopyViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *houseCopyTableView;
@property (nonatomic,strong) BaseCommitButton *copyFooterButton;

@property (nonatomic,assign) BOOL didSetupConstraints;

//json
@property (nonatomic,strong) NSMutableDictionary *houseCopyDic;


@end

@implementation HouseCopyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"填写快递信息";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self setupForDismissKeyboard];
    
    [self.view addSubview:self.houseCopyTableView];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)dealloc
{
    [self removeKeyboardObserver];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.houseCopyTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

#pragma mark - setter and getter
- (UITableView *)houseCopyTableView
{
    if (!_houseCopyTableView) {
        _houseCopyTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _houseCopyTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _houseCopyTableView.delegate = self;
        _houseCopyTableView.dataSource = self;
        _houseCopyTableView.separatorColor = kSeparateColor;
    }
    return _houseCopyTableView;
}

- (BaseCommitButton *)copyFooterButton
{
    if (!_copyFooterButton) {
        _copyFooterButton = [BaseCommitButton newAutoLayoutView];
        [_copyFooterButton setTitle:@"点击支付" forState:0];
        
        QDFWeakSelf;
        [_copyFooterButton addAction:^(UIButton *btn) {
//            AssessSuccessViewController *assessSuccessVC = [[AssessSuccessViewController alloc] init];
//            [weakself.navigationController pushViewController:assessSuccessVC animated:YES];
        }];
    }
    return _copyFooterButton;
}

#pragma mark -tableview delegate and datasoyrce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 3) {
        return 60;
    }
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    if (indexPath.section == 0) {
        if (indexPath.row < 2) {//联系人，电话
            identifier = @"copy00";
            AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.agentButton setHidden:YES];
            
            NSArray *textArr = @[@"联系人",@"联系电话"];
            NSArray *detailArr = @[@"收件人姓名",@"您手机号码"];
            
            cell.agentLabel.text = textArr[indexPath.row];
            cell.agentTextField.placeholder = detailArr[indexPath.row];
            
            if (indexPath.row == 0) {//联系人
                [cell setDidEndEditing:^(NSString *text) {
                    
                }];
            }else{//电话
                cell.agentTextField.text = [self getValidateMobile];
                [cell setDidEndEditing:^(NSString *text) {
                    
                }];
            }
            
            return cell;
        }else if (indexPath.row == 2){//区域
            identifier = @"copy02";
            MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.userActionButton.userInteractionEnabled = NO;
            cell.userNameButton.userInteractionEnabled = NO;
            
            [cell.userNameButton setTitle:@"选择区域" forState:0];
            [cell.userActionButton setTitle:@"请选择  " forState:0];
            [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
            
            return cell;
            
        }
        //详细地址
        identifier = @"copy03";
        EditDebtAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[EditDebtAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.ediLabel.text = @"详细地址";
        cell.ediTextView.placeholder = @"请输入详细地址";
        
        QDFWeakSelf;
        [cell setDidEndEditing:^(NSString *text) {
//            [weakself.propertyDic setObject:text forKey:@""];
        }];
        
        return cell;
    }
    
    //section == 1
    if (indexPath.row == 1) {//快递费
        identifier = @"copy10";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.userActionButton.userInteractionEnabled = NO;
        cell.userNameButton.userInteractionEnabled = NO;
        
        [cell.userNameButton setTitle:@"快递费" forState:0];
        [cell.userActionButton setTitle:@"¥8" forState:0];
        [cell.userActionButton setTitleColor:kRedColor forState:0];
        
        return cell;
    }else{
        identifier = @"copy11";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSMutableAttributedString *title = [cell.userNameButton setAttributeString:@"  微信支付" withColor:kBlackColor andSecond:@"（仅支持微信支付）" withColor:kLightGrayColor withFont:13];
        [cell.userNameButton setAttributedTitle:title forState:0];
        [cell.userNameButton setImage:[UIImage imageNamed:@"conserve_tip_icon"] forState:0];
        
        [cell.userActionButton setImage:[UIImage imageNamed:@"conserve_tip_icon"] forState:0];
        
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
    UIView *footerView = [[UIView alloc] init];
    [footerView addSubview:self.copyFooterButton];
    
    [self.copyFooterButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:30];
    [self.copyFooterButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
    [self.copyFooterButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
    [self.copyFooterButton autoSetDimension:ALDimensionHeight toSize:40];
    
    return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 2) {
        HouseChooseViewController *houseChooseVC = [[HouseChooseViewController alloc] init];
        [self.navigationController pushViewController:houseChooseVC animated:YES];
        
        QDFWeakSelf;
        [houseChooseVC setDidSelectedRow:^(NSString *text) {
            MineUserCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [cell.userActionButton setTitle:text forState:0];
            
//            [weakself.propertyDic setObject:text forKey:@""];
        }];
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
