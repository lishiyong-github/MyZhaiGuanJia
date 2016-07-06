//
//  AgreementViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/30.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "AgreementViewController.h"
#import "MyReleaseViewController.h"

#import "BaseCommitButton.h"

@interface AgreementViewController ()

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UIWebView *agreementWebView;
@property (nonatomic,strong) BaseCommitButton *agreeButton;

@end

@implementation AgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"服务协议";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.agreementWebView];
    
    if ([self.flagString integerValue] == 1) {
        [self.view addSubview:self.agreeButton];
    }
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.agreementWebView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        
        if ([self.flagString integerValue] == 1) {
            [self.agreeButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5];
            [self.agreeButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5];
            [self.agreeButton autoSetDimensionsToSize:CGSizeMake(80, 30)];
        }
        
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

- (BaseCommitButton *)agreeButton
{
    if (!_agreeButton) {
        _agreeButton = [BaseCommitButton newAutoLayoutView];
        [_agreeButton setTitle:@"同意" forState:0];
        [_agreeButton addTarget:self action:@selector(agreeForAgreement) forControlEvents:UIControlEventTouchUpInside];
    }
    return _agreeButton;
}

#pragma mark - method
- (void)agreeForAgreement
{
    NSString *dfdfString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyRecordsMessageAgreeString];
    NSDictionary *params = @{@"id" : self.idString,
                             @"category" : self.categoryString,
                             @"uid" : self.pidString,
                             @"token" : [self getValidateToken]
                             };
    [self requestDataPostWithString:dfdfString params:params successBlock:^(id responseObject) {
        BaseModel *dfdfModel = [BaseModel objectWithKeyValues:responseObject];
        [self showHint:dfdfModel.msg];
        
        if ([dfdfModel.code isEqualToString:@"0000"]) {
            UINavigationController *nav = self.navigationController;
            [nav popViewControllerAnimated:NO];
            [nav popViewControllerAnimated:NO];
            [nav popViewControllerAnimated:NO];
            [nav popViewControllerAnimated:NO];
            MyReleaseViewController *myReleaseVC = [[MyReleaseViewController alloc] init];
            myReleaseVC.hidesBottomBarWhenPushed = YES;
            myReleaseVC.progreStatus = @"2";
            [nav pushViewController:myReleaseVC animated:NO];
        }
        
    } andFailBlock:^(NSError *error) {
        
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
