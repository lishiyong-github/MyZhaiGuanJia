//
//  NewProductViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/4/26.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "NewProductViewController.h"
#import "HouseAssessViewController.h"  //房产评估
#import "ApplicationGuaranteeViewController.h" //申请保函
#import "PowerProtectViewController.h" //诉讼保权

#import "ProductsDetailsViewController.h" //详细信息
#import "MarkingViewController.h"
#import "LoginViewController.h" //登录
#import "AuthentyViewController.h"//认证

#import "NewPublishCell.h"
#import "HomeCell.h"
#import "FourCell.h"

#import "NewProductModel.h"
#import "NewProductListModel.h"

#import "UIImage+Color.h"
#import "UIViewController+BlurView.h"
#import "UIButton+WebCache.h"

@interface NewProductViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;

@property (nonatomic,strong) UIButton *titleView;
@property (nonatomic,strong) UITableView *mainTableView;
@property (nonatomic,strong) UIView *mainHeaderView;
@property (nonatomic,strong) UIScrollView *mainHeaderScrollView;
@property (nonatomic,strong) UIPageControl *pageControl;

//json解析
@property (nonatomic,strong) NSMutableArray *productsDataListArray;
@property (nonatomic,strong) NSMutableArray *propagandaDataArray;
@property (nonatomic,strong) NSMutableDictionary *propagandaDic;
@property (nonatomic,strong) NSString *trackViewUrl;
@end

@implementation NewProductViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:kBlackColor,NSFontAttributeName:kNavFont}];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:kNavColor] forBarMetrics:UIBarMetricsDefault];
    
    [self getRecommendProductslist];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.titleView = self.titleView;
    
    [self.view addSubview:self.mainTableView];
    [self.view setNeedsUpdateConstraints];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getPropagandaChar];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self chechAppNewVersion];
    });
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
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _mainTableView.backgroundColor = kBackColor;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorColor = kSeparateColor;
    }
    return _mainTableView;
}

- (UIView *)mainHeaderView
{
    if (!_mainHeaderView) {
        _mainHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 110)];
        _mainHeaderView.backgroundColor = kBackColor;
        [_mainHeaderView addSubview:self.mainHeaderScrollView];
        [_mainHeaderView addSubview:self.pageControl];
        [self.mainHeaderScrollView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        [self.pageControl autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:20];
        [self.pageControl autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.pageControl autoSetDimensionsToSize:CGSizeMake(kScreenWidth, 10)];
    }
    return _mainHeaderView;
}

- (UIScrollView *)mainHeaderScrollView
{
    if (!_mainHeaderScrollView) {
        _mainHeaderScrollView = [UIScrollView newAutoLayoutView];
        _mainHeaderScrollView.contentSize = CGSizeMake(kScreenWidth*self.propagandaDic.allKeys.count/2, 100);
        _mainHeaderScrollView.pagingEnabled = YES;//分页
        _mainHeaderScrollView.delegate = self;
        _mainHeaderScrollView.scrollEnabled = YES;
        _mainHeaderScrollView.showsHorizontalScrollIndicator = NO;
        
        for (NSInteger t=0; t<self.propagandaDic.allKeys.count/2; t++) {
            
            NSString *tyString = [NSString stringWithFormat:@"banner%dios",t+1];
            NSString *urlString = [NSString stringWithFormat:@"http://%@",self.propagandaDic[tyString]];
            NSURL *tyURL = [NSURL URLWithString:urlString];
            
            UIButton *imageButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth*t, 0, kScreenWidth, 100)];
            [imageButton sd_setBackgroundImageWithURL:tyURL forState:0 placeholderImage:[UIImage imageNamed:@"banner_account_bitmap"]];
            [_mainHeaderScrollView addSubview:imageButton];
            
            QDFWeakSelf;
            [imageButton addAction:^(UIButton *btn) {
                MarkingViewController *markingVC = [[MarkingViewController alloc] init];
                markingVC.hidesBottomBarWhenPushed = YES;
                NSString *wewe = [NSString stringWithFormat:@"banner%d",t+1];
                markingVC.markString = weakself.propagandaDic[wewe];
                [weakself.navigationController pushViewController:markingVC animated:YES];
            }];
        }
    }
    return _mainHeaderScrollView;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [UIPageControl newAutoLayoutView];
        _pageControl.numberOfPages = self.propagandaDic.allKeys.count/2;
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

- (NSMutableArray *)propagandaDataArray
{
    if (!_propagandaDataArray) {
        _propagandaDataArray = [NSMutableArray array];
    }
    return _propagandaDataArray;
}

- (NSMutableDictionary *)propagandaDic
{
    if (!_propagandaDic) {
        _propagandaDic = [NSMutableDictionary dictionary];
    }
    return _propagandaDic;
}

