//
//  MyScheduleViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/5.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MyScheduleViewController.h"

#import "TextFieldCell.h"
#import "MineUserCell.h"
#import "CaseNoCell.h"

@interface MyScheduleViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *scheduleTableView;

@end

@implementation MyScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"填写进度";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kBlueColor} forState:0];
    
    [self setupForDismissKeyboard];
    
    self.scheduleFlagString = @"two";
    
    [self.view addSubview:self.scheduleTableView];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.scheduleTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)scheduleTableView
{
    if (!_scheduleTableView) {
        _scheduleTableView = [UITableView newAutoLayoutView];
        _scheduleTableView.delegate = self;
        _scheduleTableView.dataSource = self;
        _scheduleTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
        _scheduleTableView.backgroundColor = kBackColor;
        
        if ([_scheduleTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_scheduleTableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_scheduleTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_scheduleTableView setLayoutMargins:UIEdgeInsetsZero];
        }

    }
    return _scheduleTableView;
}

#pragma mark - 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.scheduleFlagString isEqualToString:@"one"]) {
        return 2;
    }
    
    return 3;//或者2
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.scheduleFlagString isEqualToString:@"one"]) {
        if (indexPath.row == 1) {
            return 200;
        }
        return kCellHeight;
    }
    
    if (indexPath.row == 2) {
        return 200;
    }
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    
    if ([self.scheduleFlagString isEqualToString:@"one"]) {
        if (indexPath.row == 0) {
            identifier = @"schedule0";
            
            MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.userNameButton setTitle:@"选择处置类型" forState:0];
            [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
            
            return cell;

        }else{
            identifier = @"schedule1";
            TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[TextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textField.placeholder = @"请填写进度";
            return cell;
        }
    }
    //三行
    if (indexPath.row == 0) {
        identifier = @"schedule00";
        CaseNoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[CaseNoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.caseNoButton setTitle:@"案号" forState:0];
        cell.caseNoTextField.placeholder = @"请输入案号";
        cell.caseNoTextField.keyboardType = UIKeyboardTypeNumberPad;
        [cell.caseGoButton setTitle:@"案号类型" forState:0];
        [cell.caseGoButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        
        return cell;
        
    }else if (indexPath.row == 1){
        identifier = @"schedule01";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.userNameButton setTitle:@"选择处置类型" forState:0];
        [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        
        return cell;
    }
        identifier = @"schedule02";
        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[TextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textField.placeholder = @"请填写进度";
    
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
    
        return cell;
}

#pragma mark - method
- (void)save
{
    
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
