//
//  CaseViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/26.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "CaseViewController.h"

@interface CaseViewController ()

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UIWebView *caseWebView;

@end

@implementation CaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"经典案例";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.caseWebView];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.caseWebView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UIWebView *)caseWebView
{
    if (!_caseWebView) {
        _caseWebView = [UIWebView newAutoLayoutView];
        [_caseWebView loadHTMLString:self.caseString baseURL:nil];
    }
    return _caseWebView;
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
