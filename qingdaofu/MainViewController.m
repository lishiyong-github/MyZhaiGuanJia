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

#import "ReportSuitViewController.h"     //诉讼
#import "LoginViewController.h"
#import "AuthentyViewController.h"

#import "UIViewController+BlurView.h"

#import "ZYTabBar.h"


@interface MainViewController ()<TabBarDelegate,UIActionSheetDelegate,ZYTabBarDelegate>

@property (nonatomic,strong) NSString *trackViewUrl;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self showTabBarItem];
    
    //设置子视图
    [self setUpAllChildVc];
    [self configureZYPathButton];
}


- (void)configureZYPathButton {
    ZYTabBar *tabBar = [ZYTabBar new];
    tabBar.delegate = self;//select_
    ZYPathItemButton *itemButton_1 = [[ZYPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-music"]highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-music-highlighted"]backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    ZYPathItemButton *itemButton_2 = [[ZYPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-place"]highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-place-highlighted"]backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    
    ZYPathItemButton *itemButton_3 = [[ZYPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-camera"]highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-camera-highlighted"]backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    
    ZYPathItemButton *itemButton_4 = [[ZYPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-thought"]highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-thought-highlighted"]backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    
    ZYPathItemButton *itemButton_5 = [[ZYPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-sleep"]highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-sleep-highlighted"]backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    tabBar.pathButtonArray = @[itemButton_1 , itemButton_2 , itemButton_3, itemButton_4 , itemButton_5];
    tabBar.basicDuration = 0.5;
    tabBar.allowSubItemRotation = YES;
    tabBar.bloomRadius = 100;
    tabBar.allowCenterButtonRotation = YES;
    tabBar.bloomAngel = 100;
    //kvc实质是修改了系统的_tabBar
    [self setValue:tabBar forKeyPath:@"tabBar"];
    
}

- (void)setUpAllChildVc {
    NewProductViewController *HomeVC = [[NewProductViewController alloc] init];
    [self setUpOneChildVcWithVc:HomeVC Image:@"tab_recommend" selectedImage:@"tab_recommend_s" title:@"首页"];
    
    ProductsViewController *FishVC = [[ProductsViewController alloc] init];
    [self setUpOneChildVcWithVc:FishVC Image:@"tab_product" selectedImage:@"tab_product_s" title:@"产品"];
    
    
    UIViewController *MessageVC = [[UIViewController alloc] init];
    [self setUpOneChildVcWithVc:MessageVC Image:@"news" selectedImage:@"news_s" title:@"消息"];
    
    UIViewController *MineVC = [[UIViewController alloc] init];
    [self setUpOneChildVcWithVc:MineVC Image:@"tab_user" selectedImage:@"tab_user_s" title:@"我的"];
}
#pragma mark - 初始化设置tabBar上面单个按钮的方法

/**
 *  @author li bo, 16/05/10
 *
 *  设置单个tabBarButton
 *
 *  @param Vc            每一个按钮对应的控制器
 *  @param image         每一个按钮对应的普通状态下图片
 *  @param selectedImage 每一个按钮对应的选中状态下的图片
 *  @param title         每一个按钮对应的标题
 */
- (void)setUpOneChildVcWithVc:(UIViewController *)Vc Image:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title
{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:Vc];
    
    Vc.view.backgroundColor = [self randomColor];
    
    UIImage *myImage = [UIImage imageNamed:image];
    myImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //tabBarItem，是系统提供模型，专门负责tabbar上按钮的文字以及图片展示
    Vc.tabBarItem.image = myImage;
    UIImage *mySelectedImage = [UIImage imageNamed:selectedImage];
    mySelectedImage = [mySelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    Vc.tabBarItem.selectedImage = mySelectedImage;
    Vc.tabBarItem.title = title;
    Vc.navigationItem.title = title;
    [self addChildViewController:nav];
    
}
- (UIColor *)randomColor
{
    CGFloat r = arc4random_uniform(256);
    CGFloat g = arc4random_uniform(256);
    CGFloat b = arc4random_uniform(256);
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
}
- (void)pathButton:(ZYPathButton *)ZYPathButton clickItemButtonAtIndex:(NSUInteger)itemButtonIndex {
    NSLog(@" 点中了第%ld个按钮" , itemButtonIndex);
//    UINavigationController *Vc = [[UINavigationController alloc]initWithRootViewController:[ZYNewViewController new]];
//    Vc.view.backgroundColor = [self randomColor];
//    [self presentViewController:Vc animated:YES completion:nil];
}







/*
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
//    [tabBar setClipsToBounds:YES];
//    tabBar.opaque = YES;
//    
//    UITabBar *tabBars = [[UITabBar alloc] init];
//    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//    [tabBars setShadowImage:img];
//    [tabBars setBackgroundImage:[[UIImage alloc]init]];


    CGFloat normalButtonWidth = kScreenWidth/5;
    CGFloat tabBarHeight = CGRectGetHeight(tabBar.frame);
    CGFloat publishItemWidth = kScreenWidth/5;
    
    TabBarItem *newProductItem = [self tabBarItemWithFram:CGRectMake(0, 0, normalButtonWidth, tabBarHeight) title:@"首页" normalImageName:@"tab_recommend" selectedImageName:@"tab_recommend_s" tabBarItemType:TabBarItemTypeNormal];
    TabBarItem *productsItem = [self tabBarItemWithFram:CGRectMake(normalButtonWidth, 0, normalButtonWidth, tabBarHeight) title:@"产品" normalImageName:@"tab_product" selectedImageName:@"tab_product_s" tabBarItemType:TabBarItemTypeNormal];
    
//    TabBarItem *publishItem = [self tabBarItemWithFram:CGRectMake(normalButtonWidth * 2, 4.5, normalButtonWidth, tabBarHeight) title:@"" normalImageName:@"publishs" selectedImageName:@"" tabBarItemType:TabBarItemTypeRise];
    TabBarItem *publishItem = [self tabBarItemWithFram:CGRectMake(normalButtonWidth * 2, 0, normalButtonWidth, tabBarHeight) title:@"发布" normalImageName:@"publishs" selectedImageName:nil tabBarItemType:TabBarItemTypeRise];

    TabBarItem *messageItem = [self tabBarItemWithFram:CGRectMake(normalButtonWidth * 3, 0, normalButtonWidth, tabBarHeight) title:@"消息" normalImageName:@"news" selectedImageName:@"news_s" tabBarItemType:TabBarItemTypeNormal];
    TabBarItem *mineItem = [self tabBarItemWithFram:CGRectMake(normalButtonWidth * 4, 0, normalButtonWidth, tabBarHeight) title:@"用户" normalImageName:@"tab_user" selectedImageName:@"tab_user_s" tabBarItemType:TabBarItemTypeNormal];
    
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
            if ([tokenModel.code isEqualToString:@"3001"]) {//未登录
                [weakself showHint:tokenModel.msg];
                
                LoginViewController *loginVC = [[LoginViewController alloc] init];
                loginVC.hidesBottomBarWhenPushed = YES;
                UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
                [viewController presentViewController:loginNav animated:YES completion:nil];
                
//                [viewController pushViewController:loginVC animated:YES];
            }else{//已登录或未认证
                if (row == 77) {
                    ReportSuitViewController *collectVC = [[ReportSuitViewController alloc] init];
                    collectVC.categoryString = @"2";
                    collectVC.tagString = @"1";
                    collectVC.hidesBottomBarWhenPushed = YES;
//                    [viewController pushViewController:collectVC animated:YES];
                    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:collectVC];
                    
                    [viewController presentViewController:nav1 animated:YES completion:nil];
                    
                }else if (row == 78){
                    ReportSuitViewController *reportSuitVC = [[ReportSuitViewController alloc] init];
                    reportSuitVC.categoryString = @"3";
                    reportSuitVC.tagString = @"1";
                    reportSuitVC.hidesBottomBarWhenPushed = YES;
//                    [viewController pushViewController:reportSuitVC animated:YES];
                    
                    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:reportSuitVC];
                    
                    [viewController presentViewController:nav2 animated:YES completion:nil];
                }
            }
        }];
    }];
}
 
 */

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
