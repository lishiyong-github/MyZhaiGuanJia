//
//  AuthentyWaitingViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/16.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "AuthentyWaitingViewController.h"

@interface AuthentyWaitingViewController ()

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UILabel *waitingLabel;

@end

@implementation AuthentyWaitingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = self.leftItem;
    self.navigationItem.title = @"等待审核";
    
    [self.view addSubview:self.waitingLabel];

    [self.view setNeedsUpdateConstraints];
}

- (void)back
{
    if ([self.backString integerValue] == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if ([self.backString integerValue] == 2){
            UINavigationController *nav = self.navigationController;
            [nav popViewControllerAnimated:NO];
            [nav popViewControllerAnimated:NO];
            [nav popViewControllerAnimated:NO];
    }
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.waitingLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:100];
        [self.waitingLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UILabel *)waitingLabel
{
    if (!_waitingLabel) {
        _waitingLabel = [UILabel newAutoLayoutView];
        _waitingLabel.textAlignment = NSTextAlignmentCenter;
        _waitingLabel.text = @"请耐心等待客服审核...";
    }
    return _waitingLabel;
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
