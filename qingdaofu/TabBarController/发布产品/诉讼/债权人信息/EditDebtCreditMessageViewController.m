//
//  EditDebtCreditMessageViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/18.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "EditDebtCreditMessageViewController.h"

#import "AgentCell.h"
#import "EditDebtAddressCell.h"
#import "TakePictureCell.h"
@interface EditDebtCreditMessageViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *editDebtTableView;
@end

@implementation EditDebtCreditMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加债权人信息";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveDebtMessage)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:kBigFont,NSForegroundColorAttributeName:kBlueColor} forState:0];
    
    [self setupForDismissKeyboard];
    
    [self.view addSubview:self.editDebtTableView];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.editDebtTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)editDebtTableView
{
    if (!_editDebtTableView) {
        _editDebtTableView = [UITableView newAutoLayoutView];
        _editDebtTableView.delegate = self;
        _editDebtTableView.dataSource = self;
        _editDebtTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
        _editDebtTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
        _editDebtTableView.backgroundColor = kBackColor;
    }
    return _editDebtTableView;
}

#pragma mark - tabelView deledate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        return 60;
    }else if (indexPath.row == 4){
        return 80;
    }
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    
    if (indexPath.row < 4 && indexPath.row != 2) {
        identifier = @"editDebt0";
        AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSArray *editTextArray = @[@"姓名",@"联系方式",@"",@"证件号"];
        NSArray *editHolderArray = @[@"请输入姓名",@"请输入联系方式",@"",@"请输入证件号"];
        
        cell.leftdAgentContraints.constant = 85;
        cell.agentLabel.text = editTextArray[indexPath.row];
        cell.agentTextField.placeholder = editHolderArray[indexPath.row];
        
        return cell;
    }else if (indexPath.row == 2){
        identifier = @"editDebt1";
        EditDebtAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[EditDebtAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.leftTextViewConstraints.constant = 80;
        cell.ediLabel.text = @"联系地址";
        cell.ediTextView.placeholder = @"请输入联系地址";
        
        return cell;
    }
    
    identifier = @"editDebt2";
    TakePictureCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TakePictureCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
        /*
    if (indexPath.row ==0) {
        identifier = @"editDebt0";
        ReportFinanceCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[ReportFinanceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.fiLabel.text = @"姓名";
        cell.fiTextField.placeholder = @"请输入姓名";
        cell.leftTextFieldConstraits.constant = 90;
        
        return cell;
    }else if (indexPath.row == 1){
        identifier = @"editDebt1";
        ReportFinanceCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[ReportFinanceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.fiLabel.text = @"联系方式";
        cell.fiTextField.placeholder = @"请输入联系方式";
        cell.leftTextFieldConstraits.constant = 90;

        return cell;
    }else if (indexPath.row == 2){
        identifier = @"editDebt2";
        EditDebtAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[EditDebtAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        cell.ediLabel.text = @"联系地址";
        cell.ediTextView.placeholder = @"请输入联系地址";
        
        return cell;
        
    }else if (indexPath.row == 3){
        identifier = @"editDebt3";
        ReportFinanceCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[ReportFinanceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.fiLabel.text = @"证件号";
        cell.fiTextField.placeholder = @"请输入证件号";
        cell.leftTextFieldConstraits.constant = 90;

        return cell;
    }
    
    identifier = @"editDebt4";
    EditDebtCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[EditDebtCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell.editImageButton1 addAction:^(UIButton *btn) {
        NSLog(@"添加图片");
    }];
    
    [cell.editImageButton2 addAction:^(UIButton *btn) {
        NSLog(@"图片");
    }];
    
    return cell;
     */
    
}

#pragma mark - method
- (void)saveDebtMessage
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
