//
//  ModifyPassWordViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/9.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ModifyPassWordViewController.h"

#import "AgentCell.h"
#import "BaseCommitButton.h"

@interface ModifyPassWordViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *modifyTableView;
@property (nonatomic,strong) BaseCommitButton *modifyCommitButton;

@property (nonatomic,strong) NSMutableDictionary *modifyDictionary;

@end

@implementation ModifyPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改密码";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self setupForDismissKeyboard];
    
    [self.view addSubview:self.modifyTableView];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.modifyTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)modifyTableView
{
    if (!_modifyTableView) {
        _modifyTableView = [UITableView newAutoLayoutView];
        _modifyTableView.delegate = self;
        _modifyTableView.dataSource = self;
        _modifyTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 70)];
        [_modifyTableView.tableFooterView addSubview:self.modifyCommitButton ];
        _modifyTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
        _modifyTableView.backgroundColor = kBackColor;
        _modifyTableView.separatorColor = kSeparateColor;
    }
    return _modifyTableView;
}

- (BaseCommitButton *)modifyCommitButton
{
    if (!_modifyCommitButton) {
        _modifyCommitButton = [[BaseCommitButton alloc] initWithFrame:CGRectMake(kBigPadding, kBigPadding, kScreenWidth-2*kBigPadding, kCellHeight)];
        [_modifyCommitButton setTitle:@"提交" forState:0];
        [_modifyCommitButton setBackgroundColor:kBlueColor];
        
        QDFWeakSelf;
        [_modifyCommitButton addAction:^(UIButton *btn) {
            NSLog(@"提交修改");
            [weakself modifyPassword];
        }];
    }
    return _modifyCommitButton;
}

- (NSMutableDictionary *)modifyDictionary
{
    if (!_modifyDictionary) {
        _modifyDictionary = [NSMutableDictionary dictionary];
    }
    return _modifyDictionary;
}
#pragma mark - 
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
    static NSString *identifier = @"modify";
    AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *mArray = @[@"请输入原密码",@"输入新密码"];
    cell.leftdAgentContraints.constant = kBigPadding;
    cell.agentTextField.placeholder = mArray[indexPath.row];
    
    if (indexPath.row == 0) {
        [cell setDidEndEditing:^(NSString *text) {
            [self.modifyDictionary setValue:text forKey:@"old_password"];
        }];
    }else if (indexPath.row == 1) {
        [cell.agentButton setTitle:@"显示密码" forState:0];
        
        [cell setDidEndEditing:^(NSString *text) {
            [self.modifyDictionary setValue:text forKey:@"new_password"];
        }];
        
        QDFWeak(cell);
        [cell.agentButton addAction:^(UIButton *btn) {
            NSLog(@"显示密码");
            if (!btn.selected) {
                weakcell.agentTextField.secureTextEntry = NO;
            }else{
                weakcell.agentTextField.secureTextEntry = YES;
            }
            btn.selected = !btn.selected;
        }];

    }
    return cell;
}

- (void)modifyPassword
{
    NSString *modifyString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kModifyPasswordString];
    
    NSString *old_password = @"";
    NSString *new_password = @"";
    
    if (self.modifyDictionary[@"old_password"]) {
        old_password = self.modifyDictionary[@"old_password"];
    }
    
    if (self.modifyDictionary[@"new_password"]) {
       new_password = self.modifyDictionary[@"new_password"];
    }
    
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"old_password" : old_password,
                             @"new_password" : new_password
                             };
    
    [self requestDataPostWithString:modifyString params:params successBlock:^(id responseObject){
        
        BaseModel *modifyModel = [BaseModel objectWithKeyValues:responseObject];
        [self showHint:modifyModel.msg];
        if ([modifyModel.code isEqualToString:@"0000"]) {
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
