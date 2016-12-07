//
//  MyOrderViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/3.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MyOrderViewController.h"
#import "ReleaseEndListViewController.h"  //已终止列表
#import "MyOrderDetailViewController.h"//详情

#import "AgreementViewController.h"  //居间协议
#import "SignProtocolViewController.h" //签约协议
#import "AddProgressViewController.h"  //添加进度
#import "AdditionalEvaluateViewController.h"  //评价
#import "EvaluateListsViewController.h"  //查看评价

#import "EvaTopSwitchView.h"

#import "ExtendHomeCell.h"
#import "EvaTopSwitchView.h"

#import "ReleaseResponse.h"

#import "OrderResponse.h"
#import "OrderModel.h"
#import "OrdersModel.h"
#import "RowsModel.h"
#import "ApplyRecordModel.h"

@interface MyOrderViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;


@property (nonatomic,strong) EvaTopSwitchView *orderProView;
@property (nonatomic,strong) UIButton *endListButton;
@property (nonatomic,strong) UITableView *myOrderTableView;

//json解析
@property (nonatomic,strong) NSMutableArray *orderDataArray;
@property (nonatomic,strong) NSMutableDictionary *orderDic;

@property (nonatomic,assign) NSInteger pageOrder;//页数
@property (nonatomic,strong) NSString *progressType;  //1-进行中／2-已完成

//@property (nonatomic,strong) AllProSegView *orderHeadView;
//@property (nonatomic,strong) UITableView *myOrderTableView;
//
////json解析
//@property (nonatomic,strong) NSMutableArray *myOrderDataList;
//@property (nonatomic,strong) NSMutableDictionary *myOrderCreditorDic;  //评价
//@property (nonatomic,strong) NSMutableDictionary *myOrderDelaysDic;
//
//@property (nonatomic,assign) NSInteger pageOrder;//页数
//@property (nonatomic,strong) NSString *deadTimeString;  //截止日期

@end

