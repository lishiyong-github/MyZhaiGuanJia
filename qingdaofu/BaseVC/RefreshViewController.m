//
//  RefreshViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/2/16.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "RefreshViewController.h"



@interface RefreshViewController ()

@end

@implementation RefreshViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)headerRefreshWithPage:(NSString *)page urlString:(NSString *)urlString Parameter:(NSDictionary *)params successBlock:(void(^)(id responseObject))successBlock andfailedBlock:(void(^)(NSError *error))failedBlock
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromData:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (error) {
            failedBlock(error);
        }else{
            if (successBlock) {
                successBlock(responseObject);
            }
            
        }
        
    }];
    
    [uploadTask resume];
    
    
    /*
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        if (successBlock) {
            successBlock(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
        
    }];
     */
}

- (void)footerRefreshWithUrlString:(NSString *)urlString Parameter:(NSDictionary *)params successBlock:(void (^)(id))successBlock andfailedBlock:(void (^)(NSError *))failedBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];

    [manager POST:urlString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (successBlock) {
            successBlock(error);
        }
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
