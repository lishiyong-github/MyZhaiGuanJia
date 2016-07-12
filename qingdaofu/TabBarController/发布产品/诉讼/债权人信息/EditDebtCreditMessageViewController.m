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
#import "UIViewController+MutipleImageChoice.h"

@interface EditDebtCreditMessageViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *editDebtTableView;
@property (nonatomic,strong) NSMutableDictionary *editDictionary;

@end

@implementation EditDebtCreditMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.categoryString integerValue] == 1) {
        self.navigationItem.title = @"添加债权人信息";
    }else{
        self.navigationItem.title = @"添加债务人信息";
    }
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

- (NSMutableDictionary *)editDictionary
{
    if (!_editDictionary) {
        _editDictionary = [NSMutableDictionary dictionary];
    }
    return _editDictionary;
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
        
        if ([self.categoryString integerValue] == 1) {//债权人信息
            if (indexPath.row == 0) {
                cell.agentTextField.text = self.deModel.creditorname?self.deModel.creditorname:@"";
            }else if (indexPath.row == 1){
                cell.agentTextField.text = self.deModel.creditormobile?self.deModel.creditormobile:@"";
            }else if (indexPath.row == 3){
                cell.agentTextField.text = self.deModel.creditorcardcode?self.deModel.creditorcardcode:@"";
            }
            
            [cell setDidEndEditing:^(NSString *text) {
                if (indexPath.row == 0) {//姓名
                    [self.editDictionary setValue:text forKey:@"creditorname"];
                }else if (indexPath.row == 1){//手机号
                    [self.editDictionary setValue:text forKey:@"creditormobile"];
                }else if (indexPath.row == 3){//证件号
                    [self.editDictionary setValue:text forKey:@"creditorcardcode"];
                }
            }];
            
        }else if([self.categoryString integerValue] == 2){//债务人信息
            if (indexPath.row == 0) {
                cell.agentTextField.text = self.deModel.borrowingname?self.deModel.borrowingname:@"";
            }else if (indexPath.row == 1){
                cell.agentTextField.text = self.deModel.borrowingmobile?self.deModel.borrowingmobile:@"";
            }else if (indexPath.row == 3){
                cell.agentTextField.text = self.deModel.borrowingcardcode?self.deModel.borrowingcardcode:@"";
            }
            
            [cell setDidEndEditing:^(NSString *text) {
                if (indexPath.row == 0) {//姓名
                    [self.editDictionary setValue:text forKey:@"borrowingname"];
                }else if (indexPath.row == 1){//手机号
                    [self.editDictionary setValue:text forKey:@"borrowingmobile"];
                }else if (indexPath.row == 3){//证件号
                    [self.editDictionary setValue:text forKey:@"borrowingcardcode"];
                }
            }];
        }
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
        
        if ([self.categoryString  integerValue] == 1) {
            cell.ediTextView.text = self.deModel.creditoraddress?self.deModel.creditoraddress:@"";
            
            [cell setDidEndEditing:^(NSString *text) {
                [self.editDictionary setValue:text forKey:@"creditoraddress"];
            }];
        }else if([self.categoryString  integerValue] == 2){
            cell.ediTextView.text = self.deModel.borrowingaddress?self.deModel.borrowingaddress:@"";
            [cell setDidEndEditing:^(NSString *text) {
                [self.editDictionary setValue:text forKey:@"borrowingaddress"];
            }];
        }
        
        return cell;
    }
    
    identifier = @"editDebt2";
    TakePictureCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TakePictureCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.collectionDataList = [NSMutableArray arrayWithObject:@"btn_camera"];
    
    if ([self.categoryString integerValue] == 1) {
        if (self.deModel.creditorcardimage.count > 0) {
            cell.collectionDataList = [NSMutableArray arrayWithArray:self.deModel.creditorcardimage];
        }else{
            cell.collectionDataList = [NSMutableArray arrayWithObject:@"btn_camera"];
        }
    }else if ([self.categoryString integerValue] == 2){
        if (self.deModel.borrowingcardimage.count > 0) {
            cell.collectionDataList = [NSMutableArray arrayWithArray:self.deModel.borrowingcardimage];
        }else{
            cell.collectionDataList = [NSMutableArray arrayWithObject:@"btn_camera"];
        }
    }
    
    QDFWeakSelf;
    QDFWeak(cell);
    [cell setDidSelectedItem:^(NSInteger tag) {
        [weakself addImageWithMaxSelection:2 andMutipleChoise:YES andFinishBlock:^(NSArray *images) {
            NSData *tData;
            NSString *ttt = @"";
            NSString *tStr = @"";
            for (int i=0; i<images.count; i++) {
                tData = [NSData dataWithContentsOfFile:images[i]];
                ttt = [NSString stringWithFormat:@"%@",tData];
                tStr = [NSString stringWithFormat:@"%@:%@",tStr,ttt];
            }
            if ([weakself.categoryString integerValue] == 1) {//债权人信息
                [self.editDictionary setValue:tStr forKey:@"creditorcardimages"];
                [self.editDictionary setValue:images forKey:@"creditorcardimage"];

            }else if ([weakself.categoryString integerValue] == 2){//债务人信息
                [self.editDictionary setValue:tStr forKey:@"borrowingcardimages"];
                [self.editDictionary setValue:images forKey:@"borrowingcardimage"];
            }
            weakcell.collectionDataList = [NSMutableArray arrayWithArray:images];
            [weakcell reloadData];
        }];
    }];
    
    return cell;
}

