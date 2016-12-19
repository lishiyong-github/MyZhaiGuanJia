//
//  MessageViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/4/26.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MessageViewController.h"
#import "SystemMessagesViewController.h"   //系统消息
#import "LoginViewController.h"  //登录
#import "MyReleaseDetailsViewController.h" //发布详情
#import "MyOrderDetailViewController.h"  //接单详情
#import "PowerDetailsViewController.h"  //保全详情
#import "ApplicationDetailsViewController.h"   //保函详情
#import "HousePropertyListViewController.h" //产调

#import "MessageTableViewCell.h"
#import "MessageSystemView.h"

#import "MessageResponse.h"
#import "MessagesModel.h"
#import "ImageModel.h"

#import "TabBarItem.h"
#import "UITabBar+Badge.h"

#import "UIButton+WebCache.h"


@interface MessageViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *messageTableView;

//json
@property (nonatomic,strong) NSMutableDictionary *resultDic;
@property (nonatomic,strong) NSMutableArray *messageCountArray;
@property (nonatomic,strong) NSMutableArray *messageArray;
@property (nonatomic,assign) NSInteger pageMessage;
@end

@implementation MessageViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self headerRefreshOfMessageGroup];
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
        _messageTableView = [UITableView newAutoLayoutView];
        _messageTableView.backgroundColor = kBackColor;
        _messageTableView.separatorColor = kSeparateColor;
        _messageTableView.delegate = self;
        _messageTableView.dataSource = self;
        _messageTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
        [_messageTableView addHeaderWithTarget:self action:@selector(headerRefreshOfMessageGroup)];
        [_messageTableView addFooterWithTarget:self action:@selector(footerRefreshOfMessageGroup)];
    }
    return _messageTableView;
}

- (NSMutableArray *)messageCountArray
{
    if (!_messageCountArray) {
        _messageCountArray = [NSMutableArray array];
    }
    return _messageCountArray;
}

- (NSMutableArray *)messageArray
{
    if (!_messageArray) {
        _messageArray = [NSMutableArray array];
    }
    return _messageArray;
}

