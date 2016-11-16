//
//  MyReleaseViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/4.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MyReleaseViewController.h"

#import "ReleaseEndListViewController.h"  //终止列表
#import "MyReleaseDetailsViewController.h"  //详情

#import "ApplyRecordViewController.h"     //查看申请
#import "PaceViewController.h"          //查看进度
#import "CheckDetailPublishViewController.h"  //联系接单方
#import "AdditionalEvaluateViewController.h"  //去评价
#import "EvaluateListsViewController.h"  //查看评价
#import "MoreMessagesViewController.h"  //完善信息

#import "ExtendHomeCell.h"
#import "EvaTopSwitchView.h"

#import "ReleaseResponse.h"
#import "RowsModel.h"
#import "OrdersModel.h"

@interface MyReleaseViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;

@property (nonatomic,strong) EvaTopSwitchView *releaseProView;
@property (nonatomic,strong) UITableView *myReleaseTableView;
@property (nonatomic,strong) UIButton *endListButton;

//json解析
@property (nonatomic,strong) NSMutableArray *releaseDataArray;

@property (nonatomic,assign) NSInteger pageRelease;//页数
@property (nonatomic,strong) NSString *progresType;  //1－进行中，2-已完成

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
    
    self.progresType = @"1";

    [self.view addSubview:self.releaseProView];
    [self.view addSubview:self.endListButton];
    [self.view addSubview:self.myReleaseTableView];
    [self.view addSubview:self.baseRemindImageView];
    [self.baseRemindImageView setHidden:YES];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.releaseProView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.releaseProView autoSetDimension:ALDimensionHeight toSize:kCellHeight1];
        
        [self.endListButton autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.endListButton autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.endListButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.releaseProView];
        [self.endListButton autoSetDimension:ALDimensionHeight toSize:kCellHeight1];
        
        [self.myReleaseTableView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.endListButton];
        [self.myReleaseTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        
        [self.baseRemindImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [self.baseRemindImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (EvaTopSwitchView *)releaseProView
{
    if (!_releaseProView) {
        _releaseProView = [EvaTopSwitchView newAutoLayoutView];
        [_releaseProView.shortLineLabel setHidden:YES];
        
        [_releaseProView.getbutton setTitle:@"进行中" forState:0];
        [_releaseProView.sendButton setTitle:@"已完成" forState:0];
        
        QDFWeakSelf;
        [_releaseProView setDidSelectedButton:^(NSInteger tag) {
            if (tag == 33) {
                weakself.progresType = @"1";
            }else if (tag == 34){
                weakself.progresType = @"2";
            }
            [weakself refreshHeaderOfMyRelease];
        }];
    }
    return _releaseProView;
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
            releaseEndListVC.personType = @"1";
            [weakself.navigationController pushViewController:releaseEndListVC animated:YES];
        }];
    }
    return _endListButton;
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
    
    RowsModel *rowModel = self.releaseDataArray[indexPath.section];
    
    //code
    [cell.nameButton setTitle:rowModel.number forState:0];
    
    //status and action
    cell.statusLabel.text = rowModel.statusLabel;
    
    if ([rowModel.statusLabel isEqualToString:@"发布中"]) {
        [cell.actButton2 setTitle:@"完善资料" forState:0];
    }else if ([rowModel.statusLabel isEqualToString:@"面谈中"]){
        [cell.actButton2 setTitle:@"联系申请方" forState:0];
    }else if ([rowModel.statusLabel isEqualToString:@"处理中"]){
        [cell.actButton2 setTitle:@"查看进度" forState:0];
    }else if ([rowModel.statusLabel isEqualToString:@"已结案"]){
        [cell.actButton2 setTitle:@"评价" forState:0];
    }
    
    QDFWeakSelf;
    [cell.actButton2 addAction:^(UIButton *btn) {
        [weakself goToCheckApplyRecordsOrAdditionMessage:btn.titleLabel.text withSection:indexPath.section withEvaString:@""];
    }];
    
    //details
    //委托本金
    NSString *orString0 = [NSString stringWithFormat:@"委托本金：%@",rowModel.accountLabel];
    //债权类型
    NSString *orString1 = [NSString stringWithFormat:@"债权类型：%@",rowModel.categoryLabel];
    //委托事项
    NSString *orString2 = [NSString stringWithFormat:@"委托事项：%@",rowModel.entrustLabel];
    //委托费用
    NSString *orString3 = [NSString stringWithFormat:@"委托费用：%@%@",rowModel.typenumLabel,rowModel.typeLabel];
    
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
    RowsModel *sModel = self.releaseDataArray[indexPath.section];

    MyReleaseDetailsViewController *myReleaseDetailsVC = [[MyReleaseDetailsViewController alloc] init];
    myReleaseDetailsVC.productid = sModel.productid;
    [self.navigationController pushViewController:myReleaseDetailsVC animated:YES];
}

