//
//  NewProductViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/4/26.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "NewProductViewController.h"

#import "ReportFinanceViewController.h"  //发布融资
#import "ReportSuitViewController.h"   //发布诉讼
//#import "ReportCollectViewController.h" //发布请收
#import "ProductsDetailsViewController.h" //详细信息
#import "MarkingViewController.h"

#import "NewPublishCell.h"
#import "HomeCell.h"
#import "FourCell.h"

#import "UIImage+Color.h"

#import "NewProductModel.h"
#import "NewProductListModel.h"

#import "UIViewController+BlurView.h"
#import "UIViewController+SelectedIndex.h"

@interface NewProductViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;

@property (nonatomic,strong) UIButton *titleView;
@property (nonatomic,strong) UITableView *mainTableView;
@property (nonatomic,strong) UIScrollView *mainHeaderScrollView;
@property (nonatomic,strong) UIPageControl *pageControl;

@property (nonatomic,strong) NSMutableArray *productsDataListArray;
@property (nonatomic,assign) NSInteger newPage;
@end

@implementation NewProductViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:kBlackColor,NSFontAttributeName:kNavFont}];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:kNavColor] forBarMetrics:UIBarMetricsDefault];
    
    [self getRecommendProductslistWithPage:@"0"];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.titleView = self.titleView;
    
    [self.view addSubview:self.mainTableView];
    [self.view setNeedsUpdateConstraints];
}

- (UIButton *)titleView
{
    if (!_titleView) {
        _titleView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
        [_titleView setImage:[UIImage imageNamed:@"nav_logo"] forState:0];
    }
    return _titleView;
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.mainTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.mainTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kTabBarHeight];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        _mainTableView.backgroundColor = kBackColor;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 110)];
        [_mainTableView.tableHeaderView addSubview:self.mainHeaderScrollView];
        [_mainTableView addSubview:self.pageControl];
        [_mainTableView addFooterWithTarget:self action:@selector(footerRefreshOfRecommend)];
        _mainTableView.separatorColor = kSeparateColor;
    }
    return _mainTableView;
}

- (UIScrollView *)mainHeaderScrollView
{
    if (!_mainHeaderScrollView) {
        _mainHeaderScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
        _mainHeaderScrollView.backgroundColor = kBackColor;
        _mainHeaderScrollView.contentSize = CGSizeMake(kScreenWidth*3, 100);
        _mainHeaderScrollView.pagingEnabled = YES;//分页
        _mainHeaderScrollView.delegate = self;
        _mainHeaderScrollView.scrollEnabled = YES;
        _mainHeaderScrollView.showsHorizontalScrollIndicator = NO;
        
        NSArray *colorArray = @[kYellowColor,kRedColor,kLightGrayColor];
        for (int t=0; t<3; t++) {
            UIButton *imageButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth*t, 0, kScreenWidth, 100)];
            [imageButton setBackgroundColor:colorArray[t]];
            [_mainHeaderScrollView addSubview:imageButton];
            
            QDFWeakSelf;
            [imageButton addAction:^(UIButton *btn) {
                MarkingViewController *markingVC = [[MarkingViewController alloc] init];
                markingVC.hidesBottomBarWhenPushed = YES;
                [weakself.navigationController pushViewController:markingVC animated:YES];
            }];
        }
    }
    return _mainHeaderScrollView;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(-kScreenWidth/2, 80, kScreenWidth, 10)];
        _pageControl.numberOfPages = 3;
        _pageControl.currentPage = 0;
        _pageControl.pageIndicatorTintColor = UIColorFromRGB1(0xffffff, 0.5);
        _pageControl.currentPageIndicatorTintColor = kBlueColor;
        [_pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
    }
    return _pageControl;
}

- (NSMutableArray *)productsDataListArray
{
    if (!_productsDataListArray) {
        _productsDataListArray = [NSMutableArray array];
    }
    return _productsDataListArray;
}

