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
#import "LoginViewController.h"
#import "AuthentyViewController.h"

#import "HomeCell.h"
#import "BidOneCell.h"
#import "UIImage+Color.h"

#import "AllProductsChooseView.h"
#import "ProductsView.h"
#import "UIViewController+BlurView.h"

#import "NewProductModel.h"
#import "NewProductListModel.h"
@interface ProductsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) ProductsView *proTitleView;
@property (nonatomic,strong) AllProductsChooseView *chooseView;  //头部选择栏
@property (nonatomic,strong) UITableView *productsTableView;

@property (nonatomic,strong) UIView *backBlurView;
@property (nonatomic,strong) UITableView *tableView11;
@property (nonatomic,strong) UITableView *tableView12;
@property (nonatomic,strong) UITableView *tableView13;

//json解析
@property (nonatomic,strong) NSDictionary *provinceDictionary;
@property (nonatomic,strong) NSDictionary *cityDcitionary;
@property (nonatomic,strong) NSDictionary *districtDictionary;

//参数 json
@property (nonatomic,strong) NSMutableDictionary *paramsDictionary;
@property (nonatomic,strong) NSMutableArray *allDataList;
@property (nonatomic,assign) NSInteger page;

//记住选中的省份市区
@property (nonatomic,strong) NSString *proString;
@property (nonatomic,strong) NSString *cityString;
@property (nonatomic,assign) NSInteger selectedRow1;
@property (nonatomic,assign) NSInteger selectedRow2;

@end

