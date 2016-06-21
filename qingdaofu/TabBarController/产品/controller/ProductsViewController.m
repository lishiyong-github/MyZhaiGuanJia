//
//  ProductsViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/4/26.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ProductsViewController.h"
#import "SearchViewController.h"   //搜索
#import "ProductsDetailsViewController.h"   //详细信息

#import "HomeCell.h"
#import "BidOneCell.h"
#import "UIImage+Color.h"
#import "AllProView.h"

#import "AllProductsChooseView.h"

#import "UIViewController+BlurView.h"
@interface ProductsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UIButton *proTitleView;
@property (nonatomic,strong) AllProductsChooseView *chooseView;  //头部选择栏
@property (nonatomic,strong) UITableView *productsTableView;

@property (nonatomic,strong) UITableView *tableView11;
@property (nonatomic,strong) UITableView *tableView12;
@property (nonatomic,strong) UITableView *tableView13;

@property (nonatomic,strong) NSDictionary *provinceDictionary;
@property (nonatomic,strong) NSDictionary *cityDcitionary;
@property (nonatomic,strong) NSDictionary *districtDictionary;

@property (nonatomic,strong) NSMutableDictionary *paramsDictionary;

@property (nonatomic,strong) NSString *proString;

@end

@implementation ProductsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:kBlackColor,NSFontAttributeName:kNavFont}];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:kNavColor] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = self.proTitleView;
    self.navigationItem.rightBarButtonItem  = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_search"] style:UIBarButtonItemStylePlain target:self action:@selector(searchProducts)];

    [self.view addSubview:self.chooseView];
    [self.view addSubview:self.productsTableView];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.chooseView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.chooseView autoSetDimension:ALDimensionHeight toSize:40];
        
        [self.productsTableView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.chooseView];
        [self.productsTableView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.productsTableView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.productsTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kTabBarHeight];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UIButton *)proTitleView
{
    if (!_proTitleView) {
        _proTitleView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        [_proTitleView setImage:[UIImage imageNamed:@"title_product_open"] forState:0];
        [_proTitleView setImage:[UIImage imageNamed:@"title_product_close"] forState:UIControlStateSelected];
        
        QDFWeakSelf;
        [_proTitleView addAction:^(UIButton *btn) {

            NSArray *titleArray = @[@"全部",@"融资",@"催收",@"诉讼"];
            [weakself showBlurInView:weakself.view withArray:titleArray withTop:0 finishBlock:^(NSString *text, NSInteger row) {
                
            }];
        }];
    }
    return _proTitleView;
}

