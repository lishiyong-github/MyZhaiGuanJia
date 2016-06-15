//
//  AgreementViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/30.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "AgreementViewController.h"

@interface AgreementViewController ()

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UIWebView *agreementWebView;

@end

@implementation AgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"服务协议";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.agreementWebView];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.agreementWebView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UIWebView *)agreementWebView
{
    if (!_agreementWebView) {
        _agreementWebView = [UIWebView newAutoLayoutView];
        NSString *urlString = [NSString stringWithFormat:@"http://testq.zcb2016.com/protocol/mediacy?id=%@&category=%@",self.idString,self.categoryString];
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [_agreementWebView loadRequest:request];
    }
    return _agreementWebView;
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
