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
#import "LoginViewController.h"  //登录

#import "NewsTableViewCell.h"

#import "TabBarItem.h"
#import "UITabBar+Badge.h"


@interface MessageViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *messageTableView;

//json
@property (nonatomic,strong) NSMutableDictionary *resultDic;

@end

@implementation MessageViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self getMessageTypeAndNumber];
}

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
        _messageTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _messageTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        _messageTableView.delegate = self;
        _messageTableView.dataSource = self;
        _messageTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
        _messageTableView.backgroundColor = kBackColor;
    }
    return _messageTableView;
}

- (NSMutableDictionary *)resultDic
{
    if (!_resultDic) {
        _resultDic = [NSMutableDictionary dictionary];
    }
    return _resultDic;
}

#pragma mark - tabelView delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    return 2;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 60;
    }
//    return 68;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    
    //分类消息
    if (indexPath.section == 0) {
        identifier = @"all";
        NSArray *titleArray = @[@"  发布消息",@"  接单消息",@"  评价消息",@"  系统消息"];
        NSArray *imageArray = @[@"news_publish_icon",@"news_order_icon",@"news_evaluate_icon",@"news_system_icon"];
        NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[NewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        NSDictionary *childDic;
        if (self.resultDic) {
            NSString *index = [NSString stringWithFormat:@"%ld",indexPath.row+1];
            childDic = self.resultDic[index];
        }
        
        [cell.newsNameButton setTitle:titleArray[indexPath.row] forState:0];
        [cell.newsNameButton setImage:[UIImage imageNamed:imageArray[indexPath.row]] forState:0];
        cell.newsNameButton.titleLabel.font = [UIFont systemFontOfSize:18];
        
        [cell.newsActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        [cell.newsActionButton setTitleColor:kBlueColor forState:0];
        cell.newsActionButton.titleLabel.backgroundColor = kBlueColor;
        [cell.newsActionButton setTitleColor:kNavColor forState:0];
                
        if ([childDic[@"number"] integerValue] == 0) {
            [cell.newsCountButton setHidden:YES];
        }else{
            if (indexPath.row == 2) {
                [cell.newsCountButton setHidden:YES];
            }else{
                [cell.newsCountButton setHidden:NO];
                if ([childDic[@"number"] integerValue] > 99) {
                    [cell.newsCountButton setTitle:@"99+" forState:0];
                }else{
                    [cell.newsCountButton setTitle:childDic[@"number"] forState:0];
                }
            }
        }
        return cell;
    }
    
//    //最近消息
//    identifier = @"newMessages";
//    
//    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (!cell) {
//        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//    }
//    
//    [cell setSeparatorInset:UIEdgeInsetsMake(0, kBigPadding, 0, 0)];
//    
//    cell.userLabel.text = @"用户1234567888";
//    cell.timeLabel.text = @"2016-02-10 10:12";
//    cell.newsLabel.text = @"最新消息最新消息最新消息";
//    cell.countLabel.text = @"40";
//    
//    return cell;
    return nil;
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

    [self tokenIsValid];
    QDFWeakSelf;
    [self setDidTokenValid:^(TokenModel *model) {
        if ([model.code integerValue] == 0000 || [model.code integerValue] == 3006){//正常
            if (indexPath.section == 0) {
                switch (indexPath.row) {
                    case 0:{//发布消息
                        PublishMessagesViewController *pubMessagesVC = [[PublishMessagesViewController alloc] init];
                        pubMessagesVC.hidesBottomBarWhenPushed = YES;
                        [weakself.navigationController pushViewController:pubMessagesVC animated:YES];
                    }
                        break;
                    case 1:{//接单消息
                        ReceiveMessagesViewController *receiveMessagesVC = [[ReceiveMessagesViewController alloc] init];
                        receiveMessagesVC.hidesBottomBarWhenPushed = YES;
                        [weakself.navigationController pushViewController:receiveMessagesVC animated:YES];
                    }
                        break;
                    case 2:{//评价消息
                        EvaluateMessagesViewController *evaluateMessagesVC = [[EvaluateMessagesViewController alloc] init];
                        evaluateMessagesVC.hidesBottomBarWhenPushed = YES;
                        [weakself.navigationController pushViewController:evaluateMessagesVC animated:YES];
                    }
                        break;
                    case 3:{//系统消息
                        SystemMessagesViewController *systemMessagesVC = [[SystemMessagesViewController alloc] init];
                        systemMessagesVC.hidesBottomBarWhenPushed = YES;
                        [weakself.navigationController pushViewController:systemMessagesVC animated:YES];
                    }
                        break;
                    default:
                        break;
                }
            }
        }else {
            [weakself showHint:model.msg];
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            loginVC.hidesBottomBarWhenPushed = YES;
            UINavigationController *uiui = [[UINavigationController alloc] initWithRootViewController:loginVC];
            [weakself presentViewController:uiui animated:YES completion:nil];
        }
    }];
}

#pragma mark - method
- (void)getMessageTypeAndNumber
{
    NSString *messageTypeString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMessageTypeAndNumbersString];
    NSString *token = [self getValidateToken]?[self getValidateToken]:@"";
    NSDictionary *params = @{@"token" : token};
    QDFWeakSelf;
    [self requestDataPostWithString:messageTypeString params:params successBlock:^(id responseObject) {
        NSDictionary *opopo = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        weakself.resultDic = [NSMutableDictionary dictionaryWithDictionary:opopo[@"result"]];
        [weakself.messageTableView reloadData];
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        UITabBarController *tabBarController = (UITabBarController *)window.rootViewController;
        
        NSInteger n1 = [weakself.resultDic[@"1"][@"number"] integerValue];
        NSInteger n2 = [weakself.resultDic[@"2"][@"number"] integerValue];
        NSInteger n4 = [weakself.resultDic[@"4"][@"number"] integerValue];

        NSString *all = [NSString stringWithFormat:@"%ld",n1+n2+n4];
        
        if ([all integerValue] == 0) {
            //隐藏
            [self.tabBarController.tabBar hideBadgeOnItemIndex:3];
        }else{
            //显示
            [tabBarController.tabBar showBadgeOnItemIndex:3];
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
