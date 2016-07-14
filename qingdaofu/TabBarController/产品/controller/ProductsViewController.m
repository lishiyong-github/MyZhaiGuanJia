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
#import "AllProView.h"
#import "UpCell.h"

#import "AllProductsChooseView.h"

#import "UIViewController+BlurView.h"

#import "NewProductModel.h"
#import "NewProductListModel.h"
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

//参数
@property (nonatomic,strong) NSMutableDictionary *paramsDictionary;
@property (nonatomic,strong) NSMutableArray *allDataList;
@property (nonatomic,assign) NSInteger page;

//选中的省份市区
@property (nonatomic,strong) NSString *proString;
@property (nonatomic,strong) NSString *cityString;
@end

@implementation ProductsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:kBlackColor,NSFontAttributeName:kNavFont}];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:kNavColor] forBarMetrics:UIBarMetricsDefault];
    
    [self headerRefreshWithAllProducts];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = self.proTitleView;
    
//    self.navigationItem.rightBarButtonItem  = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_search"] style:UIBarButtonItemStylePlain target:self action:@selector(searchProducts)];
    
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

- (UIButton *)proTitleView
{
    if (!_proTitleView) {
        _proTitleView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        [_proTitleView setTitle:@"所有产品" forState:0];
        _proTitleView.titleLabel.font = kNavFont;
        [_proTitleView setTitleColor:kBlackColor forState:0];
        
        QDFWeakSelf;
        [_proTitleView addAction:^(UIButton *btn) {
            [weakself hiddenBlurView];
            [weakself.tableView11 removeFromSuperview];
            [weakself.tableView12 removeFromSuperview];
            [weakself.tableView13 removeFromSuperview];
            
            NSArray *titleArray = @[@"全部",@"融资",@"清收",@"诉讼"];
            [weakself showBlurInView:weakself.view withArray:titleArray withTop:0 finishBlock:^(NSString *text, NSInteger row) {
                NSString *value = [NSString stringWithFormat:@"%d",row];
                [btn setTitle:text forState:0];
                [weakself.paramsDictionary setValue:value forKey:@"category"];
                [weakself headerRefreshWithAllProducts];
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
                    selectedButton.selected = !selectedButton.selected;
                    [weakself hiddenBlurView];
                    [weakself.tableView11 removeFromSuperview];
                    [weakself.tableView12 removeFromSuperview];
                    [weakself.tableView13 removeFromSuperview];
                    if (selectedButton.selected) {
                        weakself.chooseView.stateButton.selected = NO;
                        weakself.chooseView.moneyButton.selected = NO;
                        
                        [weakself.view addSubview: weakself.tableView11];
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
                    [weakself.tableView11 removeFromSuperview];
                    [weakself.tableView12 removeFromSuperview];
                    [weakself.tableView13 removeFromSuperview];
                    if (selectedButton.selected) {
                        
                        weakself.chooseView.squrebutton.selected = NO;
                        weakself.chooseView.moneyButton.selected = NO;
                        
                        NSArray *stateArray = @[@"不限",@"发布中",@"处理中",@"已结案"];
                        [weakself showBlurInView:weakself.view withArray:stateArray withTop:weakself.chooseView.height finishBlock:^(NSString *text, NSInteger row) {
                            [selectedButton setTitle:text forState:0];
                            
                            if (row <= 2) {
                                NSString *value = [NSString stringWithFormat:@"%d",row];
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
                    [weakself.tableView11 removeFromSuperview];
                    [weakself.tableView12 removeFromSuperview];
                    [weakself.tableView13 removeFromSuperview];
                    if (selectedButton.selected) {
                        weakself.chooseView.squrebutton.selected = NO;
                        weakself.chooseView.stateButton.selected = NO;
                        
                        
                        NSArray *moneyArray = @[@"不限",@"30万以下",@"30-100万",@"100-500万",@"500万以上"];
                        [weakself showBlurInView:weakself.view withArray:moneyArray withTop:selectedButton.height finishBlock:^(NSString *text, NSInteger row) {
                            [selectedButton setTitle:text forState:0];
                            
                            NSString *value = [NSString stringWithFormat:@"%d",row];
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

- (UITableView *)tableView11
{
    if (!_tableView11) {
        _tableView11 = [UITableView newAutoLayoutView];
        _tableView11.delegate = self;
        _tableView11.dataSource = self;
        _tableView11.tableFooterView = [[UIView alloc] init];
//        _tableView11.backgroundColor = UIColorFromRGB1(0x333333, 0.3);
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
        
        NewProductListModel *proModel = self.allDataList[indexPath.section];

        [cell.recommendimageView setHidden:YES];
        
        cell.moneyView.label1.text = proModel.money;
        cell.moneyView.label2.text = @"借款本金(万元)";
        
        if ([proModel.category isEqualToString:@"1"]) {//融资
            [cell.typeImageView setImage:[UIImage imageNamed:@"list_financing"]];
            cell.addressLabel.text = proModel.location;
            cell.pointView.label1.text = proModel.rebate;
            cell.pointView.label2.text = @"返点(%)";
            cell.rateView.label1.text = proModel.rate;
            if ([proModel.rate_cat isEqualToString:@"1"]) {
                cell.rateView.label2.text = @"借款利率(%/天)";
            }else{
                cell.rateView.label2.text = @"借款利率(%/月)";
            }
        }else if ([proModel.category isEqualToString:@"2"]){//清收
            [cell.typeImageView setImage:[UIImage imageNamed:@"list_collection"]];
            
            cell.pointView.label1.text = proModel.agencycommission;
            if ([proModel.agencycommissiontype isEqualToString:@"1"]) {
                cell.pointView.label2.text = @"提成比例(%)";
            }else{
                cell.pointView.label2.text = @"固定费用(万)";
            }
            if ([proModel.loan_type isEqualToString:@"1"]) {
                cell.rateView.label1.text = @"房产抵押";
                cell.addressLabel.text = proModel.location;
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
        }else{//诉讼
            [cell.typeImageView setImage:[UIImage imageNamed:@"list_litigation"]];
            cell.pointView.label1.text = proModel.agencycommission;
            if ([proModel.agencycommissiontype isEqualToString:@"1"]) {
                cell.pointView.label2.text = @"固定费用(万)";
            }else{
                cell.pointView.label2.text = @"风险费率(%)";
            }
            if ([proModel.loan_type isEqualToString:@"1"]) {
                cell.rateView.label1.text = @"房产抵押";
                cell.addressLabel.text = proModel.location;
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
        }
        
        cell.nameLabel.text = proModel.codeString;
        
        //typeButton
        if([proModel.progress_status integerValue]  == 4){//结案
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
//
//        if (indexPath.row == 0) {
//            [cell.upButton setTitle:@"不限" forState:0];
//        }else{
//            [cell.upButton setTitle:self.provinceDictionary.allValues[indexPath.row-1] forState:0];
//        }
//        
//        QDFWeakSelf;
//        [cell.upButton addAction:^(UIButton *btn) {
//            [weakself selectedCellButtonWithRow:indexPath.row withIdentifier:@"11" withButton:btn];
//        }];
        
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
        [cell.oneButton setTitleColor:kBlueColor forState:UIControlStateSelected];
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
    } else if (tableView == self.tableView11){//省份
        
        if (indexPath.row == 0) {
            [self.chooseView.squrebutton setTitle:@"不限" forState:0];
            
            [self.tableView11 removeFromSuperview];
            [self.tableView12 removeFromSuperview];
            [self.tableView13 removeFromSuperview];
            
            [self.paramsDictionary setValue:@"0" forKey:@"province"];
            [self.paramsDictionary setValue:@"0" forKey:@"city"];
            [self.paramsDictionary setValue:@"0" forKey:@"area"];
            
            [self headerRefreshWithAllProducts];
            
        }else{
            
//            BidOneCell *cell = [self.tableView11 cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
//            [cell.oneButton setTitleColor:kBlueColor forState:0];
            
            [self.view addSubview:self.tableView12];
            self.widthConstraints.constant = kScreenWidth/2;
            [self.tableView12 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.tableView11];
            [self.tableView12 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.tableView11];
            [self.tableView12 autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.tableView11];
            [self.tableView12 autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.tableView11];
            
            _proString = self.provinceDictionary.allKeys[indexPath.row-1];
            
            [self getCityListWithProvinceID:self.provinceDictionary.allKeys[indexPath.row-1]];
        }
    }else if (tableView == self.tableView12){//市
        
//        BidOneCell *cell = [self.tableView12 cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
//        [cell.oneButton setTitleColor:kBlueColor forState:0];
        
        [self.view addSubview:self.tableView13];
        self.widthConstraints.constant = kScreenWidth/3;
        [self.tableView13 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.tableView12];
        [self.tableView13 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.tableView11];
        [self.tableView13 autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.tableView11];
        [self.tableView13 autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.tableView11];
        
        _cityString = self.cityDcitionary.allKeys[indexPath.row];

        [self getDistrictListWithCityID:self.cityDcitionary.allKeys[indexPath.row]];
        
    }else if (tableView == self.tableView13){//区
    
//        BidOneCell *cell = [self.tableView13 cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
//        [cell.oneButton setTitleColor:kBlueColor forState:0];
//        
//        cell.selectedBackgroundView = [[UIView alloc] init];
//        cell.selectedBackgroundView.backgroundColor = kCellSelectedColor;
    
        [self.tableView11 removeFromSuperview];
        [self.tableView12 removeFromSuperview];
        [self.tableView13 removeFromSuperview];
        
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

/*
- (void)selectedCellButtonWithRow:(NSInteger)indexRow withIdentifier:(NSString *)identifier withButton:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if ([identifier isEqualToString:@"11"]) {//省份
        if (indexRow == 0) {
            [self.chooseView.squrebutton setTitle:@"不限" forState:0];
            
            [self.tableView11 removeFromSuperview];
            [self.tableView12 removeFromSuperview];
            [self.tableView13 removeFromSuperview];
            
            [self.paramsDictionary setValue:@"0" forKey:@"province"];
            [self.paramsDictionary setValue:@"0" forKey:@"city"];
            [self.paramsDictionary setValue:@"0" forKey:@"area"];
            
            [self headerRefreshWithAllProducts];
            
        }else{
            [self.view addSubview:self.tableView12];
            self.widthConstraints.constant = kScreenWidth/2;
            [self.tableView12 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.tableView11];
            [self.tableView12 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.tableView11];
            [self.tableView12 autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.tableView11];
            [self.tableView12 autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.tableView11];
            
            _proString = self.provinceDictionary.allKeys[indexRow-1];
            
            [self getCityListWithProvinceID:self.provinceDictionary.allKeys[indexRow-1]];
        }
    }else if ([identifier isEqualToString:@"12"]){
        [self.view addSubview:self.tableView13];
        self.widthConstraints.constant = kScreenWidth/3;
        [self.tableView13 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.tableView12];
        [self.tableView13 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.tableView11];
        [self.tableView13 autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.tableView11];
        [self.tableView13 autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.tableView11];
        
        _cityString = self.cityDcitionary.allKeys[indexRow];
        
        [self getDistrictListWithCityID:self.cityDcitionary.allKeys[indexRow]];

    }else{
        [self.tableView11 removeFromSuperview];
        [self.tableView12 removeFromSuperview];
        [self.tableView13 removeFromSuperview];
        
        UIButton *but1 = [self.view viewWithTag:202];
        UIButton *but2 = [self.view viewWithTag:203];
        but1.userInteractionEnabled = YES;
        but2.userInteractionEnabled = YES;
        
        [self.chooseView.squrebutton setTitle:self.districtDictionary.allValues[indexRow] forState:0];
        self.widthConstraints.constant = kScreenWidth;
        [self.paramsDictionary setValue:_proString forKey:@"province"];
        [self.paramsDictionary setValue:_cityString forKey:@"city"];
        [self.paramsDictionary setValue:self.districtDictionary.allKeys[indexRow] forKey:@"area"];
        
        [self headerRefreshWithAllProducts];

    }
}
*/
 
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
    self.paramsDictionary[@"category"] = self.paramsDictionary[@"category"]?self.paramsDictionary[@"category"]:@"0";
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
    NSString *pp = [NSString stringWithFormat:@"%d",_page];
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
