//
//  AddMyAgentViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/17.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "AddMyAgentViewController.h"

#import "AgentCell.h"

@interface AddMyAgentViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *addAgentTableView;

@end

@implementation AddMyAgentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加代理";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAgent)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:kBigFont,NSForegroundColorAttributeName:kBlueColor} forState:0];
    
    [self setupForDismissKeyboard];
    
    [self.view addSubview:self.addAgentTableView];
    [self.view setNeedsUpdateConstraints];
}

#pragma mark - method
- (void)back
{
    UIAlertController *agentAlertController = [UIAlertController alertControllerWithTitle:@"" message:@"未保存，是否保存？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *agentAct1 = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"放弃保存");
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    UIAlertAction *agentAct2 = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"保存");
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [agentAlertController addAction:agentAct1];
    [agentAlertController addAction:agentAct2];
    
    [self presentViewController:agentAlertController animated:YES completion:nil];
}

- (void)saveAgent
{
    
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
    AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *aArray = @[@"姓名",@"联系方式",@"身份证号",@"执业证号",@"登录密码"];
    NSArray *bArray = @[@"请输入姓名",@"请输入联系方式",@"请输入身份证号",@"请输入执业证号",@"请设置代理人登录密码"];
    NSArray *cArray = @[@"张三三",@"12344678999",@"1234578890000",@"243254354657567655432456",@"123asgsfdhgfg"];

    cell.agentLabel.text = aArray[indexPath.row];
    cell.agentTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    if ([self.agentFlagString isEqualToString:@"no"]) {
        cell.agentTextField.placeholder = bArray[indexPath.row];
    }else{
        cell.agentTextField.text = cArray[indexPath.row];
    }
    
    return cell;
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
