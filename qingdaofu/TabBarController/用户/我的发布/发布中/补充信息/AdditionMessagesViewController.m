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
        PublishingResponse *responrf = self.addMessageDataArray[0];
        if ([responrf.product.loan_type integerValue] == 4) {//1,2,3,4
            return 12+4;
        }else{
            return 12+5;
        }
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
    cell.userNameButton.titleLabel.font = kFirstFont;
    [cell.userNameButton setTitleColor:kLightGrayColor forState:0];
    cell.userActionButton.titleLabel.font = kBigFont;
    [cell.userActionButton setTitleColor:kGrayColor forState:0];
    
    PublishingResponse *messageResonse = self.addMessageDataArray[0];
    PublishingModel *messageModel = messageResonse.product;
    //金额
    NSString *money = [NSString stringWithFormat:@"%@万",[NSString getValidStringFromString:messageModel.money]];
    //代理费用
    NSString *agencycommission;
    NSArray *agencyArr1;
    //代理费用类型
    NSString *agencycommissiontype;
    NSArray *agencyArr2;
    if ([messageModel.category integerValue] == 2) {//清收
        agencyArr1 = @[@"%",@"万"];
        agencyArr2 = @[@"服务佣金",@"固定费用"];
    }else if ([messageModel.category integerValue] == 3){
        agencyArr1 = @[@"万",@"%"];
        agencyArr2 = @[@"固定费用",@"代理费率"];
    }
    agencycommission = [NSString stringWithFormat:@"%@%@",[NSString getValidStringFromString:messageModel.agencycommission],agencyArr1[[messageModel.agencycommissiontype integerValue] -1]];
    agencycommissiontype = agencyArr2[[messageModel.agencycommissiontype integerValue] -1];
    
    //债权类型
    NSString *loanType;
    NSString *loanString;
    if ([messageModel.loan_type integerValue] == 1) {
        loanType = @"房产抵押";
        loanString = messageModel.seatmortgage;
    }else if ([messageModel.loan_type integerValue] == 2){
        loanType = @"应收账款";
        loanString = [NSString stringWithFormat:@"%@元",messageModel.accountr];
    }else if ([messageModel.loan_type integerValue] == 3){
        loanType = @"机动车抵押";
        loanString = [NSString stringWithFormat:@"%@",messageResonse.car];
    }else if ([messageModel.loan_type integerValue] == 4){
        loanType = @"无抵押";
    }
    
    NSString *rate = [NSString getValidStringFromString:messageModel.rate]; //借款利率
    if (![rate isEqualToString:@"暂无"]) {
        rate = [NSString stringWithFormat:@"%@%@/月",messageModel.rate,@"%"];
    }
    
    NSString *term = [NSString getValidStringFromString:messageModel.term];   //借款期限
    if (![term isEqualToString:@"暂无"]) {
        term = [NSString stringWithFormat:@"%@个月",messageModel.term];
    }
    NSString *repaymethod = @"暂无";//还款方式
    NSString *obligor = @"暂无";  //债务人主体
    NSString *start = [NSDate getYMDFormatterTime:messageModel.start]; //逾期日期
    if ([start isEqualToString:@"1970-01-01"]) {
        start = @"暂无";
    }

    NSString *commissionperiod = [NSString getValidStringFromString:messageModel.commissionperiod];   //委托代理期限
    if (![commissionperiod isEqualToString:@"暂无"]) {
        commissionperiod = [NSString stringWithFormat:@"%@个月",commissionperiod];
    }
    NSString *paidmoney = [NSString getValidStringFromString:messageModel.paidmoney];  //已付本金
    NSString *interestpaid = [NSString getValidStringFromString:messageModel.interestpaid];  //已付利息
    NSString *performancecontract = [NSString getValidStringFromString:messageModel.performancecontract];  //合同履行地
    
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
    
    NSString *creditorfile = @"查看";
    
    NSString *creditorinfo;//债权人信息
    if (messageResonse.creditorinfo.count > 0) {
        creditorinfo = @"查看";
    }else{
        creditorinfo = @"暂无";
    }
    
    NSString *borrowinginfo;
    if (messageResonse.borrowinginfo.count > 0) {//债务人信息
        borrowinginfo = @"查看";
    }else{
        borrowinginfo = @"暂无";
    }
    
    NSArray *dataList1;
    NSArray *dataList2;
    if ([messageModel.loan_type integerValue] == 4) {
        dataList1 = @[@"借款本金",@"费用类型",@"代理费用",@"债权类型",@"借款利率",@"借款期限",@"还款方式",@"债务人主体",@"逾期日期",@"委托代理期限",@"已付本金(元)",@"已付利息(元)",@"合同履行地",@"债权文件",@"债权人信息",@"债务人信息"];
        dataList2 = @[money,agencycommissiontype,agencycommission,loanType,rate,term,repaymethod,obligor,start,commissionperiod,paidmoney,interestpaid,performancecontract,creditorfile,creditorinfo,borrowinginfo];
    }else{
        dataList1 = @[@"借款本金",@"费用类型",@"代理费用",@"债权类型",loanType,@"借款利率",@"借款期限",@"还款方式",@"债务人主体",@"逾期日期",@"委托代理期限",@"已付本金(元)",@"已付利息(元)",@"合同履行地",@"债权文件",@"债权人信息",@"债务人信息"];
        dataList2 = @[money,agencycommissiontype,agencycommission,loanType,loanString,rate,term,repaymethod,obligor,start,commissionperiod,paidmoney,interestpaid,performancecontract,creditorfile,creditorinfo,borrowinginfo];
    }
    [cell.userNameButton setTitle:dataList1[indexPath.row] forState:0];
    [cell.userActionButton setTitle:dataList2[indexPath.row] forState:0];
    cell.userActionButton.userInteractionEnabled = NO;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PublishingResponse *response;
    DebtModel *debtModel;
    if (self.addMessageDataArray.count > 0) {
        response = self.addMessageDataArray[0];
        debtModel = response.creditorfile;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([response.product.loan_type integerValue] == 4) {
        if (indexPath.row == 13) {//债权文件
            ProductsCheckFilesViewController *productsCheckFilesVC = [[ProductsCheckFilesViewController alloc] init];
            productsCheckFilesVC.debtFileModel = debtModel;
            [self.navigationController pushViewController:productsCheckFilesVC animated:YES];
        }else if (indexPath.row == 14){//债权人信息
            if (response.creditorinfo.count > 0) {
                ProductsCheckDetailViewController *productsCheckDetailVC = [[ProductsCheckDetailViewController alloc] init];
                productsCheckDetailVC.categoryString = @"1";
                productsCheckDetailVC.listArray = response.creditorinfo;
                [self.navigationController pushViewController:productsCheckDetailVC animated:YES];
            }
        }else if (indexPath.row == 15){//债务人信息
            if (response.borrowinginfo.count > 0) {
                ProductsCheckDetailViewController *productsCheckDetailVC = [[ProductsCheckDetailViewController alloc] init];
                productsCheckDetailVC.categoryString = @"2";
                productsCheckDetailVC.listArray = response.borrowinginfo;
                [self.navigationController pushViewController:productsCheckDetailVC animated:YES];
            }
        }
    }else{
        if (indexPath.row == 14) {//债权文件
            ProductsCheckFilesViewController *productsCheckFilesVC = [[ProductsCheckFilesViewController alloc] init];
            productsCheckFilesVC.debtFileModel = debtModel;
            [self.navigationController pushViewController:productsCheckFilesVC animated:YES];
        }else if (indexPath.row == 15){//债权人信息
            if (response.creditorinfo.count > 0) {
                ProductsCheckDetailViewController *productsCheckDetailVC = [[ProductsCheckDetailViewController alloc] init];
                productsCheckDetailVC.categoryString = @"1";
                productsCheckDetailVC.listArray = response.creditorinfo;
                [self.navigationController pushViewController:productsCheckDetailVC animated:YES];
            }
        }else if (indexPath.row == 16){//债务人信息
            if (response.borrowinginfo.count > 0) {
                ProductsCheckDetailViewController *productsCheckDetailVC = [[ProductsCheckDetailViewController alloc] init];
                productsCheckDetailVC.categoryString = @"2";
                productsCheckDetailVC.listArray = response.borrowinginfo;
                [self.navigationController pushViewController:productsCheckDetailVC animated:YES];
            }
        }
    }
}

#pragma mark - method
- (void)getAdditionalMessages
{
    NSString *messageString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyReleaseDetailString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"id" : self.idString,
                             @"category" : self.categoryString
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:messageString params:params successBlock:^(id responseObject){
        
        NSDictionary *qpqp = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
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
