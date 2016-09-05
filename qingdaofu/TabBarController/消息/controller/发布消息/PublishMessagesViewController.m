//
//  PublishMessagesViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/6.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "PublishMessagesViewController.h"
#import "MyPublishingViewController.h"  //我的发布－发布中
#import "MyDealingViewController.h"  //我的发布－处理中
#import "ReleaseEndViewController.h"  //我的发布－终止
#import "ReleaseCloseViewController.h"  //我的发布－结案
#import "MyDetailSaveViewController.h" //我的保存 －详情


#import "NewsCell.h"

#import "MessageResponse.h"
#import "MessageModel.h"
#import "CategoryModel.h"

@interface PublishMessagesViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraits;
@property (nonatomic,strong) UITableView *newsListTableView;

@property (nonatomic,assign) NSInteger mesPage;
@property (nonatomic,strong) NSMutableArray *messagePubArray;

@end

@implementation PublishMessagesViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self headerRefreshWithMessageOfPublish];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发布消息";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.newsListTableView];
    [self.view addSubview:self.baseRemindImageView];
    [self.baseRemindImageView setHidden:YES];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraits) {
        
        [self.newsListTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        [self.baseRemindImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [self.baseRemindImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        
        self.didSetupConstraits = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)newsListTableView
{
    if (!_newsListTableView) {
        _newsListTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _newsListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        _newsListTableView.delegate = self;
        _newsListTableView.dataSource = self;
        _newsListTableView.backgroundColor = kBackColor;
        _newsListTableView.separatorColor = kSeparateColor;
        _newsListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
        [_newsListTableView addHeaderWithTarget:self action:@selector(headerRefreshWithMessageOfPublish)];
        [_newsListTableView addFooterWithTarget:self action:@selector(footerRefreshWithMessageOfPublish)];
    }
    return _newsListTableView;
}

- (NSMutableArray *)messagePubArray
{
    if (!_messagePubArray) {
        _messagePubArray = [NSMutableArray array];
    }
    return _messagePubArray;
}

#pragma mark - delegate datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.messagePubArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.messagePubArray.count > 0) {
        MessageModel *model = self.messagePubArray[indexPath.section];
        
        CGSize titleSize = CGSizeMake(kScreenWidth - 55, MAXFLOAT);
        CGSize actualsize = [model.contents boundingRectWithSize:titleSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :kFirstFont} context:nil].size;
        
        return 40 + MAX(actualsize.height, 16);
    }
    return 0;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"pubNewsList";
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectedBackgroundView = [[UIView alloc] init];
    cell.selectedBackgroundView.backgroundColor = UIColorFromRGB(0xdee8ed);
    
    MessageModel *model;
    if (self.messagePubArray.count > 0) {
        model = self.messagePubArray[indexPath.section];
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
    
//    [cell.typeButton setTitle:@"申请消息" forState:0];
//    cell.timeLabel.text = @"2016-12-12 10:10";
//    cell.contextLabel.text = @"您发布的融资RZ201601010001有心得申请记录";
    
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
    
    if (self.messagePubArray.count > 0) {
        MessageModel *meModel = self.messagePubArray[indexPath.section];
        if ([meModel.type isEqualToString:@"2"] || [meModel.type isEqualToString:@"16"]) {//发布中
            [self messageIsReadWithMessagesModel:meModel];
        }
    }
}

#pragma mark - method
- (void)getPublishMessageListWithPage:(NSString *)page
{
    NSString *mesString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMessageOfPublishString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"limit" : @"10",
                             @"page" : page,
                             @"type" : @"1"//发布1，接单2
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:mesString params:params successBlock:^(id responseObject) {
        
        NSDictionary *sisis = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([page integerValue] == 1) {
            [weakself.messagePubArray removeAllObjects];
        }
        
        MessageResponse *response = [MessageResponse objectWithKeyValues:responseObject];
        for (MessageModel *mesModel in response.message) {
            [weakself.messagePubArray addObject:mesModel];
        }
        
        if (weakself.messagePubArray.count > 0) {
            [weakself.baseRemindImageView setHidden:YES];
        }else{
            [weakself.baseRemindImageView setHidden:NO];
            _mesPage--;
        }
        
        [weakself.newsListTableView reloadData];
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)headerRefreshWithMessageOfPublish
{
    _mesPage = 1;
    [self getPublishMessageListWithPage:@"1"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.newsListTableView headerEndRefreshing];
    });
}

- (void)footerRefreshWithMessageOfPublish
{
    _mesPage++;
    NSString *page = [NSString stringWithFormat:@"%ld",(long)_mesPage];
    [self getPublishMessageListWithPage:page];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.newsListTableView footerEndRefreshing];
    });
}

#pragma mark - read
- (void)messageIsReadWithMessagesModel:(MessageModel *)model
{
    NSString *isReadString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMessageIsReadString];
    NSDictionary *params = @{@"id" : model.idStr,
                             @"pid" : model.category_id.idString,
                             @"token" : [self getValidateToken]
                             };
    [self requestDataPostWithString:isReadString params:params successBlock:^(id responseObject) {
        BaseModel *aModel = [BaseModel objectWithKeyValues:responseObject];
        if ([aModel.code isEqualToString:@"0000"]) {
            if ([model.progress_status integerValue] == 1) {
                MyPublishingViewController *myPublishingVC = [[MyPublishingViewController alloc] init];
                myPublishingVC.idString = model.category_id.idString;
                myPublishingVC.categaryString = model.category_id.category;
                [self.navigationController pushViewController:myPublishingVC animated:YES];
            }else if ([model.progress_status integerValue] == 2){
                MyDealingViewController *myDealingVC = [[MyDealingViewController alloc] init];
                myDealingVC.idString = model.category_id.idString;
                myDealingVC.categaryString = model.category_id.category;
                myDealingVC.pidString = model.uidInner;
                [self.navigationController pushViewController:myDealingVC animated:YES];
            }else if ([model.progress_status integerValue] == 3){
                ReleaseEndViewController *releaseEndVC = [[ReleaseEndViewController alloc] init];
                releaseEndVC.idString = model.category_id.idString;
                releaseEndVC.categaryString = model.category_id.category;
                releaseEndVC.pidString = model.uidInner;
                [self.navigationController pushViewController:releaseEndVC animated:YES];
            }else if ([model.progress_status integerValue] == 4){
                ReleaseCloseViewController *releaseCloseVC = [[ReleaseCloseViewController alloc] init];
                releaseCloseVC.idString = model.category_id.idString;
                releaseCloseVC.categaryString = model.category_id.category;
                releaseCloseVC.pidString = model.uidInner;
                releaseCloseVC.evaString = model.frequency;
                [self.navigationController pushViewController:releaseCloseVC animated:YES];
            }else if ([model.progress_status integerValue] == 0){
                MyDetailSaveViewController *mydetailSaveVC = [[MyDetailSaveViewController alloc] init];
                mydetailSaveVC.idString = model.category_id.idString;
                mydetailSaveVC.categaryString = model.category_id.category;
                [self.navigationController pushViewController:mydetailSaveVC animated:YES];
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
