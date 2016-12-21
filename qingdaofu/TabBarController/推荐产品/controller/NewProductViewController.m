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

#import "MineUserCell.h"
#import "NewPublishCell.h"  //诉讼保全
#import "HomesCell.h"
#import "MainProductview.h"

#import "ReleaseResponse.h"
#import "RowsModel.h"
#import "PublishingModel.h"
#import "ApplyRecordModel.h"
//轮播图
#import "BannerResponse.h"
#import "ImageModel.h"

#import "UIImage+Color.h"
#import "UIViewController+BlurView.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"

@interface NewProductViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *mainTableView;
////////轮播图
@property (nonatomic,strong) UIView *mainHeaderView;
@property (nonatomic,strong) UIScrollView *mainHeaderScrollView;
@property (nonatomic,strong) UIPageControl *pageControl;

@property (nonatomic,strong) UIScrollView *mainProductScrollView;//产品列表

//json解析
@property (nonatomic,strong) NSMutableArray *productsDataListArray;
@property (nonatomic,strong) NSMutableDictionary *propagandaDic;
@property (nonatomic,strong) NSMutableArray *propagandaArray; //轮播图
@property (nonatomic,strong) NSString *sumString; //累计交易总量

@end

@implementation NewProductViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self getRecommendProductslist];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.mainTableView];
    
    [self.view setNeedsUpdateConstraints];
    
    [self performSelector:@selector(chechAppNewVersion) withObject:nil afterDelay:5];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.mainTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(20, 0, 0, 0) excludingEdge:ALEdgeBottom];
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
        _mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding*2)];
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
        _mainHeaderScrollView.contentSize = CGSizeMake(kScreenWidth*self.propagandaArray.count, 110);
        _mainHeaderScrollView.pagingEnabled = YES;//分页
        _mainHeaderScrollView.delegate = self;
        _mainHeaderScrollView.scrollEnabled = YES;
        _mainHeaderScrollView.showsHorizontalScrollIndicator = NO;
        
        for (NSInteger t=0; t<self.propagandaArray.count; t++) {
            
            ImageModel *bannerModel = self.propagandaArray[t];
            
            UIButton *imageButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth*t, 0, kScreenWidth, 110)];
            [imageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:bannerModel.file] forState:0 placeholderImage:[UIImage imageNamed:@"banner_account_bitmap"]];
            [_mainHeaderScrollView addSubview:imageButton];
            
            QDFWeakSelf;
            [imageButton addAction:^(UIButton *btn) {
                MarkingViewController *markingVC = [[MarkingViewController alloc] init];
                markingVC.hidesBottomBarWhenPushed = YES;
                markingVC.markString = bannerModel.url;
                markingVC.navTitle = bannerModel.title;
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
        _pageControl.pageIndicatorTintColor = UIColorFromRGB1(0xffffff, 0.5);
        _pageControl.currentPageIndicatorTintColor = kBlueColor;
        [_pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
        if (self.propagandaArray.count <= 1) {
            _pageControl.numberOfPages = 0;
            _pageControl.currentPage = 0;
        }else{
            _pageControl.numberOfPages = self.propagandaArray.count;
            _pageControl.currentPage = 0;
        }
    }
    return _pageControl;
}

- (UIScrollView *)mainProductScrollView
{
    if (!_mainProductScrollView) {
        _mainProductScrollView = [UIScrollView newAutoLayoutView];
        _mainProductScrollView.backgroundColor = kWhiteColor;
        _mainProductScrollView.contentSize = CGSizeMake(170*self.productsDataListArray.count+10, 220);
        _mainProductScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _mainProductScrollView;
}

- (NSMutableArray *)productsDataListArray
{
    if (!_productsDataListArray) {
        _productsDataListArray = [NSMutableArray array];
    }
    return _productsDataListArray;
}

- (NSMutableArray *)propagandaArray
{
    if (!_propagandaArray) {
        _propagandaArray = [NSMutableArray array];
    }
    return _propagandaArray;
}

#pragma mark - tableView delelagte and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {//累计交易总量
        return 90;
    }else if (indexPath.section == 1){
        return 100;
    }
    return 122;//产品列表
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    if (indexPath.section == 0) {//累计交易总量
        identifier = @"main1";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.userActionButton setTitle:@"查看详情  " forState:0];
        [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        cell.userNameButton.titleLabel.numberOfLines = 0;
        
        NSString *all1 = @"累计交易总量\n";
        NSString *all2 = [NSString getValidStringFromString:self.sumString toString:@"100000"];
        NSString *all3;
        if (all2.length < 9) {//小于1亿
            all3 = @"元";
        }else{//大于1亿
            all2 = [all2 substringToIndex:all2.length-4];
            all2 = [self addSeparatorForString:[NSString getValidStringFromString:all2 toString:@"10000"]];
            all3 = @"万";
        }
        NSString *all = [NSString stringWithFormat:@"%@%@%@",all1,all2,all3];
        NSMutableAttributedString *attributeAll = [[NSMutableAttributedString alloc] initWithString:all];
        [attributeAll setAttributes:@{NSFontAttributeName : kFirstFont,NSForegroundColorAttributeName:kBlackColor} range:NSMakeRange(0, all1.length)];
        [attributeAll setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:30],NSForegroundColorAttributeName:kTextColor} range:NSMakeRange(all1.length, all2.length)];
        [attributeAll setAttributes:@{NSFontAttributeName : kNavFont,NSForegroundColorAttributeName:kTextColor} range:NSMakeRange(all1.length  + all2.length,all3.length)];

        NSMutableParagraphStyle *styleAll = [[NSMutableParagraphStyle alloc] init];
        [styleAll setLineSpacing:kSmallPadding];
        styleAll.alignment = 0;
        [attributeAll addAttribute:NSParagraphStyleAttributeName value:styleAll range:NSMakeRange(0, all.length)];
        [cell.userNameButton setAttributedTitle:attributeAll forState:0];
        
        return cell;
        
    }else if (indexPath.section == 1){//四大功能
        identifier = @"main1";
        NewPublishCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];
        if (!cell) {
            cell = [[NewPublishCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        QDFWeakSelf;
        [cell setDidSelectedItem:^(NSInteger tag) {
            if (tag == 11){//保全
                PowerProtectViewController *powerProtectVC = [[PowerProtectViewController alloc] init];
                powerProtectVC.hidesBottomBarWhenPushed = YES;
                [weakself.navigationController pushViewController:powerProtectVC animated:YES];
            }else if (tag == 12){//保函
                ApplicationGuaranteeViewController *applicationGuaranteeVC = [[ApplicationGuaranteeViewController alloc] init];
                applicationGuaranteeVC.hidesBottomBarWhenPushed = YES;
                [weakself.navigationController pushViewController:applicationGuaranteeVC animated:YES];
            }else if (tag == 13) {//房产评估
                HouseAssessViewController *houseAssessVC = [[HouseAssessViewController alloc] init];
                houseAssessVC.hidesBottomBarWhenPushed = YES;
                [weakself.navigationController pushViewController:houseAssessVC animated:YES];
            }else if (tag == 14){//产调
                HousePropertyViewController *housePropertyVC = [[HousePropertyViewController alloc] init];
                housePropertyVC.hidesBottomBarWhenPushed = YES;
                [weakself.navigationController pushViewController:housePropertyVC animated:YES];
            }
        }];
        return cell;
    }
    
    identifier = @"main2";//精选列表
    HomesCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[HomesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    RowsModel *rowModel = self.productsDataListArray[indexPath.section - 2];
    
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
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 275;
    }
    return kBigPadding;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, kSmallPadding, kScreenWidth, 275)];
        footerView.backgroundColor = kBackColor;
        
        if (self.productsDataListArray.count > 0) {
            //推荐产品
            UIButton *sssButton = [UIButton newAutoLayoutView];
            [sssButton setTitle:@"推荐产品" forState:0];
            [sssButton setTitleColor:kBlackColor forState:0];
            sssButton.titleLabel.font = kFirstFont;
            [sssButton setBackgroundColor:kWhiteColor];
            [sssButton setContentHorizontalAlignment:1];
            [sssButton setContentEdgeInsets:UIEdgeInsetsMake(0, kSmallPadding, 0, 0)];
            
            [footerView addSubview:sssButton];
            [footerView addSubview:self.mainProductScrollView];
            
            [sssButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:footerView withOffset:kSmallPadding];
            [sssButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:footerView];
            [sssButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:footerView];
            [sssButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.mainProductScrollView];
            
            [self.mainProductScrollView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:footerView withOffset:-kSmallPadding];
            [self.mainProductScrollView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:footerView];
            [self.mainProductScrollView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:footerView];
            [self.mainProductScrollView autoSetDimension:ALDimensionHeight toSize:220];
            
            /////////
            for (NSInteger k=0; k<self.productsDataListArray.count; k++) {
                MainProductview *productView = [[MainProductview alloc] initWithFrame:CGRectMake(160*k + 10*(k+1), 0, 160, 210)];
                productView.backgroundColor = kBackColor;
                [self.mainProductScrollView addSubview:productView];
                
                RowsModel *rowModel = self.productsDataListArray[k];
                
                //image
                NSString *iiii = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,rowModel.fabuuser.headimg.file];
                [productView.userImageView sd_setImageWithURL:[NSURL URLWithString:iiii] placeholderImage:[UIImage imageNamed:@"icon_head"]];
                
                //store state
                if (!rowModel.collectSelf) {//未收藏
                [productView.storeButton setImage:[UIImage imageNamed:@"nav_collection"] forState:0];
                }else{
                    [productView.storeButton setImage:[UIImage imageNamed:@"nav_collection_s"] forState:0];
                }
                QDFWeakSelf;
                [productView.storeButton addAction:^(UIButton *btn) {
                    [weakself goStoreProductWithModel:rowModel andButton:btn];
                }];
                
                //category
                NSArray *ssssArray = [rowModel.categoryLabel componentsSeparatedByString:@","];
                if (ssssArray.count == 1) {
                    [productView.categoryLabel2 setHidden:YES];
                    [productView.categoryLabel3 setHidden:YES];
                    [productView.categoryLabel4 setHidden:YES];
                    [productView.categoryLabel1 setText:ssssArray[0]];
                }else if (ssssArray.count == 2){
                    [productView.categoryLabel2 setHidden:NO];
                    [productView.categoryLabel3 setHidden:YES];
                    [productView.categoryLabel4 setHidden:YES];
                    [productView.categoryLabel1 setText:ssssArray[0]];
                    [productView.categoryLabel2 setText:ssssArray[1]];
                }else if (ssssArray.count == 3){
                    [productView.categoryLabel2 setHidden:NO];
                    [productView.categoryLabel3 setHidden:NO];
                    [productView.categoryLabel4 setHidden:YES];
                    [productView.categoryLabel1 setText:ssssArray[0]];
                    [productView.categoryLabel2 setText:ssssArray[1]];
                    [productView.categoryLabel3 setText:ssssArray[2]];
                }else if (ssssArray.count == 4){
                    [productView.categoryLabel2 setHidden:NO];
                    [productView.categoryLabel3 setHidden:NO];
                    [productView.categoryLabel4 setHidden:NO];
                    [productView.categoryLabel1 setText:ssssArray[0]];
                    [productView.categoryLabel2 setText:ssssArray[1]];
                    [productView.categoryLabel3 setText:ssssArray[2]];
                    [productView.categoryLabel4 setText:ssssArray[3]];
                }

                //委托费用
                NSString *ttt1 = rowModel.typenumLabel;
                NSString *ttt2 = [NSString stringWithFormat:@"%@\n",rowModel.typeLabel];
                NSString *ttt3;
                if ([rowModel.typeLabel isEqualToString:@"%"]) {
                    ttt3 = @"风险费率";
                }else if ([rowModel.typeLabel isEqualToString:@"万"]){
                    ttt3 = @"固定费用";
                }
                NSString *tttt = [NSString stringWithFormat:@"%@%@%@",ttt1,ttt2,ttt3];
                NSMutableAttributedString *attriTT = [[NSMutableAttributedString alloc] initWithString:tttt];
                [attriTT setAttributes:@{NSFontAttributeName:kBoldFont1,NSForegroundColorAttributeName:kRedColor} range:NSMakeRange(0,ttt1.length)];
                [attriTT setAttributes:@{NSFontAttributeName:kFont10,NSForegroundColorAttributeName:kRedColor} range:NSMakeRange(ttt1.length,ttt2.length)];
                [attriTT setAttributes:@{NSFontAttributeName:kTabBarFont,NSForegroundColorAttributeName:kGrayColor} range:NSMakeRange(ttt1.length+ttt2.length,ttt3.length)];
                NSMutableParagraphStyle *stylrr = [[NSMutableParagraphStyle alloc] init];
                [stylrr setLineSpacing:4];
                stylrr.alignment = 1;
                [attriTT addAttribute:NSParagraphStyleAttributeName value:stylrr range:NSMakeRange(0, tttt.length)];
                [productView.leftButton setAttributedTitle:attriTT forState:0];
                
                //委托金额
                NSString *mmm1 = rowModel.accountLabel;
                NSString *mmm2 = [NSString stringWithFormat:@"万\n"];
                NSString *mmm3 = @"委托金额";
                NSString *mmmm = [NSString stringWithFormat:@"%@%@%@",mmm1,mmm2,mmm3];
                NSMutableAttributedString *attriMMM = [[NSMutableAttributedString alloc] initWithString:mmmm];
                [attriMMM setAttributes:@{NSFontAttributeName:kBoldFont1,NSForegroundColorAttributeName:kRedColor} range:NSMakeRange(0,mmm1.length)];
                [attriMMM setAttributes:@{NSFontAttributeName:kFont10,NSForegroundColorAttributeName:kRedColor} range:NSMakeRange(mmm1.length,mmm2.length)];
                [attriMMM setAttributes:@{NSFontAttributeName:kTabBarFont,NSForegroundColorAttributeName:kGrayColor} range:NSMakeRange(mmm1.length+mmm2.length,mmm3.length)];
                NSMutableParagraphStyle *styler = [[NSMutableParagraphStyle alloc] init];
                [styler setLineSpacing:4];
                styler.alignment = 1;
                [attriMMM addAttribute:NSParagraphStyleAttributeName value:styler range:NSMakeRange(0, mmmm.length)];
                [productView.rightButton setAttributedTitle:attriMMM forState:0];
                
                //立即申请
                if ([rowModel.status integerValue] > 10) {
                    [productView.applyButton setTitle:@"已撮合" forState:0];
                    [productView.applyButton setTitleColor:kLightGrayColor  forState:0];
                    productView.applyButton.layer.borderColor = kBorderColor.CGColor;
                }else if(rowModel.applySelf){
                    [productView.applyButton setTitleColor:kLightGrayColor  forState:0];
                    productView.applyButton.layer.borderColor = kBorderColor.CGColor;
                    if ([rowModel.applySelf.status integerValue] == 10) {
                        [productView.applyButton setTitle:@"取消申请" forState:0];
                    }else{
                        [productView.applyButton setTitle:@"面谈中" forState:0];
                    }
                }else{
                    [productView.applyButton setTitle:@"立即申请" forState:0];
                    [productView.applyButton setTitleColor:kTextColor forState:0];
                    productView.applyButton.layer.borderColor = kButtonColor.CGColor;
                }
                [productView.applyButton addAction:^(UIButton *btn) {
                    [weakself goApplyProductWithModel:rowModel andButton:btn];
                }];
                
                //check details
                [productView addAction:^(UIButton *btn) {
                    ProductsDetailsViewController *productsDetailVC = [[ProductsDetailsViewController alloc] init];
                    productsDetailVC.hidesBottomBarWhenPushed = YES;
                    productsDetailVC.productid = rowModel.productid;
                    [weakself.navigationController pushViewController:productsDetailVC animated:YES];
                }];
            }
        }
        return footerView;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        MarkingViewController *markingVC = [[MarkingViewController alloc] init];
        markingVC.navTitle = @"累计交易总量";
        markingVC.markString = [NSString stringWithFormat:@"%@",@"http://wx.zcb2016.com/site/total-detail"];
        markingVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:markingVC animated:YES];
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
                             @"limit" : @"10",
                             @"showtype" : @"1"};
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    QDFWeakSelf;
    [session POST:allProString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [weakself.productsDataListArray removeAllObjects];
    
        ReleaseResponse *response = [ReleaseResponse objectWithKeyValues:responseObject];

        for (RowsModel *rowModel in response.data) {
            [weakself.productsDataListArray addObject:rowModel];
        }

        weakself.sumString = response.sum;

        [weakself.mainTableView reloadData];

        if (weakself.propagandaArray.count == 0) {
            [weakself getPropagandaChar];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)goApplyProductWithModel:(RowsModel *)rowModel andButton:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"取消申请"] || [sender.titleLabel.text isEqualToString:@"立即申请"]) {
        NSString *appString;
        NSDictionary *params;
        if ([sender.titleLabel.text isEqualToString:@"立即申请"]) {
            appString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kProductDetailOfApply];
            params = @{@"productid" : rowModel.productid,
                       @"token" : [self getValidateToken]};
        }else if ([sender.titleLabel.text isEqualToString:@"取消申请"]){
            appString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyOrderDetailOfCancelApplyString];
            params = @{@"applyid" : rowModel.applySelf.applyid,
                       @"token" : [self getValidateToken]};
        }
        
        QDFWeakSelf;
        [self requestDataPostWithString:appString params:params successBlock:^(id responseObject) {
            BaseModel *appModel = [BaseModel objectWithKeyValues:responseObject];
            [weakself showHint:appModel.msg];
            
            if ([appModel.code isEqualToString:@"0000"]) {
                [weakself getRecommendProductslist];
            }
        } andFailBlock:^(NSError *error) {
            
        }];
    }
}

