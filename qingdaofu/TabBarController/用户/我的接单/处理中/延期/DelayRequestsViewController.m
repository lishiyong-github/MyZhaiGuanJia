//
//  DelayRequestsViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/6/12.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "DelayRequestsViewController.h"

#import "PlaceHolderTextView.h"
#import "BaseCommitButton.h"

#import "TextFieldCell.h"
#import "CaseNoCell.h"
#import "AgentCell.h"

@interface DelayRequestsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *delayTableView;

@property (nonatomic,strong) NSMutableDictionary *reasonDic;

@end

@implementation DelayRequestsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"申请延期";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(requestDelayCommit)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kBlueColor} forState:0];
    
    [self setupForDismissKeyboard];
    
    [self.view addSubview:self.delayTableView];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.delayTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

#pragma mark - getter and setter
- (UITableView *)delayTableView
{
    if (!_delayTableView) {
        _delayTableView = [UITableView newAutoLayoutView];
        _delayTableView.separatorColor = kSeparateColor;
        _delayTableView.backgroundColor = kBackColor;
        _delayTableView.delegate = self;
        _delayTableView.dataSource = self;
        _delayTableView.tableFooterView = [[UIView alloc] init];
        _delayTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
    }
    return _delayTableView;
}

- (NSMutableDictionary *)reasonDic
{
    if (!_reasonDic) {
        _reasonDic = [NSMutableDictionary dictionary];
    }
    return _reasonDic;
}

#pragma mark - tableview delegate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        return 100;
    }
    return kCellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    if (indexPath.row == 0) {
        identifier = @"delay0";
        AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.agentTextField.keyboardType = UIKeyboardTypeNumberPad;

        cell.agentLabel.text = @"延期天数";
        cell.agentTextField.placeholder = @"请输入希望延期天数";
        cell.agentTextField.keyboardType = UIKeyboardTypeNumberPad;
        [cell.agentButton setTitle:@"天" forState:0];

        QDFWeakSelf;
        [cell setDidEndEditing:^(NSString *text) {
            [weakself.reasonDic setObject:text forKey:@"day"];
        }];
        
        return cell;
    }
    identifier = @"delay1";
    TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.topTextViewConstraints.constant = kSpacePadding;
    
    cell.textField.placeholder = @"请填写延期申请原因，只能填写一次";
    cell.countLabel.text = [NSString stringWithFormat:@"%lu/200",(unsigned long)cell.textField.text.length];
    
    QDFWeakSelf;
    [cell setDidEndEditing:^(NSString *text) {
        [weakself.reasonDic setObject:text forKey:@"dalay_reason"];
    }];
    
    return cell;
}

#pragma mark - method
- (void)requestDelayCommit
{
    [self.view endEditing:YES];
    NSString *delayString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyDelayRequestString];
    
    self.reasonDic[@"dalay_reason"] = [NSString getValidStringFromString:self.reasonDic[@"dalay_reason"] toString:@""];
    self.reasonDic[@"day"] = [NSString getValidStringFromString:self.reasonDic[@"day"] toString:@""];

    [self.reasonDic setObject:[self getValidateToken] forKey:@"token"];
    [self.reasonDic setObject:self.idString forKeyedSubscript:@"id"];
    [self.reasonDic setObject:self.categoryString forKeyedSubscript:@"category"];
    
    NSDictionary *params = self.reasonDic;
   
    QDFWeakSelf;
    [self requestDataPostWithString:delayString params:params successBlock:^(id responseObject) {
        BaseModel *delayModel = [BaseModel objectWithKeyValues:responseObject];
        [weakself showHint:delayModel.msg];
        
        if ([delayModel.code isEqualToString:@"0000"]) {
            [weakself.navigationController popViewControllerAnimated:YES];
        }
        
    } andFailBlock:^(NSError *error) {
        
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
