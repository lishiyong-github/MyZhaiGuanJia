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
    
    [self setUpMessage];
}


- (void)setUpMessage
{
    self.view.backgroundColor = kBackColor;
    
    //修改导航栏的边界黑线
    //    self.edgesForExtendedLayout = UIRectEdgeNone ;
    //    self.extendedLayoutIncludesOpaqueBars = NO ;
    //    self.automaticallyAdjustsScrollViewInsets = NO ;
    
    //设置导航条的字体颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:kWhiteColor,NSFontAttributeName:kNavFont}];
    
    //去除系统效果
    self.navigationController.navigationBar.translucent = NO;
    
    //设置导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:kNavColor] forBarMetrics:UIBarMetricsDefault];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //右滑返回
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
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
//        _leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bar_nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
        UIButton *sshhsh = [UIButton buttonWithType:0];
        sshhsh.frame = CGRectMake(0, 0, 22, 25);
        [sshhsh setImage:[UIImage imageNamed:@"bar_nav_back"] forState:0];
        [sshhsh addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        _leftItem = [[UIBarButtonItem alloc] initWithCustomView:sshhsh];
        
    }
    return _leftItem;
}

- (UIButton *)rightButton
{
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:0];
        _rightButton.frame = CGRectMake(0, 0, 70, 30);
        [_rightButton setTitleColor:kWhiteColor forState:0];
        _rightButton.titleLabel.font = kFirstFont;
        _rightButton.contentHorizontalAlignment = 2;
        [_rightButton addTarget:self action:@selector(rightItemAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

-(UIBarButtonItem *)leftItemAnother
{
    if (!_leftItemAnother) {
//        _leftItemAnother = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
        UIButton *wwww = [UIButton buttonWithType:0];
        wwww.frame = CGRectMake(0, 0, 22, 25);
        [wwww setImage:[UIImage imageNamed:@"close"] forState:0];
        [wwww addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        _leftItemAnother = [[UIBarButtonItem alloc] initWithCustomView:wwww];
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

//返回主页
- (void)anotherBack
{
    
}

//- (void)backAnother
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (NSString *)getValidateToken
{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
//    NSString *token = @"2e56461f7b7ee67f782188272bd98869";
//    = @"XXX";
    token = [NSString getValidStringFromString:token toString:@""];
    return token;
}

- (NSString *)getValidateMobile
{
    NSString *mobile = [[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"];
    return mobile;
}

- (NSString *)getValidateUserId
{
    NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
    return userid;
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
