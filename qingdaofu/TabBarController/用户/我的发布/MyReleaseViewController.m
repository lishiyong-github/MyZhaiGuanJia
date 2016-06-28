//
//  MyReleaseViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/4.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MyReleaseViewController.h"

#import "MyPublishingViewController.h"   //发布中
#import "MyDealingViewController.h"   //处理中
#import "ReleaseEndViewController.h"   //终止
#import "ReleaseCloseViewController.h"  //结案

#import "AdditionMessageViewController.h"  //补充信息
#import "ApplyRecordsViewController.h"     //查看申请
#import "PaceViewController.h"          //查看进度
#import "AdditionalEvaluateViewController.h"  //去评价

#import "AnotherHomeCell.h"
#import "AllProSegView.h"

#import "ReleaseResponse.h"
#import "RowsModel.h"

@interface MyReleaseViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) AllProSegView *releaseProView;
@property (nonatomic,strong) UITableView *myReleaseTableView;

//json解析
@property (nonatomic,strong) NSMutableArray *responseDataArray;
@property (nonatomic,strong) NSMutableArray *releaseDataArray;

@property (nonatomic,assign) NSInteger pageRelease;//页数

@end

@implementation MyReleaseViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self refreshHeaderOfMyRelease];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"所有产品";
    self.navigationItem.leftBarButtonItem = self.leftItem;

    [self.view addSubview:self.releaseProView];
    [self.view addSubview:self.myReleaseTableView];
    [self.view addSubview:self.baseRemindImageView];
    [self.baseRemindImageView setHidden:YES];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.releaseProView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.releaseProView autoSetDimension:ALDimensionHeight toSize:40];
        
        [self.myReleaseTableView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.releaseProView];
        [self.myReleaseTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        
        [self.baseRemindImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [self.baseRemindImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (AllProSegView *)releaseProView
{
    if (!_releaseProView) {
        _releaseProView = [AllProSegView newAutoLayoutView];
        _releaseProView.backgroundColor = kNavColor;
        [_releaseProView.allButton setTitle:@"全部" forState:0];
        [_releaseProView.ingButton setTitle:@"已发布" forState:0];
        [_releaseProView.dealButton setTitle:@"处理中" forState:0];
        [_releaseProView.endButton setTitle:@"终止" forState:0];
        [_releaseProView.closeButton setTitle:@"结案" forState:0];
        
        if ([self.progreStatus isEqualToString:@"1"]){
            _releaseProView.leftsConstraints.constant = kScreenWidth/5;
        }else if ([self.progreStatus isEqualToString:@"2"]){
            _releaseProView.leftsConstraints.constant = kScreenWidth/5*2;
        }else if ([self.progreStatus isEqualToString:@"3"]){
            _releaseProView.leftsConstraints.constant = kScreenWidth/5*3;
        }else if([self.progreStatus isEqualToString:@"4"]){
            _releaseProView.leftsConstraints.constant = kScreenWidth/5*4;
        }else{
            _releaseProView.leftsConstraints.constant = 0;
        }
        
        QDFWeakSelf;
        [_releaseProView setDidSelectedSeg:^(NSInteger segTag) {
            
            [weakself.releaseDataArray removeAllObjects];
            
            switch (segTag) {
                case 111:{
                    weakself.progreStatus = @"0";
                    [weakself refreshHeaderOfMyRelease];
                }
                    break;
                case 112:{
                    weakself.progreStatus = @"1";
                    [weakself refreshHeaderOfMyRelease];
                }
                    break;
                case 113:{
                    weakself.progreStatus = @"2";
                    [weakself refreshHeaderOfMyRelease];
                }
                    break;
                case 114:{
                    weakself.progreStatus = @"3";
                    [weakself refreshHeaderOfMyRelease];
                }
                    break;
                case 115:{
                    weakself.progreStatus = @"4";
                    [weakself refreshHeaderOfMyRelease];
                }
                    break;
                default:
                    break;
            }
        }];
    }
    return _releaseProView;
}

- (UITableView *)myReleaseTableView
{
    if (!_myReleaseTableView) {
        _myReleaseTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _myReleaseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        _myReleaseTableView.delegate = self;
        _myReleaseTableView.dataSource = self;
        _myReleaseTableView.backgroundColor = kBackColor;
        _myReleaseTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
        [_myReleaseTableView addHeaderWithTarget:self action:@selector(refreshHeaderOfMyRelease)];
        [_myReleaseTableView addFooterWithTarget:self action:@selector(refreshFooterOfMyRelease)];
    }
    return _myReleaseTableView;
}

- (NSMutableArray *)responseDataArray
{
    if (!_responseDataArray) {
        _responseDataArray = [NSMutableArray array];
    }
    return _responseDataArray;
}

- (NSMutableArray *)releaseDataArray
{
    if (!_releaseDataArray) {
        _releaseDataArray = [NSMutableArray array];
    }
    return _releaseDataArray;
}

#pragma mark - 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.releaseDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RowsModel *rModel = self.releaseDataArray[indexPath.section];
    if ([rModel.progress_status intValue] == 3) {
        return 156;
    }
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    identifier = @"myRelease0";
        AnotherHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AnotherHomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.typeLabel.textColor = kBlueColor;
    
        RowsModel *rowModel = self.releaseDataArray[indexPath.section];

        cell.nameLabel.text = rowModel.codeString;
        /*typeImageView
         nameLabel*/
        //融资－－借款本金（万元），返点（％），借款利率（月，天）
        //清收－－借款本金（万元），代理费用，债权类型
        //诉讼－－借款本金（万元），代理费用（或风险费率  具体看用户自己选择），债权类型
        if ([rowModel.category intValue] == 1) {//融资
            cell.typeImageView.image = [UIImage imageNamed:@"list_financing"];
            if ([rowModel.progress_status intValue] > 2) {
                cell.typeImageView.image = [UIImage imageNamed:@"list_financing_nor"];
            }
            
            cell.pointView.label1.text = rowModel.rebate;
            cell.pointView.label2.text = @"返点(%)";
            cell.rateView.label1.text = rowModel.rate;
            if ([rowModel.rate_cat integerValue] == 1) {
                cell.rateView.label2.text = @"借款利率(天)";
            }else{
                cell.rateView.label2.text = @"借款利率(月)";
            }
            
        }else if ([rowModel.category intValue] == 2){//清收
            cell.typeImageView.image = [UIImage imageNamed:@"list_collection"];
            if ([rowModel.progress_status intValue] > 2) {
                cell.typeImageView.image = [UIImage imageNamed:@"list_collection_nor"];
            }
            
            cell.pointView.label1.text = rowModel.agencycommission;
            cell.pointView.label2.text = @"代理费用(万元)";
            if ([rowModel.loan_type isEqualToString:@"1"]) {
                cell.rateView.label1.text = @"房产抵押";
            }else if ([rowModel.loan_type isEqualToString:@"2"]){
                cell.rateView.label1.text = @"应收账款";
            }else if ([rowModel.loan_type isEqualToString:@"3"]){
                cell.rateView.label1.text = @"机动车抵押";
            }else if([rowModel.loan_type isEqualToString:@"4"]){
                cell.rateView.label1.text = @"无抵押";
            }
            cell.rateView.label2.text = @"债权类型";
        }else if ([rowModel.category intValue] == 3){//诉讼
            cell.typeImageView.image = [UIImage imageNamed:@"list_litigation"];
            if ([rowModel.progress_status intValue] > 2) {
                cell.typeImageView.image = [UIImage imageNamed:@"list_litigation_nor"];
            }
            
            cell.pointView.label1.text = rowModel.agencycommission;
            if ([rowModel.agencycommissiontype isEqualToString:@"1"]) {
                cell.pointView.label2.text = @"固定费用(万)";
            }else{
                cell.pointView.label2.text = @"风险费率(%)";
            }

            if ([rowModel.loan_type isEqualToString:@"1"]) {
                cell.rateView.label1.text = @"房产抵押";
            }else if ([rowModel.loan_type isEqualToString:@"2"]){
                cell.rateView.label1.text = @"应收账款";
            }else if ([rowModel.loan_type isEqualToString:@"3"]){
                cell.rateView.label1.text = @"机动车抵押";
            }else if([rowModel.loan_type isEqualToString:@"4"]){
                cell.rateView.label1.text = @"无抵押";
            }
            cell.rateView.label2.text = @"债权类型";
        }
        /*typeLabel*/
        if ([rowModel.progress_status integerValue]  == 0) {
            [cell.typeLabel setHidden:NO];
            cell.typeLabel.text = @"待发布";
            [cell.typeButton setHidden:YES];
        }else if ([rowModel.progress_status integerValue]  == 1){
            [cell.typeLabel setHidden:NO];
            [cell.typeButton setHidden:YES];
            cell.typeLabel.text = @"发布中";
            [cell.firstButton setHidden:NO];
            [cell.secondButton setHidden:NO];
            [cell.thirdButton setHidden:NO];
            [cell.firstButton setTitle:@"您有新的申请记录" forState:0];
            [cell.secondButton setTitle:@"补充信息" forState:0];
            [cell.thirdButton setTitle:@"查看申请" forState:0];
            
            QDFWeakSelf;
            [cell.secondButton addAction:^(UIButton *btn) {
                [weakself goToCheckApplyRecordsOrAdditionMessage:@"补充信息" withRow:indexPath.section];
            }];
            
            [cell.thirdButton addAction:^(UIButton *btn) {
                [weakself goToCheckApplyRecordsOrAdditionMessage:@"查看申请" withRow:indexPath.section];
            }];
            
        }else if ([rowModel.progress_status integerValue]  == 2){
            [cell.typeLabel setHidden:NO];
            [cell.typeButton setHidden:YES];
            cell.typeLabel.text = @"处理中";
            [cell.firstButton setHidden:YES];
            [cell.secondButton setHidden:NO];
            [cell.thirdButton setHidden:NO];
            [cell.secondButton setTitle:@"查看进度" forState:0];
            [cell.thirdButton setTitle:@"联系接单方" forState:0];
            
            QDFWeakSelf;
            [cell.secondButton addAction:^(UIButton *btn) {
                [weakself goToCheckApplyRecordsOrAdditionMessage:@"查看进度" withRow:indexPath.section];
            }];
            
            [cell.thirdButton addAction:^(UIButton *btn) {
                [weakself goToCheckApplyRecordsOrAdditionMessage:@"联系接单方" withRow:indexPath.section];
            }];
            
        }else if ([rowModel.progress_status integerValue]  == 3){
            [cell.typeLabel setHidden:NO];
            [cell.typeButton setHidden:YES];
            cell.typeLabel.text = @"终止";
            [cell.firstButton setHidden:YES];
            [cell.secondButton setHidden:YES];
            [cell.thirdButton setHidden:YES];
        }else if([rowModel.progress_status integerValue]  == 4){
            [cell.typeLabel setHidden:YES];
            [cell.typeButton setHidden:NO];
            [cell.typeButton setImage:[UIImage imageNamed:@"list_chapter"] forState:0];
            [cell.firstButton setHidden:YES];
            [cell.secondButton setHidden:YES];
            [cell.thirdButton setHidden:NO];
            [cell.thirdButton setTitle:@"去评价" forState:0];
            QDFWeakSelf;
            [cell.thirdButton addAction:^(UIButton *btn) {
                [weakself goToCheckApplyRecordsOrAdditionMessage:@"去评价" withRow:indexPath.section];
            }];
        }
        
        cell.addressLabel.text = rowModel.seatmortgage;
        cell.moneyView.label1.text = rowModel.money;
        cell.moneyView.label2.text = @"借款本金(万元)";
        
//                    QDFWeakSelf;
//            [cell.secondButton addAction:^(UIButton *btn) {
    
//                AdditionMessageViewController *additionMessageVC = [[AdditionMessageViewController alloc] init];
//                additionMessageVC.categoryString = rowModel.category;
//                additionMessageVC.tModel = self.responseDataArray[0];
//                [weakself.navigationController pushViewController:additionMessageVC animated:YES];
                
//            }];
    
//            [cell.thirdButton addAction:^(UIButton *btn) {
//                ApplyRecordsViewController *applyRecordsVC = [[ApplyRecordsViewController alloc] init];
//                applyRecordsVC.idStr = rowModel.idString;
//                applyRecordsVC.categaryStr = rowModel.category;
//                [weakself.navigationController pushViewController:applyRecordsVC animated:YES];
//            }];
    
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
    RowsModel *sModel = self.releaseDataArray[indexPath.section];
    if ([sModel.progress_status isEqualToString:@"1"]) {//发布中
            MyPublishingViewController *myPublishingVC = [[MyPublishingViewController alloc] init];
            myPublishingVC.idString = sModel.idString;
            myPublishingVC.categaryString = sModel.category;
            myPublishingVC.reResponse = self.responseDataArray[0];
            [self.navigationController pushViewController:myPublishingVC animated:YES];
        }else if ([sModel.progress_status isEqualToString:@"2"]){//处理中
            MyDealingViewController *myDealingVC = [[MyDealingViewController alloc] init];
            myDealingVC.idString = sModel.idString;
            myDealingVC.categaryString = sModel.category;
            myDealingVC.pidString = sModel.pid;
            [self.navigationController pushViewController:myDealingVC animated:YES];

        }else if ([sModel.progress_status isEqualToString:@"3"]){//终止
            ReleaseEndViewController *releaseEndVC = [[ReleaseEndViewController alloc] init];
            releaseEndVC.idString = sModel.idString;
            releaseEndVC.categaryString = sModel.category;
            releaseEndVC.pidString = sModel.pid;
            [self.navigationController pushViewController:releaseEndVC animated:YES];
        }else if ([sModel.progress_status isEqualToString:@"4"]){//结案
            ReleaseCloseViewController *releaseCloseVC = [[ReleaseCloseViewController alloc] init];
            releaseCloseVC.idString = sModel.idString;
            releaseCloseVC.categaryString = sModel.category;
            releaseCloseVC.pidString = sModel.pid;
            [self.navigationController pushViewController:releaseCloseVC animated:YES];
        }
}

#pragma mark - method
- (void)getMyReleaseListWithPage:(NSString *)page
{
    NSString *myReleaseString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyReleaseString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"progress_status" : self.progreStatus,
                             @"limit" : @"10",
                             @"page" : page
                             };
    [self requestDataPostWithString:myReleaseString params:params successBlock:^(id responseObject) {
        
        if ([page intValue] == 0) {
            [self.releaseDataArray removeAllObjects];
        }
        
        ReleaseResponse *responseModel = [ReleaseResponse objectWithKeyValues:responseObject];
        
        [self.responseDataArray addObject:responseModel];

        if (responseModel.rows.count == 0) {
            [self showHint:@"没有更多了"];
            _pageRelease --;
        }
        
        for (RowsModel *rowsModel in responseModel.rows) {
            [self.releaseDataArray addObject:rowsModel];
        }
        
        if (self.releaseDataArray.count > 0) {
            [self.baseRemindImageView setHidden:YES];
        }else{
            [self.baseRemindImageView setHidden:NO];
        }
        
        [self.myReleaseTableView reloadData];
        
    } andFailBlock:^(NSError *error) {
        [self.myReleaseTableView reloadData];
    }];
}

- (void)refreshHeaderOfMyRelease
{
    _pageRelease = 0;
    [self getMyReleaseListWithPage:@"0"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.myReleaseTableView headerEndRefreshing];
    });
}