#pragma mark - method
- (void)saveDebtMessage
{
    [self.view endEditing:YES];
    
    if ([self.categoryString integerValue] == 1) {//债权人信息
        
        DebtModel *cModel = [[DebtModel alloc] init];
        cModel.creditorname = self.editDictionary[@"creditorname"]?self.editDictionary[@"creditorname"]:self.deModel.creditorname;
        cModel.creditormobile = self.editDictionary[@"creditormobile"]?self.editDictionary[@"creditormobile"]:self.deModel.creditormobile;
        cModel.creditoraddress = self.editDictionary[@"creditoraddress"]?self.editDictionary[@"creditoraddress"]:self.deModel.creditoraddress;
        cModel.creditorcardcode = self.editDictionary[@"creditorcardcode"]?self.editDictionary[@"creditorcardcode"]:self.deModel.creditorcardcode;
        cModel.creditorcardimage = self.editDictionary[@"creditorcardimage"];
        cModel.creditorcardimages = self.editDictionary[@"creditorcardimages"];
        
        if ((cModel.creditoraddress == nil || [cModel.creditoraddress isEqualToString:@""]) || (cModel.creditorcardcode == nil || [cModel.creditorcardcode isEqualToString:@""]) || (cModel.creditormobile == nil || [cModel.creditormobile isEqualToString:@""]) || (cModel.creditorname == nil || [cModel.creditorname isEqualToString:@""])){
            [self showHint:@"信息填写不完整，请检查"];
        }else{
            if (self.didSaveMessage) {
                self.didSaveMessage(cModel);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else if([self.categoryString  integerValue] == 2){//债务人信息
        DebtModel *bModel = [[DebtModel alloc] init];
        bModel.borrowingname = self.editDictionary[@"borrowingname"]?self.editDictionary[@"borrowingname"]:self.deModel.borrowingname;
        bModel.borrowingmobile = self.editDictionary[@"borrowingmobile"]?self.editDictionary[@"borrowingmobile"]:self.deModel.borrowingmobile;
        bModel.borrowingcardcode = self.editDictionary[@"borrowingcardcode"]?self.editDictionary[@"borrowingcardcode"]:self.deModel.borrowingcardcode;
        bModel.borrowingaddress = self.editDictionary[@"borrowingaddress"]?self.editDictionary[@"borrowingaddress"]:self.deModel.borrowingaddress;
        bModel.borrowingcardimage = self.editDictionary[@"borrowingcardimage"];
        bModel.borrowingcardimages = self.editDictionary[@"borrowingcardimages"];

        if ((!bModel.borrowingname || [bModel.borrowingname isEqualToString:@""]) && (!bModel.borrowingmobile || [bModel.borrowingmobile isEqualToString:@""]) && (!bModel.borrowingaddress || [bModel.borrowingaddress isEqualToString:@""]) && (!bModel.borrowingcardcode || [bModel.borrowingcardcode isEqualToString:@""])){
            [self showHint:@"信息填写不完整，请检查"];
        }else{
            if (self.didSaveMessage) {
                self.didSaveMessage(bModel);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
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
