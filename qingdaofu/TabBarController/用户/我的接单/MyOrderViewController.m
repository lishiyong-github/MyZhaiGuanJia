//
//  MyOrderViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/3.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MyOrderViewController.h"
#import "MyApplyingViewController.h"    //申请中
#import "MyProcessingViewController.h"  //处理中
#import "MyEndingViewController.h"      //终止
#import "MyClosingViewController.h"     //结案

#import "MyScheduleViewController.h"   //填写进度
#import "DelayRequestsViewController.h"  //申请延期
#import "AdditionalEvaluateViewController.h"  //去评价
#import "EvaluateListsViewController.h"  //查看评价

#import "AllProSegView.h"
#import "ExtendHomeCell.h"

#import "ReleaseResponse.h"
#import "RowsModel.h"

#import "DelayResponse.h"
#import "DelayModel.h"

@interface MyOrderViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) AllProSegView *orderHeadView;
@property (nonatomic,strong) UITableView *myOrderTableView;

//json解析
@property (nonatomic,strong) NSMutableArray *myOrderDataList;
@property (nonatomic,strong) NSMutableDictionary *myOrderCreditorDic;  //评价
@property (nonatomic,strong) NSMutableDictionary *myOrderDelaysDic;

@property (nonatomic,assign) NSInteger pageOrder;//页数
@property (nonatomic,strong) NSString *deadTimeString;  //截止日期

@end

