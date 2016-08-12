//
//  BaseViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/1/29.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "BaseViewController.h"

#import "UIImage+Color.h"


@interface BaseViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = kBackColor;
//    
//    //修改导航栏的边界黑线
////    self.edgesForExtendedLayout = UIRectEdgeNone ;
////    self.extendedLayoutIncludesOpaqueBars = NO ;
////    self.automaticallyAdjustsScrollViewInsets = NO ;
//        
//    //设置导航条的字体颜色
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:kBlackColor,NSFontAttributeName:kNavFont}];
//    
//    //去除系统效果
//    self.navigationController.navigationBar.translucent = NO;
//    
//    //设置导航栏颜色
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:kNavColor] forBarMetrics:UIBarMetricsDefault];
//    
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    
//    //右滑返回
//    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"=====%@===init==",NSStringFromClass([self class]));
}

- (void)dealloc
{
    NSLog(@"=====%@===dealloc==",NSStringFromClass([self class]));
}

-(UIBarButtonItem *)leftItem
{
    if (!_leftItem) {
        _leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bar_nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    }
    return _leftItem;
}

-(UIBarButtonItem *)leftItemAnother
{
    if (!_leftItemAnother) {
        _leftItemAnother = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    }
    return _leftItemAnother;
}

- (UIImageView *)baseRemindImageView
{
    if (!_baseRemindImageView) {
        _baseRemindImageView = [UIImageView newAutoLayoutView];
        [_baseRemindImageView setImage:[UIImage imageNamed:@"kong"]];
    }
    return _baseRemindImageView;
}

#pragma mark - method
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)backAnother
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (NSString *)getValidateToken
{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    return token;
}

- (NSString *)getValidateMobile
{
    NSString *mobile = [[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"];
    return mobile;
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
