//
//  IntroduceViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/7/11.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "IntroduceViewController.h"
#import "MainViewController.h"

@interface IntroduceViewController ()


@property (nonatomic,assign) BOOL didSetupconstraints;
@property (nonatomic,strong) UIImageView *introImageView1;
@property (nonatomic,strong) UIImageView *introImageView2;
@property (nonatomic,strong) UIButton *introButton;

@end

@implementation IntroduceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = UIColorFromRGB(0xf0f6fa);
    
    [self.view addSubview:self.introImageView1];
    [self.view addSubview:self.introImageView2];
    [self.view addSubview:self.introButton];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupconstraints) {
        
        [self.introImageView1 autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:75];
        [self.introImageView1 autoAlignAxisToSuperviewAxis:ALAxisVertical];

        [self.introImageView2 autoAlignAxis:ALAxisVertical toSameAxisOfView:self.introImageView1];
        [self.introImageView2 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.introImageView1 withOffset:55];
        
        [self.introButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:55];
        [self.introButton autoAlignAxis:ALAxisVertical toSameAxisOfView:self.introImageView1];
        
        self.didSetupconstraints = YES;
    }
    [super updateViewConstraints];
}

- (UIImageView *)introImageView1
{
    if (!_introImageView1) {
        _introImageView1 = [UIImageView newAutoLayoutView];
        [_introImageView1 setImage:[UIImage imageNamed:@"qing"]];
    }
    return _introImageView1;
}
- (UIImageView *)introImageView2
{
    if (!_introImageView2) {
        _introImageView2 = [UIImageView newAutoLayoutView];
        [_introImageView2 setImage:[UIImage imageNamed:@"image"]];
    }
    return _introImageView2;
}

- (UIButton *)introButton
{
    if (!_introButton) {
        _introButton = [UIButton newAutoLayoutView];
        [_introButton setImage:[UIImage imageNamed:@"button"] forState:0];
        [_introButton addAction:^(UIButton *btn) {
            
        MainViewController *mainVC = [[MainViewController alloc] init];
        UINavigationController *mainNav = [[UINavigationController alloc] initWithRootViewController:mainVC];
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        keyWindow.rootViewController = mainNav;
        }];
    }
    return _introButton;
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
