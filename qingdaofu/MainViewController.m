//
//  MainViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/17.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MainViewController.h"

#import "TabBar.h"
#import "TabBarItem.h"

#import "NewProductViewController.h"
#import "ProductsViewController.h"
#import "MessageViewController.h"
#import "MineViewController.h"

#import "ReportFinanceViewController.h"  //融资
#import "ReportSuitViewController.h"     //诉讼

#import "UIViewController+BlurView.h"

@interface MainViewController ()<TabBarDelegate,UIActionSheetDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showTabBarItem];
}

- (void)showTabBarItem
{
    NewProductViewController *newProductVC = [[NewProductViewController alloc] init];
    UINavigationController *newproductNav = [[UINavigationController alloc] initWithRootViewController:newProductVC];
    
    ProductsViewController *productsVC = [[ProductsViewController alloc] init];
    UINavigationController *productsNav = [[UINavigationController alloc] initWithRootViewController:productsVC];
    
    MessageViewController *messageVC = [[MessageViewController alloc] init];
    UINavigationController *messageNav = [[UINavigationController alloc] initWithRootViewController:messageVC];
    
    MineViewController *mineVC = [[MineViewController alloc] init];
    UINavigationController *mineNav = [[UINavigationController alloc] initWithRootViewController:mineVC];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[newproductNav,productsNav,messageNav,mineNav];
    
    TabBar *tabBar = [[TabBar alloc] initWithFrame:tabBarController.tabBar.bounds];
    
    CGFloat normalButtonWidth = kScreenWidth/5;
    CGFloat tabBarHeight = CGRectGetHeight(tabBar.frame);
    CGFloat publishItemWidth = kScreenWidth/5;
    
    TabBarItem *newProductItem = [self tabBarItemWithFram:CGRectMake(0, 0, normalButtonWidth, tabBarHeight) title:@"精选" normalImageName:@"tab_recommend" selectedImageName:@"tab_recommend_s" tabBarItemType:TabBarItemTypeNormal];
    TabBarItem *productsItem = [self tabBarItemWithFram:CGRectMake(normalButtonWidth, 0, normalButtonWidth, tabBarHeight) title:@"产品" normalImageName:@"tab_product" selectedImageName:@"tab_product_s" tabBarItemType:TabBarItemTypeNormal];
    
    TabBarItem *publishItem = [self tabBarItemWithFram:CGRectMake(normalButtonWidth * 2, 4.5, normalButtonWidth, tabBarHeight) title:@"" normalImageName:@"publishs" selectedImageName:@"" tabBarItemType:TabBarItemTypeRise];
    
    TabBarItem *messageItem = [self tabBarItemWithFram:CGRectMake(normalButtonWidth * 2 + publishItemWidth, 0, normalButtonWidth, tabBarHeight) title:@"消息" normalImageName:@"news" selectedImageName:@"news_s" tabBarItemType:TabBarItemTypeNormal];
    TabBarItem *mineItem = [self tabBarItemWithFram:CGRectMake(normalButtonWidth * 3 + publishItemWidth, 0, normalButtonWidth, tabBarHeight) title:@"用户" normalImageName:@"tab_user" selectedImageName:@"tab_user_s" tabBarItemType:TabBarItemTypeNormal];
    
    tabBar.tabBarItems = @[newProductItem,productsItem,publishItem,messageItem,mineItem];
    tabBar.delegate = self;
    [tabBarController.tabBar addSubview:tabBar];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = tabBarController;
}

- (TabBarItem *)tabBarItemWithFram:(CGRect)frame title:(NSString *)title normalImageName:(NSString *)normalImageName selectedImageName:(NSString *)selectedImageName tabBarItemType:(TabBarItemType)tabBarItemType
{
    TabBarItem *item = [[TabBarItem alloc] initWithFrame:frame];
    [item setTitle:title forState:0];
    [item setTitle:title forState:UIControlStateSelected];
    item.titleLabel.font = kTabBarFont;
    
    UIImage *normalImage = [UIImage imageNamed:normalImageName];
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    
    [item setImage:normalImage forState:0];
    [item setImage:selectedImage forState:UIControlStateSelected];
    [item setTitleColor:kLightGrayColor forState:0];
    [item setTitleColor:kBlueColor forState:UIControlStateSelected];
    item.tabBarItemType = tabBarItemType;
    
    return item;
}

#pragma mark - tabBar delegate
- (void)tabBarDidSelectedRiseButton
{
    QDFWeakSelf;
    [self showBlurInView:[UIApplication sharedApplication].keyWindow withArray:nil finishBlock:^(NSInteger row) {
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        UITabBarController *tabBarController = (UITabBarController *)window.rootViewController;
        UINavigationController *viewController = tabBarController.selectedViewController;
        
        [weakself tokenIsValid];
        [weakself setDidTokenValid:^(TokenModel *tokenModel) {
            if ([tokenModel.code isEqualToString:@"0000"]) {
                if (row == 11) {
                    ReportFinanceViewController *reportFinanceVC = [[ReportFinanceViewController alloc] init];
                    reportFinanceVC.hidesBottomBarWhenPushed = YES;
                    [viewController pushViewController:reportFinanceVC animated:YES];
                }else if (row == 12){
                    ReportSuitViewController *collectVC = [[ReportSuitViewController alloc] init];
                    collectVC.categoryString = @"2";
                    collectVC.hidesBottomBarWhenPushed = YES;
                    [viewController pushViewController:collectVC animated:YES];
                }else{
                    ReportSuitViewController *reportSuitVC = [[ReportSuitViewController alloc] init];
                    reportSuitVC.categoryString = @"3";
                    reportSuitVC.hidesBottomBarWhenPushed = YES;
                    [viewController pushViewController:reportSuitVC animated:YES];
                }

            }else{
                [weakself showHint:tokenModel.msg];
            }
        }];
                
    }];
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
