//
//  CompanyWebSiteViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/6/2.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "CompanyWebSiteViewController.h"

@interface CompanyWebSiteViewController ()

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UIWebView *companyWebView;

@end

@implementation CompanyWebSiteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"公司官网";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.companyWebView];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.companyWebView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UIWebView *)companyWebView
{
    if (!_companyWebView) {
        _companyWebView = [[UIWebView alloc] init];
        NSString *companyString = @"http://www.zcb2016.com";
        NSURL *companyUrl = [NSURL URLWithString:companyString];
        [_companyWebView loadRequest:[NSURLRequest requestWithURL:companyUrl]];
    }
    return _companyWebView;
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