@implementation MyOrderViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self refreshsHeaderOfMyOrder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的接单";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.orderHeadView];
    [self.view addSubview:self.myOrderTableView];
    [self.view addSubview:self.baseRemindImageView];
    [self.baseRemindImageView setHidden:YES];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.orderHeadView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.orderHeadView autoSetDimension:ALDimensionHeight toSize:40];
        
        [self.myOrderTableView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.orderHeadView];
        [self.myOrderTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        
        [self.baseRemindImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.baseRemindImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (AllProSegView *)orderHeadView
{
    if (!_orderHeadView) {
        _orderHeadView = [AllProSegView newAutoLayoutView];
        _orderHeadView.backgroundColor = kNavColor;
        [_orderHeadView.allButton setTitle:@"全部" forState:0];
        [_orderHeadView.ingButton setTitle:@"申请中" forState:0];
        [_orderHeadView.dealButton setTitle:@"处理中" forState:0];
        [_orderHeadView.endButton setTitle:@"终止" forState:0];
        [_orderHeadView.closeButton setTitle:@"结案" forState:0];
        
       if ([self.progresStatus isEqualToString:@"1"]){
            _orderHeadView.leftsConstraints.constant = kScreenWidth/5;

        }else if ([self.progresStatus isEqualToString:@"2"]){
            _orderHeadView.leftsConstraints.constant = kScreenWidth/5*2;

        }else if ([self.progresStatus isEqualToString:@"3"]){
            _orderHeadView.leftsConstraints.constant = kScreenWidth/5*3;

        }else if([self.progresStatus isEqualToString:@"4"]){
            _orderHeadView.leftsConstraints.constant = kScreenWidth/5*4;
        }else{
            _orderHeadView.leftsConstraints.constant = 0;
        }
        
        QDFWeakSelf;
        [_orderHeadView setDidSelectedSeg:^(NSInteger segTag) {
            [weakself.myOrderDataList removeAllObjects];
            _pageOrder = 1;
            switch (segTag) {
                case 111:{//全部
                    weakself.status = @"-1";
                    weakself.progresStatus = @"0";
                    [weakself refreshsHeaderOfMyOrder];
                }
                    break;
                case 112:{//申请中
                    weakself.orderHeadView.leftsConstraints.constant = kScreenWidth/5;
                    weakself.status = @"0";
                    weakself.progresStatus = @"1";
                    [weakself refreshsHeaderOfMyOrder];
                }
                    break;
                case 113:{//处理中
                    weakself.orderHeadView.leftsConstraints.constant = kScreenWidth/5*2;
                    weakself.status = @"1";
                    weakself.progresStatus = @"2";
                    [weakself refreshsHeaderOfMyOrder];
                }
                    break;
                case 114:{//终止
                    weakself.orderHeadView.leftsConstraints.constant = kScreenWidth/5*3;
                    weakself.status = @"1";
                    weakself.progresStatus = @"3";
                    [weakself refreshsHeaderOfMyOrder];
                }
                    break;
                case 115:{//结案
                    weakself.orderHeadView.leftsConstraints.constant = kScreenWidth/5*4;
                    weakself.status = @"1";
                    weakself.progresStatus = @"4";
                    [weakself refreshsHeaderOfMyOrder];
                }
                    break;
                default:
                    break;
            }
        }];
    }
    return _orderHeadView;
}

- (UITableView *)myOrderTableView
{
    if (!_myOrderTableView) {
        _myOrderTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _myOrderTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _myOrderTableView.delegate = self;
        _myOrderTableView.dataSource = self;
        _myOrderTableView.backgroundColor = kBackColor;
        _myOrderTableView.separatorColor = kSeparateColor;
        _myOrderTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
        [_myOrderTableView addHeaderWithTarget:self action:@selector(refreshsHeaderOfMyOrder)];
        [_myOrderTableView addFooterWithTarget:self action:@selector(refreshsFooterOfMyOrder)];
    }
    return _myOrderTableView;
}

- (NSMutableArray *)myOrderDataList
{
    if (!_myOrderDataList) {
        _myOrderDataList = [NSMutableArray array];
    }
    return _myOrderDataList;
}

- (NSMutableDictionary *)myOrderCreditorDic
{
    if (!_myOrderCreditorDic) {
        _myOrderCreditorDic = [NSMutableDictionary dictionary];
    }
    return _myOrderCreditorDic;
}

- (NSMutableDictionary *)myOrderDelaysDic
{
    if (!_myOrderDelaysDic) {
        _myOrderDelaysDic = [NSMutableDictionary dictionary];
    }
    return _myOrderDelaysDic;
}

#pragma mark - tableView delegate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  self.myOrderDataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    RowsModel *orderModel = self.myOrderDataList[indexPath.section];
//    
//    if (([orderModel.progress_status integerValue] == 1) || [orderModel.progress_status integerValue] == 3) {
//        return 160;
//    }else if ([orderModel.progress_status integerValue] == 4){
//        
//        NSString *id_category = [NSString stringWithFormat:@"%@_%@",orderModel.idString,orderModel.category];
//        NSString *value = self.myOrderCreditorDic[id_category];
//        if ([value integerValue] >= 2) {//不能评价
//            return 160;
//        }
//    }
    return 200;//200
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"myOrder0";
    ExtendHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ExtendHomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.nameButton.userInteractionEnabled = NO;
//    cell.deadLineButton.userInteractionEnabled = NO;
    RowsModel *rowModel = self.myOrderDataList[indexPath.section];
    
    
    return cell;
    
    /*
    //image and name
    if ([rowModel.category intValue] == 2){//清收
        [cell.nameButton setImage:[UIImage imageNamed:@"list_collection"] forState:0];
    }else if ([rowModel.category intValue] == 3){//诉讼
        [cell.nameButton setImage:[UIImage imageNamed:@"list_litigation"] forState:0];
    }
    
    //code
    NSString *codeS = [NSString stringWithFormat:@"  %@",rowModel.codeString];
    [cell.nameButton setTitle:codeS forState:0];
    
    //status
    NSArray *statusArray = @[@"申请中",@"处理中",@"已终止",@"已结案"];
    NSInteger statusInt = [rowModel.progress_status integerValue];
    cell.statusLabel.text = statusArray[statusInt - 1];
    
    //content
    NSString *orString0 = [NSString stringWithFormat:@"   借款本金：%@万",rowModel.money];
    NSString *orString1;
    if ([rowModel.category integerValue] == 2) {//清收
        if ([rowModel.agencycommissiontype integerValue] == 1) {
            orString1 = [NSString stringWithFormat:@"   服务佣金：%@%@",rowModel.agencycommission,@"%"];
        }else{
            orString1 = [NSString stringWithFormat:@"   固定费用：%@万",rowModel.agencycommission];
        }
    }else if ([rowModel.category integerValue] == 3){//诉讼
        if ([rowModel.agencycommissiontype integerValue] == 1) {
            orString1 = [NSString stringWithFormat:@"   固定费用：%@万",rowModel.agencycommission];
        }else{
            orString1 = [NSString stringWithFormat:@"   代理费率：%@%@",rowModel.agencycommission,@"%"];
        }
    }
    NSString *orString2;
    NSString *orString3;
    if ([rowModel.loan_type integerValue] == 1) {
        orString2 = [NSString stringWithFormat: @"   债权类型：房产抵押"];
        orString3 = [NSString stringWithFormat:@"   抵押物地址：%@",rowModel.seatmortgage];
    }else if ([rowModel.loan_type integerValue] == 2){
        orString2 = [NSString stringWithFormat: @"   债权类型：应收帐款"];
        orString3 = [NSString stringWithFormat:@"   应收帐款：%@万",rowModel.accountr];
    }else if ([rowModel.loan_type integerValue] == 3){
        orString2 = [NSString stringWithFormat: @"   债权类型：机动车抵押"];
        NSArray *plateArray = @[@"沪牌",@"非沪牌"];
        NSInteger plateInt = [rowModel.licenseplate integerValue] - 1;
        NSString *carSdd = [NSString stringWithFormat:@"%@%@%@",rowModel.carbrand,rowModel.audi,plateArray[plateInt]];
        orString3 = [NSString stringWithFormat:@"   机动车抵押：%@",carSdd];
    }else if ([rowModel.loan_type integerValue] == 4){
        orString2 = [NSString stringWithFormat: @"   债权类型：无抵押"];
        orString3 = [NSString stringWithFormat:@"   无抵押"];
    }
    
    NSString *orString = [NSString stringWithFormat:@"%@\n%@\n%@\n%@",orString0,orString1,orString2,orString3];
    NSMutableAttributedString *orAttributeStr = [[NSMutableAttributedString alloc] initWithString:orString];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:6];
    [orAttributeStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, orString.length)];
    [cell.contentLabel setAttributedText:orAttributeStr];
    
    //deadlineLabel
    if ([rowModel.progress_status intValue] == 2){//处理中（距离单子处理还剩一周，显示截止日期）
        [cell.deadLineButton setHidden:NO];
        
        NSString *id_category = [NSString stringWithFormat:@"%@_%@",rowModel.idString,rowModel.category];
        NSString *value11 = self.myOrderDelaysDic[id_category];
        NSString *deadString = [NSString stringWithFormat:@"截止处理时间：%@",value11];
        [cell.deadLineButton setTitle:deadString forState:0];
        [cell.deadLineButton setImage:[UIImage imageNamed:@"time"] forState:0];
        self.deadTimeString = value11;
    }else{
        [cell.deadLineButton setHidden:YES];
    }
    
    //action
    QDFWeakSelf;
    if ([rowModel.progress_status integerValue] == 1) {//申请
        [cell.actButton1 setHidden:YES];
        [cell.actButton2 setHidden:NO];
        [cell.actButton2 setTitle:@"取消申请" forState:0];
        [cell.actButton2 setTitleColor:kBlackColor forState:0];
        cell.actButton2.layer.borderColor = kBorderColor.CGColor;
        
        [cell.actButton2 addAction:^(UIButton *btn) {
            [weakself goToWriteScheduleOrEvaluate:@"取消申请" withSection:indexPath.section withString:@""];
        }];
        
    }else if ([rowModel.progress_status integerValue] == 2) {//处理
        [cell.actButton1 setHidden:NO];
        [cell.actButton2 setHidden:NO];
        cell.actButton1.layer.borderColor = kBorderColor.CGColor;
        [cell.actButton1 setTitleColor:kBlackColor forState:0];
        [cell.actButton1 setTitle:@"联系发布方" forState:0];
        
        cell.actButton2.layer.borderColor = kBlueColor.CGColor;
        [cell.actButton2 setTitleColor:kBlueColor forState:0];
        [cell.actButton2 setTitle:@"填写进度" forState:0];
        
        [cell.actButton1 addAction:^(UIButton *btn) {
            [weakself goToWriteScheduleOrEvaluate:@"联系发布方" withSection:indexPath.section withString:@""];
        }];
        
        [cell.actButton2 addAction:^(UIButton *btn) {
            [weakself goToWriteScheduleOrEvaluate:@"填写进度" withSection:indexPath.section withString:@""];
        }];
        
    }else if ([rowModel.progress_status integerValue] == 3) {//终止
        [cell.actButton1 setHidden:YES];
        [cell.actButton2 setHidden:NO];
        [cell.actButton2 setTitle:@"删除订单" forState:0];
        [cell.actButton2 setTitleColor:kBlackColor forState:0];
        cell.actButton2.layer.borderColor = kBorderColor.CGColor;
        
        [cell.actButton2 addAction:^(UIButton *btn) {
            [weakself goToWriteScheduleOrEvaluate:@"删除订单" withSection:indexPath.section withString:@""];
        }];
        
    }else if ([rowModel.progress_status integerValue] == 4) {//结案
        [cell.actButton1 setHidden:NO];
        [cell.actButton2 setHidden:NO];
        cell.actButton1.layer.borderColor = kBorderColor.CGColor;
        [cell.actButton1 setTitleColor:kBlackColor forState:0];
        [cell.actButton1 setTitle:@"删除订单" forState:0];
        
        cell.actButton2.layer.borderColor = kBlueColor.CGColor;
        [cell.actButton2 setTitleColor:kBlueColor forState:0];
        
        NSString *id_cateStr = [NSString stringWithFormat:@"%@_%@",rowModel.idString,rowModel.category];
        NSString *idCate = self.myOrderCreditorDic[id_cateStr];
        if ([idCate integerValue] == 0) {
            [cell.actButton2 setTitle:@"评价发布方" forState:0];
            [cell.actButton2 addAction:^(UIButton *btn) {
                [weakself goToWriteScheduleOrEvaluate:@"评价发布方" withSection:indexPath.section withString:@""];
            }];
        }else{
            [cell.actButton2 setTitle:@"查看评价" forState:0];
            [cell.actButton2 addAction:^(UIButton *btn) {
                [weakself goToWriteScheduleOrEvaluate:@"查看评价" withSection:indexPath.section withString:@""];
            }];
        }
        
        [cell.actButton1 addAction:^(UIButton *btn) {
            [weakself goToWriteScheduleOrEvaluate:@"删除订单" withSection:indexPath.section withString:@""];
        }];
    }
    return cell;
     */
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kBigPadding;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RowsModel *eModel = self.myOrderDataList[indexPath.section];
    
    if ([eModel.is_del integerValue] == 1) {//产品已被删除
        [self showHint:@"该产品已被删除，不能查看详情"];
    }else{
        if ([eModel.progress_status isEqualToString:@"1"]){//申请中
            MyApplyingViewController *myApplyingVC = [[MyApplyingViewController alloc] init];
            myApplyingVC.idString = eModel.idString;
            myApplyingVC.categaryString = eModel.category;
            myApplyingVC.pidString = eModel.uidString;
            myApplyingVC.cancelIdString = eModel.applyid;
            [self.navigationController pushViewController:myApplyingVC animated:YES];
        }else if ([eModel.progress_status isEqualToString:@"2"]){//处理中
            MyProcessingViewController *myProcessingVC = [[MyProcessingViewController alloc] init];
            myProcessingVC.idString = eModel.idString;
            myProcessingVC.categaryString = eModel.category;
            myProcessingVC.pidString = eModel.uidString;
            myProcessingVC.deadLine = self.deadTimeString;
            [self.navigationController pushViewController:myProcessingVC animated:YES];
        }else if ([eModel.progress_status isEqualToString:@"3"]){//终止
            MyEndingViewController *myEndingVC = [[MyEndingViewController alloc] init];
            myEndingVC.idString = eModel.idString;
            myEndingVC.categaryString = eModel.category;
            myEndingVC.pidString = eModel.uidString;
            myEndingVC.deleteId = eModel.applyid;
            [self.navigationController pushViewController:myEndingVC animated:YES];
        }else if([eModel.progress_status isEqualToString:@"4"]){//结案
            NSString *id_category = [NSString stringWithFormat:@"%@_%@",eModel.idString,eModel.category];
            NSString *value1 = self.myOrderCreditorDic[id_category];
            
            MyClosingViewController *myClosingVC = [[MyClosingViewController alloc] init];
            myClosingVC.idString = eModel.idString;
            myClosingVC.categaryString = eModel.category;
            myClosingVC.pidString = eModel.uidString;
            myClosingVC.deleteId = eModel.applyid;
            myClosingVC.evaString = value1;
            [self.navigationController pushViewController:myClosingVC animated:YES];
        }
    }
}

#pragma mark - method
- (void)getOrderListWithPage:(NSString *)page
{
    NSString *myOrderString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyOrdersString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"progress_status" : self.progresStatus,
                             @"page" : page,
                             @"status" : self.status
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:myOrderString params:params successBlock:^(id responseObject) {
                        
        if ([page intValue] == 1) {
            [weakself.myOrderDataList removeAllObjects];
            [weakself.myOrderCreditorDic removeAllObjects];
            [weakself.myOrderDelaysDic removeAllObjects];
        }
        
        ReleaseResponse *responceModel = [ReleaseResponse objectWithKeyValues:responseObject];
        
        if (responceModel.rows.count == 0) {
            _pageOrder -- ;
            [weakself showHint:@"没有更多了"];
        }
        
        [weakself.myOrderCreditorDic setValuesForKeysWithDictionary:responceModel.creditor];
        [weakself.myOrderDelaysDic setValuesForKeysWithDictionary:responceModel.delays];
        
        for (RowsModel *orderModel in responceModel.rows) {
            [weakself.myOrderDataList addObject:orderModel];
        }
        
        if (weakself.myOrderDataList.count > 0) {
            [weakself.baseRemindImageView setHidden:YES];
        }else{
            [weakself.baseRemindImageView setHidden:NO];
        }
        
        [weakself.myOrderTableView reloadData];

    } andFailBlock:^(NSError *error) {
         [weakself.myOrderTableView reloadData];
    }];
}

