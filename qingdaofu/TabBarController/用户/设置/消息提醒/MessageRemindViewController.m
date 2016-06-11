//
//  MessageRemindViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/9.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MessageRemindViewController.h"

#import "MineUserCell.h"

@interface MessageRemindViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *messageRemindTableView;
@property (nonatomic,strong) UIButton *meReFootView;

@end

@implementation MessageRemindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"消息提醒";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.messageRemindTableView];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.messageRemindTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)messageRemindTableView
{
    if (!_messageRemindTableView) {
        _messageRemindTableView = [UITableView newAutoLayoutView];
        _messageRemindTableView.delegate = self;
        _messageRemindTableView.dataSource = self;
        _messageRemindTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
        _messageRemindTableView.backgroundColor = kBackColor;
        _messageRemindTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        [_messageRemindTableView.tableFooterView addSubview:self.meReFootView];
    }
    return _messageRemindTableView;
}

- (UIButton *)meReFootView
{
    if (!_meReFootView) {
        _meReFootView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        [_meReFootView setTitle:@"在iPhone的“设置－通知”功能中找到应用程序清道夫，可以更改清道夫的新消息提醒设置" forState:0];
        [_meReFootView setTitleColor:kLightGrayColor forState:0];
        _meReFootView.titleLabel.font = kSecondFont;
        _meReFootView.titleLabel.numberOfLines = 0;
        [_meReFootView setContentEdgeInsets:UIEdgeInsetsMake(10, kBigPadding, 5, kBigPadding)];
    }
    return _meReFootView;
}

#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"messageRemind";
    MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    [cell.userNameButton setTitle:@"消息提醒" forState:0];
    [cell.userActionButton setTitle:@"已开启" forState:0];
    cell.userActionButton.titleLabel.font = kBigFont;
    
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
