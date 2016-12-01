//
//  NetworkViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/1/29.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "NetworkViewController.h"
#import "MBProgressHUD.h"
#import "ImageResponse.h"

@interface NetworkViewController ()

@end

@implementation NetworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)requestDataPostWithString:(NSString *)string params:(NSDictionary *)params successBlock:(void (^)(id responseObject))successBlock andFailBlock:(void (^)(NSError *error))failBlock
{
    [self showHudInView:self.view hint:@"正在加载"];
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    QDFWeakSelf;
    [session POST:string parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            [weakself hideHud];
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failBlock) {
            [weakself hideHud];
            [weakself showHint:@"网络错误"];
        }
    }];
}

- (void)uploadImages:(NSString *)imgData andType:(NSString *)imgType andFilePath:(NSString *)filePath
{
    NSString *uploadsString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kUploadImagesString];
    NSDictionary *params = @{@"filetype" : @"1",
                             @"extension" : @"jpg",
                             @"picture" : imgData
                             };
    
    QDFWeakSelf;
    [self requestDataPostWithString:uploadsString params:params successBlock:^(id responseObject) {
        [weakself hideHud];
        
        ImageResponse *imResponse = [ImageResponse objectWithKeyValues:responseObject];
        
        if (weakself.didGetValidImage) {
            weakself.didGetValidImage(imResponse.result);
        }
    } andFailBlock:^(NSError *error) {
        [weakself hideHud];
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
