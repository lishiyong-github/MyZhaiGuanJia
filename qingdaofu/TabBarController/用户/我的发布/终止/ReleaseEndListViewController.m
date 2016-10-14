//
//  ReleaseEndListViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/10/14.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ReleaseEndListViewController.h"

#import "ReleaseEndViewController.h"  //详情

#import "ExtendHomeCell.h"
#import "EvaTopSwitchView.h"

#import "ReleaseResponse.h"
#import "RowsModel.h"

@interface ReleaseEndListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;

@property (nonatomic,strong) UITableView *releaseEndListTableView;

//json解析
@property (nonatomic,strong) NSMutableArray *releaseEndListArray;
@property (nonatomic,assign) NSInteger pageReleaseList;//页数


@end

@implementation ReleaseEndListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"已终止的";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.releaseEndListTableView];
    [self.view addSubview:self.baseRemindImageView];
    [self.baseRemindImageView setHidden:YES];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.releaseEndListTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        [self.baseRemindImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [self.baseRemindImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)releaseEndListTableView
{
    if (!_releaseEndListTableView) {
        _releaseEndListTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _releaseEndListTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _releaseEndListTableView.backgroundColor = kBackColor;
        _releaseEndListTableView.separatorColor = kSeparateColor;
        _releaseEndListTableView.delegate = self;
        _releaseEndListTableView.dataSource = self;
        _releaseEndListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
        [_releaseEndListTableView addHeaderWithTarget:self action:@selector(refreshHeaderOfMyReleaseEndList)];
        [_releaseEndListTableView addFooterWithTarget:self action:@selector(refreshFooterOfMyReleaseEndList)];
    }
    return _releaseEndListTableView;
}

- (NSMutableArray *)releaseEndListArray
{
    if (!_releaseEndListArray) {
        _releaseEndListArray = [NSMutableArray array];
    }
    return _releaseEndListArray;
}


#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.releaseEndListArray.count;
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
    RowsModel *rowModel = self.releaseEndListArray[indexPath.section];
    
    //code
    NSString *codeS = [NSString stringWithFormat:@"%@",rowModel.codeString];
    [cell.nameButton setTitle:codeS forState:0];
    
    //status and action
    
    //details
    //委托本金
    NSString *orString0 = [NSString stringWithFormat:@"委托本金：%@万",@"1000"];
    //债权类型
    NSString *orString1 = [NSString stringWithFormat:@"债权类型：%@",@"房产抵押，机动车抵押，合同纠纷"];
    //委托事项
    NSString *orString2 = [NSString stringWithFormat:@"委托事项：%@",@"清收，诉讼，债权转让"];
    //委托费用
    NSString *orSt;
    if ([rowModel.agencycommissiontype integerValue] == 1) {
        orSt = @"万";
    }else if ([rowModel.agencycommissiontype integerValue] == 2){
        orSt = @"％";
    }
    NSString *orString3 = [NSString stringWithFormat:@"委托费用：%@%@",rowModel.agencycommission,orSt];
    
    //违约期限
    NSString *orString4 = [NSString stringWithFormat:@"违约期限：%@个月",@"1"];
    //合同履行地
    NSString *orString5 = [NSString stringWithFormat:@"合同履行地：%@",@"上海上海市浦东新区"];
    
    NSString *orString = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@",orString0,orString1,orString2,orString3,orString4,orString5];
    NSMutableAttributedString *orAttributeStr = [[NSMutableAttributedString alloc] initWithString:orString];
    [orAttributeStr setAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kGrayColor} range:NSMakeRange(0, orString.length)];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:6];
    [orAttributeStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, orString.length)];
    [cell.contentButton setAttributedTitle:orAttributeStr forState:0];
    
    [cell.actButton2  setTitle:@"协商详情" forState:0];
    cell.actButton2.layer.borderColor = kBorderColor.CGColor;
    [cell.actButton2 setTitleColor:kLightGrayColor forState:0];
    
    return cell;
    
    /*
     //image
     if ([rowModel.category intValue] == 2){//清收
     [cell.nameButton setImage:[UIImage imageNamed:@"list_collection"] forState:0];
     }else if ([rowModel.category intValue] == 3){//诉讼
     [cell.nameButton setImage:[UIImage imageNamed:@"list_litigation"] forState:0];
     }
     
     //code
     NSString *codeS = [NSString stringWithFormat:@"%@",rowModel.codeString];
     [cell.nameButton setTitle:codeS forState:0];
     
     //status
     NSArray *statusArray = @[@"发布中",@"处理中",@"已终止",@"已结案"];
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
     
     //remind
     if ([rowModel.app_id isEqualToString:@"0"]) {
     [cell.deadLineButton setHidden:NO];
     [cell.deadLineButton setTitle:@"您有新的申请记录" forState:0];
     }else{
     [cell.deadLineButton setHidden:YES];
     }
     
     //action
     QDFWeakSelf;
     if ([rowModel.progress_status integerValue] == 1) {//发布中
     [cell.actButton1 setHidden:YES];
     [cell.actButton2 setHidden:NO];
     
     [cell.actButton2 setTitle:@"查看申请人" forState:0];
     [cell.actButton2 setTitleColor:kBlueColor forState:0];
     cell.actButton2.layer.borderColor = kBlueColor.CGColor;
     
     [cell.actButton2 addAction:^(UIButton *btn) {
     [weakself goToCheckApplyRecordsOrAdditionMessage:@"查看申请人" withSection:indexPath.section withEvaString:@""];
     }];
     }else if ([rowModel.progress_status integerValue] == 2) {//处理
     [cell.actButton1 setHidden:NO];
     [cell.actButton2 setHidden:NO];
     
     cell.actButton1.layer.borderColor = kBorderColor.CGColor;
     [cell.actButton1 setTitleColor:kBlackColor forState:0];
     [cell.actButton1 setTitle:@"联系接单方" forState:0];
     
     cell.actButton2.layer.borderColor = kBlueColor.CGColor;
     [cell.actButton2 setTitleColor:kBlueColor forState:0];
     [cell.actButton2 setTitle:@"查看进度" forState:0];
     
     [cell.actButton1 addAction:^(UIButton *btn) {
     [weakself goToCheckApplyRecordsOrAdditionMessage:@"联系接单方" withSection:indexPath.section withEvaString:@""];
     }];
     
     [cell.actButton2 addAction:^(UIButton *btn) {
     [weakself goToCheckApplyRecordsOrAdditionMessage:@"查看进度" withSection:indexPath.section withEvaString:@""];
     }];
     
     }else if ([rowModel.progress_status integerValue] == 3) {//终止
     [cell.actButton1 setHidden:YES];
     [cell.actButton2 setHidden:NO];
     
     [cell.actButton2 setTitle:@"删除订单" forState:0];
     [cell.actButton2 setTitleColor:kBlackColor forState:0];
     cell.actButton2.layer.borderColor = kBorderColor.CGColor;
     
     [cell.actButton2 addAction:^(UIButton *btn) {
     [weakself goToCheckApplyRecordsOrAdditionMessage:@"删除订单" withSection:indexPath.section withEvaString:@""];
     }];
     
     }else if ([rowModel.progress_status integerValue] == 4) {//结案
     [cell.actButton1 setHidden:NO];
     [cell.actButton2 setHidden:NO];
     
     cell.actButton1.layer.borderColor = kBorderColor.CGColor;
     [cell.actButton1 setTitleColor:kBlackColor forState:0];
     [cell.actButton1 setTitle:@"删除订单" forState:0];
     
     cell.actButton2.layer.borderColor = kBlueColor.CGColor;
     [cell.actButton2 setTitleColor:kBlueColor forState:0];
     
     NSString *id_category = [NSString stringWithFormat:@"%@_%@",rowModel.idString,rowModel.category];
     NSString *creditor = self.releaseDic[id_category];
     if ([creditor integerValue] == 0) {
     [cell.actButton2 setTitle:@"评价接单方" forState:0];
     [cell.actButton2 addAction:^(UIButton *btn) {
     [weakself goToCheckApplyRecordsOrAdditionMessage:@"评价接单方" withSection:indexPath.section withEvaString:@""];
     }];
     }else{
     [cell.actButton2 setTitle:@"查看评价" forState:0];
     [cell.actButton2 addAction:^(UIButton *btn) {
     [weakself goToCheckApplyRecordsOrAdditionMessage:@"查看评价" withSection:indexPath.section withEvaString:@""];
     }];
     }
     
     [cell.actButton1 addAction:^(UIButton *btn) {
     [weakself goToCheckApplyRecordsOrAdditionMessage:@"删除订单" withSection:indexPath.section withEvaString:@""];
     }];
     
     
     }
     
     return cell;
     
     */
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
    RowsModel *sModel = self.releaseEndListArray[indexPath.section];
    ReleaseEndViewController *releaseEndVC = [[ReleaseEndViewController alloc] init];
    releaseEndVC.idString = sModel.idString;
    releaseEndVC.categaryString = sModel.category;
    releaseEndVC.pidString = sModel.pid;
    [self.navigationController pushViewController:releaseEndVC animated:YES];
    
    /*
     if ([sModel.progress_status isEqualToString:@"1"]) {//发布中
     //        MyPublishingViewController *myPublishingVC = [[MyPublishingViewController alloc] init];
     //        myPublishingVC.idString = sModel.idString;
     //        myPublishingVC.categaryString = sModel.category;
     //        myPublishingVC.app_idString = sModel.app_id;
     //        [self.navigationController pushViewController:myPublishingVC animated:YES];
     
     //面谈中
     PublishInterviewViewController *publishInterviewVC = [[PublishInterviewViewController alloc] init];
     publishInterviewVC.idString = sModel.idString;
     publishInterviewVC.categaryString = sModel.category;
     publishInterviewVC.pidString = sModel.pid;
     [self.navigationController pushViewController:publishInterviewVC animated:YES];
     
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
     
     //        RowsModel *eModel = self.releaseEndListArray[indexPath.section];
     NSString *id_category = [NSString stringWithFormat:@"%@_%@",sModel.idString,sModel.category];
     NSString *value1 = self.releaseDic[id_category];
     
     ReleaseCloseViewController *releaseCloseVC = [[ReleaseCloseViewController alloc] init];
     releaseCloseVC.evaString = value1;
     releaseCloseVC.idString = sModel.idString;
     releaseCloseVC.categaryString = sModel.category;
     releaseCloseVC.pidString = sModel.pid;
     [self.navigationController pushViewController:releaseCloseVC animated:YES];
     }
     */
}

