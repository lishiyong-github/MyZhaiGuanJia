//
//  ReceiveMessagesViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/6.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ReceiveMessagesViewController.h"
#import "MyApplyingViewController.h"  //我的接单－申请中
#import "MyProcessingViewController.h" //我的接单－处理中
#import "MyEndingViewController.h"  //我的接单－终止
#import "MyClosingViewController.h" //我的接单－结案
#import "MyPublishingViewController.h"//我的发布－发布中
#import "MyDealingViewController.h"//我的发布－处理中
#import "ReleaseEndViewController.h"//我的发布－终止
#import "ReleaseCloseViewController.h"//我的发布－结案

#import "ApplyRecordsViewController.h"  //申请记录
#import "PaceViewController.h"

#import "ProductsDetailsViewController.h" //产品详情
#import "MyDetailStoreViewController.h"  //我的收藏
#import "PaceViewController.h"

#import "NewsCell.h"

#import "MessageResponse.h"
#import "MessageModel.h"
#import "CategoryModel.h"

#import "UIImage+Color.h"

@interface ReceiveMessagesViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *receiveTableView;


@property (nonatomic,assign) NSInteger rePage;
@property (nonatomic,strong) NSMutableArray *messageReceiveArray;

@end

@implementation ReceiveMessagesViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:kBlackColor,NSFontAttributeName:kNavFont}];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:kNavColor] forBarMetrics:UIBarMetricsDefault];
    
    [self headerRefreshWithMessageOfOrder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"接单消息";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.receiveTableView];
    [self.view addSubview:self.baseRemindImageView];
    [self.baseRemindImageView setHidden:YES];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.receiveTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        [self.baseRemindImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [self.baseRemindImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)receiveTableView
{
    if (!_receiveTableView) {
        _receiveTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _receiveTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        _receiveTableView.delegate = self;
        _receiveTableView.dataSource = self;
        _receiveTableView.backgroundColor = kBackColor;
        _receiveTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
        [_receiveTableView addHeaderWithTarget:self action:@selector(headerRefreshWithMessageOfOrder)];
        [_receiveTableView addFooterWithTarget:self action:@selector(footerRefreshWithMessageOfOrder)];
    }
    return _receiveTableView;
}

- (NSMutableArray *)messageReceiveArray
{
    if (!_messageReceiveArray) {
        _messageReceiveArray = [NSMutableArray array];
    }
    return _messageReceiveArray;
}

#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.messageReceiveArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.messageReceiveArray.count > 0) {
        MessageModel *model = self.messageReceiveArray[indexPath.section];
        
        CGSize titleSize = CGSizeMake(kScreenWidth - 60, MAXFLOAT);
        CGSize actualsize = [model.content boundingRectWithSize:titleSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :kFirstFont} context:nil].size;
        
        return 45 + MAX(actualsize.height, 30);
//        CGSize titleSize = CGSizeMake(kScreenWidth - 175, MAXFLOAT);
//        CGSize  actualsize =[wtwt boundingRectWithSize:titleSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :kFirstFont} context:nil].size;
        
//        return 105 + MAX(actualsize.height, 16);
        
    }
//    return 75;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"reNewsList";
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectedBackgroundView = [[UIView alloc] init];
    cell.selectedBackgroundView.backgroundColor = UIColorFromRGB(0xdee8ed);
    
    MessageModel *model;
    if (self.messageReceiveArray.count > 0) {
        model = self.messageReceiveArray[indexPath.section];
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
    cell.contextLabel.text = model.content;
    
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
    if (self.messageReceiveArray.count > 0) {
        MessageModel *meModel = self.messageReceiveArray[indexPath.section];
        [self messageIsReadWithMessageModel:meModel];
    }
}

#pragma mark - method
- (void)getOrderMessageListWithPage:(NSString *)page
{
    NSString *mesString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMessageOfPublishString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"limit" : @"10",
                             @"page" : page,
                             @"type" : @"2"//发布1，接单2
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:mesString params:params successBlock:^(id responseObject) {
        
        if ([page integerValue] == 1) {
            [weakself.messageReceiveArray removeAllObjects];
        }
        
        MessageResponse *response = [MessageResponse objectWithKeyValues:responseObject];
        
        for (MessageModel *mesModel in response.message) {
            [weakself.messageReceiveArray addObject:mesModel];
        }
        
        if (weakself.messageReceiveArray.count > 0) {
            [weakself.baseRemindImageView setHidden:YES];
        }else{
            [weakself.baseRemindImageView setHidden:NO];
            _rePage--;
        }
        
        [weakself.receiveTableView reloadData];
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)headerRefreshWithMessageOfOrder
{
    _rePage = 1;
    [self getOrderMessageListWithPage:@"1"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.receiveTableView headerEndRefreshing];
    });
}

