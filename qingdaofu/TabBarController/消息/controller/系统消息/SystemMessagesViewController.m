//
//  SystemMessagesViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/6.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "SystemMessagesViewController.h"
#import "CompleteViewController.h"  //完成认证
#import "MyPublishingViewController.h"  //发布中
#import "MyAgentListViewController.h" //我的代理

#import "SystemMessageCell.h"


#import "MessageResponse.h"
#import "MessagesModel.h"

@interface SystemMessagesViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *sysMessageTableView;

//json
@property (nonatomic,assign) NSInteger pageSys;
@property (nonatomic,strong) NSMutableArray *messageSysArray;

@end

@implementation SystemMessagesViewController
- (void)viewWillAppear:(BOOL)animated
{
    [self headerRefreshWithMessageOfSystem];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"系统消息";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.sysMessageTableView];
    [self.view addSubview:self.baseRemindImageView];
    [self.baseRemindImageView setHidden:YES];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.sysMessageTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        [self.baseRemindImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [self.baseRemindImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)sysMessageTableView
{
    if (!_sysMessageTableView) {
        _sysMessageTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _sysMessageTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _sysMessageTableView.delegate = self;
        _sysMessageTableView.dataSource = self;
        _sysMessageTableView.backgroundColor = kBackColor;
        _sysMessageTableView.separatorColor = kSeparateColor;
        _sysMessageTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
        [_sysMessageTableView addHeaderWithTarget:self action:@selector(headerRefreshWithMessageOfSystem)];
        [_sysMessageTableView addFooterWithTarget:self action:@selector(footerRefreshWithMessageOfSystem)];
    }
    return _sysMessageTableView;
}

- (NSMutableArray *)messageSysArray
{
    if (!_messageSysArray) {
        _messageSysArray = [NSMutableArray array];
    }
    return _messageSysArray;
}

#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.messageSysArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"newsList";
    SystemMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[SystemMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    MessagesModel *messagesModel = self.messageSysArray[indexPath.section];
    
    cell.titleLabel.text = messagesModel.title;
    cell.timeLabel.text = [NSDate getMDhmFormatterTime:messagesModel.create_time];
    
    NSMutableAttributedString *attributeTT = [[NSMutableAttributedString alloc] initWithString:messagesModel.content];
    [attributeTT setAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(0, messagesModel.content.length)];
    NSMutableParagraphStyle *styped = [[NSMutableParagraphStyle alloc] init];
    [styped setLineSpacing:kSpacePadding];
    [attributeTT addAttribute:NSParagraphStyleAttributeName value:styped range:NSMakeRange(0, messagesModel.content.length)];
    [cell.contenLabel setAttributedText:attributeTT];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kBigPadding;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - method
- (void)getSystemMessageListWithPage:(NSString *)page
{
    NSString *mesString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMessageOfSystemString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"limit" : @"10",
                             @"page" : page,
                             @"type" : @"4"//发布1，接单2
                             };
    
    QDFWeakSelf;
    [self requestDataPostWithString:mesString params:params successBlock:^(id responseObject) {
        
        if ([page integerValue] == 1) {
            [weakself.messageSysArray removeAllObjects];
        }
        
        MessageResponse *responfg = [MessageResponse objectWithKeyValues:responseObject];
        
        for (MessagesModel *messageModel in responfg.data) {
            [weakself.messageSysArray addObject:messageModel];
        }

        if (weakself.messageSysArray.count > 0) {
            [weakself.baseRemindImageView setHidden:YES];
        }else{
            [weakself.baseRemindImageView setHidden:NO];
            _pageSys--;
        }
        
        [weakself.sysMessageTableView reloadData];
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)headerRefreshWithMessageOfSystem
{
    _pageSys = 1;
    [self getSystemMessageListWithPage:@"1"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.sysMessageTableView headerEndRefreshing];
    });
}

- (void)footerRefreshWithMessageOfSystem
{
    _pageSys++;
    NSString *page = [NSString stringWithFormat:@"%ld",(long)_pageSys];
    [self getSystemMessageListWithPage:page];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.sysMessageTableView footerEndRefreshing];
    });
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
