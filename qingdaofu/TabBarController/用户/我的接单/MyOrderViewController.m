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
@property (nonatomic,strong) NSMutableDictionary *myOrderResonseDic;  //评价
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

- (NSMutableDictionary *)myOrderResonseDic
{
    if (!_myOrderResonseDic) {
        _myOrderResonseDic = [NSMutableDictionary dictionary];
    }
    return _myOrderResonseDic;
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
//        NSString *value = self.myOrderResonseDic[id_category];
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
    cell.nameButton.userInteractionEnabled = NO;
    cell.deadLineButton.userInteractionEnabled = NO;
    RowsModel *rowModel = self.myOrderDataList[indexPath.section];
    
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
        orString3 = [NSString stringWithFormat:@"   抵押物地址：%@",rowModel.mortorage_community];
    }else if ([rowModel.loan_type integerValue] == 2){
        orString2 = [NSString stringWithFormat: @"   债权类型：应收帐款"];
        orString3 = [NSString stringWithFormat:@"   应收帐款：%@万",rowModel.mortorage_community];
    }else if ([rowModel.loan_type integerValue] == 3){
        orString2 = [NSString stringWithFormat: @"   债权类型：机动车抵押"];
        orString3 = [NSString stringWithFormat:@"   机动车抵押：%@",rowModel.mortorage_community];
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
    if ([rowModel.progress_status intValue] == 2){//处理中（距离单子处理还剩一周，显示截至日期）
        [cell.deadLineButton setHidden:NO];
        
        NSString *id_category = [NSString stringWithFormat:@"%@_%@",rowModel.idString,rowModel.category];
        NSString *value11 = self.myOrderDelaysDic[id_category];
        NSString *deadString = [NSString stringWithFormat:@" 截止处理时间：%@",value11];
        [cell.deadLineButton setTitle:deadString forState:0];
        [cell.deadLineButton setImage:[UIImage imageNamed:@"time"] forState:0];
        self.deadTimeString = value11;
    }else{
        [cell.deadLineButton setHidden:YES];
    }
    
    //action
    if ([rowModel.progress_status integerValue] == 1) {//申请
        [cell.actButton1 setHidden:YES];
        [cell.actButton2 setHidden:NO];
        [cell.actButton2 setTitle:@"取消申请" forState:0];
        [cell.actButton2 setTitleColor:kBlackColor forState:0];
        cell.actButton2.layer.borderColor = kBorderColor.CGColor;
    }else if ([rowModel.progress_status integerValue] == 2) {//处理
        [cell.actButton1 setHidden:NO];
        [cell.actButton2 setHidden:NO];
        cell.actButton1.layer.borderColor = kBorderColor.CGColor;
        [cell.actButton1 setTitleColor:kBlackColor forState:0];
        [cell.actButton1 setTitle:@"联系发布方" forState:0];
        
        cell.actButton2.layer.borderColor = kBlueColor.CGColor;
        [cell.actButton2 setTitleColor:kBlueColor forState:0];
        [cell.actButton2 setTitle:@"填写进度" forState:0];
    }else if ([rowModel.progress_status integerValue] == 3) {//终止
        [cell.actButton1 setHidden:YES];
        [cell.actButton2 setHidden:NO];
        [cell.actButton2 setTitle:@"删除订单" forState:0];
        [cell.actButton2 setTitleColor:kBlackColor forState:0];
        cell.actButton2.layer.borderColor = kBorderColor.CGColor;
    }else if ([rowModel.progress_status integerValue] == 4) {//结案
        [cell.actButton1 setHidden:NO];
        [cell.actButton2 setHidden:NO];
        cell.actButton1.layer.borderColor = kBorderColor.CGColor;
        [cell.actButton1 setTitleColor:kBlackColor forState:0];
        [cell.actButton1 setTitle:@"删除订单" forState:0];
        
        cell.actButton2.layer.borderColor = kBlueColor.CGColor;
        [cell.actButton2 setTitleColor:kBlueColor forState:0];
        [cell.actButton2 setTitle:@"评价发布方" forState:0];
    }
    

    return cell;
    
    /*
    identifier = @"myRelease1";
    AnotherHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[AnotherHomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.typeLabel.textColor = kBlueColor;
    
    RowsModel *rowModel = self.myOrderDataList[indexPath.section];
    
    cell.nameLabel.text = rowModel.codeString;
    //typeImageView  nameLabel*/
    //清收－－借款本金（万元），代理费用，债权类型
    //诉讼－－借款本金（万元），代理费用（或风险费率  具体看用户自己选择），债权类型
    /*
    if ([rowModel.category intValue] == 1) {//融资
        cell.typeImageView.image = [UIImage imageNamed:@"list_financing"];
        if ([rowModel.progress_status intValue] > 2) {
            cell.typeImageView.image = [UIImage imageNamed:@"list_financing_nor"];
        }
        
        NSString *seatmortgageS1 = [NSString getValidStringFromString:rowModel.seatmortgage];
        NSString *mortorage_communityS1 = [NSString getValidStringFromString:rowModel.mortorage_community];
        cell.addressLabel.text = [NSString stringWithFormat:@"%@%@",seatmortgageS1,mortorage_communityS1];
        cell.pointView.label1.text = [NSString getValidStringFromString:rowModel.rebate toString:@"0"];
        cell.pointView.label2.text = @"返点(%)";
        cell.rateView.label1.text = [NSString getValidStringFromString:rowModel.rate toString:@"0"];
        if ([rowModel.rate_cat integerValue] == 1) {
            cell.rateView.label2.text = @"借款利率(%/天)";
        }else{
            cell.rateView.label2.text = @"借款利率(%/月)";
        }
        
    }else if ([rowModel.category intValue] == 2){//催收
        cell.typeImageView.image = [UIImage imageNamed:@"list_collection"];
        if ([rowModel.progress_status intValue] > 2) {
            cell.typeImageView.image = [UIImage imageNamed:@"list_collection_nor"];
        }
        
        cell.pointView.label1.text = [NSString getValidStringFromString:rowModel.agencycommission toString:@"0"];
        if ([rowModel.agencycommissiontype isEqualToString:@"1"]) {
            cell.pointView.label2.text = @"服务佣金(%)";
        }else{
            cell.pointView.label2.text = @"固定费用(万元)";
        }

        if ([rowModel.loan_type isEqualToString:@"1"]) {
            cell.rateView.label1.text = @"房产抵押";
            NSString *seatmortgageS2 = [NSString getValidStringFromString:rowModel.seatmortgage];
            NSString *mortorage_communityS2 = [NSString getValidStringFromString:rowModel.mortorage_community];
            cell.addressLabel.text = [NSString stringWithFormat:@"%@%@",seatmortgageS2,mortorage_communityS2];
        }else if ([rowModel.loan_type isEqualToString:@"2"]){
            cell.rateView.label1.text = @"应收账款";
            cell.addressLabel.text = @"无抵押物地址";
        }else if ([rowModel.loan_type isEqualToString:@"3"]){
            cell.rateView.label1.text = @"机动车抵押";
            cell.addressLabel.text = @"无抵押物地址";
        }else{
            cell.rateView.label1.text = @"无抵押";
            cell.addressLabel.text = @"无抵押物地址";
        }
        cell.rateView.label2.text = @"债权类型";
    }else if ([rowModel.category intValue] == 3){//诉讼
        cell.typeImageView.image = [UIImage imageNamed:@"list_litigation"];
        if ([rowModel.progress_status intValue] > 2) {
            cell.typeImageView.image = [UIImage imageNamed:@"list_litigation_nor"];
        }
        
        cell.pointView.label1.text = [NSString getValidStringFromString:rowModel.agencycommission toString:@"0"];
        if ([rowModel.agencycommissiontype isEqualToString:@"1"]) {
            cell.pointView.label2.text = @"固定费用(万元)";
        }else{
            cell.pointView.label2.text = @"风险费率(%)";
        }
        
        if ([rowModel.loan_type isEqualToString:@"1"]) {
            cell.rateView.label1.text = @"房产抵押";
            NSString *seatmortgageS3 = [NSString getValidStringFromString:rowModel.seatmortgage];
            NSString *mortorage_communityS3 = [NSString getValidStringFromString:rowModel.mortorage_community];
            cell.addressLabel.text = [NSString stringWithFormat:@"%@%@",seatmortgageS3,mortorage_communityS3];
        }else if ([rowModel.loan_type isEqualToString:@"2"]){
            cell.rateView.label1.text = @"应收账款";
            cell.addressLabel.text = @"无抵押物地址";
        }else if ([rowModel.loan_type isEqualToString:@"3"]){
            cell.rateView.label1.text = @"机动车抵押";
            cell.addressLabel.text = @"无抵押物地址";
        }else if([rowModel.loan_type isEqualToString:@"4"]){
            cell.rateView.label1.text = @"无抵押";
            cell.addressLabel.text = @"无抵押物地址";
        }
        cell.rateView.label2.text = @"债权类型";
    }
    
    /*typeLabel*/
    /*
    if ([rowModel.progress_status integerValue]  == 0) {
        [cell.typeLabel setHidden:NO];
        cell.typeLabel.text = @"待申请";
        [cell.typeButton setHidden:YES];
    }else if ([rowModel.progress_status integerValue]  == 1){
        [cell.typeLabel setHidden:NO];
        cell.typeLabel.text = @"申请中";
        [cell.typeButton setHidden:YES];
    }else if ([rowModel.progress_status integerValue]  == 2){
        [cell.typeLabel setHidden:NO];
        cell.typeLabel.text = @"处理中";
        [cell.typeButton setHidden:YES];
    }else if ([rowModel.progress_status integerValue]  == 3){
        [cell.typeLabel setHidden:NO];
        cell.typeLabel.text = @"终止";
        [cell.typeButton setHidden:YES];
    }else if([rowModel.progress_status integerValue]  == 4){
        [cell.typeLabel setHidden:YES];
        [cell.typeButton setHidden:NO];
        [cell.typeButton setImage:[UIImage imageNamed:@"list_chapter"] forState:0];
    }

    cell.moneyView.label1.text = [NSString getValidStringFromString:rowModel.money toString:@"0"];
    cell.moneyView.label2.text = @"借款本金(万元)";
    
    if (([rowModel.progress_status intValue] == 1) || ([rowModel.progress_status intValue] == 3)) {//申请中，终止
        [cell.firstButton setHidden:YES];
        [cell.secondButton setHidden:YES];
        [cell.thirdButton setHidden:YES];
    }else if ([rowModel.progress_status intValue] == 2){//处理中（距离单子处理还剩一周，显示截至日期）
        [cell.firstButton setHidden:NO];
        [cell.secondButton setHidden:NO];
        [cell.thirdButton setHidden:NO];
        
        
        NSString *id_category = [NSString stringWithFormat:@"%@_%@",rowModel.idString,rowModel.category];
        NSString *value11 = self.myOrderDelaysDic[id_category];
        NSString *deadString = [NSString stringWithFormat:@"截止日期：%@",value11];
        [cell.firstButton setTitle:deadString forState:0];
        [cell.secondButton setTitle:@"申请延期" forState:0];
        [cell.thirdButton setTitle:@"填写进度" forState:0];
        
        QDFWeakSelf;
        [cell.secondButton addAction:^(UIButton *btn) {
            [weakself goToWriteScheduleOrEvaluate:@"申请延期" withRow:indexPath.section withString:@""];
        }];
        
        [cell.thirdButton addAction:^(UIButton *btn) {
            [weakself goToWriteScheduleOrEvaluate:@"填写进度" withRow:indexPath.section withString:@""];
        }];
        
    }else {//结案
        [cell.firstButton setHidden:YES];
        [cell.secondButton setHidden:YES];
        
        NSString *id_category = [NSString stringWithFormat:@"%@_%@",rowModel.idString,rowModel.category];
        NSString *value = self.myOrderResonseDic[id_category];
        if ([value integerValue] >= 2) {
            [cell.thirdButton setHidden:YES];
        }else{
            [cell.thirdButton setHidden:NO];
            
            if ([value integerValue] == 0) {
                [cell.thirdButton setTitle:@"去评价" forState:0];
            }else{
                [cell.thirdButton setTitle:@"再次评价" forState:0];
            }
            QDFWeakSelf;
            [cell.thirdButton addAction:^(UIButton *btn) {
                [weakself goToWriteScheduleOrEvaluate:@"去评价" withRow:indexPath.section withString:value];
            }];
        }
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
   if ([eModel.progress_status isEqualToString:@"1"]){//申请中
       MyApplyingViewController *myApplyingVC = [[MyApplyingViewController alloc] init];
       myApplyingVC.idString = eModel.idString;
       myApplyingVC.categaryString = eModel.category;
       myApplyingVC.pidString = eModel.uidString;
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
        [self.navigationController pushViewController:myEndingVC animated:YES];
    }else if([eModel.progress_status isEqualToString:@"4"]){//结案
        NSString *id_category = [NSString stringWithFormat:@"%@_%@",eModel.idString,eModel.category];
        NSString *value1 = self.myOrderResonseDic[id_category];
        
        MyClosingViewController *myClosingVC = [[MyClosingViewController alloc] init];
        myClosingVC.idString = eModel.idString;
        myClosingVC.categaryString = eModel.category;
        myClosingVC.pidString = eModel.uidString;
        myClosingVC.evaString = value1;
        [self.navigationController pushViewController:myClosingVC animated:YES];
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
        
        NSDictionary *sususu = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([page intValue] == 1) {
            [weakself.myOrderDataList removeAllObjects];
            [weakself.myOrderResonseDic removeAllObjects];
        }
        
        ReleaseResponse *responceModel = [ReleaseResponse objectWithKeyValues:responseObject];
        
        if (responceModel.rows.count == 0) {
            [weakself showHint:@"没有更多了"];
            _pageOrder -- ;
        }
        
        [weakself.myOrderResonseDic setValuesForKeysWithDictionary:responceModel.creditor];
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

- (void)goToWriteScheduleOrEvaluate:(NSString *)string withRow:(NSInteger)row withString:(NSString *)evaString
{
    RowsModel *model = self.myOrderDataList[row];
    
    if ([string isEqualToString:@"申请延期"]) {
        [self delayRequestWithID:model.idString andCategary:model.category];
    }else if([string isEqualToString:@"填写进度"]){
        MyScheduleViewController *myScheduleVC = [[MyScheduleViewController alloc] init];
        myScheduleVC.idString = model.idString;
        myScheduleVC.categoryString = model.category;
        [self.navigationController pushViewController:myScheduleVC animated:YES];
    }else if ([string isEqualToString:@"去评价"]){
        AdditionalEvaluateViewController *additionalEvaluateVC = [[AdditionalEvaluateViewController alloc] init];
        additionalEvaluateVC.idString = model.idString;
        additionalEvaluateVC.categoryString = model.category;
        additionalEvaluateVC.typeString = @"接单方";
        additionalEvaluateVC.evaString = evaString;
        [self.navigationController pushViewController:additionalEvaluateVC animated:YES];
    }
}

- (void)delayRequestWithID:(NSString *)idStr andCategary:(NSString *)categaryStr
{
    NSString *deString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kIsDelayRequestString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"id" : idStr,
                             @"category" : categaryStr
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:deString params:params successBlock:^(id responseObject) {

        DelayResponse *response = [DelayResponse objectWithKeyValues:responseObject];
        DelayModel *delayModel = response.delay;
        
        if (![delayModel.is_agree isEqualToString:@""]) {//已申请
            [weakself showHint:@"您已申请，不能重复申请"];
        }else if ([delayModel.delays intValue] > 7){
            [weakself showHint:@"小于7天才可申请延期"];
        }else{
            DelayRequestsViewController *delayRequestsVC = [[DelayRequestsViewController alloc] init];
            delayRequestsVC.idString = idStr;
            delayRequestsVC.categoryString = categaryStr;
            [weakself.navigationController pushViewController:delayRequestsVC animated:YES];
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
