//
//  AppDelegate.m
//  qingdaofu
//
//  Created by zhixiang on 16/1/28.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "AppDelegate.h"
#import "MBResourceManager.h"
#import "MainViewController.h"
#import "TabBarViewController.h"

#import "IntroduceViewController.h"

@interface AppDelegate ()  

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //判断是否是首次登录
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"first"];
    NSString *value = [settings objectForKey:key];

    if (!value) {//首次登录
        IntroduceViewController *introVC = [[IntroduceViewController alloc] init];
        self.window.rootViewController = introVC;
        [[NSUserDefaults standardUserDefaults] setObject:@"first" forKey:@"first"];
    }else{
        MainViewController *mainVC = [[MainViewController alloc] init];
        UINavigationController *mainNav = [[UINavigationController alloc] initWithRootViewController:mainVC];
        self.window.rootViewController = mainNav;
        
//        TabBarViewController *tabBarVC = [[TabBarViewController alloc] init];
//        UINavigationController *tabBarNav = [[UINavigationController alloc] initWithRootViewController:tabBarVC];
//        self.window.rootViewController = tabBarNav;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [[MBResourceManager sharedInstance] removeUnusedResource];
    });
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), )

//    [NSThread sleepForTimeInterval:0.1];//设置启动页面时间
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