- (void)refreshFooterOfMyRelease
{
    _pageRelease ++;
    NSString *page = [NSString stringWithFormat:@"%d",_pageRelease];
    [self getMyReleaseListWithPage:page];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.myReleaseTableView footerEndRefreshing];
    });
}

- (void)goToCheckApplyRecordsOrAdditionMessage:(NSString *)string withRow:(NSInteger)row
{
    RowsModel *model = self.releaseDataArray[row];
    
   if([string isEqualToString:@"补充信息"]){
       AdditionMessageViewController *additionMessageVC = [[AdditionMessageViewController alloc] init];
//       additionMessageVC.meResponse = self.responseDataArray[0];
       additionMessageVC.categoryString = model.category;
       additionMessageVC.idString = model.idString;
       [self.navigationController pushViewController:additionMessageVC animated:YES];
   }else if ([string isEqualToString:@"查看申请"]){
      ApplyRecordsViewController *applyRecordsVC = [[ApplyRecordsViewController alloc] init];
       applyRecordsVC.idStr = model.idString;
       applyRecordsVC.categaryStr = model.category;
      [self.navigationController pushViewController:applyRecordsVC animated:YES];
   }
   else if ([string isEqualToString:@"查看进度"]){
        PaceViewController *paceVC = [[PaceViewController alloc] init];
       paceVC.idString = model.idString;
       paceVC.categoryString = model.category;
        [self.navigationController pushViewController:paceVC animated:YES];
    }else if ([string isEqualToString:@"联系接单方"]){
        
    }else if ([string isEqualToString:@"去评价"]){
        AdditionalEvaluateViewController *additionalEvaluateVC = [[AdditionalEvaluateViewController alloc] init];
        additionalEvaluateVC.typeString = @"发布方";
        additionalEvaluateVC.idString = model.idString;
        additionalEvaluateVC.categoryString = model.category;
        [self.navigationController pushViewController:additionalEvaluateVC animated:YES];
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