- (void)footerRefreshWithMessageOfOrder
{
    _rePage++;
    NSString *page = [NSString stringWithFormat:@"%ld",(long)_rePage];
    [self getOrderMessageListWithPage:page];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.receiveTableView footerEndRefreshing];
    });
}

#pragma mark - method
- (void)messageIsReadWithMessageModel:(MessageModel *)messageModel
{
    NSString *isReadString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMessageIsReadString];
    NSDictionary *params = @{@"id" : messageModel.idStr,
                             @"token" : [self getValidateToken]
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:isReadString params:params successBlock:^(id responseObject) {
        BaseModel *aModel = [BaseModel objectWithKeyValues:responseObject];
        if ([aModel.code isEqualToString:@"0000"]){
            if ([messageModel.progress_status integerValue] == 1) {//申请中
                if (!messageModel.app_id || [messageModel.app_id isEqualToString:@""] || [messageModel.app_id isEqualToString:@"<null>"] || [messageModel.app_id isEqualToString:@"(null)"]){
                    ProductsDetailsViewController *productsDetailsVC = [[ProductsDetailsViewController alloc] init];
                    productsDetailsVC.idString = messageModel.category_id.idString;
                    productsDetailsVC.categoryString = messageModel.category_id.category;
                    [weakself.navigationController pushViewController:productsDetailsVC animated:YES];
                }else{
                    if ([messageModel.app_id integerValue] == 0) {//申请中
                        if ([messageModel.fuid isEqualToString:messageModel.belonguid]) {//发布方
                            ApplyRecordsViewController *applyRecordsVC = [[ApplyRecordsViewController alloc] init];
                            applyRecordsVC.idStr = messageModel.category_id.idString;
                            applyRecordsVC.categaryStr = messageModel.category_id.category;
                            [weakself.navigationController pushViewController:applyRecordsVC animated:YES];
                        }else{
                            MyApplyingViewController *myApplyVC = [[MyApplyingViewController alloc] init];
                            myApplyVC.idString = messageModel.category_id.idString;
                            myApplyVC.categaryString = messageModel.category_id.category;
                            myApplyVC.pidString = messageModel.uidInner;
                            [weakself.navigationController pushViewController:myApplyVC animated:YES];
                        }
                    }else if ([messageModel.app_id integerValue] == 2){//收藏
                        ProductsDetailsViewController *productsDetailsVC = [[ProductsDetailsViewController alloc] init];
                        productsDetailsVC.idString = messageModel.category_id.idString;
                        productsDetailsVC.categoryString = messageModel.category_id.category;
                        [weakself.navigationController pushViewController:productsDetailsVC animated:YES];
                    }
                }
            }else if ([messageModel.progress_status integerValue] == 2){//处理中
                if ([messageModel.fuid isEqualToString:messageModel.belonguid]) {//发布
                    if ([messageModel.type integerValue] == 14) {//进度列表
                        PaceViewController *paceVC = [[PaceViewController alloc] init];
                        paceVC.idString = messageModel.category_id.idString;
                        paceVC.categoryString = messageModel.category_id.category;
                        [weakself.navigationController pushViewController:paceVC animated:YES];
                    }else if ([messageModel.type integerValue] == 19){//申请延期
                        
                    }else{
                        MyDealingViewController *myDealingVC = [[MyDealingViewController alloc] init];
                        myDealingVC.idString = messageModel.category_id.idString;
                        myDealingVC.categaryString = messageModel.category_id.category;
                        myDealingVC.pidString = messageModel.uidInner;
                        [weakself.navigationController pushViewController:myDealingVC animated:YES];
                    }
                }else{
                    MyProcessingViewController *myProcessingVC = [[MyProcessingViewController alloc] init];
                    myProcessingVC.idString = messageModel.category_id.idString;
                    myProcessingVC.categaryString = messageModel.category_id.category;
                    myProcessingVC.pidString = messageModel.uidInner;
                    [weakself.navigationController pushViewController:myProcessingVC animated:YES];
                }
            }else if ([messageModel.progress_status integerValue] == 3){//终止
                if ([messageModel.fuid isEqualToString:messageModel.belonguid]) {
                    ReleaseEndViewController *releaseEndVC = [[ReleaseEndViewController alloc] init];
                    releaseEndVC.idString = messageModel.category_id.idString;
                    releaseEndVC.categaryString = messageModel.category_id.category;
                    releaseEndVC.pidString = messageModel.uidInner;
                    [weakself.navigationController pushViewController:releaseEndVC animated:YES];
                }else{
                    MyEndingViewController *myEndingVC = [[MyEndingViewController alloc] init];
                    myEndingVC.idString = messageModel.category_id.idString;
                    myEndingVC.categaryString = messageModel.category_id.category;
                    myEndingVC.pidString = messageModel.uidInner;
                    [weakself.navigationController pushViewController:myEndingVC animated:YES];
                }
            }else if ([messageModel.progress_status integerValue] == 4){//结案
                if ([messageModel.fuid isEqualToString:messageModel.belonguid]) {
                    ReleaseCloseViewController *releaseCloseVC = [[ReleaseCloseViewController alloc] init];
                    releaseCloseVC.idString = messageModel.category_id.idString;
                    releaseCloseVC.categaryString = messageModel.category_id.category;
                    releaseCloseVC.pidString = messageModel.uidInner;
                    releaseCloseVC.evaString = messageModel.frequency;
                    [weakself.navigationController pushViewController:releaseCloseVC animated:YES];
                }else{
                    MyClosingViewController  *myClosingVC = [[MyClosingViewController alloc] init];
                    myClosingVC.idString = messageModel.category_id.idString;
                    myClosingVC.categaryString = messageModel.category_id.category;
                    myClosingVC.pidString = messageModel.uidInner;
                    myClosingVC.evaString = messageModel.frequency;
                    [weakself.navigationController pushViewController:myClosingVC animated:YES];
                }
            }
        }
        
    } andFailBlock:^(NSError *error) {
        
    }];
    
}

