//
//  LaunchViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/12/26.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "LaunchViewController.h"

#import "MainViewController.h"

#import "ImageModel.h"

#import "UIButton+WebCache.h"

@interface LaunchViewController ()

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UIButton *launchImageButton;

@end

@implementation LaunchViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.launchImageButton];
    
    [self.view setNeedsUpdateConstraints];
    
//    NSTimeInterval time = [nsti]
    [self performSelector:@selector(toMainView) withObject:nil afterDelay:2];
}

- (void)toMainView
{
    MainViewController *mainVC = [[MainViewController alloc] init];
    UINavigationController *mainNav = [[UINavigationController alloc] initWithRootViewController:mainVC];
    [UIApplication sharedApplication].keyWindow.rootViewController = mainNav;
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.launchImageButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.launchImageButton autoSetDimension:ALDimensionHeight toSize:kScreenHeight-80];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UIButton *)launchImageButton
{
    if (!_launchImageButton) {
        _launchImageButton = [UIButton newAutoLayoutView];
        
        ImageModel *imlModel = self.ad[0];
        [_launchImageButton sd_setImageWithURL:[NSURL URLWithString:imlModel.file] forState:0];
    }
    return _launchImageButton;
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