@implementation MyOrderViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self refreshHeaderOfMyOrder];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.navType integerValue] == 2) {
        self.title = @"我的接单";
    }else if ([self.navType integerValue] == 3){
        self.title = @"经办事项";
    }
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    self.progressType = @"1";
    
    [self.view addSubview:self.orderProView];
    [self.view addSubview:self.endListButton];
    [self.view addSubview:self.myOrderTableView];
    [self.view addSubview:self.baseRemindImageView];
    [self.baseRemindImageView setHidden:YES];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.orderProView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.orderProView autoSetDimension:ALDimensionHeight toSize:kCellHeight1];
        
        [self.endListButton autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.endListButton autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.endListButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.orderProView];
        [self.endListButton autoSetDimension:ALDimensionHeight toSize:kCellHeight1];
        
        [self.myOrderTableView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.endListButton];
        [self.myOrderTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        
        [self.baseRemindImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [self.baseRemindImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (EvaTopSwitchView *)orderProView
{
    if (!_orderProView) {
        _orderProView = [EvaTopSwitchView newAutoLayoutView];
        [_orderProView.shortLineLabel setHidden:YES];
        
        [_orderProView.getbutton setTitle:@"进行中" forState:0];
        [_orderProView.sendButton setTitle:@"已完成" forState:0];
        
        QDFWeakSelf;
        [_orderProView setDidSelectedButton:^(NSInteger tag) {
            if (tag == 33) {
                weakself.progressType = @"1";
            }else{
                weakself.progressType = @"2";
            }
            [weakself refreshHeaderOfMyOrder];
        }];
    }
    return _orderProView;
}

- (UIButton *)endListButton
{
    if (!_endListButton) {
        _endListButton = [UIButton newAutoLayoutView];
        _endListButton.backgroundColor = kWhiteColor;
        [_endListButton swapImage];
        [_endListButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        [_endListButton setTitle:@"已终止" forState:0];
        [_endListButton setTitleColor:kBlackColor forState:0];
        _endListButton.titleLabel.font = kBigFont;
        [_endListButton setContentHorizontalAlignment:1];
        [_endListButton setTitleEdgeInsets:UIEdgeInsetsMake(0, kScreenWidth-76, 0, 0)];
        [_endListButton  setImageEdgeInsets:UIEdgeInsetsMake(0, kBigPadding, 0, 0)];
        QDFWeakSelf;
        [_endListButton addAction:^(UIButton *btn) {
            ReleaseEndListViewController *releaseEndListVC = [[ReleaseEndListViewController alloc] init];
            releaseEndListVC.personType = weakself.navType;
            [weakself.navigationController pushViewController:releaseEndListVC animated:YES];
        }];
    }
    return _endListButton;
}

- (UITableView *)myOrderTableView
{
    if (!_myOrderTableView) {
        _myOrderTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _myOrderTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _myOrderTableView.backgroundColor = kBackColor;
        _myOrderTableView.separatorColor = kSeparateColor;
        _myOrderTableView.delegate = self;
        _myOrderTableView.dataSource = self;
        _myOrderTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
        [_myOrderTableView addHeaderWithTarget:self action:@selector(refreshHeaderOfMyOrder)];
        [_myOrderTableView addFooterWithTarget:self action:@selector(refreshFooterOfMyRelease)];
    }
    return _myOrderTableView;
}

- (NSMutableArray *)orderDataArray
{
    if (!_orderDataArray) {
        _orderDataArray = [NSMutableArray array];
    }
    return _orderDataArray;
}

- (NSMutableDictionary *)orderDic
{
    if (!_orderDic) {
        _orderDic = [NSMutableDictionary dictionary];
    }
    return _orderDic;
}

#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.orderDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 245;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"myRelease0";
    ExtendHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ExtendHomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.detailTextLabel setHidden:YES];
    OrderModel *orderModel = self.orderDataArray[indexPath.section];
    RowsModel *rowModel = orderModel.product;
    
    //code
    [cell.nameButton setTitle:rowModel.number forState:0];
    
    //status and action    
    if ([orderModel.statusLabel isEqualToString:@"申请中"]) {
        
        cell.topStatusButtonConstraints.constant = -kSpacePadding;
        [cell.statusButton setTitle:orderModel.statusLabel forState:0];
        [cell.statusButton setImage:[UIImage imageNamed:@""] forState:0];
        
        [cell.actButton2 setTitle:@"取消申请" forState:0];
    }else if ([orderModel.statusLabel isEqualToString:@"面谈中"]){
        cell.topStatusButtonConstraints.constant = -kSpacePadding;
        [cell.statusButton setTitle:orderModel.statusLabel forState:0];
        [cell.statusButton setImage:[UIImage imageNamed:@""] forState:0];
        
        [cell.actButton2 setTitle:@"面谈详情" forState:0];
    }else if ([orderModel.statusLabel isEqualToString:@"处理中"]){
        
        cell.topStatusButtonConstraints.constant = -kSpacePadding;
        [cell.statusButton setTitle:orderModel.statusLabel forState:0];
        [cell.statusButton setImage:[UIImage imageNamed:@""] forState:0];

        if ([orderModel.orders.status integerValue] == 0) {
            [cell.actButton2 setTitle:@"居间协议" forState:0];
        }else if ([orderModel.orders.status integerValue] == 10){
            [cell.actButton2 setTitle:@"签约协议" forState:0];
        }else{
            [cell.actButton2 setTitle:@"填写进度" forState:0];
        }
    }else if ([orderModel.statusLabel isEqualToString:@"已结案"]){
        cell.topStatusButtonConstraints.constant = -kBigPadding;
        [cell.statusButton setTitle:@"" forState:0];
        [cell.statusButton setImage:[UIImage imageNamed:@"close_case"] forState:0];
        
        if (rowModel.productComment) {
            [cell.actButton2 setTitle:@"查看评价" forState:0];
        }else{
            [cell.actButton2 setTitle:@"评价" forState:0];
        }
    }else if ([orderModel.statusLabel isEqualToString:@"申请失败"]){
        cell.topStatusButtonConstraints.constant = -kSpacePadding;
        [cell.statusButton setTitle:orderModel.statusLabel forState:0];
        [cell.statusButton setImage:[UIImage imageNamed:@""] forState:0];

        [cell.actButton2 setTitle:@"删除" forState:0];
    }else if ([orderModel.statusLabel isEqualToString:@"面谈失败"]){
        cell.topStatusButtonConstraints.constant = -kSpacePadding;
        [cell.statusButton setTitle:orderModel.statusLabel forState:0];
        [cell.statusButton setImage:[UIImage imageNamed:@""] forState:0];

        [cell.actButton2 setTitle:@"删除" forState:0];
    }else if ([orderModel.statusLabel isEqualToString:@"取消申请"]){
        cell.topStatusButtonConstraints.constant = -kSpacePadding;
        [cell.statusButton setTitle:orderModel.statusLabel forState:0];
        [cell.statusButton setImage:[UIImage imageNamed:@""] forState:0];

        [cell.actButton2 setTitle:@"删除" forState:0];
    }
    
    QDFWeakSelf;
    [cell.actButton2 addAction:^(UIButton *btn) {
        [weakself goToCheckApplyRecordsOrAdditionMessage:btn.titleLabel.text withModel:orderModel];
    }];
    
    //details
    //委托本金
    NSString *orString0 = [NSString stringWithFormat:@"委托本金：%@万",rowModel.accountLabel];
    //债权类型
    NSString *orString1 = [NSString stringWithFormat:@"债权类型：%@",rowModel.categoryLabel];
    //委托事项
    NSString *orString2 = [NSString stringWithFormat:@"委托事项：%@",rowModel.entrustLabel];
    //委托费用
    NSString *orString3;
    if ([rowModel.typeLabel isEqualToString:@"万"]) {
        orString3 = [NSString stringWithFormat:@"固定费用：%@%@",rowModel.typenumLabel,rowModel.typeLabel];
    }else if ([rowModel.typeLabel isEqualToString:@"%"]){
        orString3 = [NSString stringWithFormat:@"风险费率：%@%@",rowModel.typenumLabel,rowModel.typeLabel];
    }
    
    //违约期限
    NSString *orString4 = [NSString stringWithFormat:@"违约期限：%@个月",rowModel.overdue];
    //合同履行地
    NSString *orString5 = [NSString stringWithFormat:@"合同履行地：%@",rowModel.addressLabel];
    
    NSString *orString = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@",orString0,orString1,orString2,orString3,orString4,orString5];
    NSMutableAttributedString *orAttributeStr = [[NSMutableAttributedString alloc] initWithString:orString];
    [orAttributeStr setAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kGrayColor} range:NSMakeRange(0, orString.length)];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:6];
    [orAttributeStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, orString.length)];
    [cell.contentButton setAttributedTitle:orAttributeStr forState:0];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kBigPadding;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderModel *orderModel = self.orderDataArray[indexPath.section];
    MyOrderDetailViewController *myOrderDetailVC = [[MyOrderDetailViewController alloc] init];
    myOrderDetailVC.applyid = orderModel.applyid;
    [self.navigationController pushViewController:myOrderDetailVC animated:YES];
}

