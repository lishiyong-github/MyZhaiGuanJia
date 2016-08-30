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

#import "ApplyRecordsViewController.h"     //查看申请
#import "PaceViewController.h"          //查看进度
#import "CheckDetailPublishViewController.h"  //联系接单方
#import "AdditionalEvaluateViewController.h"  //去评价

//#import "AnotherHomeCell.h"
#import "ExtendHomeCell.h"
#import "AllProSegView.h"

#import "ReleaseResponse.h"
#import "RowsModel.h"

@interface MyReleaseViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) AllProSegView *releaseProView;
@property (nonatomic,strong) UITableView *myReleaseTableView;

//json解析
@property (nonatomic,strong) NSMutableArray *releaseDataArray;
@property (nonatomic,strong) NSMutableDictionary *releaseDic;

@property (nonatomic,assign) NSInteger pageRelease;//页数


@end

@implementation MyReleaseViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self refreshHeaderOfMyRelease];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的发布";
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
        _myReleaseTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _myReleaseTableView.backgroundColor = kBackColor;
        _myReleaseTableView.separatorColor = kSeparateColor;
        _myReleaseTableView.delegate = self;
        _myReleaseTableView.dataSource = self;
        _myReleaseTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
        [_myReleaseTableView addHeaderWithTarget:self action:@selector(refreshHeaderOfMyRelease)];
        [_myReleaseTableView addFooterWithTarget:self action:@selector(refreshFooterOfMyRelease)];
    }
    return _myReleaseTableView;
}

- (NSMutableArray *)releaseDataArray
{
    if (!_releaseDataArray) {
        _releaseDataArray = [NSMutableArray array];
    }
    return _releaseDataArray;
}

- (NSMutableDictionary *)releaseDic
{
    if (!_releaseDic) {
        _releaseDic = [NSMutableDictionary dictionary];
    }
    return _releaseDic;
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
//    RowsModel *rModel = self.releaseDataArray[indexPath.section];
//    if ([rModel.progress_status intValue] == 3) {//终止
//        return 160;
//    }else if ([rModel.progress_status integerValue] == 4){//结案
//        NSString *id_category = [NSString stringWithFormat:@"%@_%@",rModel.idString,rModel.category];
//        NSString *value = self.releaseDic[id_category];
//        if ([value integerValue] == 2) {//不能评价
//            return 160;
//        }
//    }
    return 200;
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
    cell.nameButton.userInteractionEnabled = NO;
    cell.deadLineButton.userInteractionEnabled = NO;
    RowsModel *rowModel = self.releaseDataArray[indexPath.section];
    
    //image
    if ([rowModel.category intValue] == 2){//清收
        [cell.nameButton setImage:[UIImage imageNamed:@"list_collection"] forState:0];
    }else if ([rowModel.category intValue] == 3){//诉讼
        [cell.nameButton setImage:[UIImage imageNamed:@"list_litigation"] forState:0];
    }
    
    //code
    NSString *codeS = [NSString stringWithFormat:@"  %@",rowModel.codeString];
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
    
    //remind
    if ([rowModel.app_id isEqualToString:@"0"]) {
        [cell.deadLineButton setHidden:NO];
        [cell.deadLineButton setTitle:@"您有新的申请记录" forState:0];
    }else{
        [cell.deadLineButton setHidden:YES];
    }
    
    //action
    if ([rowModel.progress_status integerValue] == 1) {//发布中
        [cell.actButton1 setHidden:YES];
        [cell.actButton2 setHidden:NO];
        
        [cell.actButton2 setTitle:@"查看申请人" forState:0];
        [cell.actButton2 setTitleColor:kBlueColor forState:0];
        cell.actButton2.layer.borderColor = kBlueColor.CGColor;
    }else if ([rowModel.progress_status integerValue] == 2) {//处理
        [cell.actButton1 setHidden:NO];
        [cell.actButton2 setHidden:NO];
        
        cell.actButton1.layer.borderColor = kBorderColor.CGColor;
        [cell.actButton1 setTitleColor:kBlackColor forState:0];
        [cell.actButton1 setTitle:@"联系接单方" forState:0];
        
        cell.actButton2.layer.borderColor = kBlueColor.CGColor;
        [cell.actButton2 setTitleColor:kBlueColor forState:0];
        [cell.actButton2 setTitle:@"查看进度" forState:0];
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
        [cell.actButton2 setTitle:@"评价接单方" forState:0];
    }
    
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
        myPublishingVC.app_idString = sModel.app_id;
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
        
//        RowsModel *eModel = self.releaseDataArray[indexPath.section];
        NSString *id_category = [NSString stringWithFormat:@"%@_%@",sModel.idString,sModel.category];
        NSString *value1 = self.releaseDic[id_category];
        
        ReleaseCloseViewController *releaseCloseVC = [[ReleaseCloseViewController alloc] init];
        releaseCloseVC.evaString = value1;
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
    QDFWeakSelf;
    [self requestDataPostWithString:myReleaseString params:params successBlock:^(id responseObject) {
        
        
        NSDictionary *aoao = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        
        if ([page intValue] == 1) {
            [weakself.releaseDataArray removeAllObjects];
            [weakself.releaseDic removeAllObjects];
        }
        
        ReleaseResponse *responseModel = [ReleaseResponse objectWithKeyValues:responseObject];

        if (responseModel.rows.count == 0) {
            [weakself showHint:@"没有更多了"];
            _pageRelease --;
        }
        
        [weakself.releaseDic setValuesForKeysWithDictionary:responseModel.creditor];
        
        for (RowsModel *rowsModel in responseModel.rows) {
            [weakself.releaseDataArray addObject:rowsModel];
        }
        
        if (weakself.releaseDataArray.count > 0) {
            [weakself.baseRemindImageView setHidden:YES];
        }else{
            [weakself.baseRemindImageView setHidden:NO];
        }
        
        [weakself.myReleaseTableView reloadData];
        
    } andFailBlock:^(NSError *error) {
        [weakself.myReleaseTableView reloadData];
    }];
}