- (void)refreshsHeaderOfMyOrder
{
    _pageOrder = 1;
    [self getOrderListWithPage:@"1"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.myOrderTableView headerEndRefreshing];
    });
}

- (void)refreshsFooterOfMyOrder
{
    _pageOrder ++;
    NSString *page = [NSString stringWithFormat:@"%ld",(long)_pageOrder];
    [self getOrderListWithPage:page];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.myOrderTableView footerEndRefreshing];
    });
}

- (void)goToWriteScheduleOrEvaluate:(NSString *)string withSection:(NSInteger)section withString:(NSString *)evaString
{
    RowsModel *lModel = self.myOrderDataList[section];
    
    if ([string isEqualToString:@"取消申请"]) {
        [self cancelTheProductApplyWithID:lModel.applyid];
    }else if ([string isEqualToString:@"联系发布方"]){
        if ([lModel.applymobile isEqualToString:@""] || !lModel.applymobile || lModel.applymobile == nil) {
            [self showHint:@"发布方未认证，不能打电话"];
        }else{
            NSMutableString *phoneStr = [NSMutableString stringWithFormat:@"telprompt://%@",lModel.applymobile];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr]];
        }
    }else if ([string isEqualToString:@"填写进度"]){
        MyScheduleViewController *myScheduleVC = [[MyScheduleViewController alloc] init];
        myScheduleVC.idString = lModel.idString;
        myScheduleVC.categoryString = lModel.category;
        [self.navigationController pushViewController:myScheduleVC animated:YES];
    }else if ([string isEqualToString:@"删除订单"]){
        [self deleteTheOrderProductWithModel:lModel];
    }else if ([string isEqualToString:@"评价发布方"]){
        AdditionalEvaluateViewController *additionalEvaluateVC = [[AdditionalEvaluateViewController alloc] init];
        additionalEvaluateVC.idString = lModel.idString;
        additionalEvaluateVC.categoryString = lModel.category;
        additionalEvaluateVC.typeString = @"接单方";
        additionalEvaluateVC.evaString = evaString;
        
        UINavigationController *nahuh = [[UINavigationController alloc] initWithRootViewController:additionalEvaluateVC];
        [self presentViewController:nahuh animated:YES completion:nil];
    }else if ([string isEqualToString:@"查看评价"]){
        EvaluateListsViewController *evaluateListVC = [[EvaluateListsViewController alloc] init];
        evaluateListVC.typeString = @"接单方";
        evaluateListVC.idString = lModel.idString;
        evaluateListVC.categoryString = lModel.category;
        [self.navigationController pushViewController:evaluateListVC animated:YES];
    }
}

