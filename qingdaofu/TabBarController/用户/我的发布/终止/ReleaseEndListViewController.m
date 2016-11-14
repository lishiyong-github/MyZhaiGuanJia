//
//  ReleaseEndListViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/10/14.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ReleaseEndListViewController.h"

#import "ReleaseEndViewController.h"  //详情
#import "MyDealingViewController.h"   //我的发布
#import "MyProcessingViewController.h"  //我的接单
#import "MyReleaseDetailsViewController.h"  //发布详情
#import "MyOrderDetailViewController.h"  //接单详情


#import "ExtendHomeCell.h"

#import "OrderResponse.h"
#import "OrderModel.h"
#import "OrdersModel.h"
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
    
    [self refreshHeaderOfMyReleaseEndList];
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
    static NSString *identifier;
    if ([self.personType integerValue] == 1) {
        identifier = @"myRelease";
        ExtendHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[ExtendHomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.detailTextLabel setHidden:YES];
        OrderModel *orderModel = self.releaseEndListArray[indexPath.section];
        //    RowsModel *orderModel = self.releaseDataArray[indexPath.section];
        //    RowsModel *product
        
        //code
        [cell.nameButton setTitle:orderModel.number forState:0];
        
        //status and action
        cell.statusLabel.text = orderModel.statusLabel;
        
        [cell.actButton2 setTitle:@"协商详情" forState:0];
        cell.actButton2.layer.borderColor = kBorderColor.CGColor;
        [cell.actButton2 setTitleColor:kLightGrayColor forState:0];
        
        QDFWeakSelf;
        [cell.actButton2 addAction:^(UIButton *btn) {
        }];
        
        //details
        //委托本金
        NSString *orString0 = [NSString stringWithFormat:@"委托本金：%@",orderModel.accountLabel];
        //债权类型
        NSString *orString1 = [NSString stringWithFormat:@"债权类型：%@",orderModel.categoryLabel];
        //委托事项
        NSString *orString2 = [NSString stringWithFormat:@"委托事项：%@",orderModel.entrustLabel];
        //委托费用
        NSString *orString3 = [NSString stringWithFormat:@"委托费用：%@%@",orderModel.typenumLabel,orderModel.typeLabel];
        
        //违约期限
        NSString *orString4 = [NSString stringWithFormat:@"违约期限：%@个月",orderModel.overdue];
        //合同履行地
        NSString *orString5 = [NSString stringWithFormat:@"合同履行地：%@",orderModel.addressLabel];
        
        NSString *orString = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@",orString0,orString1,orString2,orString3,orString4,orString5];
        NSMutableAttributedString *orAttributeStr = [[NSMutableAttributedString alloc] initWithString:orString];
        [orAttributeStr setAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kGrayColor} range:NSMakeRange(0, orString.length)];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        [style setLineSpacing:6];
        [orAttributeStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, orString.length)];
        [cell.contentButton setAttributedTitle:orAttributeStr forState:0];
        
        return cell;
    }else{
        identifier = @"myOrder";
        ExtendHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[ExtendHomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.detailTextLabel setHidden:YES];
        OrderModel *orderModel = self.releaseEndListArray[indexPath.section];
        RowsModel *rowModel = orderModel.product;
        
        //code
        [cell.nameButton setTitle:rowModel.number forState:0];
        
        //status and action
        cell.statusLabel.text = rowModel.statusLabel;
        
        [cell.actButton2 setTitle:@"协商详情" forState:0];
        cell.actButton2.layer.borderColor = kBorderColor.CGColor;
        [cell.actButton2 setTitleColor:kLightGrayColor forState:0];
        
        QDFWeakSelf;
        [cell.actButton2 addAction:^(UIButton *btn) {
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
    return nil;
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
    OrderModel *orderModel = self.releaseEndListArray[indexPath.section];
    
    if ([self.personType integerValue] == 1) {//发布
        MyReleaseDetailsViewController *myReleaseDetailsVC = [[MyReleaseDetailsViewController alloc] init];
        myReleaseDetailsVC.productid = orderModel.productid;
        [self.navigationController pushViewController:myReleaseDetailsVC animated:YES];
    }else{
        MyOrderDetailViewController *myOrderDetailVC = [[MyOrderDetailViewController alloc] init];
        myOrderDetailVC.applyid = orderModel.applyid;
        [self.navigationController pushViewController:myOrderDetailVC animated:YES];
    }
}

#pragma mark - method
- (void)getMyReleaseListWithPage:(NSString *)page
{
    NSString *myReleaseString;
    if ([self.personType integerValue] == 1) {//发布列表
        myReleaseString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyReleaseOfEndString];
    }else{//接单列表
        myReleaseString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyOrdersOfEndString];
    }
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"type" : @"0",
                             @"limit" : @"10",
                             @"page" : page
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:myReleaseString params:params successBlock:^(id responseObject) {
            
        if ([page intValue] == 1) {
            [weakself.releaseEndListArray removeAllObjects];
        }
        
        OrderResponse *respondf = [OrderResponse objectWithKeyValues:responseObject];
        
        if (respondf.data.count == 0) {
            [weakself showHint:@"没有更多了"];
            _pageReleaseList --;
        }
        
        for (OrderModel *orderModel in respondf.data) {
            [weakself.releaseEndListArray addObject:orderModel];
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
    
    QDFWeakSelf;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakself.releaseEndListTableView headerEndRefreshing];
    });
}

- (void)refreshFooterOfMyReleaseEndList
{
    _pageReleaseList ++;
    NSString *page = [NSString stringWithFormat:@"%ld",(long)_pageReleaseList];
    [self getMyReleaseListWithPage:page];
    
    QDFWeakSelf;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakself.releaseEndListTableView footerEndRefreshing];
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
