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

#import "UIViewController+BlurView.h"
#import "UIViewController+SelectedIndex.h"
#import "UITabBar+Badge.h"

#import "CompleteResponse.h"

@interface MainViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate,TabBarDelegate>

@property (nonatomic,strong) NSString *trackViewUrl;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showTabBarItem];
}

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
    
    TabBarItem *publishItem = [self tabBarItemWithFram:CGRectMake(normalButtonWidth * 2, 0, normalButtonWidth, tabBarHeight) title:@"发布" normalImageName:@"center" selectedImageName:@"center" tabBarItemType:TabBarItemTypeRise];

    TabBarItem *messageItem = [self tabBarItemWithFram:CGRectMake(normalButtonWidth * 3, 0, normalButtonWidth, tabBarHeight) title:@"消息" normalImageName:@"news" selectedImageName:@"news_s" tabBarItemType:TabBarItemTypeNormal];
    TabBarItem *mineItem = [self tabBarItemWithFram:CGRectMake(normalButtonWidth * 4, 0, normalButtonWidth, tabBarHeight) title:@"用户" normalImageName:@"tab_user" selectedImageName:@"tab_user_s" tabBarItemType:TabBarItemTypeNormal];
    
    tabBar.tabBarItems = @[newProductItem,productsItem,publishItem,messageItem,mineItem];
    tabBar.delegate = self;
    [tabBarController.tabBar addSubview:tabBar];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = tabBarController;
    
    
    //去掉分割线
    CGRect rect = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [tabBarController.tabBar setBackgroundImage:img];
    [tabBarController.tabBar setShadowImage:img];
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

- (void)tabbarDicSelectedCommonButton:(NSInteger)selectedIndex
{
    NSString *aoaoa = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kPersonCenterMessagesString];
    NSDictionary *params = @{@"token" : [self getValidateToken]};
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    QDFWeakSelf;
    [session POST:aoaoa parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        CompleteResponse *response = [CompleteResponse objectWithKeyValues:responseObject];
        if ([response.code isEqualToString:@"3001"]) {
            [weakself showHint:response.msg];
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            loginVC.hidesBottomBarWhenPushed = YES;
            UINavigationController *msss = [[UINavigationController alloc] initWithRootViewController:loginVC];
            
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            UITabBarController *tabBarController = (UITabBarController *)window.rootViewController;
            UINavigationController *viewController = tabBarController.selectedViewController;
            [viewController presentViewController:msss animated:YES completion:nil];
        }else{
            [self setSelectedIndex:selectedIndex andType:@"0"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)checkMessagesOfNoRead
{
    NSString *noReadString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMessageOfNoReadString];
    NSDictionary *params = @{@"token" : [self getValidateToken]};
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [session POST:noReadString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        BaseModel *baseModel = [BaseModel objectWithKeyValues:responseObject];
        UITabBarController *tabBarController = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        if ([baseModel.code isEqualToString:@"0000"]) {
            [tabBarController.tabBar showBadgeOnItemIndex:3];
        }else{
            [tabBarController.tabBar hideBadgeOnItemIndex:3];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
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
