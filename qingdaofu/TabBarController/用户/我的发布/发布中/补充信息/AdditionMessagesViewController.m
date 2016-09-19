//
//  AdditionMessagesViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/9/2.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "AdditionMessagesViewController.h"

#import "ProductsCheckDetailViewController.h"   //债权人信息，债务人信息
#import "ProductsCheckFilesViewController.h"  //债权文件

#import "MineUserCell.h"

#import "PublishingResponse.h"
#import "PublishingModel.h"

#import "DebtModel.h"


@interface AdditionMessagesViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *addMessageTableView;
@property (nonatomic,strong) NSMutableArray *addMessageDataArray;

@end

@implementation AdditionMessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"补充信息";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kBlueColor} forState:0];
    
    [self.view addSubview:self.addMessageTableView];
    [self.view setNeedsUpdateConstraints];
    
    [self getAdditionalMessages];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.addMessageTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)addMessageTableView
{
    if (!_addMessageTableView) {
        _addMessageTableView = [UITableView newAutoLayoutView];
        _addMessageTableView.backgroundColor = kBackColor;
        _addMessageTableView.delegate = self;
        _addMessageTableView.dataSource = self;
        _addMessageTableView.separatorColor = kSeparateColor;
        _addMessageTableView.tableFooterView = [[UIView alloc] init];
        _addMessageTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
    }
    return _addMessageTableView;
}

- (NSMutableArray *)addMessageDataArray
{
    if (!_addMessageDataArray) {
        _addMessageDataArray = [NSMutableArray array];
    }
    return _addMessageDataArray;
}

#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.addMessageDataArray.count > 0) {
        if ([self.categoryString intValue] == 1) {
            return 8;
        }
        return 14;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"messages";
    MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    PublishingResponse *messageResonse = self.addMessageDataArray[0];
    PublishingModel *messageModel = messageResonse.product;
        
    NSString *rate = [NSString getValidStringFromString:messageModel.rate]; //借款利率
    NSString *rate_cat = @"暂无"; //借款期限类型
    NSString *term = [NSString getValidStringFromString:messageModel.term];   //借款期限
    NSString *repaymethod = @"暂无";//还款方式
    NSString *obligor = @"暂无";  //债务人主体
    NSString *start = @"暂无"; //逾期日期
//    NSString *commitment = @"暂无";  //委托事项
    NSString *commissionperiod = [NSString getValidStringFromString:messageModel.commissionperiod];   //委托代理期限
    NSString *paidmoney = [NSString getValidStringFromString:messageModel.paidmoney];  //已付本金
    NSString *interestpaid = [NSString getValidStringFromString:messageModel.interestpaid];  //已付利息
    NSString *performancecontract = [NSString getValidStringFromString:messageModel.performancecontract];  //合同履行地
    
    if (messageModel.rate_cat) {
        if ([messageModel.rate_cat intValue] == 1) {
            rate_cat = @"天";
        }else{
            rate_cat = @"月";
        }
    }
    
    if (messageModel.repaymethod) {
        if ([messageModel.repaymethod intValue] == 1) {
            repaymethod = @"一次性到期还本付息";
        }else if([messageModel.repaymethod intValue] == 2){
            repaymethod = @"按月付息，到期还本";
        }else{
            repaymethod = @"其他";
        }
    }
    if (messageModel.obligor) {
        if ([messageModel.obligor intValue] == 1) {
            obligor = @"自然人";
        }else if([messageModel.obligor intValue] == 2){
            obligor = @"法人";
        }else{
            obligor = @"其他";
        }
    }
    
    if (messageModel.start) {
        start = [NSDate getMDhmFormatterTime:messageModel.start];
    }
    
    PublishingResponse *meResponse;
    if (self.addMessageDataArray.count > 0) {
        meResponse = self.addMessageDataArray[0];
    }
    
    NSString *creditorfile = @"查看";
    
    NSString *creditorinfo;//债权人信息
    if (meResponse.creditorinfos.count > 0) {
        creditorinfo = @"查看";
    }else{
        creditorinfo = @"暂无";
    }
    
    NSString *borrowinginfo;
    if (meResponse.borrowinginfos.count > 0) {//债务人信息
        borrowinginfo = @"查看";
    }else{
        borrowinginfo = @"暂无";
    }
    
    NSArray *dataList1 = @[@"借款利率(%)",@"借款利率类型",@"借款期限",@"借款期限类型",@"还款方式",@"债务人主体",@"逾期日期",@"委托代理期限(月)",@"已付本金(元)",@"已付利息(元)",@"合同履行地",@"债权文件",@"债权人信息",@"债务人信息"];
    NSArray *dataList2 = @[rate,rate_cat,term,rate_cat,repaymethod,obligor,start,commissionperiod,paidmoney,interestpaid,performancecontract,creditorfile,creditorinfo,borrowinginfo];
    [cell.userNameButton setTitle:dataList1[indexPath.row] forState:0];
    [cell.userActionButton setTitle:dataList2[indexPath.row] forState:0];
    cell.userActionButton.userInteractionEnabled = NO;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PublishingResponse *response;
    if (self.addMessageDataArray.count > 0) {
        response = self.addMessageDataArray[0];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 11) {//债权人件
        ProductsCheckFilesViewController *productsCheckFilesVC = [[ProductsCheckFilesViewController alloc] init];
        productsCheckFilesVC.fileResponse = response;
        [self.navigationController pushViewController:productsCheckFilesVC animated:YES];
        
    }else if (indexPath.row == 12){//债权人信息
        if (response.creditorinfos.count > 0) {
            ProductsCheckDetailViewController *productsCheckDetailVC = [[ProductsCheckDetailViewController alloc] init];
            productsCheckDetailVC.categoryString = @"1";
            productsCheckDetailVC.listArray = response.creditorinfos;
            [self.navigationController pushViewController:productsCheckDetailVC animated:YES];
        }
    }else if (indexPath.row == 13){//债务人信息
        if (response.borrowinginfos.count > 0) {
            ProductsCheckDetailViewController *productsCheckDetailVC = [[ProductsCheckDetailViewController alloc] init];
            productsCheckDetailVC.categoryString = @"2";
            productsCheckDetailVC.listArray = response.borrowinginfos;
            [self.navigationController pushViewController:productsCheckDetailVC animated:YES];
        }
    }
}

#pragma mark - method
- (void)getAdditionalMessages
{
    NSString *messageString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kProdutsDetailString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"id" : self.idString,
                             @"category" : self.categoryString
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:messageString params:params successBlock:^(id responseObject){
        
        PublishingResponse *response = [PublishingResponse objectWithKeyValues:responseObject];
        
        [weakself.addMessageDataArray addObject:response];
        [weakself.addMessageTableView reloadData];
        
    } andFailBlock:^(NSError *error){
        
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
