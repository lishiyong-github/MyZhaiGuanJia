//
//  HandleMatterViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/11/7.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "HandleMatterViewController.h"
#import "ReleaseEndListViewController.h"  //已终止列表
#import "MyOrderDetailViewController.h"//详情
#import "AdditionalEvaluateViewController.h"  //评价
#import "AddProgressViewController.h"  //添加进度

#import "EvaTopSwitchView.h"

#import "ExtendHomeCell.h"
#import "EvaTopSwitchView.h"

#import "ReleaseResponse.h"

#import "OrderResponse.h"
#import "OrderModel.h"
#import "OrdersModel.h"
#import "RowsModel.h"
#import "ApplyRecordModel.h"

@interface HandleMatterViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;

@property (nonatomic,strong) EvaTopSwitchView *releaseProView;
@property (nonatomic,strong) UITableView *handleTableView;
@property (nonatomic,strong) UIButton *endListButton;

@property (nonatomic,strong) NSString *progresType;  //1－进行中，2-已完成

//json解析
@property (nonatomic,strong) NSMutableArray *handleArray;
@property (nonatomic,assign) NSInteger pageHandle;//页数

@end

@implementation HandleMatterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"经办事项";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    self.progresType = @"1";
    
    [self.view addSubview:self.releaseProView];
    [self.view addSubview:self.handleTableView];
    [self.view addSubview:self.endListButton];
    [self.view addSubview:self.baseRemindImageView];
    [self.baseRemindImageView setHidden:YES];
    
    [self.view setNeedsUpdateConstraints];
    
    [self refreshHeaderOfHandleMatter];
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
        
        [self.handleTableView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.endListButton];
        [self.handleTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        
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
//            [weakself refreshHeaderOfMyRelease];
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
//            ReleaseEndListViewController *releaseEndListVC = [[ReleaseEndListViewController alloc] init];
//            releaseEndListVC.personType = @"1";
//            [weakself.navigationController pushViewController:releaseEndListVC animated:YES];
        }];
    }
    return _endListButton;
}

- (UITableView *)handleTableView
{
    if (!_handleTableView) {
        _handleTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _handleTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _handleTableView.backgroundColor = kBackColor;
        _handleTableView.separatorColor = kSeparateColor;
        _handleTableView.delegate = self;
        _handleTableView.dataSource = self;
        _handleTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
        [_handleTableView addHeaderWithTarget:self action:@selector(refreshHeaderOfHandleMatter)];
        [_handleTableView addFooterWithTarget:self action:@selector(refreshFooterOfHandleMatterList)];
    }
    return _handleTableView;
}

- (NSMutableArray *)handleArray
{
    if (!_handleArray) {
        _handleArray = [NSMutableArray array];
    }
    return _handleArray;
}


#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.handleArray.count;
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
    
    RowsModel *rowModel = self.handleArray[indexPath.section];
    
    //code
    [cell.nameButton setTitle:rowModel.number forState:0];
    
    //status and action
    cell.statusLabel.text = rowModel.statusLabel;
    
    if ([rowModel.statusLabel isEqualToString:@"处理中"]){
        [cell.actButton2 setTitle:@"查看进度" forState:0];
    }else if ([rowModel.statusLabel isEqualToString:@"已结案"]){
        [cell.actButton2 setTitle:@"评价" forState:0];
    }
    
    QDFWeakSelf;
    [cell.actButton2 addAction:^(UIButton *btn) {
//        [weakself goToCheckApplyRecordsOrAdditionMessage:btn.titleLabel.text withSection:indexPath.section withEvaString:@""];
    }];
    
    //details
    //委托本金
    NSString *orString0 = [NSString stringWithFormat:@"委托本金：%@万",rowModel.accountLabel];
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
    OrderModel *orderModel = self.handleArray[indexPath.section];
    
//    if ([self.personType integerValue] == 1) {//发布
//        
//    }else{
//        MyProcessingViewController *myProcessingVC = [[MyProcessingViewController alloc] init];
//        myProcessingVC.applyid = orderModel.applyid;
//        [self.navigationController pushViewController:myProcessingVC animated:YES];
//    }
}

#pragma mark - method
- (void)getHandleMatterListWithPage:(NSString *)page
{
    NSString *handleString;
    if ([self.progresType integerValue] == 1) {
//        handleString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kHandleMatterListOfProcessing];
    }else if ([self.progresType integerValue] == 2){
//        handleString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kHandleMatterListOfClose];
    }
    
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"limit" : @"10",
                             @"page" : page
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:handleString params:params successBlock:^(id responseObject) {
        
        NSDictionary *spspsp = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([page intValue] == 1) {
            [weakself.handleArray removeAllObjects];
        }
        
        OrderResponse *respondf = [OrderResponse objectWithKeyValues:responseObject];
        
        if (respondf.data.count == 0) {
            [weakself showHint:@"没有更多了"];
            _pageHandle --;
        }
        
        for (OrderModel *orderModel in respondf.data) {
            [weakself.handleArray addObject:orderModel];
        }
        
        if (weakself.handleArray.count > 0) {
            [weakself.baseRemindImageView setHidden:YES];
        }else{
            [weakself.baseRemindImageView setHidden:NO];
        }
        
        [weakself.handleTableView reloadData];
        
    } andFailBlock:^(NSError *error) {
        [weakself.handleTableView reloadData];
    }];
}

- (void)refreshHeaderOfHandleMatter
{
    _pageHandle = 1;
    [self getHandleMatterListWithPage:@"1"];
    
    QDFWeakSelf;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakself.handleTableView headerEndRefreshing];
    });
}

- (void)refreshFooterOfHandleMatterList
{
    _pageHandle ++;
    NSString *page = [NSString stringWithFormat:@"%ld",(long)_pageHandle];
    [self getHandleMatterListWithPage:page];
    
    QDFWeakSelf;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakself.handleTableView footerEndRefreshing];
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
