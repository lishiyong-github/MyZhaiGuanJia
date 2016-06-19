//
//  NetworkViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/1/29.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "NetworkViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"

@interface NetworkViewController ()

@end

@implementation NetworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
/*
- (void)requestDataGetWithString:(NSString *)string params:(NSDictionary *)params successBlock:(void (^)())successBlock andFailBlock:(void (^)())failBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

   [manager GET:string parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
       if (successBlock) {
           successBlock(operation,responseObject);
       }
       
   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       if (failBlock) {
           failBlock(operation,error);
       }
   }];

}
 */
- (void)requestDataPostWithString:(NSString *)string params:(NSDictionary *)params andImages:(NSDictionary *)images successBlock:(void (^)(id responseObject))successBlock andFailBlock:(void (^)(NSError *error))failBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:@"text/html;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];

    
    [manager POST:string parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (images) {
            for (NSString *key in [images allKeys]) {
                NSArray *uploadImages = images[key];
                for (id obj in uploadImages) {
                    if ([obj isKindOfClass:[NSString class]]) {
                        [formData appendPartWithFileData:[NSData dataWithContentsOfFile:obj] name:key fileName:KTimeStamp mimeType:@"image/png"];
                    }else if ([obj isKindOfClass:[UIImage class]]){
                        [formData appendPartWithFileData:UIImageJPEGRepresentation(obj, 0.7) name:key fileName:KTimeStamp mimeType:@"image/png"];
                    }
                }
            }
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (successBlock) {
            successBlock(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failBlock) {
            failBlock(error);
        }
    }];
}
- (void)requestDataPostWithString:(NSString *)string params:(NSDictionary *)params successBlock:(void (^)(id responseObject))successBlock andFailBlock:(void (^)(NSError *error))failBlock
{
//    [self requestDataPostWithString:string params:params andImages:nil successBlock:successBlock andFailBlock:failBlock];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:string parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failBlock) {
            failBlock(error);
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
