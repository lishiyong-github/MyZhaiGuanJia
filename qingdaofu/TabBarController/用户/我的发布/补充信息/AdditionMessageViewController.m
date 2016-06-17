//
//  AdditionMessageViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/5.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "AdditionMessageViewController.h"

#import "MineUserCell.h"

#import "PublishingResponse.h"
#import "PublishingModel.h"

@interface AdditionMessageViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *addMessageTableView;
@property (nonatomic,strong) NSMutableArray *addMessageDataArray;

@end

@implementation AdditionMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"补充信息";
    self.navigationItem.leftBarButtonItem = self.leftItem;
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveMessage)];
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
    
    PublishingResponse *resonse = self.addMessageDataArray[0];
    PublishingModel *messageModel = resonse.product;
    
    if ([messageModel.category intValue] == 1) {//融资
        NSString *rateCatStr; //借款期限类型
        NSString *term = messageModel.term?messageModel.term:@"无";   //借款期限
        NSString *mortgagecategory = @"无";//抵押物类型
        NSString *status = @"无";  //抵押物状态
        NSString *rentmoney = messageModel.rentmoney?messageModel.rentmoney:@"无"; //租金
        NSString *mortgagearea = messageModel.mortgagearea?messageModel.mortgagearea:@"无";  //抵押物面积
        NSString *loanyear = messageModel.loanyear?messageModel.loanyear:@"无";   //借款人年龄
        NSString *obligeeyear = @"无";  //权利人年龄
        
        if ([messageModel.rate_cat intValue] == 1) {
            rateCatStr = @"天";
        }else if ([messageModel.rate_cat intValue] == 2){
            rateCatStr = @"月";
        }
        
        if (messageModel.mortgagecategory) {
            if ([messageModel.mortgagecategory intValue] == 1) {
                mortgagecategory = @"住宅";
            }else if ([messageModel.mortgagecategory intValue] == 2){
                mortgagecategory = @"商户";
            }else{
                mortgagecategory = @"办公楼";
            }
        }
        if (messageModel.status) {
            if ([messageModel.status intValue] == 2){
                status = @"自住";
            }else{
                status = @"出租";
            }
        }
        if (messageModel.obligeeyear) {
            if ([messageModel.obligeeyear intValue] == 1) {
                obligeeyear = @"65岁以上";
            }else{
                obligeeyear = @"65岁以下";
            }
        }
        
        NSArray *dataList1 = @[@"借款期限",@"借款期限类型",@"抵押物类型",@"抵押物状态",@"租金",@"抵押物面积",@"借款人年龄",@"权利人年龄"];
        NSArray *dataList2 = @[term,rateCatStr,mortgagecategory,status,rentmoney,mortgagearea,loanyear,obligeeyear];
        [cell.userNameButton setTitle:dataList1[indexPath.row] forState:0];
        [cell.userActionButton setTitle:dataList2[indexPath.row] forState:0];
        
    }else{//催收，诉讼
        
        NSString *rate = messageModel.rate?messageModel.rate:@"无"; //借款利率
        NSString *rate_cat = @"无"; //借款期限类型
        NSString *term = messageModel.term?messageModel.term:@"无";   //借款期限
        NSString *repaymethod = @"无";//还款方式
        NSString *obligor = @"无";  //债务人主体
        NSString *commitment = @"无";  //委托事项
        NSString *commissionperiod = messageModel.commissionperiod?messageModel.commissionperiod:@"无";   //委托代理期限
        NSString *paidmoney = messageModel.paidmoney?messageModel.paidmoney:@"无";  //已付本金
        NSString *interestpaid = messageModel.interestpaid?messageModel.interestpaid:@"无";  //已付利息
        NSString *performancecontract = messageModel.performancecontract?messageModel.performancecontract:@"无";  //合同履行地
        NSString *creditorfile = messageModel.creditorfile?messageModel.creditorfile:@"无";  //债权文件
        NSString *creditorinfo = messageModel.creditorinfo?messageModel.creditorinfo:@"无";  //债权人信息
        NSString *borrowinginfo = messageModel.borrowinginfo?messageModel.borrowinginfo:@"无";  //债务人信息
        
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
            }else{
                repaymethod = @"按月付息，到期还本";
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
        if (messageModel.commitment) {
            if ([messageModel.commitment intValue] == 1) {
                commitment = @"代理诉讼";
            }else if([messageModel.commitment intValue] == 2){
                commitment = @"代理仲裁";
            }else{
                commitment = @"代理执行";
            }
        }
        
        NSArray *dataList1 = @[@"借款利率(%)",@"借款利率类型",@"借款期限",@"借款期限类型",@"还款方式",@"债务人主体",@"委托事项",@"委托代理期限(月)",@"已付本金",@"已付利息",@"合同履行地",@"债权文件",@"债权人信息",@"债务人信息"];
        NSArray *dataList2 = @[rate,rate_cat,term,rate_cat,repaymethod,obligor,commitment,commissionperiod,paidmoney,interestpaid,performancecontract,creditorfile,creditorinfo,borrowinginfo];
        [cell.userNameButton setTitle:dataList1[indexPath.row] forState:0];
        [cell.userActionButton setTitle:dataList2[indexPath.row] forState:0];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - method
- (void)saveMessage
{
    
}

- (void)getAdditionalMessages
{
    NSString *messageString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyReleaseDetailString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"id" : self.idString,
                             @"category" : self.categoryString
                             };
    [self requestDataPostWithString:messageString params:params successBlock:^(id responseObject){
        PublishingResponse *response = [PublishingResponse objectWithKeyValues:responseObject];
        
        [self.addMessageDataArray addObject:response];
        [self.addMessageTableView reloadData];
        
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
