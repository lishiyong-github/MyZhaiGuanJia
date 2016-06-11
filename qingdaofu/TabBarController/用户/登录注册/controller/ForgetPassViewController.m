//
//  ForgetPassViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/11.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ForgetPassViewController.h"

#import "LoginCell.h"
#import "BaseCommitButton.h"

@interface ForgetPassViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *forgetPassTableView;
@property (nonatomic,assign) BOOL didSetupConstraints;

@end

@implementation ForgetPassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"忘记密码";
    self.navigationItem.leftBarButtonItem = self.leftItem;

    [self setupForDismissKeyboard];
    
    [self.view addSubview:self.forgetPassTableView];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.forgetPassTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)forgetPassTableView
{
    if (!_forgetPassTableView) {
        _forgetPassTableView = [UITableView newAutoLayoutView];
        _forgetPassTableView.delegate = self;
        _forgetPassTableView.dataSource = self;
        _forgetPassTableView.backgroundColor = kBackColor;
        _forgetPassTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
        _forgetPassTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
    }
    return _forgetPassTableView;
}

#pragma mark - tableView delelagte and datasource
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
    static NSString *identifier = @"forgetPass";
    LoginCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[LoginCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *arr = @[@"手机号",@"验证码",@"输入新密码"];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:arr[indexPath.row]];
    [attributeStr addAttributes:@{NSFontAttributeName:kBigFont,NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(0, attributeStr.length)];
    [cell.loginTextField setAttributedPlaceholder:attributeStr];
    
    if (indexPath.row == 0) {
        [cell.getCodebutton setHidden:YES];
        [cell.loginButton setHidden:YES];
    }else if (indexPath.row == 1){
        [cell.loginButton setHidden:YES];
        [cell.getCodebutton setBackgroundColor:kBlueColor];
        [cell.getCodebutton setTitleColor:kNavColor forState:0];
        [cell.getCodebutton setTitle:@"获取验证码" forState:0];
        [cell.getCodebutton addTarget:self action:@selector(getForgetCode:) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
        [cell.getCodebutton setHidden:YES];
        [cell.loginButton setTitle:@"显示密码" forState:0];
        [cell.loginButton setTitle:@"隐藏密码" forState:UIControlStateSelected];
        QDFWeak(cell);
        [cell.loginButton addAction:^(UIButton *btn) {
            btn.selected = !btn.selected;
            if (btn.selected) {
                weakcell.loginTextField.secureTextEntry = YES;
            }else{
                weakcell.loginTextField.secureTextEntry = NO;
            }
        }];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 70;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 70)];
    BaseCommitButton *forgetCommitBtn = [[BaseCommitButton alloc] initWithFrame:CGRectMake(kBigPadding, kBigPadding, kScreenWidth-kBigPadding*2, 40)];
    [forgetCommitBtn setTitle:@"确定" forState:0];
    [footerView addSubview:forgetCommitBtn];
    [forgetCommitBtn addTarget:self action:@selector(forgetCommitAction) forControlEvents:UIControlEventTouchUpInside];
    
    return footerView;
}

- (void)getForgetCode:(JKCountDownButton *)sender
{
    NSString *codeString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kLoginGetCodeString];
    NSDictionary *params = @{@"mobile" : @"13162521916"};
    
    [self requestDataPostWithString:codeString params:params successBlock:^(AFHTTPRequestOperation *operation, id responseObject){//成功
        
        BaseModel *codeModel = [BaseModel objectWithKeyValues:responseObject];
        [self showHint:codeModel.msg];
        if ([codeModel.code isEqualToString:@"0000"]) {
            
            [sender startWithSecond:60];
            [sender didChange:^NSString *(JKCountDownButton *countDownButton, int second) {
                [sender setBackgroundColor:kLightGrayColor];
                sender.enabled = NO;
                NSString *title = [NSString stringWithFormat:@"剩余(%d秒)",second];
                return title;
            }];
            
            [sender didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
                sender.backgroundColor = kBlueColor;
                sender.enabled = YES;
                return @"获取验证码";
            }];
        }
    } andFailBlock:^{//失败
        
    }];
}

- (void)forgetCommitAction
{
    NSString *forgetString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kResetPasswordString];
    NSDictionary *params = @{@"mobile" : @"13162521916",
                             @"validatecode" : @"1835",
                             @"new_password" : @"123456"};
    [self requestDataPostWithString:forgetString params:params successBlock:^(AFHTTPRequestOperation *operation, id responseObject){
        BaseModel *forgetModel = [BaseModel objectWithKeyValues:responseObject];
        [self showHint:forgetModel.msg];
        
        if ([forgetModel.code isEqualToString:@"0000"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } andFailBlock:^{
        
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
