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

#import "MainView.h"

@interface MainViewController ()<TabBarDelegate,UIActionSheetDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showTabBarItem];
    
//    [self.view setNeedsUpdateConstraints];
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
    
//    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
//    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    TabBar *tabBar = [[TabBar alloc] initWithFrame:tabBarController.tabBar.bounds];
    
    CGFloat normalButtonWidth = kScreenWidth/5;
    //(kScreenWidth * 3 / 4) / 4;
    CGFloat tabBarHeight = CGRectGetHeight(tabBar.frame);
    CGFloat publishItemWidth = kScreenWidth/5;
    //(kScreenWidth / 4);
    
    TabBarItem *newProductItem = [self tabBarItemWithFram:CGRectMake(0, 0, normalButtonWidth, tabBarHeight) title:@"精选" normalImageName:@"tab_recommend" selectedImageName:@"tab_recommend_s" tabBarItemType:TabBarItemTypeNormal];
    TabBarItem *productsItem = [self tabBarItemWithFram:CGRectMake(normalButtonWidth, 0, normalButtonWidth, tabBarHeight) title:@"产品" normalImageName:@"tab_product" selectedImageName:@"tab_product_s" tabBarItemType:TabBarItemTypeNormal];
    
    TabBarItem *publishItem = [self tabBarItemWithFram:CGRectMake(normalButtonWidth * 2, 4.5, normalButtonWidth, tabBarHeight) title:@"" normalImageName:@"publishs" selectedImageName:@"" tabBarItemType:TabBarItemTypeRise];
    
    [publishItem addAction:^(UIButton *btn) {
        
        NSLog(@"诉讼");
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        UITabBarController *tabBarController = (UITabBarController *)window.rootViewController;
        //
        UINavigationController *viewController = tabBarController.selectedViewController;
        
        UIAlertController *tabAlertController = [UIAlertController alertControllerWithTitle:@"测试" message:@"发布清收融资" preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *act1 = [UIAlertAction actionWithTitle:@"诉讼" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            ReportSuitViewController *reportSuitVC = [[ReportSuitViewController alloc] init];
            [reportSuitVC setHidesBottomBarWhenPushed:YES];
            [viewController pushViewController:reportSuitVC animated:YES];
        }];
        
        UIAlertAction *act2 = [UIAlertAction actionWithTitle:@"清收" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction *act3 = [UIAlertAction actionWithTitle:@"融资" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            ReportFinanceViewController *reportFinanceVC = [[ReportFinanceViewController alloc] init];
            [reportFinanceVC setHidesBottomBarWhenPushed:YES];
            [viewController pushViewController:reportFinanceVC animated:YES];
        }];
        
        UIAlertAction *act0 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [tabAlertController addAction:act1];
        [tabAlertController addAction:act2];
        [tabAlertController addAction:act3];
        [tabAlertController addAction:act0];
        
        [viewController presentViewController:tabAlertController animated:YES completion:nil];
    }];
    
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
    
        NSLog(@"发布");
    
//    UIView *showView = [UIView newAutoLayoutView];
//    //
//    [showView setBackgroundColor:kBlackColor];
//    showView.alpha = 0.8;
//    [window addSubview:showView];
//    [showView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
//    return;

    
}

- (void)displayView
{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UITabBarController *tabBarController = (UITabBarController *)window.rootViewController;
    //
    UINavigationController *viewController = tabBarController.selectedViewController;
    
    UIAlertController *tabAlertController = [UIAlertController alertControllerWithTitle:@"测试" message:@"发布清收融资" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *act1 = [UIAlertAction actionWithTitle:@"诉讼" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ReportSuitViewController *reportSuitVC = [[ReportSuitViewController alloc] init];
        [reportSuitVC setHidesBottomBarWhenPushed:YES];
        [viewController pushViewController:reportSuitVC animated:YES];
    }];
    
    UIAlertAction *act2 = [UIAlertAction actionWithTitle:@"清收" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *act3 = [UIAlertAction actionWithTitle:@"融资" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ReportFinanceViewController *reportFinanceVC = [[ReportFinanceViewController alloc] init];
        [reportFinanceVC setHidesBottomBarWhenPushed:YES];
        [viewController pushViewController:reportFinanceVC animated:YES];
    }];
    
    UIAlertAction *act0 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [tabAlertController addAction:act1];
    [tabAlertController addAction:act2];
    [tabAlertController addAction:act3];
    [tabAlertController addAction:act0];
    
    [viewController presentViewController:tabAlertController animated:YES completion:nil];
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
