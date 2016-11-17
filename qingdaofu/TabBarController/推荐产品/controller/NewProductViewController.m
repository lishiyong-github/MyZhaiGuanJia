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
#import "PowerProtectViewController.h" //诉讼保全
#import "HousePropertyViewController.h" //产调

#import "ProductsDetailsViewController.h" //详细信息
#import "MarkingViewController.h"
#import "LoginViewController.h" //登录
#import "AuthentyViewController.h"//认证

//#import "NewPublishCell.h"
//#import "HomeCell.h"
#import "FourCell.h"
#import "HomesCell.h"

//#import "NewProductModel.h"
//#import "NewProductListModel.h"

#import "ReleaseResponse.h"
#import "RowsModel.h";

#import "UIImage+Color.h"
#import "UIViewController+BlurView.h"
#import "UIButton+WebCache.h"

@interface NewProductViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIGestureRecognizerDelegate>

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
    
//    QDFWeakSelf;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [weakself chechAppNewVersion];
//    });
//    
//    [self performSelector:@selector(chechAppNewVersion) withObject:nil afterDelay:10];
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
        _mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
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
        _mainHeaderScrollView.contentSize = CGSizeMake(kScreenWidth*self.propagandaDic.allKeys.count/2, 110);
        _mainHeaderScrollView.pagingEnabled = YES;//分页
        _mainHeaderScrollView.delegate = self;
        _mainHeaderScrollView.scrollEnabled = YES;
        _mainHeaderScrollView.showsHorizontalScrollIndicator = NO;
        
        for (NSInteger t=0; t<self.propagandaDic.allKeys.count/2; t++) {
            
            NSString *tyString = [NSString stringWithFormat:@"banner%dios",t+1];
//            NSString *urlString = [NSString stringWithFormat:@"http://%@",self.propagandaDic[tyString]];
            NSString *urlString = self.propagandaDic[tyString];
            NSURL *tyURL = [NSURL URLWithString:urlString];
            
            UIButton *imageButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth*t, 0, kScreenWidth, 110)];
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
    return 122;//产品列表
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
            
            [weakself tokenIsValid];
            [weakself setDidTokenValid:^(TokenModel *tokenModel) {
                if ([tokenModel.code isEqualToString:@"0000"] || [tokenModel.code isEqualToString:@"3006"]) {
                    if (tag == 11) {//房产评估
                        HouseAssessViewController *houseAssessVC = [[HouseAssessViewController alloc] init];
                        houseAssessVC.hidesBottomBarWhenPushed = YES;
                        [weakself.navigationController pushViewController:houseAssessVC animated:YES];
                    }else if (tag == 22){//产调
                        HousePropertyViewController *housePropertyVC = [[HousePropertyViewController alloc] init];
                        housePropertyVC.hidesBottomBarWhenPushed = YES;
                        [weakself.navigationController pushViewController:housePropertyVC animated:YES];
                        
                    }else if (tag == 33){//保全
                        PowerProtectViewController *powerProtectVC = [[PowerProtectViewController alloc] init];
                        powerProtectVC.hidesBottomBarWhenPushed = YES;
                        [weakself.navigationController pushViewController:powerProtectVC animated:YES];
                        
                    }else if (tag == 44){//保函
                        ApplicationGuaranteeViewController *applicationGuaranteeVC = [[ApplicationGuaranteeViewController alloc] init];
                        applicationGuaranteeVC.hidesBottomBarWhenPushed = YES;
                        [weakself.navigationController pushViewController:applicationGuaranteeVC animated:YES];
                    }
                }else{//未登录
                    [weakself showHint:tokenModel.msg];
                    LoginViewController *loginVC = [[LoginViewController alloc] init];
                    loginVC.hidesBottomBarWhenPushed = YES;
                    UINavigationController *uiui = [[UINavigationController alloc] initWithRootViewController:loginVC];
                    [weakself presentViewController:uiui animated:YES completion:nil];
                }
            }];
        }];
        return cell;
    }
    
    identifier = @"main1";//精选列表
    HomesCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[HomesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    RowsModel *rowModel = self.productsDataListArray[indexPath.section - 1];
    
    cell.nameLabel.text = rowModel.number;
    cell.addressLabel.text = rowModel.addressLabel;
    
    //债权类型
    NSArray *ssssArray = [rowModel.categoryLabel componentsSeparatedByString:@","];
    if (ssssArray.count <= 1) {
        [cell.typeLabel2 setHidden:YES];
        [cell.typeLabel3 setHidden:YES];
        [cell.typeLabel4 setHidden:YES];
        cell.typeLabel1.text = ssssArray[0];
    }else if(ssssArray.count == 2){
        [cell.typeLabel2 setHidden:NO];
        [cell.typeLabel3 setHidden:YES];
        [cell.typeLabel4 setHidden:YES];
        
        cell.typeLabel1.text = ssssArray[0];
        cell.typeLabel2.text = ssssArray[1];
    }else if (ssssArray.count == 3){
        [cell.typeLabel2 setHidden:NO];
        [cell.typeLabel3 setHidden:NO];
        [cell.typeLabel4 setHidden:YES];
        
        cell.typeLabel1.text = ssssArray[0];
        cell.typeLabel2.text = ssssArray[1];
        cell.typeLabel3.text = ssssArray[2];
    }else{
        [cell.typeLabel2 setHidden:NO];
        [cell.typeLabel3 setHidden:NO];
        [cell.typeLabel4 setHidden:NO];
        
        cell.typeLabel1.text = ssssArray[0];
        cell.typeLabel2.text = ssssArray[1];
        cell.typeLabel3.text = ssssArray[2];
        cell.typeLabel4.text = ssssArray[3];
    }
    
    if ([rowModel.typeLabel isEqualToString:@"%"]) {
        cell.moneyView.label2.text = @"风险费率";
    }else if ([rowModel.typeLabel isEqualToString:@"万"]){
        cell.moneyView.label2.text = @"固定费用";
    }
    NSString *tttt = [NSString stringWithFormat:@"%@%@",rowModel.typenumLabel,rowModel.typeLabel];
    NSMutableAttributedString *attriTT = [[NSMutableAttributedString alloc] initWithString:tttt];
    [attriTT setAttributes:@{NSFontAttributeName:kBoldFont1,NSForegroundColorAttributeName:kYellowColor} range:NSMakeRange(0,rowModel.typenumLabel.length)];
    [attriTT setAttributes:@{NSFontAttributeName:kSmallFont,NSForegroundColorAttributeName:kYellowColor} range:NSMakeRange(rowModel.typenumLabel.length,rowModel.typeLabel.length)];
    [cell.moneyView.label1 setAttributedText:attriTT];
    
    cell.pointView.label2.text = @"委托金额";
    NSString *mmmm = [NSString stringWithFormat:@"%@%@",rowModel.accountLabel,@"万"];
    NSMutableAttributedString *attriMM = [[NSMutableAttributedString alloc] initWithString:mmmm];
    [attriMM setAttributes:@{NSFontAttributeName:kBoldFont1,NSForegroundColorAttributeName:kTextColor} range:NSMakeRange(0,rowModel.accountLabel.length)];
    [attriMM setAttributes:@{NSFontAttributeName:kSmallFont,NSForegroundColorAttributeName:kTextColor} range:NSMakeRange(rowModel.accountLabel.length,1)];
    [cell.pointView.label1 setAttributedText:attriMM];
    
    cell.rateView.label2.text = @"违约期限";
    NSString *rrrr = [NSString stringWithFormat:@"%@%@",rowModel.overdue,@"个月"];
    NSMutableAttributedString *attriRR = [[NSMutableAttributedString alloc] initWithString:rrrr];
    [attriRR setAttributes:@{NSFontAttributeName:kBoldFont1,NSForegroundColorAttributeName:kTextColor} range:NSMakeRange(0,rowModel.overdue.length)];
    [attriRR setAttributes:@{NSFontAttributeName:kSmallFont,NSForegroundColorAttributeName:kTextColor} range:NSMakeRange(rowModel.overdue.length,2)];
    [cell.rateView.label1 setAttributedText:attriRR];
    
    
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
    if (indexPath.section > 0) {
        
        [self tokenIsValid];
        
        QDFWeakSelf;
        [self setDidTokenValid:^(TokenModel *model) {
            if ([model.code isEqualToString:@"0000"]) {//正常
                RowsModel *sModel = weakself.productsDataListArray[indexPath.section - 1];
                ProductsDetailsViewController *productsDetailVC = [[ProductsDetailsViewController alloc] init];
                productsDetailVC.hidesBottomBarWhenPushed = YES;
                productsDetailVC.productid = sModel.productid;
                [weakself.navigationController pushViewController:productsDetailVC animated:YES];
            }else if([model.code isEqualToString:@"3006"]){//已登录，未认证
                [weakself showHint:model.msg];
                AuthentyViewController *authentyVC = [[AuthentyViewController alloc] init];
                authentyVC.hidesBottomBarWhenPushed = YES;
                authentyVC.typeAuthty = @"0";
                [weakself.navigationController pushViewController:authentyVC animated:YES];
            }else{//未登录
                [weakself showHint:model.msg];
                LoginViewController *loginVC = [[LoginViewController alloc] init];
                loginVC.hidesBottomBarWhenPushed = YES;
                UINavigationController *uiui = [[UINavigationController alloc] initWithRootViewController:loginVC];
                [weakself presentViewController:uiui animated:YES completion:nil];
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
    self.mainHeaderScrollView.contentOffset = CGPointMake([page currentPage]*kScreenWidth, 0);
}

#pragma mark - method
- (void)getRecommendProductslist
{
    NSString *allProString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kProductListsString];
    
    NSDictionary *params = @{@"page" : @"1",
                             @"limit" : @"3",
                             @"token" : [self getValidateToken]
                             };
    
    QDFWeakSelf;
    [self requestDataPostWithString:allProString params:params successBlock:^(id responseObject) {
        
        [weakself.productsDataListArray removeAllObjects];
        
        ReleaseResponse *response = [ReleaseResponse objectWithKeyValues:responseObject];
        
        for (RowsModel *rowModel in response.data) {
            [weakself.productsDataListArray addObject:rowModel];
        }
        
        if (weakself.productsDataListArray.count == 0) {
            [weakself.baseRemindImageView setHidden:NO];
        }else{
            [weakself.baseRemindImageView setHidden:YES];
        }
        
        [weakself.mainTableView reloadData];
        
        if (weakself.propagandaDic.allKeys.count == 0) {
            [weakself getPropagandaChar];
        }
        
    } andFailBlock:^(NSError *error) {
        
    }];

    
//    NSString *recommendString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kProductsRecommendListString];
//    NSDictionary *params = @{@"limit" : @"6"};
//    
//    QDFWeakSelf;
//    [self requestDataPostWithString:recommendString params:params successBlock:^(id responseObject) {
//                
//        [weakself.productsDataListArray removeAllObjects];
//        
//        NewProductModel *model = [NewProductModel objectWithKeyValues:responseObject];
//        for (NewProductListModel *listModel in model.result) {
//            [weakself.productsDataListArray addObject:listModel];
//        }
//        [weakself.mainTableView reloadData];
//        
//        if (weakself.propagandaDic.allKeys.count == 0) {
//            [weakself getPropagandaChar];
//        }
//    } andFailBlock:^(NSError *error) {
//        
//    }];
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
    NSDictionary *appInfoDic;
    if (response) {
        appInfoDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
    }
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