#pragma mark - method
- (void)getMyReleaseListWithPage:(NSString *)page
{
    NSString *myReleaseString;
    if ([self.progresType integerValue] == 1) {
        myReleaseString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyReleaseOfIngString];
    }else if ([self.progresType integerValue] == 2){
        myReleaseString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyReleaseOfFinishedString];
    }
    
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"limit" : @"10",
                             @"page" : page
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:myReleaseString params:params successBlock:^(id responseObject) {
        
        NSDictionary *sososo = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([page intValue] == 1) {
            [weakself.releaseDataArray removeAllObjects];
        }
        
        ReleaseResponse *responseModel = [ReleaseResponse objectWithKeyValues:responseObject];

        if (responseModel.data.count == 0) {
            [weakself showHint:@"没有更多了"];
            _pageRelease --;
        }
        
        for (RowsModel *rowsModel in responseModel.data) {
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



- (void)goToCheckApplyRecordsOrAdditionMessage:(NSString *)string withSection:(NSInteger)section withEvaString:(NSString *)evaString
{
    RowsModel *ymodel = self.releaseDataArray[section];
    
    if ([string isEqualToString:@"完善资料"]) {//发布成功
        MoreMessagesViewController *moreMessagesVC = [[MoreMessagesViewController alloc] init];
        moreMessagesVC.productid = ymodel.productid;
        [self.navigationController pushViewController:moreMessagesVC animated:YES];
    }else if ([string isEqualToString:@"联系申请方"]) {//面谈中
        CheckDetailPublishViewController *checkDetailPublishVC = [[CheckDetailPublishViewController alloc] init];
        checkDetailPublishVC.navTitle = @"申请方详情";
        checkDetailPublishVC.productid = ymodel.productid;
        checkDetailPublishVC.userid = ymodel.productApply.create_by;
        [self.navigationController pushViewController:checkDetailPublishVC animated:YES];
        
        if ([ymodel.productApply.mobile isEqualToString:@""] || !ymodel.productApply.mobile || ymodel.productApply.mobile == nil) {
            [self showHint:@"申请方未认证，不能打电话"];
        }else{
            NSMutableString *phoneStr = [NSMutableString stringWithFormat:@"telprompt://%@",ymodel.productApply.mobile];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr]];
        }
    }if ([string isEqualToString:@"查看进度"]) {//处理中
        PaceViewController *paceVC = [[PaceViewController alloc] init];
        paceVC.processid = ymodel.productid;
        [self.navigationController pushViewController:paceVC animated:YES];
    }if ([string isEqualToString:@"评价"]) {//结案
        AdditionalEvaluateViewController *additionalEvaluateVC = [[AdditionalEvaluateViewController alloc] init];
        additionalEvaluateVC.ordersid = ymodel.productApply.orders.ordersid;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:additionalEvaluateVC];
        [self presentViewController:nav animated:YES completion:nil];
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
