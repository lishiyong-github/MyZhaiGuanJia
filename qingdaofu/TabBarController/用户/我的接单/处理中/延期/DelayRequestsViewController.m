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

@interface DelayRequestsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *delayTableView;
@property (nonatomic,strong) PlaceHolderTextView *reasonTextView;
@property (nonatomic,strong) BaseCommitButton *commitButton;


@end

@implementation DelayRequestsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"申请延期";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self setupForDismissKeyboard];
    
    [self.view addSubview:self.delayTableView];
    [self.view addSubview:self.commitButton];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.delayTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.delayTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kTabBarHeight];
        
        [self.commitButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.commitButton autoSetDimension:ALDimensionHeight toSize:kTabBarHeight];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

#pragma mark - getter and setter
- (UITableView *)delayTableView
{
    if (!_delayTableView) {
        _delayTableView = [UITableView newAutoLayoutView];
        _delayTableView.delegate = self;
        _delayTableView.dataSource = self;
        _delayTableView.backgroundColor = kBackColor;
        _delayTableView.tableFooterView = [[UIView alloc] init];
        _delayTableView.separatorColor = kSeparateColor;
    }
    return _delayTableView;
}
- (PlaceHolderTextView *)reasonTextView
{
    if (!_reasonTextView) {
        _reasonTextView = [[PlaceHolderTextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
        _reasonTextView.placeholder = @"请填写申请延期原因";
        _reasonTextView.placeholderColor = kLightGrayColor;
    }
    return _reasonTextView;
}

- (BaseCommitButton *)commitButton
{
    if (!_commitButton) {
        _commitButton = [BaseCommitButton newAutoLayoutView];
        [_commitButton setTitle:@"立即申请" forState:0];
        [_commitButton addTarget:self action:@selector(requestDelayCommit) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitButton;
}

#pragma mark - tableview delegate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 200;
    }
    return kCellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    if (indexPath.row == 0) {
        identifier = @"delay0";
        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[TextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textField.placeholder = @"请填写延期申请原因";
        return cell;
    }
    
    identifier = @"delay1";
    CaseNoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[CaseNoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.leftFieldConstraints.constant = 135;
    [cell.caseNoButton setTitle:@"请填写延期天数" forState:0];
    cell.caseNoTextField.placeholder = @"天数";
    cell.caseNoTextField.keyboardType = UIKeyboardTypeNumberPad;
    [cell.caseGoButton setTitle:@"天" forState:0];
    return cell;
}

#pragma mark - method
- (void)requestDelayCommit
{
    NSString *delayString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyDelayRequestString];
    NSDictionary *params = @{@"token": [self getValidateToken],
                             @"id" : self.idString,
                             @"category" : self.categoryString,
                             @"dalay_reason" : @"做不完做不完做不完",
                             @"day" : @"4"
                             };
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