- (AllProductsChooseView *)chooseView
{
    if (!_chooseView) {
        _chooseView = [AllProductsChooseView newAutoLayoutView];
        _chooseView.backgroundColor = kNavColor;
        [_chooseView.squrebutton setTitle:@"区域" forState:0];
        [_chooseView.stateButton setTitle:@"状态" forState:0];
        [_chooseView.moneyButton setTitle:@"金额" forState:0];

        QDFWeakSelf;
        [_chooseView setDidSelectedButton:^(UIButton *selectedButton) {
            
            switch (selectedButton.tag) {
                case 201:{//区域
                        UIButton *but1 = [weakself.view viewWithTag:202];
                        UIButton *but2 = [weakself.view viewWithTag:203];
                        but1.userInteractionEnabled = NO;
                        but2.userInteractionEnabled = NO;
                    
                        [weakself.view addSubview: weakself.tableView11];
                        
                        [weakself.tableView11 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:weakself.chooseView];
                        [weakself.tableView11 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
                        [weakself.tableView11 autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kTabBarHeight];
                        weakself.widthConstraints = [weakself.tableView11 autoSetDimension:ALDimensionWidth toSize:kScreenWidth];
                        
                        [weakself getProvinceList];
                }
                    break;
                case 202:{//状态
                    
                        UIButton *but1 = [weakself.view viewWithTag:201];
                        UIButton *but2 = [weakself.view viewWithTag:203];
                        but1.userInteractionEnabled = NO;
                        but2.userInteractionEnabled = NO;
                        
                        NSArray *stateArray = @[@"不限",@"发布中",@"处理中",@"已结案"];
                        
                        [weakself showBlurInView:weakself.view withArray:stateArray withTop:weakself.chooseView.height finishBlock:^(NSString *text, NSInteger row) {
                            [selectedButton setTitle:text forState:0];
                            
                            UIButton *but1 = [weakself.view viewWithTag:201];
                            UIButton *but2 = [weakself.view viewWithTag:203];
                            but1.userInteractionEnabled = YES;
                            but2.userInteractionEnabled = YES;

                        }];
                }
                    break;
                case 203:{//金额
                    
                        UIButton *but1 = [weakself.view viewWithTag:201];
                        UIButton *but2 = [weakself.view viewWithTag:202];
                        but1.userInteractionEnabled = NO;
                        but2.userInteractionEnabled = NO;
                        
                        NSArray *moneyArray = @[@"不限",@"30万以下",@"30-100万",@"100-500万",@"500万以上"];
                    [weakself showBlurInView:weakself.view withArray:moneyArray withTop:selectedButton.height finishBlock:^(NSString *text, NSInteger row) {
                        [selectedButton setTitle:text forState:0];
                        
                        UIButton *but1 = [weakself.view viewWithTag:201];
                        UIButton *but2 = [weakself.view viewWithTag:202];
                        but1.userInteractionEnabled = YES;
                        but2.userInteractionEnabled = YES;
                    }];
                }
                    break;
                default:
                    break;
            }
        }];
    }
    return _chooseView;
}

- (UITableView *)productsTableView
{
    if (!_productsTableView) {
        _productsTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _productsTableView = [[UITableView alloc ]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        _productsTableView.delegate = self;
        _productsTableView.dataSource = self;
        _productsTableView.backgroundColor = kBackColor;
        _productsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
    }
    return _productsTableView;
}

- (UITableView *)tableView11
{
    if (!_tableView11) {
        _tableView11 = [UITableView newAutoLayoutView];
        _tableView11.delegate = self;
        _tableView11.dataSource = self;
        _tableView11.tableFooterView = [[UIView alloc] init];
        _tableView11.backgroundColor = UIColorFromRGB1(0x333333, 0.6);
        _tableView11.layer.borderColor = kSeparateColor.CGColor;
        _tableView11.layer.borderWidth = kLineWidth;
    }
    return _tableView11;
}

- (UITableView *)tableView12
{
    if (!_tableView12) {
        _tableView12 = [UITableView newAutoLayoutView];
        _tableView12.delegate = self;
        _tableView12.dataSource = self;
        _tableView12.tableFooterView = [[UIView alloc] init];
        _tableView12.backgroundColor = UIColorFromRGB1(0x333333, 0.7);
    }
    return _tableView12;
}

- (UITableView *)tableView13
{
    if (!_tableView13) {
        _tableView13 = [UITableView newAutoLayoutView];
        _tableView13.delegate = self;
        _tableView13.dataSource = self;
        _tableView13.tableFooterView = [[UIView alloc] init];
        _tableView13.backgroundColor = UIColorFromRGB1(0x333333, 0.7);
        _tableView13.layer.borderColor = kSeparateColor.CGColor;
        _tableView13.layer.borderWidth = kLineWidth;
    }
    return _tableView13;
}

- (NSMutableDictionary *)paramsDictionary
{
    if (!_paramsDictionary) {
        _paramsDictionary = [NSMutableDictionary dictionary];
    }
    return _paramsDictionary;
}

#pragma mark - tableView delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.productsTableView) {
        return 10;
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.productsTableView) {
        return 1;
    }else if (tableView == self.tableView11){
        return self.provinceDictionary.allKeys.count;
    }else if (tableView == self.tableView12){
        return self.cityDcitionary.allKeys.count;
    }else if (tableView == self.tableView13){
        return self.districtDictionary.allKeys.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.productsTableView) {
        return 156;
    }
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.productsTableView) {
        static NSString *identifier = @"pros";
        HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[HomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell.recommendimageView setHidden:YES];
        
        return cell;
        
    }else if (tableView == self.tableView11){//省
        static NSString *identifier = @"aa";
        BidOneCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[BidOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.oneButton.userInteractionEnabled = NO;
        [cell.oneButton setTitle:self.provinceDictionary.allValues[indexPath.row] forState:0];
        
        return cell;
        
    }else if (tableView == self.tableView12){//市
        static NSString *identifier = @"bb";
        BidOneCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[BidOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.oneButton.userInteractionEnabled = NO;
        [cell.oneButton setTitle:self.cityDcitionary.allValues[indexPath.row] forState:0];

        return cell;
    }else if (tableView == self.tableView13){//区
        static NSString *identifier = @"cc";
        BidOneCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[BidOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.oneButton.userInteractionEnabled = NO;
        [cell.oneButton setTitle:self.districtDictionary.allValues[indexPath.row] forState:0];

        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.productsTableView) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        ProductsDetailsViewController *productsDetailsVC = [[ProductsDetailsViewController alloc] init];
        productsDetailsVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:productsDetailsVC animated:YES];
    }else if (tableView == self.tableView11){
        [self.view addSubview:self.tableView12];
        self.widthConstraints.constant = kScreenWidth/2;
        [self.tableView12 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.tableView11];
        [self.tableView12 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.tableView11];
        [self.tableView12 autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.tableView11];
        [self.tableView12 autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.tableView11];
        
        [self.paramsDictionary setValue:self.provinceDictionary.allKeys[indexPath.row] forKey:@"province"];
        [self getCityListWithProvinceID:self.provinceDictionary.allKeys[indexPath.row]];
        
    }else if (tableView == self.tableView12){
        [self.view addSubview:self.tableView13];
        self.widthConstraints.constant = kScreenWidth/3;
        [self.tableView13 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.tableView12];
        [self.tableView13 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.tableView11];
        [self.tableView13 autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.tableView11];
        [self.tableView13 autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.tableView11];
        
        [self.paramsDictionary setValue:self.cityDcitionary.allKeys[indexPath.row] forKey:@"city"];
        [self getDistrictListWithCityID:self.cityDcitionary.allKeys[indexPath.row]];
        
    }else if (tableView == self.tableView13){
        [self.tableView11 removeFromSuperview];
        [self.tableView12 removeFromSuperview];
        [self.tableView13 removeFromSuperview];
        
        
        UIButton *but1 = [self.view viewWithTag:202];
        UIButton *but2 = [self.view viewWithTag:203];
        but1.userInteractionEnabled = YES;
        but2.userInteractionEnabled = YES;

        [self.chooseView.squrebutton setTitle:self.districtDictionary.allValues[indexPath.row] forState:0];
        
        [self.paramsDictionary setValue:self.districtDictionary.allKeys[indexPath.row] forKey:@"area"];
        [self getProductsListWithPage:@"0"];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.productsTableView) {
        return kBigPadding;
    }
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

#pragma mark - method
- (void)searchProducts
{
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)getProvinceList
{
    NSString *provinceString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kProvinceString];
    [self requestDataPostWithString:provinceString params:nil successBlock:^(id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        self.provinceDictionary = dic;
        
        [self.tableView11 reloadData];
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)getCityListWithProvinceID:(NSString *)provinceId
{
    NSString *cityString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kCityString];
    NSDictionary *params = @{@"fatherID" : provinceId};
    [self requestDataPostWithString:cityString params:params successBlock:^(id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"-------- %@",dic);
        
        self.cityDcitionary = dic[provinceId];
        
        [self.tableView12 reloadData];
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)getDistrictListWithCityID:(NSString *)cityId
{
    NSString *districtString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kDistrictString];
    NSDictionary *params = @{@"fatherID" : cityId};
    [self requestDataPostWithString:districtString params:params successBlock:^(id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        self.districtDictionary = dic[cityId];
        
        [self.tableView13 reloadData];
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)getProductsListWithPage:(NSString *)page
{
    NSString *allProString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kProductsListString];
    
    
    self.paramsDictionary[@"province"] = self.paramsDictionary[@"province"]?self.paramsDictionary[@"province"]:@"";
    self.paramsDictionary[@"city"] = self.paramsDictionary[@"city"]?self.paramsDictionary[@"city"]:@"";
    self.paramsDictionary[@"area"] = self.paramsDictionary[@"area"]?self.paramsDictionary[@"area"]:@"";
    self.paramsDictionary[@"category"] = self.paramsDictionary[@"category"]?self.paramsDictionary[@"category"]:@"0";
    self.paramsDictionary[@"money"] = self.paramsDictionary[@"money"]?self.paramsDictionary[@"money"]:@"0";
    self.paramsDictionary[@"status"] = self.paramsDictionary[@"status"]?self.paramsDictionary[@"status"]:@"0";
    
    
//    if ([self.paramsDictionary[@"province"] isEqualToString:@"310000"]) {
//        [self.paramsDictionary setValue:@"0" forKey:@"province"];
//    }
//    if ([self.paramsDictionary[@"city"] isEqualToString:@"310100"]) {
//        [self.paramsDictionary setValue:@"0" forKey:@"city"];
//    }
//    if ([self.paramsDictionary[@"area"] isEqualToString:@"310100"]) {
//        [self.paramsDictionary setValue:@"0" forKey:@"area"];
//    }
    
    [self.paramsDictionary setValue:[self getValidateToken] forKey:@"token"];
    [self.paramsDictionary setValue:page forKey:@"page"];
    
    NSDictionary *params = self.paramsDictionary;
    [self requestDataPostWithString:allProString params:params successBlock:^(id responseObject) {
        NSDictionary *dicc = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"####### %@",dicc);
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
