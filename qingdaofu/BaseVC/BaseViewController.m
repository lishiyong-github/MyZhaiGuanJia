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
    
    self.view.backgroundColor = kBackColor;
//    self.edgesForExtendedLayout = UIRectEdgeNone ;
//    self.extendedLayoutIncludesOpaqueBars = NO ;
//    self.automaticallyAdjustsScrollViewInsets = NO ;
    
    //设置导航条的字体颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:kBlackColor,NSFontAttributeName:kNavFont}];
    
    //去除系统效果
    self.navigationController.navigationBar.translucent = NO;
    
    //设置导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
        
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
        _leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"information_nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    }
    return _leftItem;
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

- (void)tokenIsValid
{
    [self showHudInView:self.view hint:@"请稍候"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer= [AFHTTPResponseSerializer serializer];
   
    NSString *validString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kTokenOverdue];
    NSDictionary *params = @{@"token" : [self getValidateToken]?[self getValidateToken]:@""};
    
    [manager POST:validString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            TokenModel *model = [TokenModel objectWithKeyValues:responseObject];
            if (self.didTokenValid) {
                [self hideHud];
                self.didTokenValid(model);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideHud];
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
