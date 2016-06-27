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
            
            
        }else{//债务人信息
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
        }else{
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
    
    QDFWeakSelf;
    QDFWeak(cell);
    [cell setDidSelectedItem:^(NSInteger tag) {
        [weakself addImageWithMaxSelection:1 andMutipleChoise:YES andFinishBlock:^(NSArray *images) {
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
    
    if ([self.categoryString integerValue] == 1) {
         DebtModel *cModel = [[DebtModel alloc] init];
        cModel.creditorname = self.editDictionary[@"creditorname"]?self.editDictionary[@"creditorname"]:self.deModel.creditorname;
        cModel.creditormobile = self.editDictionary[@"creditormobile"]?self.editDictionary[@"creditormobile"]:self.deModel.creditormobile;
        cModel.creditoraddress = self.editDictionary[@"creditoraddress"]?self.editDictionary[@"creditoraddress"]:self.deModel.creditoraddress;
        cModel.creditorcardcode = self.editDictionary[@"creditorcardcode"]?self.editDictionary[@"creditorcardcode"]:self.deModel.creditorcardcode;
        
        if ((cModel.creditoraddress == nil || [cModel.creditoraddress isEqualToString:@""]) && (cModel.creditorcardcode == nil || [cModel.creditorcardcode isEqualToString:@""]) && (cModel.creditormobile == nil || [cModel.creditormobile isEqualToString:@""]) && (cModel.creditorname == nil || [cModel.creditorname isEqualToString:@""])) {
            [self showHint:@"没有数据，不能保存"];
        }else{
            
            cModel.creditorname = cModel.creditorname?cModel.creditorname:@"";
            cModel.creditormobile = cModel.creditormobile?cModel.creditormobile:@"";
            cModel.creditorcardcode = cModel.creditorcardcode?cModel.creditorcardcode:@"";
            cModel.creditoraddress = cModel.creditoraddress?cModel.creditoraddress:@"";

//            NSDictionary *dic1 = [NSDictionary dictionaryWithObject:cModel.creditorname forKey:@"creditorname"];
//            NSDictionary *dic2 = [NSDictionary dictionaryWithObject:cModel.creditormobile forKey:@"creditormobile"];
//            NSDictionary *dic3 = [NSDictionary dictionaryWithObject:cModel.creditorcardcode forKey:@"creditorcardcode"];
//            NSDictionary *dic4 = [NSDictionary dictionaryWithObject:cModel.creditoraddress forKey:@"creditoraddress"];
//            
//            NSArray *aa = [NSArray arrayWithObjects:dic1,dic2,dic3,dic4, nil];
            
            NSArray *aa = [NSArray arrayWithObjects:cModel.creditorname,cModel.creditormobile,cModel.creditorcardcode,cModel.creditoraddress, nil];
            
            if (self.didSaveMessage) {
                self.didSaveMessage(cModel);
            }
            
//            if (self.didSaveMessageArray) {
//                self.didSaveMessageArray(aa);
//            }
        }

    }else{
        DebtModel *bModel = [[DebtModel alloc] init];
        bModel.borrowingname = self.editDictionary[@"borrowingname"]?self.editDictionary[@"borrowingname"]:self.deModel.borrowingname;
        bModel.borrowingmobile = self.editDictionary[@"borrowingmobile"]?self.editDictionary[@"borrowingmobile"]:self.deModel.borrowingmobile;
        bModel.borrowingaddress = self.editDictionary[@"borrowingaddress"]?self.editDictionary[@"borrowingaddress"]:self.deModel.borrowingaddress;
        bModel.borrowingcardcode = self.editDictionary[@"borrowingcardcode"]?self.editDictionary[@"borrowingcardcode"]:self.deModel.borrowingcardcode;
        
        if ((bModel.borrowingname == nil || [bModel.borrowingname isEqualToString:@""]) && (bModel.borrowingmobile == nil || [bModel.borrowingmobile isEqualToString:@""]) && (bModel.borrowingcardcode == nil || [bModel.borrowingcardcode isEqualToString:@""]) && (bModel.borrowingaddress == nil || [bModel.borrowingaddress isEqualToString:@""])) {
            [self showHint:@"没有数据，不能保存"];
        }else{
            
            bModel.borrowingname = bModel.borrowingname?bModel.borrowingname:@"";
            bModel.borrowingmobile = bModel.borrowingmobile?bModel.borrowingmobile:@"";
            bModel.borrowingcardcode = bModel.borrowingcardcode?bModel.borrowingcardcode:@"";
            bModel.borrowingaddress = bModel.borrowingaddress?bModel.borrowingaddress:@"";
            
            NSArray *aa = [NSArray arrayWithObjects:bModel.borrowingname,bModel.borrowingmobile,bModel.borrowingcardcode,bModel.borrowingaddress, nil];
            
//            if (self.didSaveMessageArray) {
//                self.didSaveMessageArray(aa);
//            }
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)back
{
//    [super back];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"是否保存?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *act1 = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self saveDebtMessage];
    }];
    
    UIAlertAction *act2 = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        [self.navigationController popViewControllerAnimated:YES];
    }];
 
    [alertVC addAction:act1];
    [alertVC addAction:act2];
    
    [self presentViewController:alertVC animated:YES completion:nil];
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