- (void)goStoreProductWithModel:(RowsModel *)rowModel andButton:(UIButton *)sender
{
    NSString *saveString;
    if (rowModel.collectSelf) {//(取消收藏)
        saveString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kProductDetailOfCancelSave];
    }else{//(收藏)
        saveString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kProductDetailOfSave];
    }
    NSDictionary *params = @{@"token" : [self getValidateToken],
               @"productid" : rowModel.productid};
    
    QDFWeakSelf;
    [self requestDataPostWithString:saveString params:params successBlock:^(id responseObject) {
        BaseModel *baseModel = [BaseModel objectWithKeyValues:responseObject];
        [weakself showHint:baseModel.msg];
        if ([baseModel.code isEqualToString:@"0000"]) {
            [weakself getRecommendProductslist];
        }
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

//轮播图
- (void)getPropagandaChar
{
    NSString *propagandaString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kPropagandasString];
    QDFWeakSelf;
    [self requestDataPostWithString:propagandaString params:nil successBlock:^(id responseObject) {
        BannerResponse *response = [BannerResponse objectWithKeyValues:responseObject];
        
        for (ImageModel *nannerModel in response.banner) {
            [weakself.propagandaArray addObject:nannerModel];
        }
        
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
    NSString *trackUrl = infoDic1[@"trackViewUrl"];
    NSString *trackName = infoDic1[@"trackName"];
    
    //当前版本
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleVersion"];
    
    //比较版本号
    NSString *s1 = [currentVersion substringToIndex:1];//当前
    NSString *s2 = [latestVersion substringToIndex:1];//最新
    if ([s1 integerValue] == [s2 integerValue]) {//第一位
        NSString *s11 = [currentVersion substringWithRange:NSMakeRange(2,1)];
        NSString *s22 = [latestVersion substringWithRange:NSMakeRange(2,1)];
        if ([s11 intValue] == [s22 intValue]) {
            NSString *s111 = [currentVersion substringFromIndex:4];
            NSString *s222 = [latestVersion substringFromIndex:4];
            if ([s111 integerValue] < [s222 integerValue]) {
                [self showNewVersionAlertWithTrackUrl:trackUrl andTrackName:trackName andLatestVersion:latestVersion];
            }
        }else if ([s11 integerValue] < [s22 integerValue]){
            [self showNewVersionAlertWithTrackUrl:trackUrl andTrackName:trackName andLatestVersion:latestVersion];
        }
    }else if ([s1 integerValue] < [s2 integerValue]){
        [self showNewVersionAlertWithTrackUrl:trackUrl andTrackName:trackName andLatestVersion:latestVersion];
    }
}

- (void)showNewVersionAlertWithTrackUrl:(NSString *)trackUrl andTrackName:(NSString *)trackName andLatestVersion:(NSString *)latestVersion
{
    NSString *titleStr = [NSString stringWithFormat:@"检查更新:%@",trackName];
    NSString *messageStr = [NSString stringWithFormat:@"发现新版本(%@),是否升级?",latestVersion];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:titleStr message:messageStr preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:nil];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:trackUrl]];//@"itms-apps://itunes.apple.com/us/app/qing-dao-fu-zhai-guan-jia/id1116869191?l=zh&ls=1&mt=8"
    }];
    
    [alertController addAction:action1];
    [alertController addAction:action2];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (NSString *)addSeparatorForString:(NSString *)sepaString
{
    NSMutableString *tempString = sepaString.mutableCopy;
    NSRange range = [sepaString rangeOfString:@"."];
    NSInteger index = 0;
    if (range.length > 0) {
        index = range.location;
    }else{
        index = sepaString.length;
    }
    
    while ((index-3) > 0) {
        index-=3;
        [tempString insertString:@"," atIndex:index];
    }
    tempString = [tempString stringByReplacingOccurrencesOfString:@"." withString:@","].mutableCopy;
    return tempString;
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
