//
//  AddMyAgentViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/17.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "AddMyAgentViewController.h"

#import "CaseNoCell.h"

@interface AddMyAgentViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *addAgentTableView;
@property (nonatomic,strong) NSMutableDictionary *addAgentDictionary;

@end

@implementation AddMyAgentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.agentFlagString isEqualToString:@"add"]) {
        self.navigationItem.title = @"添加代理";
    }else{
        self.navigationItem.title = @"修改代理";
    }
    
    self.navigationItem.leftBarButtonItem = self.leftItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAgent)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:kBigFont,NSForegroundColorAttributeName:kBlueColor} forState:0];
    
    [self setupForDismissKeyboard];
    
    [self.view addSubview:self.addAgentTableView];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.addAgentTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)addAgentTableView
{
    if (!_addAgentTableView) {
        _addAgentTableView = [UITableView newAutoLayoutView];
        _addAgentTableView.delegate = self;
        _addAgentTableView.dataSource = self;
        _addAgentTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
        _addAgentTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
        _addAgentTableView.separatorColor = kSeparateColor;
        _addAgentTableView.backgroundColor = kBackColor;
    }
    return _addAgentTableView;
}

- (NSMutableDictionary *)addAgentDictionary
{
    if (!_addAgentDictionary) {
        _addAgentDictionary = [NSMutableDictionary dictionary];
    }
    return _addAgentDictionary;
}

#pragma mark - tableView delegate and datasource
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
    static NSString *identifier = @"agent";
    CaseNoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[CaseNoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.leftFieldConstraints.constant = 90;
    
    NSArray *aArray = @[@"姓名",@"联系方式",@"身份证号",@"执业证号",@"登录密码"];
    NSArray *bArray = @[@"请输入姓名",@"请输入联系方式",@"请输入身份证号",@"请输入执业证号(律所必填)",@"请设置代理人登录密码"];

    [cell.caseNoButton setTitle:aArray[indexPath.row] forState:0];
    cell.caseNoTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    if (self.model.username) {//有信息
        if (indexPath.row == 0) {//姓名
            cell.caseNoTextField.text = self.model.username;
            [cell setDidEndEditting:^(NSString *text) {
                [self.addAgentDictionary setValue:text forKey:@"name"];
            }];
        }else if (indexPath.row == 1){//联系方式
            cell.caseNoTextField.text = self.model.mobile;
            [cell setDidEndEditting:^(NSString *text) {
                [self.addAgentDictionary setValue:text forKey:@"mobile"];
            }];
        }else if (indexPath.row == 2){ //身份证号
            cell.caseNoTextField.text = self.model.cardno;
            [cell setDidEndEditting:^(NSString *text) {
                [self.addAgentDictionary setValue:text forKey:@"cardno"];
            }];
        }else if (indexPath.row == 3){//执业证号
            cell.caseNoTextField.text = self.model.zycardno;
            [cell setDidEndEditting:^(NSString *text) {
                [self.addAgentDictionary setValue:text forKey:@"zycardno"];
            }];
        }else if (indexPath.row == 4){//登录密码
            cell.caseNoTextField.text = @"******";
            [cell setDidEndEditting:^(NSString *text) {
                [self.addAgentDictionary setValue:text forKey:@"password"];
            }];
        }
    }else{
        cell.caseNoTextField.placeholder = bArray[indexPath.row];
        if (indexPath.row == 0) {
            [cell setDidEndEditting:^(NSString *text) {
                [self.addAgentDictionary setValue:text forKey:@"name"];
            }];
        }else if (indexPath.row == 1){
            [cell setDidEndEditting:^(NSString *text) {
                [self.addAgentDictionary setValue:text forKey:@"mobile"];
            }];
        }else if (indexPath.row == 2){
            [cell setDidEndEditting:^(NSString *text) {
                [self.addAgentDictionary setValue:text forKey:@"cardno"];
            }];
        }else if (indexPath.row == 3){
            [cell setDidEndEditting:^(NSString *text) {
                [self.addAgentDictionary setValue:text forKey:@"zycardno"];
            }];
        }else if (indexPath.row == 4){
            [cell setDidEndEditting:^(NSString *text) {
                [self.addAgentDictionary setValue:text forKey:@"password"];
            }];
        }
    }
    
    
    
    return cell;
}

#pragma mark - method
- (void)saveAgent
{
    [self.view endEditing:YES];
    NSString *addAgentString;
    if ([self.agentFlagString isEqualToString:@"add"]) {
        addAgentString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyAgentAddString];
    }else{
        addAgentString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyAgentModifyString];
    }
    
    self.addAgentDictionary[@"name"] = self.addAgentDictionary[@"name"]?self.addAgentDictionary[@"name"]:self.model.username;
    self.addAgentDictionary[@"mobile"] = self.addAgentDictionary[@"mobile"]?self.addAgentDictionary[@"mobile"]:self.model.mobile;
    self.addAgentDictionary[@"cardno"] = self.addAgentDictionary[@"cardno"]?self.addAgentDictionary[@"cardno"]:self.model.cardno;
    self.addAgentDictionary[@"zycardno"] = self.addAgentDictionary[@"zycardno"]?self.addAgentDictionary[@"zycardno"]:self.model.zycardno;
    self.addAgentDictionary[@"password"] = self.addAgentDictionary[@"password"]?self.addAgentDictionary[@"password"]:self.model.password_hash;
    
    [self.addAgentDictionary setValue:self.model.idString forKey:@"id"];
    [self.addAgentDictionary setValue:[self getValidateToken] forKey:@"token"];

    NSDictionary *params = self.addAgentDictionary;
    
    [self requestDataPostWithString:addAgentString params:params successBlock:^(id responseObject) {
        BaseModel *addModel = [BaseModel objectWithKeyValues:responseObject];
        [self showHint:addModel.msg];
        if ([addModel.code isEqualToString:@"0000"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)back
{
    UIAlertController *agentAlertController = [UIAlertController alertControllerWithTitle:@"" message:@"未保存，是否保存？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *agentAct1 = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"放弃保存");
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    UIAlertAction *agentAct2 = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"保存");

        [self saveAgent];
    }];
    
    [agentAlertController addAction:agentAct1];
    [agentAlertController addAction:agentAct2];
    
    [self presentViewController:agentAlertController animated:YES completion:nil];
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