/*
- (void)messageIsReadWithIdStr:(NSString *)idStr andTypeString:(NSString *)typeStr andContent:(NSString *)content andModel:(CategoryModel *)categoryModel
{
    NSString *isReadString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMessageIsReadString];
    NSDictionary *params = @{@"id" : idStr,
                             @"token" : [self getValidateToken]
                             };
    
    QDFWeakSelf;
    [self requestDataPostWithString:isReadString params:params successBlock:^(id responseObject) {
        BaseModel *aModel = [BaseModel objectWithKeyValues:responseObject];
        if ([aModel.code isEqualToString:@"0000"]) {
            
            if ([content isEqualToString:@"申请接单"]) {//申请接单
                MyApplyingViewController *myApplyVC = [[MyApplyingViewController alloc] init];
                myApplyVC.idString = categoryModel.idString;
                myApplyVC.categaryString = categoryModel.category;
                [weakself.navigationController pushViewController:myApplyVC animated:YES];
            }else if([content isEqualToString:@"有新进度"]){
                
                PaceViewController *paceVC = [[PaceViewController alloc] init];
                paceVC.categoryString = categoryModel.category;
                paceVC.idString = categoryModel.idString;
                paceVC.hidesBottomBarWhenPushed = YES;
                [weakself.navigationController pushViewController:paceVC animated:YES];
                
//                MyProcessingViewController *myProcessingVC = [[MyProcessingViewController alloc] init];
//                myProcessingVC.idString = categoryModel.idString;
//                myProcessingVC.categaryString = categoryModel.category;
//                [weakself.navigationController pushViewController:myProcessingVC animated:YES];
            }else if([content isEqualToString:@"发布方已同意结案"]){
                MyClosingViewController *myClosingVC = [[MyClosingViewController alloc] init];
                myClosingVC.idString = .idString;
                myClosingVC.categaryString = categoryModel.category;
                [weakself.navigationController pushViewController:myClosingVC animated:YES];
            }
            
        }
        
    } andFailBlock:^(NSError *error) {
        
    }];
}
 */

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
