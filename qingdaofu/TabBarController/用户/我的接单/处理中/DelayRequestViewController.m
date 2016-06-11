//
//  DelayRequestViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/4.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "DelayRequestViewController.h"

#import "PlaceHolderTextView.h"
#import "TextFieldCell.h"
#import "BaseCommitButton.h"

@interface DelayRequestViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *delayTableView;
@property (nonatomic,strong) PlaceHolderTextView *reasonTextView;
@property (nonatomic,strong) BaseCommitButton *commitButton;

@end


@implementation DelayRequestViewController

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
    identifier = @"delay0";
    
    TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[TextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    NSArray *textArray = @[@"请填写延期申请原因",@"请填写延期天数"];
    cell.textField.placeholder = textArray[indexPath.row];
    
    if (indexPath.row == 1) {
        [cell.textDeailButton setTitle:@"天" forState:0];
    }

        return cell;
    
//    if (indexPath.row == 0) {
//        identifier = @"delay0";
//        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//        if (!cell) {
//            cell = [[TextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//        }
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        
//        cell.textField.placeholder = @"请填写延期申请原因";
//        
//        return cell;
//    }
//    identifier = @"delay1";
//    TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (!cell) {
//        cell = [[TextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    
//    cell.textField.placeholder = @"请填写延期天数";
//    [cell.textField setPlaceholderColor:kBlackColor];
//    
//    [cell.textDeailButton setTitle:@"天" forState:0];
//    
//    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

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