#pragma mark - method
- (void)getMyReleaseListWithPage:(NSString *)page
{
    NSString *myReleaseString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyReleaseString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"progress_status" : @"2",
                             @"limit" : @"10",
                             @"page" : page
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:myReleaseString params:params successBlock:^(id responseObject) {
        
        if ([page intValue] == 1) {
            [weakself.releaseEndListArray removeAllObjects];
//            [weakself.releaseDic removeAllObjects];
        }
        
        ReleaseResponse *responseModel = [ReleaseResponse objectWithKeyValues:responseObject];
        
        if (responseModel.rows.count == 0) {
            [weakself showHint:@"没有更多了"];
            _pageReleaseList --;
        }
        
//        [weakself.releaseDic setValuesForKeysWithDictionary:responseModel.creditor];
        
        for (RowsModel *rowsModel in responseModel.rows) {
            [weakself.releaseEndListArray addObject:rowsModel];
        }
        
        if (weakself.releaseEndListArray.count > 0) {
            [weakself.baseRemindImageView setHidden:YES];
        }else{
            [weakself.baseRemindImageView setHidden:NO];
        }
        
        [weakself.releaseEndListTableView reloadData];
        
    } andFailBlock:^(NSError *error) {
        [weakself.releaseEndListTableView reloadData];
    }];
}

- (void)refreshHeaderOfMyReleaseEndList
{
    _pageReleaseList = 1;
    [self getMyReleaseListWithPage:@"1"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.releaseEndListTableView headerEndRefreshing];
    });
}

- (void)refreshFooterOfMyReleaseEndList
{
    _pageReleaseList ++;
    NSString *page = [NSString stringWithFormat:@"%ld",(long)_pageReleaseList];
    [self getMyReleaseListWithPage:page];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.releaseEndListTableView footerEndRefreshing];
    });
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
