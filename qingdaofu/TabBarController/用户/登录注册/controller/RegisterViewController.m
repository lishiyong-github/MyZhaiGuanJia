//
//  RegisterViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/11.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterAgreementViewController.h"

#import "LoginCell.h"
#import "JKCountDownButton.h"

#import "BaseModel.h"
#import "BaseCommitButton.h"

@interface RegisterViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *registerTableView;
@property (nonatomic,assign) BOOL didSetupConstraints;

@property (nonatomic,strong) NSString *validateString;

@property (nonatomic,strong) NSMutableDictionary *registerDictionary;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"注册";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.registerTableView];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        [self.registerTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];

        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)registerTableView
{
    if (!_registerTableView) {
        _registerTableView = [UITableView newAutoLayoutView];
        _registerTableView.delegate = self;
        _registerTableView.dataSource = self;
        _registerTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
        _registerTableView.backgroundColor = kBackColor;
        _registerTableView.separatorColor = kSeparateColor;
    }
    return _registerTableView;
}

- (NSMutableDictionary *)registerDictionary
{
    if (!_registerDictionary) {
        _registerDictionary = [NSMutableDictionary dictionary];
    }
    return _registerDictionary;
}

#pragma mark - tabelView delegate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer = @"register";
    LoginCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[LoginCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *placeHolderArray = @[@"输入您的手机号",@"输入验证码",@"字母数字，至少6位"];
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:placeHolderArray[indexPath.row]];
    [attributeStr addAttributes:@{NSFontAttributeName:kBigFont,NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(0, attributeStr.length)];
    
    [cell.loginTextField setAttributedPlaceholder:attributeStr];
    
    QDFWeakSelf;
    if (indexPath.row == 0) {
        cell.loginTextField.keyboardType = UIKeyboardTypeNumberPad;
        [cell setFinishEditing:^(NSString *text) {
            [weakself.registerDictionary setValue:text forKey:@"mobile"];
        }];
    }else if (indexPath.row == 1) {
        cell.loginTextField.keyboardType = UIKeyboardTypeNumberPad;
        [cell.loginSwitch setHidden:YES];
        [cell.getCodebutton setBackgroundColor:kButtonColor];
        [cell.getCodebutton setTitleColor:kWhiteColor forState:0];
        [cell.getCodebutton setTitle:@"获取验证码" forState:0];
        [cell.getCodebutton addTarget:self action:@selector(getCode:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell setFinishEditing:^(NSString *text) {
            [weakself.registerDictionary setValue:text forKey:@"validatecode"];
        }];
        
    }else{
        cell.loginTextField.secureTextEntry = YES;
        [cell.getCodebutton setHidden:YES];
        QDFWeak(cell);
        [cell setDidEndSwitching:^(BOOL state) {
            if (!state) {
                weakcell.loginTextField.secureTextEntry = YES;
            }else{
                weakcell.loginTextField.secureTextEntry = NO;
            }
        }];
        
        [cell setFinishEditing:^(NSString *text) {
            [weakself.registerDictionary setValue:text forKey:@"password"];
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
    UIView *footerRegisterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 120)];
    
    BaseCommitButton *registerCommitButton = [BaseCommitButton newAutoLayoutView];
    [registerCommitButton setTitle:@"注册" forState:0];
    [footerRegisterView addSubview:registerCommitButton];
    
    UIButton *chButton = [UIButton newAutoLayoutView];
    [chButton setTitle:@"  我已阅读并同意" forState:0];
    chButton.titleLabel.font = kSecondFont;
    [chButton setTitleColor:kLightGrayColor forState:0];
    [chButton setImage:[UIImage imageNamed:@"selected"] forState:0];
    [chButton setImage:[UIImage imageNamed:@"selected_dis"] forState:UIControlStateSelected];
    [footerRegisterView addSubview:chButton];
    
    UIButton *deButton = [UIButton newAutoLayoutView];
    [deButton setTitle:@"注册协议" forState:0];
    deButton.titleLabel.font = kSecondFont;
    [deButton setTitleColor:kBlueColor forState:0];
    [footerRegisterView addSubview:deButton];
    
    [registerCommitButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:30];
    [registerCommitButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
    [registerCommitButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
    [registerCommitButton autoSetDimension:ALDimensionHeight toSize:40];
    
    [chButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
    [chButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:registerCommitButton withOffset:20];
    
    [deButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:chButton];
    [deButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:chButton withOffset:kSmallPadding];
    
    QDFWeakSelf;
    [registerCommitButton addAction:^(UIButton *btn) {
        if (!chButton.selected) {
            [weakself registerUser];
        }else{
            [self showHint:@"您还未同意协议，不能注册"];
        }
    }];
    
    [chButton addAction:^(UIButton *btn) {
        btn.selected = !btn.selected;
    }];
    
    [deButton addAction:^(UIButton *btn) {
        RegisterAgreementViewController *registerAgreementVC = [[RegisterAgreementViewController alloc] init];
        registerAgreementVC.agreeString = kRegisterAgreement;
        [weakself.navigationController pushViewController:registerAgreementVC animated:YES];
    }];
    
    return footerRegisterView;
}

#pragma mark - method
- (void)getCode:(JKCountDownButton *)sender
{
    [self.view endEditing:YES];
    NSString *codeString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kLoginGetCodeString];
    self.registerDictionary[@"mobile"] = self.registerDictionary[@"mobile"]?self.registerDictionary[@"mobile"]:@"";
//    NSDictionary *params = @{@"mobile" : self.registerDictionary[@"mobile"]};
    NSDictionary *params = self.registerDictionary;
    
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
                sender.enabled = YES;
                return @"获取验证码";
            }];
        }
    } andFailBlock:^(NSError *error){
        
    }];
}