#pragma mark - tableView delelagte and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1+self.productsDataListArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 140;
    }
    return 156;//产品列表
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    if (indexPath.section == 0){
        identifier = @"main0";
        FourCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];
        if (!cell) {
            cell = [[FourCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        QDFWeakSelf;
        [cell setDidClickButton:^(NSInteger tag) {
            switch (tag) {
                case 11:{//房产评估
                    NSLog(@"房产评估");
                    HouseAssessViewController *houseAssessVC = [[HouseAssessViewController alloc] init];
                    houseAssessVC.hidesBottomBarWhenPushed = YES;
                    [weakself.navigationController pushViewController:houseAssessVC animated:YES];
                }
                    break;
                case 22:{//房屋产调
                    NSLog(@"房屋产调");
                }
                    break;
                case 33:{//诉讼保权
                    NSLog(@"诉讼保权");
                    PowerProtectViewController *powerProtectVC = [[PowerProtectViewController alloc] init];
                    powerProtectVC.hidesBottomBarWhenPushed = YES;
                    [weakself.navigationController pushViewController:powerProtectVC animated:YES];
                }
                    break;
                case 44:{//申请保函
                    NSLog(@"申请保函");
                    ApplicationGuaranteeViewController *applicationGuaranteeVC = [[ApplicationGuaranteeViewController alloc] init];
                    applicationGuaranteeVC.hidesBottomBarWhenPushed = YES;
                    [weakself.navigationController pushViewController:applicationGuaranteeVC animated:YES];
                }
                    break;
                default:
                    break;
            }
        }];
        return cell;
    }
    
    identifier = @"main1";
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];
    if (!cell) {
        cell = [[HomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NewProductListModel *newModel = self.productsDataListArray[indexPath.section-1];
    
    cell.moneyView.label1.text = [NSString getValidStringFromString:newModel.money toString:@"0"];
    cell.moneyView.label2.text = @"借款本金(万元)";
    
    if ([newModel.category isEqualToString:@"1"]) {//融资
        [cell.typeImageView setImage:[UIImage imageNamed:@"list_financing"]];
        cell.addressLabel.text = [NSString getValidStringFromString:newModel.location toString:@"无抵押物地址"];
        cell.pointView.label1.text = [NSString getValidStringFromString:newModel.rebate toString:@"0"];
        cell.pointView.label2.text = @"返点(%)";
        cell.rateView.label1.text = [NSString getValidStringFromString:newModel.rate toString:@"0"];
        if ([newModel.rate_cat isEqualToString:@"1"]) {
            cell.rateView.label2.text = @"借款利率(%/天)";
        }else{
            cell.rateView.label2.text = @"借款利率(%/月)";
        }
    }else if ([newModel.category isEqualToString:@"2"]){//清收
        [cell.typeImageView setImage:[UIImage imageNamed:@"list_collection"]];
        
        cell.pointView.label1.text = [NSString getValidStringFromString:newModel.agencycommission toString:@"0"];
        if ([newModel.agencycommissiontype isEqualToString:@"1"]) {
            cell.pointView.label2.text = @"提成比例(%)";
        }else{
            cell.pointView.label2.text = @"固定费用(万元)";
        }
        if ([newModel.loan_type isEqualToString:@"1"]) {
            cell.rateView.label1.text = @"房产抵押";
            cell.addressLabel.text = [NSString getValidStringFromString:newModel.location toString:@"无抵押物地址"];
        }else if ([newModel.loan_type isEqualToString:@"2"]){
            cell.rateView.label1.text = @"应收账款";
            cell.addressLabel.text = @"无抵押物地址";
        }else if ([newModel.loan_type isEqualToString:@"3"]){
            cell.rateView.label1.text = @"机动车抵押";
            cell.addressLabel.text = @"无抵押物地址";
        }else{
            cell.rateView.label1.text = @"无抵押";
            cell.addressLabel.text = @"无抵押物地址";
        }
        cell.rateView.label2.text = @"债权类型";
    }else{//诉讼
        [cell.typeImageView setImage:[UIImage imageNamed:@"list_litigation"]];
        cell.pointView.label1.text = [NSString getValidStringFromString:newModel.agencycommission toString:@"0"];
        if ([newModel.agencycommissiontype isEqualToString:@"1"]) {
            cell.pointView.label2.text = @"固定费用(万元)";
        }else{
            cell.pointView.label2.text = @"风险费率(%)";
        }
        if ([newModel.loan_type isEqualToString:@"1"]) {
            cell.rateView.label1.text = @"房产抵押";
            cell.addressLabel.text = [NSString getValidStringFromString:newModel.location toString:@"无抵押物地址"];
        }else if ([newModel.loan_type isEqualToString:@"2"]){
            cell.rateView.label1.text = @"应收账款";
            cell.addressLabel.text = @"无抵押物地址";
        }else if ([newModel.loan_type isEqualToString:@"3"]){
            cell.rateView.label1.text = @"机动车抵押";
            cell.addressLabel.text = @"无抵押物地址";
        }else{
            cell.rateView.label1.text = @"无抵押";
            cell.addressLabel.text = @"无抵押物地址";
        }
        cell.rateView.label2.text = @"债权类型";
    }
    
    cell.nameLabel.text = newModel.codeString;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return kSmallPadding;
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
                NewProductListModel *sModel = weakself.productsDataListArray[indexPath.section - 1];
                productsDetailVC.idString = sModel.idString;
                productsDetailVC.categoryString = sModel.category;
                [weakself.navigationController pushViewController:productsDetailVC animated:YES];
            }else if([model.code isEqualToString:@"3001"] || [self getValidateToken] == nil){//未登录
                [weakself showHint:model.msg];
                LoginViewController *loginVC = [[LoginViewController alloc] init];
                loginVC.hidesBottomBarWhenPushed = YES;
                [weakself.navigationController pushViewController:loginVC animated:YES];
            }else if([model.code isEqualToString:@"3006"]){//已登录，未认证
                [weakself showHint:model.msg];
                AuthentyViewController *authentyVC = [[AuthentyViewController alloc] init];
                authentyVC.hidesBottomBarWhenPushed = YES;
                authentyVC.typeAuthty = @"0";
                [weakself.navigationController pushViewController:authentyVC animated:YES];
            }
        }];
    }
}