@implementation ProductsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:kBlackColor,NSFontAttributeName:kNavFont}];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:kNavColor] forBarMetrics:UIBarMetricsDefault];
        
    [self headerRefreshWithAllProducts];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = self.proTitleView;
    
    _selectedRow1 = 1000;
    _selectedRow2 = 1000;
    
    [self.view addSubview:self.chooseView];
    [self.view addSubview:self.productsTableView];
    [self.view addSubview:self.baseRemindImageView];
    [self.baseRemindImageView setHidden:YES];
    
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
        
        [self.baseRemindImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [self.baseRemindImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];

        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (ProductsView *)proTitleView
{
    if (!_proTitleView) {
        _proTitleView = [[ProductsView alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
//        _proTitleView.backgroundColor = kRedColor;
        
        QDFWeakSelf;
        [_proTitleView setDidSelectedBtn:^(NSInteger tag) {
            if (tag == 101) {//清收
                [weakself.paramsDictionary setObject:@"2" forKey:@"category"];
                [weakself headerRefreshWithAllProducts];
            }else{//诉讼
                [weakself.paramsDictionary setObject:@"3" forKey:@"category"];
                [weakself headerRefreshWithAllProducts];
            }
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
                    selectedButton.selected = !selectedButton.selected;
                    [weakself hiddenBlurView];
                    
                    [weakself.backBlurView removeFromSuperview];
                    
                    if (selectedButton.selected) {
                        weakself.chooseView.stateButton.selected = NO;
                        weakself.chooseView.moneyButton.selected = NO;
                        
                        [weakself.view addSubview: weakself.backBlurView];
                        [weakself.backBlurView addSubview:weakself.tableView11];
                        
                        [weakself.tableView11 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:weakself.chooseView];
                        
                        [weakself.tableView11 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
                        [weakself.tableView11 autoSetDimension:ALDimensionHeight toSize:300];
                        weakself.widthConstraints = [weakself.tableView11 autoSetDimension:ALDimensionWidth toSize:kScreenWidth];
                        
                        [weakself getProvinceList];
                    }
                }
                    break;
                case 202:{//状态
                    
                    selectedButton.selected = !selectedButton.selected;
                    [weakself hiddenBlurView];
                    [weakself.backBlurView removeFromSuperview];
                    
                    if (selectedButton.selected) {
                        
                        weakself.chooseView.squrebutton.selected = NO;
                        weakself.chooseView.moneyButton.selected = NO;
                        
                        NSArray *stateArray = @[@"不限",@"发布中",@"处理中",@"已结案"];
                        [weakself showBlurInView:weakself.view withArray:stateArray withTop:weakself.chooseView.height finishBlock:^(NSString *text, NSInteger row) {
                            [selectedButton setTitle:text forState:0];
                            
                            if (row <= 2) {
                                NSString *value = [NSString stringWithFormat:@"%ld",(long)row];
                                [selectedButton setTitle:text forState:0];
                                [weakself.paramsDictionary setValue:value forKey:@"status"];
                            }else{
                                [weakself.paramsDictionary setValue:@"4" forKey:@"status"];
                            }
                            [weakself headerRefreshWithAllProducts];
                        }];
                        
                    }
                }
                    break;
                case 203:{//金额
                    
                    selectedButton.selected = !selectedButton.selected;
                    
                    [weakself hiddenBlurView];
                    [weakself.backBlurView removeFromSuperview];
                    if (selectedButton.selected) {
                        weakself.chooseView.squrebutton.selected = NO;
                        weakself.chooseView.stateButton.selected = NO;
                        
                        
                        NSArray *moneyArray = @[@"不限",@"30万以下",@"30-100万",@"100-500万",@"500万以上"];
                        [weakself showBlurInView:weakself.view withArray:moneyArray withTop:selectedButton.height finishBlock:^(NSString *text, NSInteger row) {
                            [selectedButton setTitle:text forState:0];
                            
                            NSString *value = [NSString stringWithFormat:@"%ld",(long)row];
                            [selectedButton setTitle:text forState:0];
                            [weakself.paramsDictionary setValue:value forKey:@"money"];
                            [weakself headerRefreshWithAllProducts];
                        }];
                    }
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
        [_productsTableView addHeaderWithTarget:self action:@selector(headerRefreshWithAllProducts)];
        [_productsTableView addFooterWithTarget:self action:@selector(footerRefreshOfAllProducts)];
    }
    return _productsTableView;
}

- (UIView *)backBlurView
{
    if (!_backBlurView) {
        _backBlurView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, kScreenHeight)];
        _backBlurView.backgroundColor = UIColorFromRGB1(0x333333, 0.6);
    }
    return _backBlurView;
}

- (UITableView *)tableView11
{
    if (!_tableView11) {
        _tableView11 = [UITableView newAutoLayoutView];
        _tableView11.delegate = self;
        _tableView11.dataSource = self;
        _tableView11.tableFooterView = [[UIView alloc] init];
        _tableView11.layer.borderColor = kSeparateColor.CGColor;
        _tableView11.layer.borderWidth = kLineWidth;
        _tableView11.backgroundColor = kNavColor;
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
        _tableView12.backgroundColor = kNavColor;
        _tableView12.layer.borderColor = kSeparateColor.CGColor;
        _tableView12.layer.borderWidth = kLineWidth;
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
        _tableView13.backgroundColor = kNavColor;
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

- (NSMutableArray *)allDataList
{
    if (!_allDataList) {
        _allDataList = [NSMutableArray array];
    }
    return _allDataList;
}

#pragma mark - tableView delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.productsTableView) {
        return self.allDataList.count;
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.productsTableView) {
        return 1;
    }else if (tableView == self.tableView11){
        return self.provinceDictionary.allKeys.count + 1;
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
    return 40;
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
        
        NewProductListModel *proModel = self.allDataList[indexPath.section];
        
        cell.moneyView.label1.text = [NSString getValidStringFromString:proModel.money toString:@"0"];
        cell.moneyView.label2.text = @"借款本金(万元)";
        
        if ([proModel.loan_type isEqualToString:@"1"]) {
            cell.rateView.label1.text = @"房产抵押";
            cell.addressLabel.text = [NSString getValidStringFromString:proModel.location toString:@"无抵押物地址"];
        }else if ([proModel.loan_type isEqualToString:@"2"]){
            cell.rateView.label1.text = @"应收账款";
            cell.addressLabel.text = @"无抵押物地址";
        }else if ([proModel.loan_type isEqualToString:@"3"]){
            cell.rateView.label1.text = @"机动车抵押";
            cell.addressLabel.text = @"无抵押物地址";
        }else{
            cell.rateView.label1.text = @"无抵押";
            cell.addressLabel.text = @"无抵押物地址";
        }
        cell.rateView.label2.text = @"债权类型";
        
        cell.pointView.label1.text = [NSString getValidStringFromString:proModel.agencycommission toString:@"0"];
        if ([proModel.category isEqualToString:@"2"]){//清收
            
            if ([proModel.progress_status integerValue] > 1) {//list_collection_nor@2x
                [cell.typeImageView setImage:[UIImage imageNamed:@"list_collection_nor"]];
            }else if ([proModel.progress_status integerValue] == 1){
                [cell.typeImageView setImage:[UIImage imageNamed:@"list_collection"]];
            }
            
            if ([proModel.agencycommissiontype isEqualToString:@"1"]) {
                cell.pointView.label2.text = @"服务佣金(%)";
            }else{
                cell.pointView.label2.text = @"固定费用(万元)";
            }
        }else if ([proModel.category isEqualToString:@"3"]){//诉讼
            
            if ([proModel.progress_status integerValue] > 1) {//list_litigation_nor@2x
                [cell.typeImageView setImage:[UIImage imageNamed:@"list_litigation_nor"]];
            }else if ([proModel.progress_status integerValue] == 1){
                [cell.typeImageView setImage:[UIImage imageNamed:@"list_litigation"]];
            }
            
            if ([proModel.agencycommissiontype isEqualToString:@"1"]) {
                cell.pointView.label2.text = @"固定费用(万元)";
            }else{
                cell.pointView.label2.text = @"风险费率(%)";
            }
        }
        
        cell.nameLabel.text = proModel.codeString;
        
        //typeButton
        if([proModel.progress_status integerValue] > 1){//不可点击
            [cell.typeButton setHidden:NO];
            [cell.typeButton setImage:[UIImage imageNamed:@"list_chapter"] forState:0];
        }else{
            [cell.typeButton setHidden:YES];
        }
                
        return cell;
        
    }else if (tableView == self.tableView11){//省
        static NSString *identifier = @"aa";
        BidOneCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[BidOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.selectedBackgroundView = [[UIView alloc] init];
        cell.selectedBackgroundView.backgroundColor = kCellSelectedColor;
        
        cell.oneButton.userInteractionEnabled = NO;
        [cell.oneButton setTitleColor:kLightGrayColor forState:0];
        cell.selectedBackgroundView = [[UIView alloc] init];
        cell.selectedBackgroundView.backgroundColor = kCellSelectedColor;

        if (indexPath.row == 0) {
            [cell.oneButton setTitle:@"不限" forState:0];
        }else{
            [cell.oneButton setTitle:self.provinceDictionary.allValues[indexPath.row-1] forState:0];
        }
        
        return cell;
        
    }else if (tableView == self.tableView12){//市
        static NSString *identifier = @"bb";
        BidOneCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[BidOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.oneButton.userInteractionEnabled = NO;
        [cell.oneButton setTitleColor:kLightGrayColor forState:0];
        cell.selectedBackgroundView = [[UIView alloc] init];
        cell.selectedBackgroundView.backgroundColor = kCellSelectedColor;

        [cell.oneButton setTitle:self.cityDcitionary.allValues[indexPath.row] forState:0];

        return cell;
    }else if (tableView == self.tableView13){//区
        static NSString *identifier = @"cc";
        BidOneCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[BidOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.oneButton.userInteractionEnabled = NO;
        [cell.oneButton setTitleColor:kLightGrayColor forState:0];
        [cell.oneButton setTitle:self.districtDictionary.allValues[indexPath.row] forState:0];

        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.productsTableView) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        [self tokenIsValid];
        QDFWeakSelf;
        [self setDidTokenValid:^(TokenModel *model) {
            if ([model.code isEqualToString:@"0000"]) {//正常
                ProductsDetailsViewController *productsDetailVC = [[ProductsDetailsViewController alloc] init];
                productsDetailVC.hidesBottomBarWhenPushed = YES;
                NewProductListModel *sModel = weakself.allDataList[indexPath.section];
                
                if ([sModel.progress_status integerValue] == 1) {
                    productsDetailVC.idString = sModel.idString;
                    productsDetailVC.categoryString = sModel.category;
                    productsDetailVC.pidString = sModel.uidString;
                    [weakself.navigationController pushViewController:productsDetailVC animated:YES];
                }else{
                    [weakself showHint:@"已撮合，不可查看"];
                }
            }else if([model.code isEqualToString:@"3001"] || [self getValidateToken] == nil){//未登录
                [weakself showHint:model.msg];
                LoginViewController *loginVC = [[LoginViewController alloc] init];
                loginVC.hidesBottomBarWhenPushed = YES;
                UINavigationController *uiui = [[UINavigationController alloc] initWithRootViewController:loginVC];
                [weakself presentViewController:uiui animated:YES completion:nil];
            }else if([model.code isEqualToString:@"3006"]){//已登录，未认证
                [weakself showHint:model.msg];
                AuthentyViewController *authentyVC = [[AuthentyViewController alloc] init];
                authentyVC.hidesBottomBarWhenPushed = YES;
                authentyVC.typeAuthty = @"0";
                [weakself.navigationController pushViewController:authentyVC animated:YES];
            }
        }];
    } else if (tableView == self.tableView11){//省份
        
        if (indexPath.row == 0) {
            [self.chooseView.squrebutton setTitle:@"不限" forState:0];
            
            self.widthConstraints.constant = kScreenWidth;
            
            [self.backBlurView removeFromSuperview];
            
            [self.paramsDictionary setValue:@"0" forKey:@"province"];
            [self.paramsDictionary setValue:@"0" forKey:@"city"];
            [self.paramsDictionary setValue:@"0" forKey:@"area"];
            
            [self headerRefreshWithAllProducts];
            
        }else{
            
            if (_selectedRow1 != 1000) {
                BidOneCell *cell = [self.tableView11 cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedRow1 inSection:0]];
                [cell.oneButton setTitleColor:kLightGrayColor forState:0];
            }
            
            _selectedRow1 = indexPath.row;
            BidOneCell *cell = [self.tableView11 cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
            [cell.oneButton setTitleColor:kBlueColor forState:0];
            
            [self.backBlurView addSubview:self.tableView12];
            self.widthConstraints.constant = kScreenWidth/2;
            [self.tableView12 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.tableView11];
            [self.tableView12 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.tableView11];
            [self.tableView12 autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.tableView11];
            [self.tableView12 autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.tableView11];
            
            _proString = self.provinceDictionary.allKeys[indexPath.row-1];
            
            [self getCityListWithProvinceID:self.provinceDictionary.allKeys[indexPath.row-1]];
        }
    }else if (tableView == self.tableView12){//市
        
        if (_selectedRow2 != 1000) {
            BidOneCell *cell = [self.tableView12 cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedRow2 inSection:0]];
            [cell.oneButton setTitleColor:kLightGrayColor forState:0];
        }
        
        _selectedRow2 = indexPath.row;
        
        BidOneCell *cell = [self.tableView12 cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
        [cell.oneButton setTitleColor:kBlueColor forState:0];
        
        [self.backBlurView addSubview:self.tableView13];
        self.widthConstraints.constant = kScreenWidth/3;
        [self.tableView13 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.tableView12];
        [self.tableView13 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.tableView11];
        [self.tableView13 autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.tableView11];
        [self.tableView13 autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.tableView11];
        
        _cityString = self.cityDcitionary.allKeys[indexPath.row];

        [self getDistrictListWithCityID:self.cityDcitionary.allKeys[indexPath.row]];
        
    }else if (tableView == self.tableView13){//区
        
        [self.backBlurView removeFromSuperview];
        
        UIButton *but1 = [self.view viewWithTag:202];
        UIButton *but2 = [self.view viewWithTag:203];
        but1.userInteractionEnabled = YES;
        but2.userInteractionEnabled = YES;

        [self.chooseView.squrebutton setTitle:self.districtDictionary.allValues[indexPath.row] forState:0];
        
        self.widthConstraints.constant = kScreenWidth;
        
        [self.paramsDictionary setValue:_proString forKey:@"province"];
        [self.paramsDictionary setValue:_cityString forKey:@"city"];
        [self.paramsDictionary setValue:self.districtDictionary.allKeys[indexPath.row] forKey:@"area"];
        
        [self headerRefreshWithAllProducts];
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.backBlurView removeFromSuperview];
}

#pragma mark - get province city and dictrict
- (void)getProvinceList
{
    NSString *provinceString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kProvinceString];
    QDFWeakSelf;
    [self requestDataPostWithString:provinceString params:nil successBlock:^(id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        weakself.provinceDictionary = dic;
        [weakself.tableView11 reloadData];
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)getCityListWithProvinceID:(NSString *)provinceId
{
    NSString *cityString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kCityString];
    NSDictionary *params = @{@"fatherID" : provinceId};
    
    QDFWeakSelf;
    [self requestDataPostWithString:cityString params:params successBlock:^(id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        weakself.cityDcitionary = dic[provinceId];
        [weakself.tableView12 reloadData];
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)getDistrictListWithCityID:(NSString *)cityId
{
    NSString *districtString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kDistrictString];
    NSDictionary *params = @{@"fatherID" : cityId};
    
    QDFWeakSelf;
    [self requestDataPostWithString:districtString params:params successBlock:^(id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        weakself.districtDictionary = dic[cityId];
        [weakself.tableView13 reloadData];
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

#pragma mark - refresh
- (void)getProductsListWithPage:(NSString *)page
{
    NSString *allProString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kProductsListString];
    
    self.paramsDictionary[@"province"] = self.paramsDictionary[@"province"]?self.paramsDictionary[@"province"]:@"0";
    self.paramsDictionary[@"city"] = self.paramsDictionary[@"city"]?self.paramsDictionary[@"city"]:@"0";
    self.paramsDictionary[@"area"] = self.paramsDictionary[@"area"]?self.paramsDictionary[@"area"]:@"0";
    self.paramsDictionary[@"category"] = self.paramsDictionary[@"category"]?self.paramsDictionary[@"category"]:@"2";
    self.paramsDictionary[@"money"] = self.paramsDictionary[@"money"]?self.paramsDictionary[@"money"]:@"0";
    self.paramsDictionary[@"status"] = self.paramsDictionary[@"status"]?self.paramsDictionary[@"status"]:@"0";
    
    [self.paramsDictionary setValue:page forKey:@"page"];
    
    NSDictionary *params = self.paramsDictionary;
    
    QDFWeakSelf;
    [self requestDataPostWithString:allProString params:params successBlock:^(id responseObject) {
        
        if ([page intValue] == 1) {
            [weakself.allDataList removeAllObjects];
        }
        
        NewProductModel *response = [NewProductModel objectWithKeyValues:responseObject];
        
        if (response.result.count == 0) {
            [weakself showHint:@"没有更多了"];
            _page--;
        }
        
        for (NewProductListModel *model in response.result) {
            [weakself.allDataList addObject:model];
        }
        
        if (weakself.allDataList.count == 0) {
            [weakself.baseRemindImageView setHidden:NO];
        }else{
            [weakself.baseRemindImageView setHidden:YES];
        }
        
        [weakself.productsTableView reloadData];
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)headerRefreshWithAllProducts
{
    _page = 1;
    [self getProductsListWithPage:@"1"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.productsTableView headerEndRefreshing];
    });
}

- (void)footerRefreshOfAllProducts
{
    _page++;
    NSString *pp = [NSString stringWithFormat:@"%ld",(long)_page];
    [self getProductsListWithPage:pp];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.productsTableView footerEndRefreshing];
    });
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