- (void)registerUser
{
    [self.view endEditing:YES];
    NSString *registerString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kRegisterString];
    self.registerDictionary[@"mobile"] = self.registerDictionary[@"mobile"]?self.registerDictionary[@"mobile"]:@"";
    self.registerDictionary[@"validatecode"] = self.registerDictionary[@"validatecode"]?self.registerDictionary[@"validatecode"]:@"";
    self.registerDictionary[@"password"] = self.registerDictionary[@"password"]?self.registerDictionary[@"password"]:@"";

    NSDictionary *params = self.registerDictionary;
    
    QDFWeakSelf;
    [weakself requestDataPostWithString:registerString params:params successBlock:^( id responseObject){
        BaseModel *registerModel = [BaseModel objectWithKeyValues:responseObject];
        [weakself showHint:registerModel.msg];
        
        if ([registerModel.code isEqualToString:@"0000"]) {
            [weakself loginUser];
        }
        
    } andFailBlock:^(NSError *error){
        
    }];
}

- (void)loginUser
{
    NSString *loginString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kLoginString];
    
    NSString *mobile = self.registerDictionary[@"mobile"];
    NSString *password = self.registerDictionary[@"password"];
    
    NSDictionary *params = @{@"mobile" : mobile,
                             @"password" : password
                             };
    
    QDFWeakSelf;
    [self requestDataPostWithString:loginString params:params successBlock:^( id responseObject){
        
        BaseModel *loginModel = [BaseModel objectWithKeyValues:responseObject];
        [weakself showHint:loginModel.msg];
        
        if ([loginModel.code isEqualToString:@"0000"]) {
            [[NSUserDefaults standardUserDefaults] setObject:loginModel.token forKey:@"token"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            UINavigationController *nav = self.navigationController;
            [nav popViewControllerAnimated:NO];
            [nav popViewControllerAnimated:NO];
        }else{
            [weakself.navigationController popViewControllerAnimated:YES];
        }
        
    } andFailBlock:^(NSError *error){
        [weakself.navigationController popViewControllerAnimated:YES];
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