#pragma mark - uiscrollViewdelegate and pageControlDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_pageControl) {
        self.pageControl.currentPage = scrollView.contentOffset.x/kScreenWidth;
    }
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
- (void)getRecommendProductslist
{
    NSString *recommendString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kProductsRecommendListString];
    NSDictionary *params = @{@"limit" : @"6"};
    
    QDFWeakSelf;
    [self requestDataPostWithString:recommendString params:params successBlock:^(id responseObject) {
        
        [weakself.productsDataListArray removeAllObjects];
        NewProductModel *model = [NewProductModel objectWithKeyValues:responseObject];
        for (NewProductListModel *listModel in model.result) {
            [weakself.productsDataListArray addObject:listModel];
        }
        [weakself.mainTableView reloadData];
    } andFailBlock:^(NSError *error) {
        
    }];
}

//轮播图
- (void)getPropagandaChar
{
    NSString *propagandaString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kPropagandaString];
    QDFWeakSelf;
    [self requestDataPostWithString:propagandaString params:nil successBlock:^(id responseObject) {
        NSDictionary *dedfr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        weakself.propagandaDic = [NSMutableDictionary dictionaryWithDictionary:dedfr];
        weakself.mainTableView.tableHeaderView = weakself.mainHeaderView;
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

#pragma mark - method
-(void)chechAppNewVersion
{
    //最新版本
    NSString *urlStr = [NSString stringWithFormat:@"http://itunes.apple.com/cn/lookup?id=%@",AppID];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *appInfoDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
    NSArray *resultArr = appInfoDic[@"results"];
    if (![resultArr count]) {
        return ;
    }
    
    NSDictionary *infoDic1 = resultArr[0];
    //需要version,trackViewUrl,trackName
    NSString *latestVersion = infoDic1[@"version"];
    _trackViewUrl = infoDic1[@"trackViewUrl"];
    NSString *trackName = infoDic1[@"trackName"];
    
    //当前版本
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleVersion"];
    
    //比较版本号
    NSString *s1 = [currentVersion substringToIndex:1];//当前
    NSString *s2 = [latestVersion substringToIndex:1];//最新
    if ([s1 integerValue] <= [s2 integerValue]) {//第一位
        NSString *s11 = [currentVersion substringWithRange:NSMakeRange(2,1)];
        NSString *s12 = [latestVersion substringWithRange:NSMakeRange(2,1)];

        if ([s11 intValue] < [s12 intValue]) {
            NSString *titleStr = [NSString stringWithFormat:@"检查更新:%@",trackName];
            NSString *messageStr = [NSString stringWithFormat:@"发现新版本(%@),是否升级?",latestVersion];
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:titleStr message:messageStr preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:nil];
            
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/us/app/qing-dao-fu-zhai-guan-jia/id1116869191?l=zh&ls=1&mt=8"]];
            }];
            
            [alertController addAction:action1];
            [alertController addAction:action2];
            [self presentViewController:alertController animated:YES completion:nil];
        }
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