- (void)cancelTheProductApplyWithID:(NSString *)idStr
{
    NSString *idsss = [NSString getValidStringFromString:idStr toString:@""];
    NSString *cancelString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kCancelProductOfMyOrderString];
    NSDictionary *params = @{@"id" : idsss,
                             @"token" : [self getValidateToken]
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:cancelString params:params successBlock:^(id responseObject) {
        
        BaseModel *baseModel = [BaseModel objectWithKeyValues:responseObject];
        [weakself showHint:baseModel.msg];
        
        if ([baseModel.code isEqualToString:@"0000"]) {
            [weakself refreshsHeaderOfMyOrder];
        }
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

//删除产品
- (void)deleteTheOrderProductWithModel:(RowsModel *)lModel
{
    NSString *deleteProString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kDeleteProductOfMyReleaseString];
    NSDictionary *params = @{@"id" : lModel.applyid,
                             @"category" : lModel.category,
                             @"token" : [self getValidateToken],
                             @"type" : @"1"
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:deleteProString params:params successBlock:^(id responseObject) {
        
        BaseModel *baModel = [BaseModel objectWithKeyValues:responseObject];
        [weakself showHint:baModel.msg];
        
        if ([baModel.code isEqualToString:@"0000"]) {
            [weakself refreshsHeaderOfMyOrder];
        }
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

//- (void)delayRequestWithID:(NSString *)idStr andCategary:(NSString *)categaryStr
//{
//    NSString *deString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kIsDelayRequestString];
//    NSDictionary *params = @{@"token" : [self getValidateToken],
//                             @"id" : idStr,
//                             @"category" : categaryStr
//                             };
//    QDFWeakSelf;
//    [self requestDataPostWithString:deString params:params successBlock:^(id responseObject) {
//
//        DelayResponse *response = [DelayResponse objectWithKeyValues:responseObject];
//        DelayModel *delayModel = response.delay;
//        
//        if (![delayModel.is_agree isEqualToString:@""]) {//已申请
//            [weakself showHint:@"您已申请，不能重复申请"];
//        }else if ([delayModel.delays intValue] > 7){
//            [weakself showHint:@"小于7天才可申请延期"];
//        }else{
//            DelayRequestsViewController *delayRequestsVC = [[DelayRequestsViewController alloc] init];
//            delayRequestsVC.idString = idStr;
//            delayRequestsVC.categoryString = categaryStr;
//            [weakself.navigationController pushViewController:delayRequestsVC animated:YES];
//        }
//    } andFailBlock:^(NSError *error) {
//
//    }];
//}

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