#pragma mark - method
- (void)getMyReleaseListWithPage:(NSString *)page
{
    NSString *myOrderString;
    if ([self.progressType integerValue] == 1) {
        myOrderString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyOrdersOfIngString];
    }else if ([self.progressType integerValue] == 2){
        myOrderString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyOrdersOfFinishedString];
    }
    
    NSString *ttt = [NSString stringWithFormat:@"%ld",[self.navType integerValue] - 2];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"type" : ttt,
                             @"limit" : @"10",
                             @"page" : page
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:myOrderString params:params successBlock:^(id responseObject) {
                
        if ([page intValue] == 1) {
            [weakself.orderDataArray removeAllObjects];
        }
        
        OrderResponse *respondf = [OrderResponse objectWithKeyValues:responseObject];
        
        if (respondf.data.count == 0) {
            [weakself showHint:@"没有更多了"];
            _pageOrder --;
        }
        
        for (OrderModel *orderModel in respondf.data) {
            [weakself.orderDataArray addObject:orderModel];
        }
        
        if (weakself.orderDataArray.count > 0) {
            [weakself.baseRemindImageView setHidden:YES];
        }else{
            [weakself.baseRemindImageView setHidden:NO];
        }
        
        [weakself.myOrderTableView reloadData];
        
    } andFailBlock:^(NSError *error) {
    }];
}