- (void)refreshHeaderOfMyRelease
{
    _pageRelease = 1;
    [self getMyReleaseListWithPage:@"1"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.myReleaseTableView headerEndRefreshing];
    });
}

- (void)refreshFooterOfMyRelease
{
    _pageRelease ++;
    NSString *page = [NSString stringWithFormat:@"%ld",(long)_pageRelease];
    [self getMyReleaseListWithPage:page];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.myReleaseTableView footerEndRefreshing];
    });
}

- (void)goToCheckApplyRecordsOrAdditionMessage:(NSString *)string withRow:(NSInteger)row withEvaString:(NSString *)evaString
{
    RowsModel *model = self.releaseDataArray[row];
    
   if ([string isEqualToString:@"查看申请"]){
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
        CheckDetailPublishViewController *checkDetailPublishVC = [[CheckDetailPublishViewController alloc] init];
        checkDetailPublishVC.typeString = @"接单方";
        checkDetailPublishVC.idString = model.idString;
        checkDetailPublishVC.categoryString = model.category;
        checkDetailPublishVC.pidString = model.pid;
        checkDetailPublishVC.typeDegreeString = @"处理中";
        [self.navigationController pushViewController:checkDetailPublishVC animated:YES];
    }else if ([string isEqualToString:@"评价"]){
        AdditionalEvaluateViewController *additionalEvaluateVC = [[AdditionalEvaluateViewController alloc] init];
        additionalEvaluateVC.idString = model.idString;
        additionalEvaluateVC.categoryString = model.category;
        additionalEvaluateVC.codeString = model.codeString;
        additionalEvaluateVC.typeString = @"发布方";
        additionalEvaluateVC.evaString = evaString;
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
