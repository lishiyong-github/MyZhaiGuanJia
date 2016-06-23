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
#import "LoginForgetView.h"
@interface LoginViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *loginTableView;
@property (nonatomic,assign) BOOL didSetupConstraints;

@property (nonatomic,strong) LoginForgetView *loginFooterView;
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
        _loginTableView.tableFooterView = self.loginFooterView;
    }
    return _loginTableView;
}

- (LoginForgetView *)loginFooterView
{
    if (!_loginFooterView) {
        _loginFooterView = [[LoginForgetView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
        
        QDFWeakSelf;
        [_loginFooterView setDidSelecBtn:^(NSInteger buttonTag) {
            if (buttonTag == 21) {//登录
                [weakself.view endEditing:YES];
                [weakself loginUser];
            }else{//忘记密码
                ForgetPassViewController *forgetPassVC = [[ForgetPassViewController alloc] init];
                [weakself.navigationController pushViewController:forgetPassVC animated:YES];
            }
        }];
    }
    return _loginFooterView;
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
        
        QDFWeak(cell);
        [cell.loginButton addAction:^(UIButton *btn) {
            btn.selected = !btn.selected;
            if (btn.selected) {
                weakcell.loginTextField.secureTextEntry = NO;
            }else{
                weakcell.loginTextField.secureTextEntry = YES;
            }
        }];
    }
    
    return cell;
}

#pragma mark - method
- (void)registerNewUser
{
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (void)loginUser
{
    NSString *loginString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kLoginString];
    
    NSString *mobile = self.loginDictionary[@"mobile"]?self.loginDictionary[@"mobile"]:@"";
    NSString *password = self.loginDictionary[@"password"]?self.loginDictionary[@"password"]:@"";
    
    NSDictionary *params = @{@"mobile" : mobile,
                             @"password" : password
                             };
    
    //18221496879 123456 (xiaolou)
    //13162521916 123456
    //15000708849   123456

    [self requestDataPostWithString:loginString params:params successBlock:^( id responseObject){
                
        BaseModel *loginModel = [BaseModel objectWithKeyValues:responseObject];
        [self showHint:loginModel.msg];
        
        if ([loginModel.code isEqualToString:@"0000"]) {
            [[NSUserDefaults standardUserDefaults] setObject:loginModel.token forKey:@"token"];
            [[NSUserDefaults standardUserDefaults] setObject:self.loginDictionary[@"mobile"] forKey:@"mobile"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.navigationController popViewControllerAnimated:YES];
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
