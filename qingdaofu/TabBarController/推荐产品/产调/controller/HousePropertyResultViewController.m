//
//  HousePropertyResultViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/31.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "HousePropertyResultViewController.h"

@interface HousePropertyResultViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIWebView *propertyResultWebView;
@property (nonatomic,assign) BOOL didSetupConstarints;

@end

@implementation HousePropertyResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"产调结果";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
//    [self.view addSubview:self.propertyResultWebView];
//    
//    [self.view setNeedsUpdateConstraints];
    
    [self getPropertyResultMessages];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstarints) {
        
        [self.propertyResultWebView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstarints = YES;
    }
    [super updateViewConstraints];
}

//- (UIWebView *)propertyResultWebView
//{
//    
//}

- (void)getPropertyResultMessages
{
    NSString *resultString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kHousePropertyResultString];
    
    NSString *codeStr = [NSString stringWithFormat:@"%@%@",self.cidString,self.idString];
//    NSData *data = [codeStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
//    data = [];
//
//    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
//    data = [GTMBase64 encodeData:data];
//    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    return base64String;
    
    
//    NSString *dser = [NSString stringWithFormat:@"%d",base64_decode(urlencode(self.cidString,self.idString))];
    
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"id" : codeStr
                             };
    
    [self requestDataPostWithString:resultString params:params successBlock:^(id responseObject) {
        
        NSDictionary *ipip = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSDictionary *uuii;
        
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