#pragma mark - tabelView delegate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 82;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"message";
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageButton.userInteractionEnabled = NO;
    cell.timeButton.userInteractionEnabled = NO;
    
    MessagesModel *messageModel = self.messageArray[indexPath.row];
    
    //image
    cell.imageButton.layer.cornerRadius = 25;
    cell.imageButton.layer.masksToBounds = YES;
    if ([messageModel.relatype integerValue] == 10) {//保全
        [cell.imageButton setImage:[UIImage imageNamed:@"news_guarantee"] forState:0];
    }else if ([messageModel.relatype integerValue] == 20){//保函
        [cell.imageButton setImage:[UIImage imageNamed:@"news_letter"] forState:0];
    }else if ([messageModel.relatype integerValue] == 30){//产调
        [cell.imageButton setImage:[UIImage imageNamed:@"news_transfer"] forState:0];
    }else{
        NSString *imgString = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,messageModel.headimg.file];
        [cell.imageButton sd_setImageWithURL:[NSURL URLWithString:imgString] forState:0 placeholderImage:nil];
    }
    
    //count
    if ([messageModel.isRead intValue] > 0) {//有未读消息
        [cell.countLabel setHidden:NO];
        cell.countLabel.text = messageModel.isRead;
    }else{//无未读消息
        [cell.countLabel setHidden:YES];
    }
    
    //content
    cell.contentLabel.numberOfLines = 0;
    NSString *contentStr = [NSString stringWithFormat:@"%@\n%@",messageModel.relatitle,messageModel.content];
    NSMutableAttributedString *attributeContent = [[NSMutableAttributedString alloc] initWithString:contentStr];
    [attributeContent setAttributes:@{NSFontAttributeName:kBigFont,NSForegroundColorAttributeName:kBlackColor} range:NSMakeRange(0, messageModel.relatitle.length)];
    [attributeContent setAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(messageModel.relatitle.length+1, messageModel.content.length)];
    NSMutableParagraphStyle *stylee = [[NSMutableParagraphStyle alloc] init];
    [stylee setParagraphSpacing:kSpacePadding];
    [attributeContent addAttribute:NSParagraphStyleAttributeName value:stylee range:NSMakeRange(0, contentStr.length)];
    [cell.contentLabel setAttributedText:attributeContent];
    
    //time
    cell.timeButton.titleLabel.numberOfLines = 0;
    NSString *timeStr = [NSString stringWithFormat:@"%@\n%@",messageModel.title,messageModel.timeLabel];
    NSMutableAttributedString *attributeTime = [[NSMutableAttributedString alloc] initWithString:timeStr];
    [attributeTime setAttributes:@{NSFontAttributeName:kFourFont,NSForegroundColorAttributeName:kYellowColor} range:NSMakeRange(0, messageModel.title.length)];
    [attributeTime setAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(messageModel.title.length+1, messageModel.timeLabel.length)];
    NSMutableParagraphStyle *styleeq = [[NSMutableParagraphStyle alloc] init];
    [styleeq setParagraphSpacing:kSpacePadding];
    styleeq.alignment = 2;
    [attributeTime addAttribute:NSParagraphStyleAttributeName value:styleeq range:NSMakeRange(0, timeStr.length)];
    [cell.timeButton setAttributedTitle:attributeTime forState:0];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 82;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MessageSystemView *headrVew = [[MessageSystemView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 82)];
    
    
    MessageResponse *respondf;
    if (self.messageCountArray.count > 0) {
        respondf = self.messageCountArray[0];
        if ([respondf.systemCount integerValue] > 0) {
            [headrVew.countLabel setHidden:NO];
            headrVew.countLabel.text = respondf.systemCount;
        }else{
            [headrVew.countLabel setHidden:YES];
        }
    }
    
    QDFWeakSelf;
    [headrVew addAction:^(UIButton *btn) {
        SystemMessagesViewController *systemMessagesVC = [[SystemMessagesViewController alloc] init];
        systemMessagesVC.hidesBottomBarWhenPushed = YES;
        [weakself.navigationController pushViewController:systemMessagesVC animated:YES];
    }];
    
    return headrVew;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //1系统消息  10保全消息  20保函消息  30产调消息  40 发布消息  50接单消息
    MessagesModel *messageModel = self.messageArray[indexPath.row];
    if ([messageModel.relatype integerValue] == 10) {//保全
        PowerDetailsViewController *powerDetailsVC = [[PowerDetailsViewController alloc] init];
        powerDetailsVC.idString = messageModel.relaid;
        powerDetailsVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:powerDetailsVC animated:YES];
    }else if ([messageModel.relatype integerValue] == 20) {//保函消息
        ApplicationDetailsViewController *applicationDetailsVC = [[ApplicationDetailsViewController alloc] init];
        applicationDetailsVC.idString = messageModel.relaid;
        applicationDetailsVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:applicationDetailsVC animated:YES];
    }else if ([messageModel.relatype integerValue] == 30) {//产调消息
        HousePropertyListViewController *housePropertyListVC = [[HousePropertyListViewController alloc] init];
        [self.navigationController pushViewController:housePropertyListVC animated:YES];
    }else if ([messageModel.relatype integerValue] == 40) {
        MyReleaseDetailsViewController *myReleaseDetailsVC = [[MyReleaseDetailsViewController alloc] init];
        myReleaseDetailsVC.hidesBottomBarWhenPushed = YES;
        myReleaseDetailsVC.productid = messageModel.relaid;
        [self.navigationController pushViewController:myReleaseDetailsVC animated:YES];
    }else if ([messageModel.relatype integerValue] == 50) {
        MyOrderDetailViewController *myOrderDetailVC = [[MyOrderDetailViewController alloc] init];
        myOrderDetailVC.hidesBottomBarWhenPushed = YES;
        myOrderDetailVC.applyid = messageModel.relaid;
        [self.navigationController pushViewController:myOrderDetailVC animated:YES];
    }
}

#pragma mark - method
- (void)getMessageTypeAndNumber:(NSString *)page
{
    NSString *messageTypeString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMessageOfGroupString];
    
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"page" : page,
                             @"limit" : @"10"
                             };
    
    QDFWeakSelf;
    [self requestDataPostWithString:messageTypeString params:params successBlock:^(id responseObject) {
        
        if ([page integerValue] == 1) {
            [weakself.messageArray removeAllObjects];
        }
        
        MessageResponse *responde = [MessageResponse objectWithKeyValues:responseObject];
        
        [weakself.messageCountArray addObject:responde];
        
        for (MessagesModel *messagesModel in responde.data) {
            [weakself.messageArray addObject:messagesModel];
        }
        
        [weakself.messageTableView reloadData];
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)headerRefreshOfMessageGroup
{
    _pageMessage = 1;
    [self getMessageTypeAndNumber:@"1"];
    
    QDFWeakSelf;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakself.messageTableView headerEndRefreshing];
    });
}

- (void)footerRefreshOfMessageGroup
{
    _pageMessage++;
    NSString *page = [NSString stringWithFormat:@"%ld",(long)_pageMessage];
    [self getMessageTypeAndNumber:page];
    
    QDFWeakSelf;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakself.messageTableView footerEndRefreshing];
    });
}

- (void)readMessagesWithMessageModel:(MessagesModel *)messagesModel
{
    NSString *readString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMessageIsReadString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"id" : messagesModel.relaid};
    
    QDFWeakSelf;
    [self requestDataPostWithString:readString params:params successBlock:^(id responseObject) {
        BaseModel *baseModel = [BaseModel objectWithKeyValues:responseObject];
        if ([baseModel.code isEqualToString:@"0000"]) {
            
        }else{
            [weakself showHint:baseModel.msg];
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
