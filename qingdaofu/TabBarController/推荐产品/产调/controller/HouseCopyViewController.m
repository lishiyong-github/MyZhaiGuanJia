//
//  HouseCopyViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/3.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "HouseCopyViewController.h"
#import "HouseChooseViewController.h" //选择区域
#import "ReceiptAddressViewController.h" //收货地址

#import "BaseCommitButton.h"

#import "CopyCell.h"
#import "MineUserCell.h"

@interface HouseCopyViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *houseCopyTableView;
@property (nonatomic,strong) BaseCommitButton *copyFooterButton;

@property (nonatomic,assign) BOOL didSetupConstraints;

//json
@property (nonatomic,strong) NSMutableDictionary *houseCopyDic;
@property (nonatomic,strong) NSString *refreshString;  //刷新单元格标志


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
        [_copyFooterButton setTitle:@"确认发货" forState:0];
        
        QDFWeakSelf;
        [_copyFooterButton addAction:^(UIButton *btn) {
//            AssessSuccessViewController *assessSuccessVC = [[AssessSuccessViewController alloc] init];
//            [weakself.navigationController pushViewController:assessSuccessVC animated:YES];
        }];
    }
    return _copyFooterButton;
}

- (NSMutableDictionary *)houseCopyDic
{
    if (!_houseCopyDic) {
        _houseCopyDic = [NSMutableDictionary dictionary];
    }
    return _houseCopyDic;
}

#pragma mark -tableview delegate and datasoyrce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if ([self.refreshString integerValue] == 1) {
            return 68;
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
        identifier = @"copy00";
        
        if ([self.refreshString integerValue] == 1) {
            CopyCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[CopyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.soButton.userInteractionEnabled = NO;
            
            return cell;
        }else{
            MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.userActionButton.userInteractionEnabled = NO;
            cell.userNameButton.userInteractionEnabled = NO;
            
            [cell.userNameButton setTitle:@"  请选择地址" forState:0];
            [cell.userNameButton setImage:[UIImage imageNamed:@"address"] forState:0];
            [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
            
            return cell;
        }
        return nil;
    }
    
    //section == 1
    identifier = @"copy10";
    MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.userActionButton.userInteractionEnabled = NO;
    cell.userNameButton.userInteractionEnabled = NO;
    
    [cell.userNameButton setTitle:@"快递方式" forState:0];
    [cell.userActionButton setTitle:@"到付" forState:0];
    
    return cell;
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
    if (indexPath.section == 0) {
        ReceiptAddressViewController *receiptAddressListVC = [[ReceiptAddressViewController alloc] init];
        receiptAddressListVC.cateString = @"1";
        [self.navigationController pushViewController:receiptAddressListVC animated:YES];
        
        QDFWeakSelf;
        [receiptAddressListVC setDidSelectedReceiptAddress:^(NSString *name,NSString *phone,NSString *address) {
            
            if ([weakself.refreshString integerValue] == 1) {
                
            }else{
                weakself.refreshString = @"1";
                [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            }
            
            CopyCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [cell.imageViewcc setImage:[UIImage imageNamed:@"address"]];            [cell.soButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
            cell.nameLabel.text = name;
            cell.phoneLabel.text = phone;
            cell.addressLabel.text = address;
            
            [weakself.houseCopyDic setObject:address forKey:@"address"];
        }];
    }
}

#pragma mark - method
- (void)commitToExpress
{
    [self.view endEditing:YES];
    NSString *expressString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kHousePropertyCopyString];
    
    NSDictionary *params = @{};
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
