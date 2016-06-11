//
//  MessageViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/4/26.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MessageViewController.h"
#import "PublishMessagesViewController.h" //发布消息
#import "ReceiveMessagesViewController.h"  //接单消息
#import "EvaluateMessagesViewController.h"  //评价消息
#import "SystemMessagesViewController.h"   //系统消息

#import "MessageCell.h"

#import "MineUserCell.h"

@interface MessageViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *messageTableView;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"消息";
    
    [self.view addSubview:self.messageTableView];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.messageTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.messageTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kTabBarHeight];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)messageTableView
{
    if (!_messageTableView) {
//        _messageTableView = [UITableView newAutoLayoutView];
        _messageTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _messageTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        _messageTableView.delegate = self;
        _messageTableView.dataSource = self;
        _messageTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
        _messageTableView.backgroundColor = kBackColor;
    }
    return _messageTableView;
}

#pragma mark - tabelView delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 60;
    }
    return 68;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    
    if (indexPath.section == 0) {
        identifier = @"all";
        NSArray *titleArray = @[@"  发布消息",@"  接单消息",@"  评价消息",@"  系统消息"];
        NSArray *imageArray = @[@"news_publish_icon",@"news_order_icon",@"news_evaluate_icon",@"news_system_icon"];
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        [cell setSeparatorInset:UIEdgeInsetsMake(0, kBigPadding, 0, 0)];
        
        [cell.userNameButton setTitle:titleArray[indexPath.row] forState:0];
        [cell.userNameButton setImage:[UIImage imageNamed:imageArray[indexPath.row]] forState:0];
        cell.userNameButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        
        cell.userNameButton.userInteractionEnabled = NO;
        cell.userActionButton.userInteractionEnabled = NO;
        
        return cell;
    }
    
    identifier = @"newMessages";
    
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    [cell setSeparatorInset:UIEdgeInsetsMake(0, kBigPadding, 0, 0)];
    
    cell.userLabel.text = @"用户1234567888";
    cell.timeLabel.text = @"2016-02-10 10:12";
    cell.newsLabel.text = @"最新消息最新消息最新消息";
    cell.countLabel.text = @"40";
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return kBigPadding;
    }
    return kCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *headerView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kCellHeight)];
        headerView1.backgroundColor = kBackColor;
        
        UILabel *friendLabel = [UILabel newAutoLayoutView];
        friendLabel.text = @"最近联系人";
        friendLabel.textColor = kBlackColor;
        friendLabel.font = kBigFont;
        [headerView1 addSubview:friendLabel];
        
        [friendLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [friendLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20];
        
        return headerView1;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:{//发布消息
                PublishMessagesViewController *pubMessagesVC = [[PublishMessagesViewController alloc] init];
                pubMessagesVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:pubMessagesVC animated:YES];
            }
                break;
            case 1:{//接单消息
                ReceiveMessagesViewController *receiveMessagesVC = [[ReceiveMessagesViewController alloc] init];
                receiveMessagesVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:receiveMessagesVC animated:YES];
            }
                break;
            case 2:{//评价消息
                EvaluateMessagesViewController *evaluateMessagesVC = [[EvaluateMessagesViewController alloc] init];
                evaluateMessagesVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:evaluateMessagesVC animated:YES];
            }
                break;
            case 3:{//系统消息
                SystemMessagesViewController *systemMessagesVC = [[SystemMessagesViewController alloc] init];
                systemMessagesVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:systemMessagesVC animated:YES];
            }
                break;
            default:
                break;
        }
    }
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
