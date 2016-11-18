//
//  LoginViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/11.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"  //注册
#import "ForgetPassViewController.h"  //忘记密码

#import "LoginCell.h"
#import "EvaTopSwitchView.h"
#import "BaseCommitButton.h"
@interface LoginViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) EvaTopSwitchView *loginSwitchView;
@property (nonatomic,strong) UITableView *loginTableView;
@property (nonatomic,assign) BOOL didSetupConstraints;

@property (nonatomic,strong) NSMutableDictionary *loginDictionary;
@property (nonatomic,strong) NSString *loginType;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"登录";
    self.navigationItem.leftBarButtonItem = self.leftItemAnother;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(registerNewUser)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:kBigFont,NSForegroundColorAttributeName:kWhiteColor} forState:0];
    
    [self setupForDismissKeyboard];
    
    self.loginType = @"2";
    
    [self.view addSubview:self.loginTableView];
    [self.view addSubview:self.loginSwitchView];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.loginSwitchView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.loginSwitchView autoSetDimension:ALDimensionHeight toSize:kTabBarHeight];
        
        [self.loginTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.loginTableView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.loginSwitchView];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (EvaTopSwitchView *)loginSwitchView
{
    if (!_loginSwitchView) {
        _loginSwitchView = [EvaTopSwitchView newAutoLayoutView];
        _loginSwitchView.backgroundColor = kWhiteColor;
        [_loginSwitchView.getbutton setTitle:@"验证码登录" forState:0];
        [_loginSwitchView.sendButton setTitle:@"账号密码登录" forState:0];
        _loginSwitchView.leftBlueConstraints.constant = 0;
        _loginSwitchView.widthBlueConstraints.constant = kScreenWidth/2;
        [_loginSwitchView.shortLineLabel setHidden:YES];
        
        QDFWeakSelf;
        QDFWeak(_loginSwitchView);
        [_loginSwitchView setDidSelectedButton:^(NSInteger tag) {
            if (tag == 33) {//验证码登录
                weakself.loginSwitchView.leftBlueConstraints.constant = 0;
                [weak_loginSwitchView.getbutton setTitleColor:kTextColor forState:0];
                [weak_loginSwitchView.sendButton setTitleColor:kBlackColor forState:0];
                
                LoginCell *cell = [weakself.loginTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                [cell.loginSwitch setHidden:YES];
                [cell.getCodebutton setHidden:NO];
                [cell.getCodebutton setBackgroundColor:kButtonColor];
                [cell.getCodebutton setTitleColor:kWhiteColor forState:0];
                [cell.getCodebutton setTitle:@"获取验证码" forState:0];
                
                //row==1
                LoginCell *cell1 = [weakself.loginTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
                [cell1.getCodebutton setHidden:YES];
                [cell1.loginSwitch setHidden:YES];
                cell1.loginTextField.placeholder = @"输入验证码";
                cell1.loginTextField.secureTextEntry = NO;
                
                weakself.loginType = @"2";
                
            }else if (tag == 34){//账号密码登录
                weakself.loginSwitchView.leftBlueConstraints.constant = kScreenWidth/2;
                [weak_loginSwitchView.sendButton setTitleColor:kTextColor forState:0];
                [weak_loginSwitchView.getbutton setTitleColor:kBlackColor forState:0];
                
                //row==0
                LoginCell *cell = [weakself.loginTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                [cell.getCodebutton setHidden:YES];
                [cell.loginSwitch setHidden:YES];
                
                //row==1
                LoginCell *cell1 = [weakself.loginTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
                [cell1.getCodebutton setHidden:YES];
                [cell1.loginSwitch setHidden:NO];
                cell1.loginTextField.placeholder = @"输入密码";
                cell1.loginTextField.secureTextEntry = YES;
                QDFWeak(cell1);
                [cell1 setDidEndSwitching:^(BOOL state) {
                    if (!state) {
                        weakcell1.loginTextField.secureTextEntry = YES;
                    }else{
                        weakcell1.loginTextField.secureTextEntry = NO;
                    }
                }];
                
                weakself.loginType = @"1";
            }
        }];
    }
    return _loginSwitchView;
}

- (UITableView *)loginTableView
{
    if (!_loginTableView) {
        _loginTableView = [UITableView newAutoLayoutView];
        _loginTableView.delegate = self;
        _loginTableView.dataSource = self;
        _loginTableView.tableFooterView = [[UIView alloc] init];
        _loginTableView.separatorColor = kSeparateColor;
        _loginTableView.backgroundColor = kBackColor;
        _loginTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
    }
    return _loginTableView;
}

- (NSMutableDictionary *)loginDictionary
{
    if (!_loginDictionary) {
        _loginDictionary = [NSMutableDictionary dictionary];
    }
    return _loginDictionary;
}

#pragma mark - tableView delegate and dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"login";
    LoginCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[LoginCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    NSArray *array1 = @[@"输入您的手机号码    ",@"输入验证码        "];
    cell.loginTextField.placeholder = array1[indexPath.row];
    
    if (indexPath.row == 0) {//手机号
        [cell.loginSwitch setHidden:YES];
        [cell.getCodebutton setHidden:NO];
        [cell.getCodebutton setBackgroundColor:kButtonColor];
        [cell.getCodebutton setTitleColor:kWhiteColor forState:0];
        [cell.getCodebutton setTitle:@"获取验证码" forState:0];
        [cell.getCodebutton addTarget:self action:@selector(getCodess:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.loginTextField.keyboardType = UIKeyboardTypeNumberPad;
        [cell setFinishEditing:^(NSString *text) {
            [self.loginDictionary setValue:text forKey:@"mobile"];
        }];
    }else if (indexPath.row == 1) {//验证码
        [cell.getCodebutton setHidden:YES];
        [cell.loginSwitch setHidden:YES];
        cell.loginTextField.secureTextEntry = NO;
        
        [cell setFinishEditing:^(NSString *text) {
            [self.loginDictionary setValue:text forKey:@"password"];
        }];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 120;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    
    BaseCommitButton *loginCommitButton = [BaseCommitButton newAutoLayoutView];
    [loginCommitButton setTitle:@"登录" forState:0];
    [loginCommitButton addTarget: self action:@selector(loginUser) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:loginCommitButton];
    
    UIButton *forgrtButton = [UIButton newAutoLayoutView];
    [forgrtButton setTitleColor:kTextColor forState:0];
    forgrtButton.titleLabel.font = kSecondFont;
    [forgrtButton setTitle:@"忘记密码?" forState:0];
    [footerView addSubview:forgrtButton];
    QDFWeakSelf;
    [forgrtButton addAction:^(UIButton *btn) {
        ForgetPassViewController *forgetPassVC = [[ForgetPassViewController alloc] init];
        [weakself.navigationController pushViewController:forgetPassVC animated:YES];
    }];
    
    [loginCommitButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:30];
    [loginCommitButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
    [loginCommitButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
    [loginCommitButton autoSetDimension:ALDimensionHeight toSize:40];
    
    [forgrtButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:loginCommitButton withOffset:kBigPadding];
    [forgrtButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:loginCommitButton];
    
    return footerView;
    
}

#pragma mark - method
- (void)getCodess:(JKCountDownButton *)sender
{
    [self.view endEditing:YES];
    NSString *codeString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kLoginGetCodeString];
    self.loginDictionary[@"mobile"] = self.loginDictionary[@"mobile"]?self.loginDictionary[@"mobile"]:@"";
    
    NSDictionary *params = self.loginDictionary;
    
    QDFWeakSelf;
    [self requestDataPostWithString:codeString params:params successBlock:^(id responseObject){//成功
        
        BaseModel *codeModel = [BaseModel objectWithKeyValues:responseObject];
        [weakself showHint:codeModel.msg];
        if ([codeModel.code isEqualToString:@"0000"]) {
            [sender startWithSecond:60];
            [sender didChange:^NSString *(JKCountDownButton *countDownButton, int second) {
                [sender setBackgroundColor:kLightGrayColor];
                sender.enabled = NO;
                NSString *title = [NSString stringWithFormat:@"剩余(%d)秒",second];
                return title;
            }];
            
            [sender didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
                sender.backgroundColor = kButtonColor;
                [sender setTitleColor:kWhiteColor forState:0];
                sender.enabled = YES;
                return @"获取验证码";
            }];
        }
    } andFailBlock:^(NSError *error){
        
    }];
}

- (void)registerNewUser
{
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (void)loginUser
{
    [self.view endEditing:YES];
    NSString *loginString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kLoginString];
    
    NSString *mobile = self.loginDictionary[@"mobile"]?self.loginDictionary[@"mobile"]:@"";
    NSString *password = self.loginDictionary[@"password"]?self.loginDictionary[@"password"]:@"";
    
    NSDictionary *params = @{@"mobile" : mobile,
                             @"password" : password,
                             @"logintype" : self.loginType
                             };
    
    //18221496879 123456 (xiaolou)
    //13162521916 123456
    //15000708849   123456

    QDFWeakSelf;
    [self requestDataPostWithString:loginString params:params successBlock:^( id responseObject){
            
        BaseModel *loginModel = [BaseModel objectWithKeyValues:responseObject];
        [weakself showHint:loginModel.msg];
        
        if ([loginModel.code isEqualToString:@"0000"]) {
            [[NSUserDefaults standardUserDefaults] setObject:loginModel.token forKey:@"token"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [weakself back];
        }
        
    } andFailBlock:^(NSError *error){
        
    }];
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
