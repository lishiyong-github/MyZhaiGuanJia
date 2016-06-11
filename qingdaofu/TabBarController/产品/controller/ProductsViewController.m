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
#import "UIImage+Color.h"
#import "AllProView.h"

#import "AllProductsChooseView.h"

@interface ProductsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UIButton *proTitleView;
@property (nonatomic,strong) AllProductsChooseView *chooseView;
@property (nonatomic,strong) UITableView *productsTableView;

@property (nonatomic,strong) UIButton *backButtonView;
@property (nonatomic,strong) AllProView *proView;
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
    [self.view addSubview:self.backButtonView];
    [self.backButtonView setHidden:YES];
    
    self.topConstraints = [self.backButtonView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:40];

    self.proView.heightTableConstraints = [self.proView autoSetDimension:ALDimensionHeight toSize:240];
    
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
        
        [self.backButtonView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        
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
            btn.selected = !btn.selected;
            
            if (btn.selected) {
                [weakself.backButtonView setHidden:NO];
                weakself.topConstraints.constant = 0;
                weakself.proView.dataList = @[@"全部",@"融资",@"催收",@"诉讼"];
                weakself.proView.heightTableConstraints.constant = 5*40;
                [weakself.proView reloadData];
            }else{
                [weakself.backButtonView setHidden:YES];
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
                    
                    [weakself.backButtonView setHidden:YES];
                }
                    break;
                case 202:{//状态
                    
                    selectedButton.selected = !selectedButton.selected;
                    
                    if (selectedButton.selected) {
                        [weakself.backButtonView setHidden:NO];
                        weakself.topConstraints.constant = 40;
                        weakself.proView.dataList = @[@"不限",@"发布中",@"处理中",@"已结案"];
                        weakself.proView.heightTableConstraints.constant = 5*40;
                        [weakself.proView reloadData];
                    }else{
                        [weakself.backButtonView setHidden:YES];
                    }
                    
                }
                    break;
                case 203:{//金额

                    selectedButton.selected = !selectedButton.selected;

                    if (selectedButton.selected) {
                        weakself.topConstraints.constant = 40;

                        [weakself.backButtonView setHidden:NO];
                        weakself.proView.dataList = @[@"不限",@"30万以下",@"30-100万",@"100-500万",@"500万以上"];
                        weakself.proView.heightTableConstraints.constant = 6*40;
                        [weakself.proView reloadData];
                    }else{
                        [weakself.backButtonView setHidden:YES];
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

- (UIButton *)backButtonView
{
    if (!_backButtonView) {
        _backButtonView = [UIButton newAutoLayoutView];
        _backButtonView.backgroundColor = kBlackColor;
        _backButtonView.alpha = 0.8;
        [_backButtonView addSubview:self.proView];
        
//        QDFWeakSelf;
//        [_backButtonView addAction:^(UIButton *btn) {
//            [weakself.backButtonView setHidden:YES];
//            weakself.chooseView.squrebutton.selected = NO;
//            weakself.chooseView.stateButton.selected = NO;
//            weakself.chooseView.moneyButton.selected = NO;
//        }];
        
        [self.proView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    }
    return _backButtonView;
}

- (AllProView *)proView
{
    if (!_proView) {
        _proView = [AllProView newAutoLayoutView];
        _proView.backgroundColor = kNavColor;
        
        QDFWeakSelf;
        [_proView setDidSelectedRow:^(NSIndexPath *indexPath) {
            
            
        }];
    }
    return _proView;
}

- (UITableView *)productsTableView
{
    if (!_productsTableView) {
//        _productsTableView = [UITableView newAutoLayoutView];
        _productsTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _productsTableView = [[UITableView alloc ]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        _productsTableView.delegate = self;
        _productsTableView.dataSource = self;
        _productsTableView.backgroundColor = kBackColor;
        _productsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
    }
    return _productsTableView;
}

#pragma mark - tableView delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 10;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 156;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"pros";
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[HomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell.recommendimageView setHidden:YES];

    UIView *cellbackButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, kBigPadding, kScreenWidth, 156)];
    cellbackButtonView.backgroundColor = kSeparateColor;
    cell.selectedBackgroundView = cellbackButtonView;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ProductsDetailsViewController *productsDetailsVC = [[ProductsDetailsViewController alloc] init];
    productsDetailsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:productsDetailsVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kBigPadding;
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
    
//    [self presentViewController:searchVC animated:YES completion:nil];
}

- (void)getProductsListWithPage:(NSString *)page
{
    
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
