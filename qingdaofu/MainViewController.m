//
//  MainViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/17.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MainViewController.h"
#import "UIImage+Color.h"

#import "NewProductViewController.h"
#import "ProductsViewController.h"
#import "MessageViewController.h"
#import "MineViewController.h"

#import "ReportSuitViewController.h"     //发布诉讼
#import "LoginViewController.h"  //登录

#import "TabBar.h"
#import "TabBarItem.h"

#import "ZYTabBar.h"
#import "UIViewController+BlurView.h"

@interface MainViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate>

@property (nonatomic,strong) NSString *trackViewUrl;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showTabBarItem];
    
//    [self setUpAllChildVc];
//    [self configureZYPathButton];
}

/*
- (void)configureZYPathButton {
    ZYTabBar *tabBar = [ZYTabBar new];
    tabBar.delegate = self;//select_   ／／tab_bar
    ZYPathItemButton *itemButton_1 = [[ZYPathItemButton alloc]initWithImage:[UIImage imageNamed:@"tab_recommend"]highlightedImage:[UIImage imageNamed:@"tab_recommend_s"]backgroundImage:[UIImage imageNamed:@"tab_bars"]backgroundHighlightedImage:[UIImage imageNamed:@"tab_bars"]];
    ZYPathItemButton *itemButton_2 = [[ZYPathItemButton alloc]initWithImage:[UIImage imageNamed:@"tab_product"]highlightedImage:[UIImage imageNamed:@"tab_product_s"]backgroundImage:[UIImage imageNamed:@"tab_bars"]backgroundHighlightedImage:[UIImage imageNamed:@"tab_bars"]];
    
    ZYPathItemButton *itemButton_3 = [[ZYPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-camera"]highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-camera-highlighted"]backgroundImage:[UIImage imageNamed:@"tab_bars"]backgroundHighlightedImage:[UIImage imageNamed:@"tab_bars"]];
    
//    [itemButton_3 addAction:^(UIButton *btn) {
//        NSLog(@"发布");
//    }];
    
    [itemButton_3 addTarget:self action:@selector(ffffff) forControlEvents:UIControlEventTouchUpInside];
    
    ZYPathItemButton *itemButton_4 = [[ZYPathItemButton alloc]initWithImage:[UIImage imageNamed:@"news"]highlightedImage:[UIImage imageNamed:@"news_s"]backgroundImage:[UIImage imageNamed:@"tab_bars"]backgroundHighlightedImage:[UIImage imageNamed:@"tab_bars"]];
    
    ZYPathItemButton *itemButton_5 = [[ZYPathItemButton alloc]initWithImage:[UIImage imageNamed:@"tab_user"]highlightedImage:[UIImage imageNamed:@"tab_user_s"]backgroundImage:[UIImage imageNamed:@"tab_bars"]backgroundHighlightedImage:[UIImage imageNamed:@"tab_bars"]];
    tabBar.pathButtonArray = @[itemButton_1 , itemButton_2 , itemButton_3, itemButton_4 , itemButton_5];
    tabBar.delegate = self;
    
//    tabBar.basicDuration = 0.5;
//    tabBar.allowSubItemRotation = YES;
//    tabBar.bloomRadius = 100;
//    tabBar.allowCenterButtonRotation = YES;
//    tabBar.bloomAngel = 100;
    
    //kvc实质是修改了系统的_tabBar
    [self setValue:tabBar forKeyPath:@"tabBar"];
}

- (void)setUpAllChildVc {
    NewProductViewController *HomeVC = [[NewProductViewController alloc] init];
    [self setUpOneChildVcWithVc:HomeVC Image:@"tab_recommend" selectedImage:@"tab_recommend_s" title:@"首页"];
    
    ProductsViewController *FishVC = [[ProductsViewController alloc] init];
    [self setUpOneChildVcWithVc:FishVC Image:@"tab_product" selectedImage:@"tab_product_s" title:@"产品"];
    
    MessageViewController *MessageVC = [[MessageViewController alloc] init];
    [self setUpOneChildVcWithVc:MessageVC Image:@"news" selectedImage:@"news_s" title:@"消息"];
    
    MineViewController *MineVC = [[MineViewController alloc] init];
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
/*
- (void)setUpOneChildVcWithVc:(UIViewController *)Vc Image:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title
{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:Vc];
    
//    Vc.view.backgroundColor = [self randomColor];
    Vc.view.backgroundColor = kRedColor;
    
    
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


- (void)ffffff
{
    
}


*/


- (void)showTabBarItem
{
    
    for (UIView *view in self.tabBarController.tabBar.subviews) {
        
        if ([view isKindOfClass:[UIImageView class]] && view.bounds.size.height <= 1) {
            UIImageView *ima = (UIImageView *)view;
//                        ima.backgroundColor = [UIColor redColor];
            ima.hidden = YES;
        }
    }
    
    
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
    tabBar.backgroundColor = kWhiteColor;
//    [tabBar setClipsToBounds:YES];
//    tabBar.opaque = YES;
//    
//    UITabBar *tabBars = [[UITabBar alloc] init];
//    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//    [tabBars setShadowImage:img];
//    [tabBars setBackgroundImage:[[UIImage alloc]init]];


    CGFloat normalButtonWidth = kScreenWidth/5;
    CGFloat tabBarHeight = CGRectGetHeight(tabBar.frame);
//    CGFloat publishItemWidth = kScreenWidth/5;
    
    TabBarItem *newProductItem = [self tabBarItemWithFram:CGRectMake(0, 0, normalButtonWidth, tabBarHeight) title:@"首页" normalImageName:@"tab_recommend" selectedImageName:@"tab_recommend_s" tabBarItemType:TabBarItemTypeNormal];
    TabBarItem *productsItem = [self tabBarItemWithFram:CGRectMake(normalButtonWidth, 0, normalButtonWidth, tabBarHeight) title:@"产品" normalImageName:@"tab_product" selectedImageName:@"tab_product_s" tabBarItemType:TabBarItemTypeNormal];
    
//    TabBarItem *publishItem = [self tabBarItemWithFram:CGRectMake(normalButtonWidth * 2, 4.5, normalButtonWidth, tabBarHeight) title:@"" normalImageName:@"publishs" selectedImageName:@"" tabBarItemType:TabBarItemTypeRise];
    TabBarItem *publishItem = [self tabBarItemWithFram:CGRectMake(normalButtonWidth * 2, 0, normalButtonWidth, tabBarHeight) title:@"发布" normalImageName:@"center" selectedImageName:@"center" tabBarItemType:TabBarItemTypeRise];

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
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UITabBarController *tabBarController = (UITabBarController *)window.rootViewController;
    UINavigationController *viewController = tabBarController.selectedViewController;
    
    ReportSuitViewController *collectVC = [[ReportSuitViewController alloc] init];
    collectVC.tagString = @"1";
    collectVC.hidesBottomBarWhenPushed = YES;
    
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:collectVC];
    
    [viewController presentViewController:nav1 animated:YES completion:nil];
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
