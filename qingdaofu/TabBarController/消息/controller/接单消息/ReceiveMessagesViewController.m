//
//  ReceiveMessagesViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/6.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ReceiveMessagesViewController.h"
#import "MyApplyingViewController.h"  //我的接单－申请中

#import "NewsCell.h"

#import "MessageResponse.h"
#import "MessageModel.h"
#import "CategoryModel.h"

@interface ReceiveMessagesViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *receiveTableView;


@property (nonatomic,assign) NSInteger rePage;
@property (nonatomic,strong) NSMutableArray *messageReceiveArray;

@end

@implementation ReceiveMessagesViewController

- (void)viewWillAppear:(BOOL)animated
{
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
    return 75;
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
        //接单的申请中---7接单申请中详情，89产品详情， 11(发布方结案) 12（接单方结案） 16
        [self messageIsReadWithIdStr:meModel.idStr andTypeString:meModel.type andModel:meModel.category_id];
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
    [self requestDataPostWithString:mesString params:params successBlock:^(id responseObject) {
        NSDictionary *dddd = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"^^^^^^^ %@",dddd);
        
        if ([page integerValue] == 0) {
            [self.messageReceiveArray removeAllObjects];
        }
        
        MessageResponse *response = [MessageResponse objectWithKeyValues:responseObject];
        
        for (MessageModel *mesModel in response.message) {
            [self.messageReceiveArray addObject:mesModel];
        }
        
        if (self.messageReceiveArray.count > 0) {
            [self.baseRemindImageView setHidden:YES];
        }else{
            [self.baseRemindImageView setHidden:NO];
            _rePage--;
        }
        
        [self.receiveTableView reloadData];
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)headerRefreshWithMessageOfOrder
{
    [self getOrderMessageListWithPage:@"0"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.receiveTableView headerEndRefreshing];
    });
}

- (void)footerRefreshWithMessageOfOrder
{
    _rePage++;
    NSString *page = [NSString stringWithFormat:@"%d",_rePage];
    [self getOrderMessageListWithPage:page];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.receiveTableView footerEndRefreshing];
    });
}

- (void)messageIsReadWithIdStr:(NSString *)idStr andTypeString:(NSString *)typeStr andModel:(CategoryModel *)categoryModel
{
    NSString *isReadString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMessageIsReadString];
    NSDictionary *params = @{@"id" : idStr,
                             @"token" : [self getValidateToken]
                             };
    [self requestDataPostWithString:isReadString params:params successBlock:^(id responseObject) {
        BaseModel *aModel = [BaseModel objectWithKeyValues:responseObject];
        if ([aModel.code isEqualToString:@"0000"]) {
            MyApplyingViewController *myApplyVC = [[MyApplyingViewController alloc] init];
            myApplyVC.idString = categoryModel.idString;
            myApplyVC.categaryString = categoryModel.category;
            [self.navigationController pushViewController:myApplyVC animated:YES];
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
