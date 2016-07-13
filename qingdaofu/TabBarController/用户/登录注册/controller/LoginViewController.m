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
#import "BaseCommitButton.h"
@interface LoginViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *loginTableView;
@property (nonatomic,assign) BOOL didSetupConstraints;

@property (nonatomic,strong) NSMutableDictionary *loginDictionary;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"登录";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(registerNewUser)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:kBigFont,NSForegroundColorAttributeName:kBlueColor} forState:0];
    
    [self setupForDismissKeyboard];
    
    [self.view addSubview:self.loginTableView];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.loginTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
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

    NSArray *array1 = @[@"输入您的手机号码    ",@"输入您的密码        "];
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:array1[indexPath.row]];
    [attriStr addAttributes:@{NSFontAttributeName:kBigFont,NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(0, attriStr.length)];
    [cell.loginTextField setAttributedPlaceholder:attriStr];
    
    if (indexPath.row == 0) {//手机号
        cell.loginTextField.keyboardType = UIKeyboardTypeNumberPad;
        [cell setFinishEditing:^(NSString *text) {
            [self.loginDictionary setValue:text forKey:@"mobile"];
        }];
    }else if (indexPath.row == 1) {//密码
        cell.loginTextField.secureTextEntry = YES;
        [cell.loginButton setTitle:@"显示密码" forState:0];
        [cell.loginButton setTitle:@"隐藏密码" forState:UIControlStateSelected];
        [cell.getCodebutton setHidden:YES];
        
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
    [forgrtButton setTitleColor:kBlueColor forState:0];
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
                             @"password" : password
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
            [[NSUserDefaults standardUserDefaults] setObject:weakself.loginDictionary[@"mobile"] forKey:@"mobile"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [weakself.navigationController popViewControllerAnimated:YES];
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