- (void)refreshHeaderOfMyOrder
{
    _pageOrder = 1;
    [self getMyReleaseListWithPage:@"1"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.myOrderTableView headerEndRefreshing];
    });
}

- (void)refreshFooterOfMyRelease
{
    _pageOrder ++;
    NSString *page = [NSString stringWithFormat:@"%ld",(long)_pageOrder];
    [self getMyReleaseListWithPage:page];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.myOrderTableView footerEndRefreshing];
    });
}

- (void)goToCheckApplyRecordsOrAdditionMessage:(NSString *)string withModel:(OrderModel *)ymodel
{
    if ([string isEqualToString:@"取消申请"]) {
        NSString *cancelString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyOrderDetailOfCancelApplyString];
        NSDictionary *params = @{@"applyid" : ymodel.applyid,
                                 @"token" : [self getValidateToken]
                                 };
        QDFWeakSelf;
        [self requestDataPostWithString:cancelString params:params successBlock:^(id responseObject) {
            
            BaseModel *baseModel = [BaseModel objectWithKeyValues:responseObject];
            [weakself showHint:baseModel.msg];
            
            if ([baseModel.code isEqualToString:@"0000"]) {
                [weakself refreshHeaderOfMyOrder];
            }
            
        } andFailBlock:^(NSError *error) {
            
        }];
    }else if ([string isEqualToString:@"面谈详情"]) {
        MyOrderDetailViewController *myOrderDetailVC = [[MyOrderDetailViewController alloc] init];
        myOrderDetailVC.applyid = ymodel.applyid;
        [self.navigationController pushViewController:myOrderDetailVC animated:YES];
    }else if ([string isEqualToString:@"居间协议"]) {
        AgreementViewController *agreementVC = [[AgreementViewController alloc] init];
        agreementVC.navTitleString = @"居间协议";
        agreementVC.flagString = @"1";
        agreementVC.productid = ymodel.productid;
        agreementVC.ordersid = ymodel.orders.ordersid;
        [self.navigationController pushViewController:agreementVC animated:YES];
    }else if ([string isEqualToString:@"签约协议"]) {
        SignProtocolViewController *signProtocolVC = [[SignProtocolViewController alloc] init];
        signProtocolVC.ordersid = ymodel.orders.ordersid;
        [self.navigationController pushViewController:signProtocolVC animated:YES];
    }else if ([string isEqualToString:@"填写进度"]) {
        AddProgressViewController *addProgressVC = [[AddProgressViewController alloc] init];
        addProgressVC.ordersid = ymodel.orders.ordersid;
        [self.navigationController pushViewController:addProgressVC animated:YES];
    }else if ([string isEqualToString:@"评价"]) {
        AdditionalEvaluateViewController *additionalEvaluateVC = [[AdditionalEvaluateViewController alloc] init];
        additionalEvaluateVC.ordersid = ymodel.orders.ordersid;
        additionalEvaluateVC.typeString = @"接单方";
        additionalEvaluateVC.evaString = @"0";
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:additionalEvaluateVC];
        [self presentViewController:nav animated:YES completion:nil];
    }else if ([string isEqualToString:@"查看评价"]){
        EvaluateListsViewController *evaluateListsVC = [[EvaluateListsViewController alloc] init];
        evaluateListsVC.typeString = @"接单方";
        evaluateListsVC.ordersid = ymodel.orders.ordersid;
        [self.navigationController pushViewController:evaluateListsVC animated:YES];
    }else if([string isEqualToString:@"删除"]){
        NSString *deletePubString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyOrderDetailsOfDeleteString];
        NSDictionary *params = @{@"applyid" : ymodel.applyid,
                                 @"token" : [self getValidateToken]
                                 };
        QDFWeakSelf;
        [self requestDataPostWithString:deletePubString params:params successBlock:^(id responseObject) {
            
            BaseModel *baseModel = [BaseModel objectWithKeyValues:responseObject];
            [weakself showHint:baseModel.msg];
            if ([baseModel.code isEqualToString:@"0000"]) {
                [weakself refreshHeaderOfMyOrder];
            }
            
        } andFailBlock:^(NSError *error) {
            
        }];
    }
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