#pragma mark - tableView delelagte and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2+self.productsDataListArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 110;
    }else if (indexPath.section == 1){
        return 160;
    }
    return 156;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    if (indexPath.section == 0){
        identifier = @"main0";
        NewPublishCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[NewPublishCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        QDFWeakSelf;
        [cell.financeButton addAction:^(UIButton *btn) {//融资
            ReportFinanceViewController *reportFinanceVC = [[ReportFinanceViewController alloc] init];
            reportFinanceVC.hidesBottomBarWhenPushed = YES;
            [weakself.navigationController pushViewController:reportFinanceVC animated:YES];
        }];
        
        [cell.collectionButton addAction:^(UIButton *btn) {//清收
            ReportSuitViewController *reportCollectVC = [[ReportSuitViewController alloc] init];
            reportCollectVC.hidesBottomBarWhenPushed = YES;
            reportCollectVC.categoryString = @"2";
            reportCollectVC.tagString = @"1";
            [weakself.navigationController pushViewController:reportCollectVC animated:YES];
        }];
        
        [cell.suitButton addAction:^(UIButton *btn) {//诉讼
            ReportSuitViewController *reportSuitVC = [[ReportSuitViewController alloc] init];
            reportSuitVC.hidesBottomBarWhenPushed = YES;
            reportSuitVC.categoryString = @"3";
            reportSuitVC.tagString = @"1";
            [weakself.navigationController pushViewController:reportSuitVC animated:YES];
        }];
        
        return cell;
        
    }else if (indexPath.section == 1){
        identifier = @"main1";
        FourCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];
        if (!cell) {
            cell = [[FourCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell setDidClickButton:^(NSInteger tag) {
            switch (tag) {
                case 11:{//房产评估
                    NSLog(@"房产评估");
                }
                    break;
                case 22:{//房屋产调
                    NSLog(@"房屋产调");
                }
                    break;
                case 33:{//诉讼保全
                    NSLog(@"诉讼保全");
                }
                    break;
                case 44:{//申请保函
                    NSLog(@"申请保函");
                }
                    break;
                default:
                    break;
            }
        }];
        
        return cell;
    }
    
    identifier = @"main2";
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];
    if (!cell) {
        cell = [[HomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NewProductListModel *newModel = self.productsDataListArray[indexPath.section-2];
    
    cell.moneyView.label1.text = newModel.money;
    cell.moneyView.label2.text = @"借款本金(万元)";
    
    if ([newModel.category isEqualToString:@"1"]) {//融资
        [cell.typeImageView setImage:[UIImage imageNamed:@"list_financing"]];
        cell.pointView.label1.text = newModel.rebate;
        cell.pointView.label2.text = @"返点(%)";
        cell.rateView.label1.text = newModel.rate;
        if ([newModel.rate_cat isEqualToString:@"1"]) {
            cell.rateView.label2.text = @"借款利率(天)";
        }else{
            cell.rateView.label2.text = @"借款利率(月)";
        }
    }else if ([newModel.category isEqualToString:@"2"]){//清收
        [cell.typeImageView setImage:[UIImage imageNamed:@"list_collection"]];
        
        cell.pointView.label1.text = newModel.agencycommission;
        cell.pointView.label2.text = @"代理费用(万元)";
        if ([newModel.loan_type isEqualToString:@"1"]) {
            cell.rateView.label1.text = @"房产抵押";
        }else if ([newModel.loan_type isEqualToString:@"2"]){
            cell.rateView.label1.text = @"应收账款";
        }else if ([newModel.loan_type isEqualToString:@"3"]){
            cell.rateView.label1.text = @"机动车抵押";
        }else{
            cell.rateView.label1.text = @"无抵押";
        }
        cell.rateView.label2.text = @"债权类型";
    }else{//诉讼
        [cell.typeImageView setImage:[UIImage imageNamed:@"list_litigation"]];
        cell.pointView.label1.text = newModel.agencycommission;
        if ([newModel.agencycommissiontype isEqualToString:@"1"]) {
            cell.pointView.label2.text = @"固定费用(万)";
        }else{
            cell.pointView.label2.text = @"风险费率(%)";
        }
        if ([newModel.loan_type isEqualToString:@"1"]) {
            cell.rateView.label1.text = @"房产抵押";
        }else if ([newModel.loan_type isEqualToString:@"2"]){
            cell.rateView.label1.text = @"应收账款";
        }else if ([newModel.loan_type isEqualToString:@"3"]){
            cell.rateView.label1.text = @"机动车抵押";
        }else{
            cell.rateView.label1.text = @"无抵押";
        }
        cell.rateView.label2.text = @"债权类型";
    }
    
    cell.nameLabel.text = newModel.codeString;
    cell.addressLabel.text = newModel.location?newModel.location:@"无抵押物地址";
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return kBigPadding;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section > 0) {
        
        [self tokenIsValid];
        
        QDFWeakSelf;
        [self setDidTokenValid:^(TokenModel *model) {
            if ([model.code isEqualToString:@"0000"]) {//正常
                ProductsDetailsViewController *productsDetailVC = [[ProductsDetailsViewController alloc] init];
                productsDetailVC.hidesBottomBarWhenPushed = YES;
                NewProductListModel *sModel = weakself.productsDataListArray[indexPath.section - 2];
                productsDetailVC.idString = sModel.idString;
                productsDetailVC.categoryString = sModel.category;
                [weakself.navigationController pushViewController:productsDetailVC animated:YES];
            }else {//token过期,或未认证（code=3001过期   code=3006未认证）
                [weakself showHint:model.msg];
            }
        }];
    }
}

#pragma mark - uiscrollViewdelegate and pageControlDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = scrollView.contentOffset.x/kScreenWidth;
}

- (void)pageTurn:(UIPageControl *)page
{
//    CATransaction *transition;
//    int secondPage = [page currentPage];
//    if (secondPage > [page currentPage]) {
////        transition = [self get];
//    }else{
//        
//    }
    self.mainHeaderScrollView.contentOffset = CGPointMake([page currentPage]*kScreenWidth, 0);
    
    
//    CATransition *transition;
//    int secondPage = [pageControl currentPage];
//    if((secondPage - currentPage)>0)
//        transition = [self getAnimation:@"fromRight"];
//    else
//        transition = [self getAnimation:@"fromLeft"];
//    
//    UIImageView *newView = (UIImageView *)[[contentView subviews] objectAtIndex:0];
//    [newView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ipad_wallpaper%02d.jpg",secondPage+1]]];
//    [contentView exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
//    [[contentView layer] addAnimation:transition forKey:@"transitionView Animation"];
//    
//    currentPage = [pageControl currentPage];
}

#pragma mark - method
- (void)getRecommendProductslistWithPage:(NSString *)page
{
    NSString *recommendString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kProductsRecommendListString];
    NSDictionary *params = @{@"page" : page};
    
    [self requestDataPostWithString:recommendString params:params successBlock:^(id responseObject) {
        if ([page intValue] == 0) {
            [self.productsDataListArray removeAllObjects];
        }
        
        NewProductModel *model = [NewProductModel objectWithKeyValues:responseObject];
        
        if (model.result.count == 0) {
            [self showHint:@"没有更多了"];
            _newPage--;
        }
        
        for (NewProductListModel *listModel in model.result) {
            [self.productsDataListArray addObject:listModel];
        }
        
        [self.mainTableView reloadData];

    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)footerRefreshOfRecommend
{
    _newPage++;
    NSString *page = [NSString stringWithFormat:@"%d",_newPage];
    [self getRecommendProductslistWithPage:page];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.mainTableView footerEndRefreshing];
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
