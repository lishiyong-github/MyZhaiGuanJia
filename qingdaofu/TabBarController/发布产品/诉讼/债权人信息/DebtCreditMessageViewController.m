//
//  DebtCreditMessageViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/17.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "DebtCreditMessageViewController.h"

#import "EditDebtCreditMessageViewController.h"

#import "BaseCommitButton.h"
#import "DebtCell.h"

#import "UIView+UITextColor.h"
#import "DebtModel.h"

@interface DebtCreditMessageViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *debtCreditTableView;
@property (nonatomic,strong) BaseCommitButton *debtCreditCommitButton;

@end

@implementation DebtCreditMessageViewController

- (void)viewWillAppear:(BOOL)animated
{
    if (self.debtArray.count > 0) {
        [self.baseRemindImageView setHidden:YES];
    }else{
        [self.baseRemindImageView setHidden:NO];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.categoryString integerValue] == 1) {
        self.navigationItem.title = @"债权人信息";
    }else{
        self.navigationItem.title = @"债务人信息";
    }
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.debtCreditTableView];
    [self.view addSubview:self.debtCreditCommitButton];
    [self.view addSubview:self.baseRemindImageView];
    [self.baseRemindImageView setHidden:YES];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.debtCreditTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.debtCreditTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kTabBarHeight];
        
        [self.debtCreditCommitButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.debtCreditCommitButton autoSetDimension:ALDimensionHeight toSize:kTabBarHeight];
        
        [self.baseRemindImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.baseRemindImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)debtCreditTableView
{
    if (!_debtCreditTableView) {
        _debtCreditTableView.translatesAutoresizingMaskIntoConstraints = YES;
        _debtCreditTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        _debtCreditTableView.delegate = self;
        _debtCreditTableView.dataSource = self;
        _debtCreditTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
        _debtCreditTableView.backgroundColor = kBackColor;
    }
    return _debtCreditTableView;
}

- (BaseCommitButton *)debtCreditCommitButton
{
    if (!_debtCreditCommitButton) {
        _debtCreditCommitButton = [BaseCommitButton newAutoLayoutView];
        [_debtCreditCommitButton setTitle:@"添加" forState:0];
        QDFWeakSelf;
        [_debtCreditCommitButton addAction:^(UIButton *btn) {
            
            EditDebtCreditMessageViewController *editDebtCreditMessageVC = [[EditDebtCreditMessageViewController alloc] init];
            editDebtCreditMessageVC.categoryString = weakself.categoryString;
            [editDebtCreditMessageVC setDidSaveMessage:^(DebtModel *deModel) {
                [weakself.debtArray addObject:deModel];
                [weakself.debtCreditTableView reloadData];
                [weakself.debtCreditCommitButton setTitle:@"继续添加" forState:0];
            }];
            
            [weakself.navigationController pushViewController:editDebtCreditMessageVC animated:YES];
        }];
    }
    return _debtCreditCommitButton;
}

- (NSMutableArray *)debtArray
{
    if (!_debtArray) {
        _debtArray = [NSMutableArray array];
    }
    return _debtArray;
}

#pragma mark - tableView delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.debtArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 190;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"debtCredit";
    DebtCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[DebtCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.debtEditButton setTitle:@"编辑" forState:0];
    
    DebtModel *deModel = self.debtArray[indexPath.section];
    
    //姓名
    NSString *name;
    if ([self.categoryString  integerValue] == 1) {
        name = [NSString getValidStringFromString:deModel.creditorname];
    }else{
        name = [NSString getValidStringFromString:deModel.borrowingname];
    }
    NSMutableAttributedString *nameStr = [cell.debtNameLabel setAttributeString:@"姓        名    " withColor:kBlackColor andSecond:name withColor:kLightGrayColor withFont:12];
    [cell.debtNameLabel setAttributedText:nameStr];
    
    //联系方式
    NSString *tel;
    if ([self.categoryString  integerValue] == 1) {
        tel = [NSString getValidStringFromString:deModel.creditormobile];
    }else{
        tel = [NSString getValidStringFromString:deModel.borrowingmobile];
    }
    NSMutableAttributedString *telStr = [cell.debtTelLabel setAttributeString:@"联系方式    " withColor:kBlackColor andSecond:tel withColor:kLightGrayColor withFont:12];
    [cell.debtTelLabel setAttributedText:telStr];
    
    //联系地址
    cell.debtAddressLabel.text = @"联系地址";
    if ([self.categoryString integerValue] == 1) {
        cell.debtAddressLabel1.text = [NSString getValidStringFromString:deModel.creditoraddress];
    }else{
        cell.debtAddressLabel1.text = [NSString getValidStringFromString:deModel.borrowingaddress];
    }

    //证件号
    NSString *ID;
    if ([self.categoryString  integerValue] == 1) {
        ID = [NSString getValidStringFromString:deModel.creditorcardcode];
    }else{
        ID = [NSString getValidStringFromString:deModel.borrowingcardcode];
    }
    NSMutableAttributedString *IDStr = [cell.debtIDLabel setAttributeString:@"证件号        " withColor:kBlackColor andSecond:ID withColor:kLightGrayColor withFont:12];
    [cell.debtIDLabel setAttributedText:IDStr];
    
    //图片
    NSArray *imgs;
    if ([self.categoryString integerValue] == 1) {
        imgs = deModel.creditorcardimage;
    }else{
        imgs = deModel.borrowingcardimage;;
    }
    if (imgs.count == 1) {
        [cell.debtImageView1 setImage:[UIImage imageNamed:imgs[0]]];
    }else if(imgs.count == 2){        
        [cell.debtImageView1 setImage:[UIImage imageWithContentsOfFile:imgs[0]]];
        [cell.debtImageView2 setImage:[UIImage imageWithContentsOfFile:imgs[1]]];
    }
    
    QDFWeakSelf;
    [cell.debtEditButton addAction:^(UIButton *btn) {
        EditDebtCreditMessageViewController *editDebtCreditMessageVC = [[EditDebtCreditMessageViewController alloc] init];
        editDebtCreditMessageVC.deModel = deModel;
        editDebtCreditMessageVC.categoryString = self.categoryString;
        
        [editDebtCreditMessageVC setDidSaveMessage:^(DebtModel *model) {
           [weakself.debtArray replaceObjectAtIndex:indexPath.section withObject:model];
            [weakself.debtCreditTableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        }];
        [weakself.navigationController pushViewController:editDebtCreditMessageVC animated:YES];
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kBigPadding;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

#pragma mark - method
- (void)back
{
    if (self.didEndEditting) {
        self.didEndEditting(self.debtArray);
    }
    [self.navigationController popViewControllerAnimated:YES];
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
