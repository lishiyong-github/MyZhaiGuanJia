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

#import "NewsCell.h"

#import "MessageResponse.h"
#import "MessageModel.h"
#import "CategoryModel.h"

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
        _sysMessageTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
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
    if (self.messageSysArray.count > 0) {
        MessageModel *model = self.messageSysArray[indexPath.section];
        
        CGSize titleSize = CGSizeMake(kScreenWidth - 55, MAXFLOAT);
        CGSize actualsize = [model.contents boundingRectWithSize:titleSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :kFirstFont} context:nil].size;
        
        return 40 + MAX(actualsize.height, 16);
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"newsList";
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectedBackgroundView = [[UIView alloc] init];
    cell.selectedBackgroundView.backgroundColor = UIColorFromRGB(0xdee8ed);
    
    MessageModel *model;
    if (self.messageSysArray.count > 0) {
        model = self.messageSysArray[indexPath.section];
    }
    
    if ([model.isRead integerValue] == 0) {//未读
        [cell.typeButton setImage:[UIImage imageNamed:@"tips"] forState:0];
        [cell.typeButton setTitle:model.title forState:0];
        [cell.typeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, kSmallPadding, 0, 0)];
    }else{//已读
        [cell.typeButton setImage:[UIImage imageNamed:@"q"] forState:0];
        [cell.typeButton setTitle:model.title forState:0];
        [cell.typeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    cell.timeLabel.text = [NSDate getYMDhmFormatterTime:model.create_time];
    cell.contextLabel.text = model.contents;
    
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
    if (self.messageSysArray.count > 0) {
        MessageModel *meModel = self.messageSysArray[indexPath.section];
            [self messageIsReadWithIdStr:meModel.idStr andType:meModel.type andModel:meModel.category_id];
    }
}

#pragma mark - method
- (void)getSystemMessageListWithPage:(NSString *)page
{
    NSString *mesString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMessageOfPublishString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"limit" : @"10",
                             @"page" : page,
                             @"type" : @"4"//发布1，接单2
                             };
    
    QDFWeakSelf;
    [self requestDataPostWithString:mesString params:params successBlock:^(id responseObject) {
        
        NSDictionary *spsps = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                
        if ([page integerValue] == 1) {
            [weakself.messageSysArray removeAllObjects];
        }
        
        MessageResponse *response = [MessageResponse objectWithKeyValues:responseObject];
        
        for (MessageModel *mesModel in response.message) {
            [weakself.messageSysArray addObject:mesModel];
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

#pragma mark - method
- (void)messageIsReadWithIdStr:(NSString *)idStr andType:(NSString *)typeStr andModel:(CategoryModel *)categoryModel
{
    NSString *isReadString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMessageIsReadString];
    NSDictionary *params = @{@"id" : idStr,
                             @"pid" : categoryModel.idString,
                             @"token" : [self getValidateToken]
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:isReadString params:params successBlock:^(id responseObject) {
        
        BaseModel *aModel = [BaseModel objectWithKeyValues:responseObject];
        if ([aModel.code isEqualToString:@"0000"]) {
            if ([typeStr integerValue] == 10) {//认证
                [weakself tokenIsValid];
                [weakself setDidTokenValid:^(TokenModel *tModel) {
                    NSString *categoryStr;
                    if ([tModel.state intValue] == 1 && [tModel.category intValue] == 1) {//个人
                        categoryStr = @"1";
                    }else if ([tModel.state intValue] == 1 && [tModel.category intValue] == 2){//律所
                        categoryStr = @"2";
                    }else if ([tModel.state intValue] == 1 && [tModel.category intValue] == 3){//公司
                        categoryStr = @"3";
                    }
                    CompleteViewController *completeVC = [[CompleteViewController alloc] init];
                    completeVC.hidesBottomBarWhenPushed = YES;
                    completeVC.categoryString = categoryStr;
                    [weakself.navigationController pushViewController:completeVC animated:YES];
                }];
            }else if([typeStr integerValue] == 21){//完善（融资清收诉讼）发布中
                MyPublishingViewController *myPublishVC = [[MyPublishingViewController alloc] init];
                myPublishVC.idString = categoryModel.idString;
                myPublishVC.categaryString = categoryModel.category;
                myPublishVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:myPublishVC animated:YES];
            }else{//代理人
                MyAgentListViewController *myAgentListVC = [[MyAgentListViewController alloc] init];
                myAgentListVC.hidesBottomBarWhenPushed = YES;
                myAgentListVC.typePid = @"本人";
                [weakself.navigationController pushViewController:myAgentListVC animated:YES];
            }
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
